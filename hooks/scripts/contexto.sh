#!/usr/bin/env bash
# Uma linha de onde o projeto parou, no inicio da sessao. Prefixo estavel, barato.
set -uo pipefail
[ -f .broto/estado.json ] || exit 0
python3 - <<'PY'
import json,os
e=json.load(open('.broto/estado.json'))
partes=[f"broto › estado: {e.get('estado','?')}"]
if e.get('kit'): partes.append(f"kit: {e['kit']}")
if os.path.exists('.broto/gates.json'):
    g=json.load(open('.broto/gates.json'))['resumo']
    partes.append(f"provas: {g['pass']} ok / {g['fail']} falhando")
print(" | ".join(partes))
PY
