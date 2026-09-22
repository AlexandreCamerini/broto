#!/usr/bin/env bash
# Invariantes 2 e 3, impostos: nao escreve tela antes do kit; nao cria componente fora do kit depois dele.
set -uo pipefail
input=$(cat); f=$(python3 -c "
import json,sys
try: d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path') or d.get('tool_input',{}).get('path') or '')
except: print('')" <<<"$input")
[ -n "$f" ] || exit 0
[ -f .broto/estado.json ] || exit 0
est=$(python3 -c "import json;print(json.load(open('.broto/estado.json')).get('estado',''))" 2>/dev/null)
kit=$(python3 -c "import json;print(json.load(open('.broto/estado.json')).get('kit',''))" 2>/dev/null)
case "$est" in kit|construcao|prova) ;; *) exit 0;; esac
case "$f" in *Kit/*|*/kit/*|*DesignSystem*|*tokens*|*.broto/*) exit 0;; esac
case "$f" in
  *View*.swift|*Screen*.swift|*/Views/*|*/Screens/*|*.tsx|*/pages/*|*/screens/*|*/lib/*.dart) ;;
  *) exit 0;;
esac
if [ "$kit" != "aprovado" ]; then
  echo "broto › o kit ainda nao foi aprovado. Antes de escrever tela: gere os tokens (scripts/tokens.sh), monte os componentes base e as telas vazias, capture com scripts/telas.sh --kit, passe pelo juiz e grave kit:\"aprovado\" em .broto/estado.json. Bloqueado: $f" >&2
  exit 2
fi
exit 0
