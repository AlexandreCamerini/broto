#!/usr/bin/env bash
# Gera o arquivo de tokens nativo do pack a partir de .broto/tokens.json (DTCG).
#   tokens.sh <ios|web|flutter> [--out <caminho>]
set -euo pipefail
PACK="${1:-}"; shift || true
OUT=""; while [ $# -gt 0 ]; do case "$1" in --out) OUT="$2"; shift 2;; *) shift;; esac; done
[ -n "$PACK" ] || { echo "uso: tokens.sh <ios|web|flutter>"; exit 2; }
[ -f .broto/tokens.json ] || { echo "falta .broto/tokens.json (estado arte)"; exit 1; }
python3 - "$PACK" "$OUT" <<'PY'
import json,sys,os,pathlib
pack,out=sys.argv[1],sys.argv[2]
t=json.load(open('.broto/tokens.json'))
cor={k:(v['$value'],v.get('$extensions',{}).get('broto.dark',v['$value'])) for k,v in t['cor'].items()}
esc=t['tipo']['escala']['$value']; base=t['espaco']['base']['$value']
raio=t['forma']['raio']['$value']; dur=t['movimento']['duracao']['$value']; cur=t['movimento']['curva']['$value']
def hx(h): h=h.lstrip('#'); return tuple(int(h[i:i+2],16)/255 for i in (0,2,4))
if pack=='ios':
    out=out or 'Kit/DesignSystem.swift'
    L=['// Gerado por broto tokens.sh — nao edite a mao. Fonte: .broto/tokens.json','import SwiftUI','',
       'public extension Color {',
       '    init(light: Color, dark: Color) {',
       '        #if os(iOS)',
       '        self.init(UIColor { $0.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light) })',
       '        #else',
       '        self.init(NSColor(name: nil) { $0.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light) })',
       '        #endif',
       '    }','}','','public enum Cor {']
    for k,(l,d) in cor.items():
        rl,gl,bl=hx(l); rd,gd,bd=hx(d)
        L.append(f'    public static let {k} = Color(light: Color(red: {rl:.4f}, green: {gl:.4f}, blue: {bl:.4f}), dark: Color(red: {rd:.4f}, green: {gd:.4f}, blue: {bd:.4f}))')
    L+= ['}','','public enum Tipo {']
    nomes=['legenda','corpoPequeno','corpo','titulo','display']
    estilos=['.caption','.subheadline','.body','.title3','.largeTitle']
    for n,s,v in zip(nomes,estilos,esc):
        L.append(f'    public static let {n}: Font = .system({s}, design: .default)  // ~{v}pt, escala dinamica preservada')
    L+= ['}','','public enum Espaco {']
    for i,m in enumerate([0.5,1,1.5,2,3,4]):
        L.append(f'    public static let e{i+1}: CGFloat = {base*m:g}')
    L+= ['}','','public enum Forma {',f'    public static let raio: CGFloat = {raio:g}','}','',
         'public enum Movimento {', f'    public static let padrao: Animation = .timingCurve({cur[0]}, {cur[1]}, {cur[2]}, {cur[3]}, duration: {dur/1000:.3f})','}','']
    txt='\n'.join(L)
elif pack=='web':
    out=out or 'src/kit/tokens.css'
    def blk(i): return '\n'.join(f'  --{k}: {v[i]};' for k,v in cor.items())
    txt=(f"/* Gerado por broto tokens.sh — nao edite a mao. */\n:root {{\n{blk(0)}\n"
         + '\n'.join(f'  --fonte-{i+1}: {v}px;' for i,v in enumerate(esc)) + '\n'
         + '\n'.join(f'  --espaco-{i+1}: {base*m:g}px;' for i,m in enumerate([0.5,1,1.5,2,3,4])) + '\n'
         + f"  --raio: {raio}px;\n  --duracao: {dur}ms;\n  --curva: cubic-bezier({cur[0]},{cur[1]},{cur[2]},{cur[3]});\n}}\n"
         + f"@media (prefers-color-scheme: dark) {{ :root:not([data-theme=\"light\"]) {{\n{blk(1)}\n}} }}\n"
         + f":root[data-theme=\"dark\"] {{\n{blk(1)}\n}}\n")
else:
    out=out or 'lib/kit/tokens.dart'
    def c(h): return '0xFF'+h.lstrip('#').upper()
    L=['// Gerado por broto tokens.sh — nao edite a mao.',"import 'package:flutter/material.dart';",'','class Cor {']
    for k,(l,d) in cor.items():
        L.append(f'  static const {k}Claro = Color({c(l)});'); L.append(f'  static const {k}Escuro = Color({c(d)});')
    L+=['}','','class Espaco {'] + [f'  static const e{i+1} = {base*m:g};' for i,m in enumerate([0.5,1,1.5,2,3,4])] + ['}','',
        'class Forma {', f'  static const raio = {raio:g};', '}', '', 'class Movimento {',
        f'  static const duracao = Duration(milliseconds: {dur});',
        f'  static const curva = Cubic({cur[0]}, {cur[1]}, {cur[2]}, {cur[3]});', '}','',
        'ThemeData temaClaro() => ThemeData(brightness: Brightness.light, colorSchemeSeed: Cor.primariaClaro, scaffoldBackgroundColor: Cor.fundoClaro, useMaterial3: true);',
        'ThemeData temaEscuro() => ThemeData(brightness: Brightness.dark, colorSchemeSeed: Cor.primariaEscuro, scaffoldBackgroundColor: Cor.fundoEscuro, useMaterial3: true);','']
    txt='\n'.join(L)
pathlib.Path(out).parent.mkdir(parents=True,exist_ok=True); open(out,'w').write(txt)
print(f"tokens -> {out}")
PY
