#!/usr/bin/env bash
# Se o projeto e um projeto Broto, injeta o estado no inicio da sessao.
set -uo pipefail
[ -f .broto/estado.json ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0
est=$(jq -r '.estagio // "?"' .broto/estado.json 2>/dev/null)
pack=$(jq -r '.pack // "?"' .broto/estado.json 2>/dev/null)
bloq=$(jq -r '.resumo.bloqueado // false' .broto/gates.json 2>/dev/null || echo "sem-gates")
echo "[broto] projeto Broto detectado — estagio: $est | pack: $pack | gates bloqueados: $bloq"
echo "[broto] use /broto:status para retomar. Nao altere .broto/segredos.env."
exit 0
