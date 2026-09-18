---
description: Broto — faz um projeto nascer certo. Sem argumento abre o menu guiado.
argument-hint: "[novo|refactor|setup|status] [descricao ou caminho]"
---

Ative a skill `broto`.

Modo: $1
Alvo: $2

Se `$1` estiver vazio, mostre este menu e espere a escolha (uma linha cada, sem jargao):
1. **novo** — comecar um projeto do zero
2. **refactor** — arrumar um projeto que ja existe
3. **setup** — contar ao Broto quem voce e (faz uma vez; ele nao pergunta de novo)
4. **status** — ver o que esta pronto, o que falta e quanto custa por mes

Se nao existir `.broto/profile.md` nem `~/.claude/broto/profile.md`, rode `setup` antes de qualquer outro modo.

Regras nao negociaveis:
- Uma pergunta por vez, sempre com resposta recomendada e o motivo em uma linha.
- Design brief antes de arquitetura; arquitetura antes de ambiente.
- Nenhuma escrita no repo e nenhum `/plugin install` antes do gate humano.
- Toda proposta mostra custo mensal em US$.
- Prefixe mensagens do plugin com `broto ›`.
