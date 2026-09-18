#!/usr/bin/env bash
# Verifica o ambiente antes de construir. Nao instala nada sem pedir.
set -uo pipefail
PACK="${1:-web}"
faltando=()

checa() { command -v "$1" >/dev/null 2>&1 && echo "ok      $1 ($($1 --version 2>&1 | head -1))" || { echo "FALTA   $1 — $2"; faltando+=("$1"); }; }

echo "== Preflight (pack: $PACK) =="
checa git "instale o git: https://git-scm.com"
checa jq "necessario para os gates: brew install jq | apt install jq"
case "$PACK" in
  web|ferramenta) checa node "instale o Node LTS: https://nodejs.org" ;;
  ios)            checa xcodebuild "instale o Xcode pela App Store"; checa swift "vem com o Xcode" ;;
  android)        checa java "instale o JDK 17+"; checa adb "instale o Android SDK Platform Tools" ;;
  multi)          checa node "instale o Node LTS"; echo "aviso   iOS e Android exigem Xcode/JDK — cobrados no estagio de publicacao" ;;
esac

if [ ${#faltando[@]} -gt 0 ]; then
  echo; echo "Faltam ${#faltando[@]} item(ns): ${faltando[*]}"; exit 1
fi
echo; echo "Ambiente pronto."; exit 0
