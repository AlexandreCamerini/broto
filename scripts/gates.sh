#!/usr/bin/env bash
# Roda as provas. Gate bloqueante sem comando FALHA — nunca pula.
#   gates.sh --pack <pack> [--only <id>] [--out .broto/gates.json]
set -uo pipefail
PACK=""; ONLY=""; OUT=".broto/gates.json"; R="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
while [ $# -gt 0 ]; do case "$1" in --pack) PACK="$2"; shift 2;; --only) ONLY="$2"; shift 2;; --out) OUT="$2"; shift 2;; *) shift;; esac; done
[ -n "$PACK" ] || { echo "uso: gates.sh --pack <ios|web|flutter>"; exit 2; }
mkdir -p "$(dirname "$OUT")"; itens="[]"; pass=0; fail=0; bloqueado=false

gate(){ # id bloqueante limite comando como_corrigir
  local id="$1" bloq="$2" lim="$3" cmd="$4" fix="$5" st saida
  [ -n "$ONLY" ] && [ "$ONLY" != "$id" ] && return 0
  if [ -z "$cmd" ] && [ "$bloq" = "true" ]; then
    st="fail"; saida="sem comando para este pack: gate bloqueante nao pode ser pulado"; fail=$((fail+1)); bloqueado=true
  elif [ -z "$cmd" ]; then
    st="skip"; saida="nao se aplica"
  else
    saida=$(eval "$cmd" 2>&1 | tail -25)
    if [ ${PIPESTATUS[0]:-0} -eq 0 ] 2>/dev/null || [ $? -eq 0 ]; then st="pass"; pass=$((pass+1)); else st="fail"; fail=$((fail+1)); [ "$bloq" = "true" ] && bloqueado=true; fi
  fi
  printf '  %-14s %-5s %s\n' "$id" "$st" "$(echo "$saida" | head -1)"
  itens=$(python3 -c "
import json,sys
i=json.loads(sys.argv[1]); i.append({'id':sys.argv[2],'bloqueante':sys.argv[3]=='true','status':sys.argv[4],'limite':sys.argv[5],'saida':sys.argv[6][:900],'como_corrigir':sys.argv[7]})
print(json.dumps(i))" "$itens" "$id" "$bloq" "$st" "$lim" "$saida" "$fix")
}

G="$R/scripts/gates"
# universais
gate contrato   true  "journey+arch validos" "bash '$G/contrato.sh'"        "corrija o contrato conforme o schema"
gate deriva     true  "contrato estavel"     "bash '$G/deriva.sh'"          "as telas listadas voltam ao kit e sao reaprovadas; so elas"
gate kit        true  "zero valor cru"       "bash '$G/kit.sh' $PACK"       "troque o valor literal por token do kit"
gate contraste  true  "WCAG AA"              "bash '$G/contraste.sh'"       "ajuste a cor no tokens.json e regenere com tokens.sh"
gate interface  true  "zero tela reprovada"  "bash '$G/interface.sh'"       "aplique a mudanca apontada pelo juiz, uma por vez, e recapture"
gate segredos   true  "zero ocorrencia"      "bash '$G/segredos.sh'"        "mova para variavel de ambiente e limpe o historico"

case "$PACK" in
  ios)
    XC=$(ls -d *.xcodeproj 2>/dev/null | head -1); SC="${XC%.xcodeproj}"
    PRE=""; [ -f project.yml ] && [ project.yml -nt "${XC:-project.yml}" ] && PRE="xcodegen generate >/dev/null && "
    B=""; S=""; A=""
    if [ -n "$XC" ]; then
      B="${PRE}xcodebuild -project \"$XC\" -scheme \"$SC\" -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO -quiet build"
      S="${PRE}xcodebuild -project \"$XC\" -scheme \"$SC\" -destination \"platform=iOS Simulator,name=\${BROTO_SIM:-iPhone 16}\" CODE_SIGNING_ALLOWED=NO -quiet test -only-testing:*Smoke*"
      A="${PRE}xcodebuild -project \"$XC\" -scheme \"$SC\" -destination \"platform=iOS Simulator,name=\${BROTO_SIM:-iPhone 16}\" CODE_SIGNING_ALLOWED=NO -quiet test -only-testing:*Accessibility*"
    fi
    gate build  true  "compila"      "$B" "leia o erro e corrija a causa"
    gate smoke  true  "caminho feliz" "$S" "a acao primaria da jornada precisa passar ponta a ponta"
    gate a11y   true  "zero critica"  "$A" "corrija rotulo, alvo de toque ou escala apontados pelo audit"
    gate privacidade true "declarado" "bash '$G/ios_privacidade.sh'" "declare a API no manifesto e escreva o texto de cada permissao"
    gate tipos  false "zero erro"     "$([ -f Package.swift ] && echo 'swift build -q')" "corrija os tipos"
    ;;
  web)
    gate build true "compila"       "$([ -f package.json ] && echo 'npm run -s build')" "leia o erro de build"
    gate smoke true "caminho feliz" "$([ -f package.json ] && echo 'npm run -s test:smoke')" "o caminho feliz precisa passar"
    gate a11y  true "zero critica"  "$([ -f package.json ] && echo 'npm run -s test:a11y')" "corrija as violacoes do axe"
    gate tipos false "zero erro"    "$([ -f tsconfig.json ] && echo 'npx tsc --noEmit')" "corrija os tipos"
    ;;
  flutter)
    gate build true "compila"       "flutter build apk --debug" "leia o erro de build"
    gate smoke true "caminho feliz" "flutter test integration_test" "o caminho feliz precisa passar"
    gate a11y  true "zero critica"  "flutter test test/a11y" "use meetsGuideline nos testes de widget"
    gate tipos false "zero erro"    "dart analyze --fatal-infos" "corrija o analyze"
    ;;
esac

python3 -c "
import json,sys
print(json.dumps({'em':__import__('datetime').datetime.now().isoformat(),'pack':sys.argv[2],
 'resumo':{'pass':int(sys.argv[3]),'fail':int(sys.argv[4]),'bloqueado':sys.argv[5]=='true'},
 'gates':json.loads(sys.argv[1])},ensure_ascii=False,indent=1))" "$itens" "$PACK" "$pass" "$fail" "$bloqueado" > "$OUT"
echo "  ----"; echo "  $((pass+fail)) provas, $pass passaram -> $OUT"
[ "$bloqueado" = "false" ]
