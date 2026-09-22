#!/usr/bin/env bash
# Contraste WCAG calculado sobre os tokens. Determinismo no lugar de juizo de modelo.
set -uo pipefail
[ -f .broto/tokens.json ] || { echo "sem tokens.json"; exit 1; }
python3 - <<'PY'
import json,sys
t=json.load(open('.broto/tokens.json'))['cor']
def v(k,dark): 
    c=t[k]; return c['$extensions']['broto.dark'] if dark and '$extensions' in c else c['$value']
def lum(h):
    h=h.lstrip('#'); r,g,b=[int(h[i:i+2],16)/255 for i in (0,2,4)]
    f=lambda c: c/12.92 if c<=0.03928 else ((c+0.055)/1.055)**2.4
    return .2126*f(r)+.7152*f(g)+.0722*f(b)
def cr(a,b):
    la,lb=lum(a),lum(b); hi,lo=max(la,lb),min(la,lb); return (hi+.05)/(lo+.05)
ruim=[]
for modo,d in (("claro",False),("escuro",True)):
    for fg,bg,minimo,rot in (("texto","fundo",4.5,"texto/fundo"),("texto","superficie",4.5,"texto/superficie"),
                             ("sutil","fundo",4.5,"sutil/fundo"),("primaria","fundo",3.0,"primaria/fundo"),
                             ("erro","fundo",4.5,"erro/fundo")):
        r=cr(v(fg,d),v(bg,d))
        print(f"  {modo:7} {rot:20} {r:.2f}:1 (min {minimo})")
        if r<minimo: ruim.append(f"{modo} {rot} {r:.2f}<{minimo}")
if ruim: print("REPROVA: "+ "; ".join(ruim)); sys.exit(1)
print("contraste ok")
PY
