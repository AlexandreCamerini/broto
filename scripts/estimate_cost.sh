#!/usr/bin/env bash
# Projeta custo mensal de IA. Precos entram como parametro — nunca hardcoded, porque mudam.
set -euo pipefail
usage() {
  cat <<'H'
uso: estimate_cost.sh --in-tok N --out-tok N --interacoes N \
     --preco-in USD_POR_MTOK --preco-out USD_POR_MTOK [--cache-hit 0.7] [--usd-brl 5.4]
Os precos vem de consulta a tabela vigente do provedor. Nao use valores de memoria.
H
}
IN=0; OUT=0; INTER=0; PIN=0; POUT=0; CACHE=0; USDBRL=5.4
while [ $# -gt 0 ]; do case "$1" in
  --in-tok) IN="$2"; shift 2;; --out-tok) OUT="$2"; shift 2;;
  --interacoes) INTER="$2"; shift 2;; --preco-in) PIN="$2"; shift 2;;
  --preco-out) POUT="$2"; shift 2;; --cache-hit) CACHE="$2"; shift 2;;
  --usd-brl) USDBRL="$2"; shift 2;; *) usage; exit 1;; esac; done
[ "$PIN" = "0" ] && { usage; exit 1; }

printf "%-10s %-14s %-14s\n" "usuarios" "USD/mes" "BRL/mes"
for U in 10 100 1000; do
  awk -v u="$U" -v i="$INTER" -v it="$IN" -v ot="$OUT" -v pi="$PIN" -v po="$POUT" -v c="$CACHE" -v fx="$USDBRL" \
    'BEGIN{ ent=it*(1-c)+it*c*0.1; usd=u*i*((ent/1000000)*pi+(ot/1000000)*po);
            printf "%-10d %-14.2f %-14.2f\n", u, usd, usd*fx }'
done
echo
echo "Premissa de cache: ${CACHE} do prefixo em cache, a ~10% do preco de entrada."
echo "Maior alavanca normalmente: cache de prefixo, tier menor na tarefa de maior volume, limite de entrada."
