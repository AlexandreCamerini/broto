# Estagio 3 — Construir

Objetivo: o app rodando na maquina da pessoa, com a primeira tela real visivel. Nada de placeholder generico.

## Ordem de execucao

1. **Preflight** — `bash "${CLAUDE_PLUGIN_ROOT}/scripts/preflight.sh"`. Verifica o que falta instalar. Se faltar algo, instale ou de o comando exato de uma linha. Nunca mande a pessoa "configurar o ambiente".
2. **Aplicar o plano** — `bash "${CLAUDE_PLUGIN_ROOT}/scripts/apply_plan.sh" .broto/plano.json --dry-run` primeiro. Mostre o que vai acontecer. So depois rode sem `--dry-run`.
3. **Esqueleto** — estrutura do pack, dependencias, configuracao.
4. **Proxy de IA** — antes de qualquer chamada de IA. Copie `templates/proxy-ia/` e adapte. A chave vai para `.broto/segredos.env`, que ja esta no `.gitignore`.
5. **Fatia vertical** — a acao principal do briefing funcionando ponta a ponta. Uma tela, um caminho, de verdade. Nada de "Hello World".
6. **CLAUDE.md** — gere a partir de `templates/CLAUDE.md.tmpl` para que sessoes futuras do Claude Code peguem o contexto sozinhas.
7. **Guia** — `guia.md` na raiz, de `templates/guia.md.tmpl`: como rodar, como mudar as coisas mais obvias, o que nao mexer.
8. **Commit por etapa** — cada item acima e um commit com mensagem legivel. Em projeto existente, tudo na branch `broto/<data>`.

## Durante

Fale o tempo todo em linguagem comum. A cada etapa: o que fez, o que vem, quanto falta.

Quando quebrar, nao despeje stack trace. Diga o que quebrou, o que voce vai tentar, e tente. So envolva a pessoa se precisar de uma decisao ou de uma credencial.

## Fim do estagio

O app precisa abrir. Peca para a pessoa **olhar**:

> "Abre ai: http://localhost:3000. Ta aparecendo?"

Se sim, comemore — e este e um dos dois momentos que fazem alguem continuar. Grave `estagio: 4`.
