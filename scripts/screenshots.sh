#!/usr/bin/env bash
# Captura screenshots de telas/estados do app para o gate ux.
#   screenshots.sh --pack <ios|web|android|multi> [--todas | --tela <nome> | --kit]
# Saida: .broto/cache/screens/<tela>__<estado>.png + manifest.json
# Depende do harness: o app em build de dev honra BROTO_SCREEN=<tela>:<estado>.
set -uo pipefail
PACK=""; MODO="todas"; TELA=""
while [ $# -gt 0 ]; do case "$1" in
  --pack) PACK="$2"; shift 2;; --todas) MODO="todas"; shift;;
  --tela) MODO="tela"; TELA="$2"; shift 2;; --kit) MODO="kit"; shift;; *) shift;; esac; done
[ -n "$PACK" ] || { echo "uso: --pack <pack>"; exit 2; }
OUT=".broto/cache/screens"; mkdir -p "$OUT"; rm -f "$OUT"/*.png
command -v jq >/dev/null || { echo "jq ausente"; exit 2; }

# alvos: kit = componentes; tela = uma; todas = fluxo_principal x estados
if [ "$MODO" = "kit" ]; then
  ALVOS=$(jq -r '["botao-primario","botao-secundario","card","campo","vazio","erro","carregando","navegacao"][] | "kit:"+.' .broto/plano.json)
elif [ "$MODO" = "tela" ]; then
  ALVOS=$(printf '%s:%s\n' "$TELA" cheio "$TELA" vazio "$TELA" carregando "$TELA" erro)
else
  ALVOS=$(jq -r '.ux.fluxo_principal[].tela as $t | ["cheio","vazio","carregando","erro"][] | $t+":"+.' .broto/plano.json)
fi

captura_ios() { # tela estado
  local dest="$OUT/$1__$2.png"
  xcrun simctl boot "${BROTO_SIM:-iPhone 16}" 2>/dev/null; xcrun simctl bootstatus "${BROTO_SIM:-iPhone 16}" -b >/dev/null 2>&1
  local app; app=$(ls -d "$(xcodebuild -showBuildSettings -json 2>/dev/null | jq -r '.[0].buildSettings.TARGET_BUILD_DIR' 2>/dev/null)"/*.app 2>/dev/null | head -1)
  [ -n "$app" ] || app=$(find ~/Library/Developer/Xcode/DerivedData -path '*iphonesimulator/*.app' -maxdepth 6 2>/dev/null | head -1)
  [ -n "$app" ] || { echo "app nao encontrado; rode o build para simulador antes"; return 1; }
  local bid; bid=$(defaults read "$app/Info" CFBundleIdentifier)
  xcrun simctl install booted "$app" >/dev/null
  xcrun simctl terminate booted "$bid" 2>/dev/null
  SIMCTL_CHILD_BROTO_SCREEN="$1:$2" xcrun simctl launch booted "$bid" >/dev/null
  sleep "${BROTO_SETTLE:-2}"
  xcrun simctl io booted screenshot "$dest" >/dev/null 2>&1
}
captura_macos() { # tela estado — app Mac lancado com env; janela frontal
  local dest="$OUT/$1__$2.png"; local app; app=$(find ~/Library/Developer/Xcode/DerivedData -path '*/Debug/*.app' -maxdepth 6 2>/dev/null | head -1)
  [ -n "$app" ] || return 1
  pkill -f "$app/Contents/MacOS" 2>/dev/null; BROTO_SCREEN="$1:$2" open -n "$app"; sleep "${BROTO_SETTLE:-2}"
  local wid; wid=$(osascript -e 'tell application "System Events" to get id of first window of (first process whose frontmost is true)' 2>/dev/null)
  [ -n "$wid" ] && screencapture -x -l"$wid" "$dest" || screencapture -x "$dest"
}
captura_web() { # tela estado — Playwright via script do projeto
  local dest="$OUT/$1__$2.png"
  [ -f package.json ] && jq -e '.scripts["screenshot"]' package.json >/dev/null 2>&1 \
    && BROTO_SCREEN="$1:$2" BROTO_OUT="$dest" npm run -s screenshot || { echo "defina scripts.screenshot no package.json (Playwright)"; return 1; }
}

n=0; ok=0; itens="[]"
for alvo in $ALVOS; do
  t="${alvo%%:*}"; e="${alvo##*:}"; n=$((n+1))
  case "$PACK" in
    ios)   captura_ios "$t" "$e";;
    web)   captura_web "$t" "$e";;
    multi) captura_ios "$t" "$e" || captura_web "$t" "$e";;
    *)     echo "pack $PACK: captura nao implementada"; false;;
  esac
  f="$OUT/${t}__${e}.png"
  if [ -s "$f" ]; then ok=$((ok+1)); itens=$(jq -c --arg t "$t" --arg e "$e" --arg f "$f" '. + [{tela:$t,estado:$e,arquivo:$f}]' <<<"$itens"); printf '  %-28s ok\n' "$t/$e"
  else printf '  %-28s FALHOU\n' "$t/$e"; fi
done
# destino macOS do pack ios quando existir (dois destinos no mesmo projeto)
if [ "$PACK" = "ios" ] && [ "$MODO" != "kit" ] && ls *.xcodeproj >/dev/null 2>&1 && xcodebuild -list 2>/dev/null | grep -qi mac; then
  for alvo in $ALVOS; do t="${alvo%%:*}"; e="${alvo##*:}"; captura_macos "$t" "mac-$e" && itens=$(jq -c --arg t "$t" --arg e "mac-$e" --arg f "$OUT/${t}__mac-$e.png" '. + [{tela:$t,estado:$e,arquivo:$f}]' <<<"$itens"); done
fi
jq -n --arg d "$(date -Iseconds)" --arg p "$PACK" --arg m "$MODO" --argjson i "$itens" '{capturado_em:$d,pack:$p,modo:$m,telas:$i}' > "$OUT/manifest.json"
echo "capturas: $ok/$n -> $OUT/manifest.json"
[ "$ok" -eq "$n" ] && [ "$n" -gt 0 ]
