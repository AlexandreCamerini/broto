#!/usr/bin/env bash
# Invariante 1, imposto: chave de IA nunca alcanca o cliente.
# Tres vetores: literal em arquivo, variavel com prefixo publico, chamada direta de codigo de cliente.
set -uo pipefail
input=$(cat)
eval "$(python3 -c "
import json,sys,shlex
try: d=json.load(sys.stdin); t=d.get('tool_input',{}) or {}
except: t={}
f=t.get('file_path') or t.get('path') or ''
c=(t.get('content') or '')+(t.get('new_string') or '')
print('f='+shlex.quote(f)); print('c='+shlex.quote(c))" <<<"$input")"
[ -n "$c" ] || exit 0

nega() { printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' \
  "$(python3 -c 'import json,sys;print(json.dumps(sys.argv[1]))' "$1")"; echo "broto › $1" >&2; exit 2; }

SK='sk'; A='ant'
case "$f" in *.broto/*|*.example|*gates/*|*guarda_chave.sh) exit 0;; esac

grep -qE "(${SK}-${A}-[A-Za-z0-9_-]{20,}|${SK}-[A-Za-z0-9]{32,}|AIza[0-9A-Za-z_-]{30,})" <<<"$c" \
  && nega "chave literal em ${f##*/}. A chave vive no cofre do sistema e e lida pelo servidor; o cliente chama o proxy."

grep -qE '(NEXT_PUBLIC|VITE_|REACT_APP_|EXPO_PUBLIC|PUBLIC_)[A-Z_]*(API_KEY|SECRET|TOKEN|ANTHROPIC|OPENAI|GEMINI)' <<<"$c" \
  && nega "variavel de segredo com prefixo publico em ${f##*/}: prefixo publico entra no bundle e fica legivel. Mova para o servidor."

if grep -qE 'api\.(anthropic|openai)\.com|generativelanguage\.googleapis' <<<"$c"; then
  case "$f" in
    */api/*|*/server/*|*/functions/*|*/routes/*|*proxy*|*Service*.swift|*/backend/*) ;;
    *.tsx|*.jsx|*View*.swift|*Screen*.swift|*/Views/*|*/Screens/*|*/screens/*|*/widgets/*|*.vue|*.svelte)
      nega "chamada direta ao provedor de IA em ${f##*/}, que roda no cliente. Passe pelo proxy no servidor." ;;
  esac
fi
exit 0
