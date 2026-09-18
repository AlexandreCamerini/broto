#!/usr/bin/env bash
# Valida .broto/plano.json contra o schema. Sem schema-validator, cai para checagem estrutural minima.
set -uo pipefail
PLANO="${1:-.broto/plano.json}"
SCHEMA="${CLAUDE_PLUGIN_ROOT:-.}/templates/plano.schema.json"

[ -f "$PLANO" ] || { echo "erro: $PLANO nao existe"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "erro: jq nao instalado"; exit 1; }
jq empty "$PLANO" 2>/dev/null || { echo "erro: $PLANO nao e JSON valido"; exit 1; }

if command -v ajv >/dev/null 2>&1; then
  ajv validate -s "$SCHEMA" -d "$PLANO" --strict=false || exit 1
else
  echo "aviso: ajv nao encontrado — checagem estrutural minima"
  for campo in .versao .app.nome .app.acao_principal .pack .arquitetura.ia.proxy_obrigatorio .qualidade.gates .distribuicao.passos; do
    v=$(jq -r "$campo // \"__vazio__\"" "$PLANO")
    [ "$v" = "__vazio__" ] && { echo "erro: campo obrigatorio ausente: $campo"; exit 1; }
  done
fi

# Regra inviolavel, independente do validador
if [ "$(jq -r '.arquitetura.ia.proxy_obrigatorio' "$PLANO")" != "true" ]; then
  echo "erro: proxy_obrigatorio deve ser true. Chave de IA nunca vai ao cliente."; exit 1
fi
if [ "$(jq -r '.arquitetura.ia.usa' "$PLANO")" = "true" ]; then
  for campo in .arquitetura.ia.eval_minimo .arquitetura.ia.teto_gasto_brl_mes; do
    [ "$(jq -r "$campo // \"__vazio__\"" "$PLANO")" = "__vazio__" ] && { echo "erro: app com IA exige $campo"; exit 1; }
  done
fi
echo "plano valido"
