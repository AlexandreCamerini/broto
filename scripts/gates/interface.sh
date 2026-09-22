#!/usr/bin/env bash
# Veredito do juiz: existe, e mais novo que as capturas e que o codigo de tela, cobre tudo, zero reprovada.
set -uo pipefail
V=".broto/veredito.json"; M=".broto/telas/manifesto.json"
[ -f "$V" ] || { echo "sem veredito: rode telas.sh e delegue ao juiz"; exit 1; }
[ -f "$M" ] || { echo "sem capturas"; exit 1; }
[ "$V" -nt "$M" ] || { echo "veredito mais velho que as capturas"; exit 1; }
novo=$(find . -type f \( -name '*View*.swift' -o -name '*Screen*.swift' -o -name '*.tsx' -o -name '*.dart' \) \
  -not -path './.git/*' -not -path './node_modules/*' -not -path './.build/*' -newer "$V" 2>/dev/null | head -3)
[ -z "$novo" ] || { echo "tela editada depois do veredito: $novo"; exit 1; }
python3 - <<'PY'
import json,yaml,sys
v=json.load(open('.broto/veredito.json')); j=yaml.safe_load(open('.broto/journey.yaml'))
vis={(t['tela'],t['estado']) for t in v['telas']}
falta=[f"{t['id']}/{e}" for t in j['telas'] for e in ('cheio','vazio','carregando','erro') if (t['id'],e) not in vis]
if falta: print("sem veredito: "+", ".join(falta[:8])); sys.exit(1)
ruim=[f"{t['tela']}/{t['estado']}: {t.get('mudanca','')}" for t in v['telas'] if not t.get('aprovada')]
if ruim: print("reprovadas:\n"+"\n".join("  - "+r for r in ruim)); sys.exit(1)
print(f"interface ok: {len(vis)} telas/estados aprovados")
PY
