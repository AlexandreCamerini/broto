#!/usr/bin/env bash
# Executa os gates e grava JSON conforme templates/gate-result.schema.json
set -uo pipefail
PACK="web"; OUT=".broto/gates.json"; ONLY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --pack) PACK="$2"; shift 2 ;;
    --out)  OUT="$2";  shift 2 ;;
    --only) ONLY="$2"; shift 2 ;;
    *) shift ;;
  esac
done
mkdir -p "$(dirname "$OUT")"
resultados=(); total=0; passou=0; falhou=0; pulou=0; bloqueado=false

gate() { # id bloqueante limite comando como_corrigir
  local id="$1" bloq="$2" limite="$3" cmd="$4" fix="$5"
  [ -n "$ONLY" ] && [ "$ONLY" != "$id" ] && return 0
  total=$((total+1))
  local status saida
  if [ -z "$cmd" ] && [ "$bloq" = "true" ]; then status="fail"; falhou=$((falhou+1)); bloqueado=true; saida="sem comando para este pack: gate bloqueante nao pode ser pulado"
  elif [ -z "$cmd" ]; then status="skip"; pulou=$((pulou+1)); saida="sem comando para este projeto"
  elif saida=$(eval "$cmd" 2>&1); then status="pass"; passou=$((passou+1))
  else status="fail"; falhou=$((falhou+1)); [ "$bloq" = "true" ] && bloqueado=true
  fi
  printf '  %-12s %s\n' "$id" "$status"
  resultados+=("$(jq -nc --arg id "$id" --arg s "$status" --argjson b "$bloq" \
    --arg c "$cmd" --arg m "$(echo "$saida" | tail -3 | tr '\n' ' ' | cut -c1-300)" \
    --arg l "$limite" --arg f "$fix" \
    '{id:$id,status:$s,bloqueante:$b,comando:$c,medido:$m,limite:$l,como_corrigir:$f}')")
}

detect() { # devolve comando se o script existir no package.json
  [ -f package.json ] && jq -e ".scripts[\"$1\"]" package.json >/dev/null 2>&1 && echo "npm run $1"
}
# comandos do pack ios (Xcode). XcodeGen: regenera projeto se project.yml for mais novo.
XCPROJ=$(ls -d *.xcodeproj 2>/dev/null | head -1); XCSCHEME="${XCPROJ%.xcodeproj}"
ios_cmd() { # build|test
  [ -n "$XCPROJ" ] || return 0
  local pre=""; [ -f project.yml ] && [ project.yml -nt "$XCPROJ" ] && pre="xcodegen generate >/dev/null && "
  case "$1" in
    build) echo "${pre}xcodebuild -project '$XCPROJ' -scheme '$XCSCHEME' -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO -quiet build";;
    test)  echo "${pre}xcodebuild -project '$XCPROJ' -scheme '$XCSCHEME' -destination 'platform=iOS Simulator,name=\${BROTO_SIM:-iPhone 16}' CODE_SIGNING_ALLOWED=NO -quiet test";;
  esac
}
swiftpm_test() { [ -f Package.swift ] && echo "swift test -q"; ls */Package.swift >/dev/null 2>&1 && echo "for p in */Package.swift; do (cd \$(dirname \$p) && swift test -q) || exit 1; done"; }
IA=$(jq -r '.arquitetura.ia // "nenhuma"' .broto/plano.json 2>/dev/null)
BLOQ_IA=true; [ "$IA" = "nenhuma" ] && BLOQ_IA=false

echo "== Gates (pack: $PACK) =="

case "$PACK" in
  ios)   B="$(ios_cmd build)"; S="$(ios_cmd test)"; T="$(swiftpm_test | head -1)"; L="$(command -v swiftlint >/dev/null && echo 'swiftlint --quiet --strict')";;
  *)     B="$(detect build)"; S="$(detect test:smoke)"; T="$(detect typecheck)"; L="$(detect lint)";;
esac
gate build      true  "sem erro"            "$B"                   "leia o erro de build e corrija a causa; nunca desative o gate"
gate smoke      true  "acao principal ok"   "$S"                   "o caminho principal do briefing precisa passar ponta a ponta"
gate ux         true  "zero tela reprovada" "bash '${CLAUDE_PLUGIN_ROOT:-.}/scripts/ux_gate.sh'" "corrija o maior_impacto da tela reprovada, refaca screenshot e review"
gate segredos   true  "zero ocorrencia"     "! git log -p -S'sk-' --all 2>/dev/null | grep -qE 'sk-[a-zA-Z0-9_-]{16,}' && ! grep -rIlE 'sk-[a-zA-Z0-9_-]{16,}' --exclude-dir=.git --exclude-dir=node_modules . 2>/dev/null | grep -q ." "remova a chave, rotacione no provedor e reescreva o historico se necessario"
gate deps-cve   true  "zero critica"        "$(command -v npm >/dev/null && echo 'npm audit --audit-level=critical')" "atualize a dependencia vulneravel"
gate lint       false "zero erro"           "$L"                   "rode o autofix do linter"
gate tipos      false "zero erro"           "$T"                   "corrija os tipos apontados"
gate a11y       true  "zero critica"        "$(detect test:a11y)"  "contraste, foco de teclado e rotulo em elemento interativo"
gate ia-eval    $BLOQ_IA "acima do minimo"     "$(detect eval:ia)"    "ajuste prompt ou tier; rode o eval de novo antes de aceitar"
gate ia-teto    $BLOQ_IA "configurado"         '[ -n "${CLAUDE_PLUGIN_OPTION_TETO_GASTO_BRL:-}" ] || grep -rq "TETO_GLOBAL_BRL" . --include="*.env*" --exclude-dir=node_modules 2>/dev/null' "configure o teto em /config (Teto de gasto mensal) e no painel do provedor"

jq -n --arg d "$(date -Iseconds)" --arg p "$PACK" \
  --argjson t "$total" --argjson ok "$passou" --argjson f "$falhou" --argjson sk "$pulou" \
  --argjson bl "$bloqueado" --argjson g "$(printf '%s\n' "${resultados[@]}" | jq -sc '.')" \
  '{executado_em:$d,pack:$p,resumo:{total:$t,passou:$ok,falhou:$f,pulou:$sk,bloqueado:$bl},gates:$g}' > "$OUT"

echo; echo "resumo: $passou/$total passaram, $falhou falharam, $pulou pulados -> $OUT"
[ "$bloqueado" = "true" ] && { echo "BLOQUEADO: ha falha bloqueante."; exit 1; }
exit 0
