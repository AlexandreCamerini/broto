#!/usr/bin/env bash
set -uo pipefail
F=".broto/metricas.json"; mkdir -p .broto; [ -f "$F" ] || echo '{"eventos":[]}' > "$F"
ev="${1:-?}"; shift || true
python3 - "$F" "$ev" "$@" <<'PY'
import json,sys,datetime
f,ev=sys.argv[1],sys.argv[2]; d=json.load(open(f))
item={'evento':ev,'em':datetime.datetime.now().isoformat()}
for a in sys.argv[3:]:
    if '=' in a: k,v=a.split('=',1); item[k]=v
d['eventos'].append(item); json.dump(d,open(f,'w'),ensure_ascii=False)
PY
