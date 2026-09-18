#!/usr/bin/env bash
# Rede de seguranca: avisa se uma chave aparente foi escrita em arquivo versionavel.
set -uo pipefail
PADRAO='(sk-[a-zA-Z0-9_-]{16,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----)'
achados=$(grep -rIlE "$PADRAO" . \
  --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build \
  --exclude='*.lock' 2>/dev/null | grep -v '^./.broto/segredos.env' | head -5)
[ -z "$achados" ] && exit 0
echo "[broto] ALERTA: possivel chave/segredo em arquivo versionavel:"
echo "$achados" | sed 's/^/  /'
echo "[broto] mova para .broto/segredos.env (gitignored) e chame pelo proxy. Nunca no cliente."
exit 0
