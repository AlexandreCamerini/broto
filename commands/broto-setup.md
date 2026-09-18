---
description: Cria ou atualiza o seu perfil do Broto (8 perguntas, uma por vez, todas com default)
---

Ative a skill `broto` em modo `setup`.

Objetivo: preencher `references/profile.template.md` e salvar em `~/.claude/broto/profile.md` (global) ou `.broto/profile.md` (se o usuario pedir por projeto).

Regras:
- Uma pergunta por vez. Cada uma com a resposta recomendada para quem esta comecando e o porque em uma linha. "ok" aceita o default.
- Nivel `leigo` liga explicacoes de meia linha para cada termo tecnico nas fases seguintes.
- Mostre o arquivo final e peca confirmacao antes de salvar. Nunca sobrescreva perfil existente sem mostrar o diff.
