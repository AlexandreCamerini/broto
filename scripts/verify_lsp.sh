#!/usr/bin/env bash
# Prova que o language server esta instalado e responde. O operador roda; nao precisa interpretar.
#   uso: verify_lsp.sh <swift|typescript|python|dart>
set -uo pipefail
L="${1:-}"
ok(){ printf '  [OK]   %s\n' "$1"; }
bad(){ printf '  [FALHA] %s\n     -> %s\n' "$1" "$2"; FAIL=1; }
FAIL=0
echo "== verificando LSP: $L"
case "$L" in
  swift)
    command -v sourcekit-lsp >/dev/null && ok "sourcekit-lsp no PATH ($(command -v sourcekit-lsp))" \
      || bad "sourcekit-lsp nao encontrado" "rode: xcode-select --install  e abra o Xcode uma vez"
    { [ -f Package.swift ] || ls *.xcodeproj >/dev/null 2>&1; } && ok "projeto Swift detectado" \
      || bad "nenhum Package.swift ou .xcodeproj na raiz" "o LSP so responde com projeto resolvido"
    ;;
  typescript)
    command -v typescript-language-server >/dev/null && ok "typescript-language-server no PATH" \
      || bad "typescript-language-server nao encontrado" "rode: npm i -g typescript-language-server typescript"
    [ -f tsconfig.json ] && ok "tsconfig.json presente" || bad "tsconfig.json ausente" "sem tsconfig o LSP nao tipa nada"
    ;;
  python)
    command -v pyright-langserver >/dev/null && ok "pyright-langserver no PATH" \
      || bad "pyright-langserver nao encontrado" "rode: npm i -g pyright   (ou pip install pyright)"
    { [ -f pyproject.toml ] || [ -f pyrightconfig.json ]; } && ok "config de projeto presente" \
      || bad "pyproject.toml/pyrightconfig.json ausente" "sem config o pyright usa defaults frouxos"
    ;;
  dart)
    command -v dart >/dev/null && ok "dart no PATH" || bad "dart nao encontrado" "instale o Flutter SDK"
    echo "  [INFO] Dart nao tem plugin LSP oficial; o sinal de tipo vem do hook 'dart analyze'."
    ;;
  *) echo "uso: $0 <swift|typescript|python|dart>"; exit 2;;
esac

# Teste de fumaca: o servidor sobe e responde ao initialize?
BIN=""
case "$L" in swift) BIN="sourcekit-lsp";; typescript) BIN="typescript-language-server --stdio";; python) BIN="pyright-langserver --stdio";; esac
if [ -n "$BIN" ] && [ "$FAIL" -eq 0 ]; then
  MSG='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
  OUT=$( (printf 'Content-Length: %d\r\n\r\n%s' "${#MSG}" "$MSG"; sleep 2) | timeout 8 $BIN 2>/dev/null | head -c 2000 )
  echo "$OUT" | grep -q '"capabilities"' && ok "servidor respondeu ao initialize" \
    || bad "servidor nao respondeu" "binario existe mas nao sobe; rode '$BIN' na mao e leia o erro"
fi

echo "== plugin no Claude Code"
echo "  rode /plugin e confira que ${L}-lsp (ou pyright-lsp) aparece como instalado; se nao, /reload-plugins"
[ "$FAIL" -eq 0 ] && echo "== RESULTADO: pronto" || { echo "== RESULTADO: pendencias acima"; exit 1; }
