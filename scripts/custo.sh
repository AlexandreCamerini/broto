#!/usr/bin/env bash
# Placar da rodada, a partir de .broto/metricas.json (alimentado pelo hook SubagentStop).
set -uo pipefail
F=".broto/metricas.json"; [ -f "$F" ] || { echo "sem metricas ainda"; exit 0; }
python3 - <<'PY'
import json,collections,datetime
d=json.load(open('.broto/metricas.json'))['eventos']
ag=collections.Counter(e['nome'] for e in d if e['evento']=='agente')
print("agentes: "+(", ".join(f"{k}x{v}" for k,v in ag.most_common()) or "nenhum"))
print("buscas web:", sum(1 for e in d if e['evento']=='busca'))
ini=[e for e in d if e['evento']=='inicio']; tel=[e for e in d if e['evento']=='tela-aprovada']
if ini and tel:
    t=(datetime.datetime.fromisoformat(tel[0]['em'])-datetime.datetime.fromisoformat(ini[0]['em'])).total_seconds()
    print(f"primeira tela aprovada: {int(t//60)} min apos o inicio")
PY
