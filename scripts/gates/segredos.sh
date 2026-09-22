#!/usr/bin/env bash
set -uo pipefail
P='(sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{32,}|AIza[0-9A-Za-z_-]{30,}|ghp_[A-Za-z0-9]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,})'
h=$(grep -rnE "$P" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.build --exclude='*.example' 2>/dev/null | head -5)
[ -z "$h" ] || { echo "segredo no codigo:"; echo "$h"; exit 1; }
if [ -d .git ]; then
  g=$(git log -p --all -S 'sk-ant-' --oneline 2>/dev/null | head -3)
  [ -z "$g" ] || { echo "segredo no historico do git:"; echo "$g"; exit 1; }
fi
echo "segredos ok"
