#!/usr/bin/env bash
# Aplica o plano de forma nao-destrutiva. Dry-run e o padrao.
set -euo pipefail
PLANO="${1:-.broto/plano.json}"
DRY=true
for a in "$@"; do [ "$a" = "--executar" ] && DRY=false; done

[ -f "$PLANO" ] || { echo "erro: $PLANO nao existe"; exit 1; }
bash "${CLAUDE_PLUGIN_ROOT:-.}/scripts/validate_plan.sh" "$PLANO" >/dev/null || { echo "erro: plano invalido"; exit 1; }

if git rev-parse --git-dir >/dev/null 2>&1; then
  if [ -n "$(git status --porcelain)" ]; then
    echo "AVISO: ha alteracoes nao commitadas."
    $DRY || { echo "Commite ou guarde antes de executar. Abortando."; exit 1; }
  fi
  BR="broto/$(date +%Y%m%d-%H%M)"
  if $DRY; then echo "[dry-run] criaria a branch $BR"
  else git checkout -b "$BR"; echo "branch: $BR"; fi
else
  $DRY && echo "[dry-run] iniciaria repositorio git" || { git init -q; echo "git iniciado"; }
fi

echo
echo "== Etapas =="
jq -r '.distribuicao.passos[]' "$PLANO" | nl -w2 -s'. '
echo
if $DRY; then
  echo "Isto foi um ENSAIO. Nada foi alterado."
  echo "Para aplicar de verdade: bash apply_plan.sh $PLANO --executar"
else
  echo "Aplicando. Cada etapa vira um commit separado."
fi
