#!/usr/bin/env bash
# Gate ux: .broto/ux-review.json existe, e mais novo que screenshots e codigo de tela, e nao tem tela reprovada.
set -uo pipefail
R=".broto/ux-review.json"; M=".broto/cache/screens/manifest.json"
[ -f "$R" ] || { echo "sem review: rode screenshots.sh e ux-director modo revisar"; exit 1; }
[ -f "$M" ] || { echo "sem screenshots"; exit 1; }
[ "$R" -nt "$M" ] || { echo "review mais velho que os screenshots"; exit 1; }
# codigo de tela mais novo que o review -> review invalido
novo=$(find . -type f \( -name '*View*.swift' -o -name '*Screen*.swift' -o -path '*/Views/*' -o -name '*.tsx' -o -name '*.dart' \) \
  -not -path './.git/*' -not -path './node_modules/*' -not -path './.build/*' -newer "$R" 2>/dev/null | head -3)
[ -z "$novo" ] || { echo "tela editada depois do review: $novo"; exit 1; }
# cobertura: toda tela do fluxo, em 4 estados, presente no review
esperado=$(jq -r '.ux.fluxo_principal[].tela' .broto/plano.json 2>/dev/null | sort -u)
for t in $esperado; do
  n=$(jq -r --arg t "$t" '[.telas[] | select(.tela==$t and (.estado|startswith("mac-")|not))] | length' "$R")
  [ "$n" -ge 4 ] || { echo "tela '$t' com $n/4 estados revisados"; exit 1; }
done
ruim=$(jq -r '[.telas[] | select(.veredito!="aprovada")] | map(.tela+"/"+.estado+": "+.maior_impacto) | .[]' "$R")
[ -z "$ruim" ] || { echo "reprovadas:"; echo "$ruim"; exit 1; }
echo "ux: $(jq -r '.resumo.aprovadas' "$R") telas/estados aprovados"
