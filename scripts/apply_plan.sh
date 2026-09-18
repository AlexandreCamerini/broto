#!/usr/bin/env bash
# Aplica um setup-plan.json aprovado. Idempotente e nao-destrutivo por padrao.
#   uso: apply_plan.sh .claude/setup-plan.json [--force] [--dry-run]
set -euo pipefail

PLAN="${1:-.claude/setup-plan.json}"
FORCE=0; DRY=0
for a in "${@:2}"; do
  [ "$a" = "--force" ] && FORCE=1
  [ "$a" = "--dry-run" ] && DRY=1
done

command -v jq >/dev/null || { echo "ERRO: jq nao encontrado."; exit 1; }
[ -f "$PLAN" ] || { echo "ERRO: plano nao encontrado em $PLAN"; exit 1; }

# Gate 1: plano sem critica nao aplica.
VERDICT=$(jq -r '.critique.verdict // "ausente"' "$PLAN")
if [ "$VERDICT" = "ausente" ] || [ "$VERDICT" = "reprovado" ]; then
  echo "BLOQUEADO: critique.verdict = $VERDICT. Rode o setup-critic antes de aplicar."
  exit 2
fi

echo "== plano: $(jq -r .project "$PLAN") (modo: $(jq -r .mode "$PLAN"), veredito: $VERDICT)"

# Premissas em tela — o humano precisa ver o que foi assumido.
echo "== premissas assumidas"
jq -r '.assumptions[]? | "  - " + .' "$PLAN"

# Gate 2: escritas. Nada fora de writes[] e tocado.
echo "== arquivos"
while IFS=$'\t' read -r path purpose ow; do
  [ -z "$path" ] && continue
  if [ -e "$path" ] && [ "$ow" != "true" ] && [ "$FORCE" -eq 0 ]; then
    echo "  SKIP  $path (ja existe; use --force ou overwrite:true)"
    continue
  fi
  if [ "$DRY" -eq 1 ]; then
    echo "  DRY   $path  <- $purpose"
  else
    mkdir -p "$(dirname "$path")"
    [ -e "$path" ] && cp "$path" "$path.bak.$(date +%s)"
    : > "$path"
    echo "  WRITE $path  <- $purpose"
  fi
done < <(jq -r '.writes[]? | [.path, .purpose, (.overwrite|tostring)] | @tsv' "$PLAN")

# Gate 3: passos manuais NUNCA sao executados. So impressos.
echo "== passos manuais (execute voce mesmo)"
jq -r '.manual_steps[]? | "  $ " + .command + "\n      motivo: " + .why + (if .verify then "\n      verifique: " + .verify else "" end)' "$PLAN"

# Gate 4: custo de contexto em tela.
PL=$(jq -r '.context_cost.plugins_enabled' "$PLAN")
MC=$(jq -r '.context_cost.mcps_enabled' "$PLAN")
echo "== custo de contexto: ${PL} plugins + ${MC} MCPs por sessao (escopo: $(jq -r '.context_cost.scope // "project"' "$PLAN"))"
if [ "$((PL + MC))" -gt 6 ]; then
  echo "   AVISO: acima de 6 extensoes habilitadas. Revise item a item."
fi

echo "== feito. Arquivos criados estao VAZIOS por design: o conteudo e gerado pelo agente na fase 6, com diff."
