#!/usr/bin/env bash
# journey.yaml e arch.yaml validos, coerentes entre si, e sem tela com duas acoes primarias.
set -uo pipefail
R="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
python3 - "$R" <<'PY'
import yaml,json,sys,os
R=sys.argv[1]; erros=[]
try: j=yaml.safe_load(open('.broto/journey.yaml'))
except Exception as e: print("journey.yaml ilegivel:",e); sys.exit(1)
try: a=yaml.safe_load(open('.broto/arch.yaml'))
except Exception as e: print("arch.yaml ilegivel:",e); sys.exit(1)
try:
    import jsonschema
    for f,d in (('journey',j),('arch',a)):
        jsonschema.validate(d,json.load(open(f"{R}/templates/{f}.schema.json")))
except ImportError: pass
except Exception as e: erros.append(f"schema: {e.message if hasattr(e,'message') else e}")
ids={t['id'] for t in j.get('telas',[])}
for t in j.get('telas',[]):
    if ',' in t.get('acao_primaria','') or ' e ' in t.get('acao_primaria',''):
        erros.append(f"tela '{t['id']}': acao primaria parece ser mais de uma — decida qual importa")
    for e in ('cheio','vazio','carregando','erro'):
        if not t.get('estados',{}).get(e): erros.append(f"tela '{t['id']}': estado '{e}' nao descrito")
for p in j.get('caminho_feliz',[]):
    if p not in ids: erros.append(f"caminho_feliz cita tela inexistente: {p}")
for op in a.get('operacoes',[]):
    for t in op.get('telas',[]):
        if t not in ids: erros.append(f"operacao '{op['nome']}' cita tela inexistente: {t}")
h=a.get('hospedagem',{})
if h.get('perfil')!='sem-backend' and not h.get('preco_consultado_em'): erros.append("hospedagem sem data de consulta de preco")
if not h.get('gatilho_revisao'): erros.append("hospedagem sem gatilho de revisao")
if erros: print("\n".join("  - "+e for e in erros)); sys.exit(1)
print(f"contrato ok: {len(ids)} telas, {len(a.get('operacoes',[]))} operacoes, host {h.get('escolha','n/a')} US$ {h.get('custo_mensal_usd',0)}/mes")
PY
