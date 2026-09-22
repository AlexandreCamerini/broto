#!/usr/bin/env bash
# Deriva de contrato: o journey mudou depois que a tela foi aprovada? Invalida SO as telas afetadas.
#   deriva.sh          -> lista e falha se houver tela invalidada
#   deriva.sh --marcar -> grava o hash atual por tela em .broto/aprovacoes.json (usado ao aprovar)
set -uo pipefail
J=".broto/journey.yaml"; A=".broto/aprovacoes.json"
[ -f "$J" ] || { echo "sem journey.yaml"; exit 1; }
[ -f "$A" ] || echo '{}' > "$A"
hashes=$(python3 - <<'PY'
import yaml,json,hashlib
j=yaml.safe_load(open('.broto/journey.yaml'))
arte=json.dumps(j.get('arte',{}).get('direcao',''),sort_keys=True)
out={}
for t in j['telas']:
    # o hash cobre o que, se mudar, invalida a tela: objetivo, acao primaria, estados, e a direcao de arte
    corpo=json.dumps({k:t.get(k) for k in ('objetivo','acao_primaria','estados','capacidades_so')},sort_keys=True,ensure_ascii=False)+arte
    out[t['id']]=hashlib.sha256(corpo.encode()).hexdigest()[:12]
print(json.dumps(out))
PY
)
if [ "${1:-}" = "--marcar" ]; then echo "$hashes" > "$A"; echo "aprovacoes marcadas"; exit 0; fi
python3 - "$hashes" <<'PY'
import json,sys
atual=json.loads(sys.argv[1]); aprov=json.load(open('.broto/aprovacoes.json'))
novas=[k for k in atual if k not in aprov]
mudou=[k for k in atual if k in aprov and atual[k]!=aprov[k]]
sumiu=[k for k in aprov if k not in atual]
if not (novas or mudou or sumiu):
    print(f"contrato estavel: {len(atual)} telas aprovadas"); raise SystemExit(0)
if novas: print("telas novas no contrato, ainda sem aprovacao: "+", ".join(novas))
if mudou: print("telas cujo contrato mudou apos a aprovacao (voltar so estas ao kit): "+", ".join(mudou))
if sumiu: print("telas aprovadas que sairam do contrato (remover o codigo): "+", ".join(sumiu))
raise SystemExit(1)
PY
