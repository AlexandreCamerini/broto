#!/usr/bin/env bash
# Captura cada tela do journey nos 4 estados e monta o lado-a-lado com a referencia de arte.
#   telas.sh --pack <pack> [--tela <id>] [--kit]
set -uo pipefail
PACK=""; ALVO=""; MODO="todas"
while [ $# -gt 0 ]; do case "$1" in --pack) PACK="$2"; shift 2;; --tela) MODO="uma"; ALVO="$2"; shift 2;; --kit) MODO="kit"; shift;; *) shift;; esac; done
[ -n "$PACK" ] || { echo "uso: telas.sh --pack <ios|web|flutter>"; exit 2; }
O=".broto/telas"; mkdir -p "$O/lado-a-lado"; rm -f "$O"/*.png
lista(){
  case "$MODO" in
    kit)  printf 'kit:%s\n' acao-primaria acao-secundaria lista campo vazio erro carregando navegacao;;
    uma)  printf '%s:%s\n' "$ALVO" cheio "$ALVO" vazio "$ALVO" carregando "$ALVO" erro;;
    *)    python3 -c "
import yaml
for t in yaml.safe_load(open('.broto/journey.yaml'))['telas']:
    for e in ('cheio','vazio','carregando','erro'): print(f\"{t['id']}:{e}\")";;
  esac
}
cap_ios(){ # tela estado
  local d="$O/$1__$2.png" sim="${BROTO_SIM:-iPhone 16}" app bid
  xcrun simctl bootstatus "$sim" -b >/dev/null 2>&1 || xcrun simctl boot "$sim" >/dev/null 2>&1
  app=$(find ~/Library/Developer/Xcode/DerivedData -path '*iphonesimulator/*.app' -maxdepth 6 2>/dev/null | head -1)
  [ -n "$app" ] || { echo "app nao encontrado: rode o build para simulador antes"; return 1; }
  bid=$(defaults read "$app/Info" CFBundleIdentifier)
  xcrun simctl install booted "$app" >/dev/null; xcrun simctl terminate booted "$bid" 2>/dev/null
  SIMCTL_CHILD_BROTO_TELA="$1:$2" xcrun simctl launch booted "$bid" >/dev/null
  sleep "${BROTO_ESPERA:-2}"; xcrun simctl io booted screenshot "$d" >/dev/null 2>&1
}
cap_web(){ [ -f package.json ] && BROTO_TELA="$1:$2" BROTO_OUT="$O/$1__$2.png" npm run -s screenshot || { echo "defina scripts.screenshot (Playwright) no package.json"; return 1; }; }
cap_flutter(){ BROTO_TELA="$1:$2" flutter screenshot --out "$O/$1__$2.png" >/dev/null 2>&1; }
n=0; ok=0; itens=""
while IFS= read -r alvo; do
  t="${alvo%%:*}"; e="${alvo##*:}"; n=$((n+1))
  case "$PACK" in ios) cap_ios "$t" "$e";; web) cap_web "$t" "$e";; flutter) cap_flutter "$t" "$e";; esac
  f="$O/${t}__${e}.png"
  if [ -s "$f" ]; then ok=$((ok+1)); itens="$itens$t|$e|$f"$'\n'; printf '  %-26s ok\n' "$t/$e"; else printf '  %-26s FALHOU\n' "$t/$e"; fi
done < <(lista)
# lado a lado com a referencia da direcao de arte
if command -v magick >/dev/null || command -v convert >/dev/null; then
  IM=$(command -v magick || command -v convert)
  ref=$(ls .broto/refs/*.png 2>/dev/null | head -1)
  [ -n "$ref" ] && for f in "$O"/*.png; do b=$(basename "$f" .png)
    "$IM" "$f" "$ref" -resize x1200 +append -bordercolor white -border 8 "$O/lado-a-lado/$b.png" 2>/dev/null || true; done
fi
python3 -c "
import json,sys,datetime
itens=[l.split('|') for l in sys.argv[1].strip().split('\n') if l]
print(json.dumps({'em':datetime.datetime.now().isoformat(),'pack':sys.argv[2],
 'telas':[{'tela':a,'estado':b,'arquivo':c} for a,b,c in itens]},ensure_ascii=False))" "$itens" "$PACK" > "$O/manifesto.json"
echo "  capturas: $ok/$n -> $O/manifesto.json"
[ "$ok" -eq "$n" ] && [ "$n" -gt 0 ]
