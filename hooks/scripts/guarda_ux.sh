#!/usr/bin/env bash
# PreToolUse Write|Edit: no Estagio 3, bloqueia edicao de arquivo de tela enquanto o kit nao foi aprovado.
set -uo pipefail
input=$(cat); f=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$input")
[ -n "$f" ] || exit 0
[ -f .broto/estado.json ] || exit 0
est=$(jq -r '.estagio // 0' .broto/estado.json); kit=$(jq -r '.kit // ""' .broto/estado.json)
[ "$est" = "3" ] || exit 0
case "$f" in
  *View*.swift|*Screen*.swift|*/Views/*|*/Screens/*|*/pages/*|*/screens/*|*.tsx|*/lib/*.dart) ;;
  *) exit 0;;
esac
case "$f" in *DesignSystem*|*/Kit/*|*/kit/*|*Tokens*|*/components/ui/*|*Components/*) exit 0;; esac
[ "$kit" = "aprovado" ] && exit 0
echo "broto › kit de interface ainda nao aprovado. Antes de escrever telas: gere tokens + componentes base, rode scripts/screenshots.sh --kit, passe pelo ux-director (modo revisar) e grave kit:\"aprovado\" em .broto/estado.json. Arquivo bloqueado: $f" >&2
exit 2
