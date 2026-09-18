#!/usr/bin/env bash
# deploy.sh — implanta o Broto: valida, publica no git e registra no Claude Code.
# Nao-destrutivo por padrao: mostra o que vai fazer e pede confirmacao antes de cada acao com efeito.
#
#   bash deploy.sh                      # ensaio completo, nao altera nada
#   bash deploy.sh --executar           # valida + commit + push + instala
#   bash deploy.sh --executar --local   # instala do caminho local (nao usa GitHub)
#   bash deploy.sh --so-validar         # apenas a auditoria de estrutura

set -uo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$RAIZ"

DRY=true; LOCAL=false; SO_VALIDAR=false
REPO="${BROTO_REPO:-AlexandreCamerini/broto}"
MARKET="semente"
PLUGIN="broto"

for a in "$@"; do
  case "$a" in
    --executar)   DRY=false ;;
    --local)      LOCAL=true ;;
    --so-validar) SO_VALIDAR=true ;;
    -h|--help)    sed -n '2,10p' "$0"; exit 0 ;;
  esac
done

vermelho() { printf '\033[31m%s\033[0m\n' "$*"; }
verde()    { printf '\033[32m%s\033[0m\n' "$*"; }
info()     { printf '\033[2m%s\033[0m\n' "$*"; }
titulo()   { printf '\n\033[1m== %s ==\033[0m\n' "$*"; }

confirma() { # confirma "pergunta"
  $DRY && { info "[ensaio] $1"; return 1; }
  read -r -p "$1 [s/N] " r; [ "${r,,}" = "s" ]
}

erros=0
falha() { vermelho "  FALHA  $1"; erros=$((erros+1)); }
ok()    { verde    "  ok     $1"; }

# ---------------------------------------------------------------- 1. estrutura
titulo "1. Estrutura do plugin"

[ -f .claude-plugin/plugin.json ]      && ok "plugin.json"      || falha "falta .claude-plugin/plugin.json"
[ -f .claude-plugin/marketplace.json ] && ok "marketplace.json" || falha "falta .claude-plugin/marketplace.json"
[ -f skills/broto/SKILL.md ]           && ok "skill principal"  || falha "falta skills/broto/SKILL.md"

for d in .claude-plugin/commands .claude-plugin/agents .claude-plugin/skills .claude-plugin/hooks; do
  [ -d "$d" ] && falha "$d nao pode existir — componentes ficam na raiz do plugin, nunca dentro de .claude-plugin/"
done

n_agentes=$(ls -1 agents/*.md 2>/dev/null | wc -l | tr -d ' ')
n_comandos=$(ls -1 commands/*.md 2>/dev/null | wc -l | tr -d ' ')
n_estagios=$(ls -1 skills/broto/stages/*.md 2>/dev/null | wc -l | tr -d ' ')
n_packs=$(ls -1 skills/broto/packs/*.md 2>/dev/null | wc -l | tr -d ' ')
[ "$n_agentes"  -ge 8 ] && ok "$n_agentes agentes"   || falha "esperado 8 agentes, achei $n_agentes"
[ "$n_comandos" -ge 5 ] && ok "$n_comandos comandos" || falha "esperado 5 comandos, achei $n_comandos"
[ "$n_estagios" -eq 5 ] && ok "$n_estagios estagios" || falha "esperado 5 estagios, achei $n_estagios"
[ "$n_packs"    -ge 5 ] && ok "$n_packs packs"       || falha "esperado 5 packs, achei $n_packs"

# ---------------------------------------------------------------- 2. sintaxe
titulo "2. Sintaxe e contratos"

if command -v python3 >/dev/null 2>&1; then
  for j in .claude-plugin/*.json hooks/hooks.json templates/*.json; do
    [ -f "$j" ] || continue
    python3 -c "import json,sys;json.load(open(sys.argv[1]))" "$j" 2>/dev/null \
      && ok "json valido: $j" || falha "json invalido: $j"
  done
else
  info "python3 ausente — pulei validacao de JSON"
fi

for s in scripts/*.sh hooks/scripts/*.sh; do
  [ -f "$s" ] || continue
  bash -n "$s" 2>/dev/null && ok "bash ok: $s" || falha "erro de sintaxe: $s"
done

for f in agents/*.md commands/*.md skills/broto/SKILL.md; do
  head -1 "$f" | grep -q '^---$' && ok "frontmatter: $f" || falha "sem frontmatter: $f"
done

# ---------------------------------------------------------------- 3. seguranca
titulo "3. Seguranca"

if grep -rIlE '(sk-[a-zA-Z0-9_-]{16,}|AKIA[0-9A-Z]{16})' . --exclude-dir=.git 2>/dev/null | grep -q .; then
  falha "possivel segredo no repositorio do plugin"
else
  ok "nenhum segredo aparente"
fi
grep -q 'segredos.env' .gitignore 2>/dev/null && ok ".gitignore cobre segredos" || falha ".gitignore nao cobre .broto/segredos.env"
grep -rq 'proxy_obrigatorio' templates/plano.schema.json && ok "schema exige proxy de IA" || falha "schema nao exige proxy de IA"

# ---------------------------------------------------------------- resultado
titulo "Resultado da auditoria"
if [ "$erros" -gt 0 ]; then
  vermelho "$erros problema(s). Corrija antes de publicar."
  exit 1
fi
verde "Estrutura integra."
$SO_VALIDAR && exit 0

# ---------------------------------------------------------------- 4. git
titulo "4. Publicacao no git"

if ! command -v git >/dev/null 2>&1; then
  vermelho "git nao instalado. Pulando."
else
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    info "nao ha repositorio git aqui"
    if confirma "Iniciar repositorio e primeiro commit?"; then
      git init -q && git add -A && git commit -qm "feat: broto v2 — do escopo a loja"
      git branch -M main
      verde "repositorio iniciado"
      info "crie o repo remoto e rode: git remote add origin git@github.com:$REPO.git && git push -u origin main"
    fi
  else
    ver=$(python3 -c "import json;print(json.load(open('.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo "?")
    info "branch atual: $(git rev-parse --abbrev-ref HEAD) | versao do plugin: $ver"
    if [ -n "$(git status --porcelain)" ]; then
      git status --short | sed 's/^/    /'
      if confirma "Commitar estas alteracoes?"; then
        git add -A && git commit -qm "feat(broto): v$ver — roteiro de 5 estagios, 8 agentes, gates executaveis"
        verde "commit criado"
      fi
    else
      ok "arvore limpa"
    fi

    if git remote get-url origin >/dev/null 2>&1; then
      if confirma "Enviar para $(git remote get-url origin)?"; then
        git push -u origin "$(git rev-parse --abbrev-ref HEAD)" && verde "push concluido"
      fi
      if confirma "Criar a tag v$ver e enviar?"; then
        git tag -a "v$ver" -m "broto v$ver" && git push origin "v$ver" && verde "tag v$ver publicada"
      fi
    else
      info "sem remoto configurado — pulei o push"
    fi
  fi
fi

# ---------------------------------------------------------------- 5. claude code
titulo "5. Registro no Claude Code"

if ! command -v claude >/dev/null 2>&1; then
  vermelho "CLI 'claude' nao encontrada no PATH."
  info "Instale o Claude Code e rode este script de novo, ou registre manualmente:"
  info "  /plugin marketplace add $RAIZ"
  info "  /plugin install $PLUGIN@$MARKET"
  exit 0
fi

if $LOCAL; then
  FONTE="$RAIZ"
  info "fonte: caminho local ($FONTE) — nao depende de credencial do GitHub"
else
  FONTE="$REPO"
  info "fonte: GitHub ($FONTE) — repositorio privado exige credencial git valida"
fi

if confirma "Registrar o marketplace '$MARKET' a partir de $FONTE?"; then
  claude plugin marketplace add "$FONTE" && verde "marketplace registrado"
fi

if confirma "Atualizar o catalogo do marketplace '$MARKET'?"; then
  claude plugin marketplace update "$MARKET" && verde "catalogo atualizado"
  info "necessario sempre que voce publicar mudanca — o Claude Code nao atualiza marketplace local sozinho"
fi

if confirma "Instalar $PLUGIN@$MARKET no escopo do usuario?"; then
  claude plugin install "$PLUGIN@$MARKET" --scope user && verde "plugin instalado"
fi

titulo "Verificacao"
claude plugin list 2>/dev/null | sed 's/^/  /' || info "rode /plugin list dentro do Claude Code"

cat <<'FIM'

Proximos passos dentro do Claude Code:
  /reload-plugins            ativa sem reiniciar a sessao
  /plugin                    aba Errors mostra falha de carga; a aba Stats mostra o custo de contexto
  /broto:novo                primeiro uso real

Em desenvolvimento do proprio plugin, prefira:
  claude --plugin-dir <caminho deste repo>
  (edita, /reload-plugins, testa — sem install, sem cache, sem credencial)

Se as skills nao aparecerem:
  rm -rf ~/.claude/plugins/cache && reinicie o Claude Code
FIM
