# Estagio 3 — Construir

Objetivo: o app rodando na maquina da pessoa, com **todas as telas do fluxo principal** implementadas contra `plano.ux` e aprovadas em screenshot. "Primeira tela visivel" nao encerra este estagio; encerrava, e produziu app com cara de esqueleto.

Leia `../references/autonomia.md` antes de comecar. Aqui voce decide sozinho.

## Ordem de execucao

1. **Preflight** — `bash "${CLAUDE_PLUGIN_ROOT}/scripts/preflight.sh" <pack>`. Se faltar algo, instale ou de o comando exato de uma linha.
1b. **Code intelligence** — language server do pack + plugin LSP (`typescript-lsp`, `pyright-lsp`, `swift-lsp`, `kotlin-lsp`). Erro de tipo no mesmo turno da edicao.
2. **Aplicar o plano** — `plan-applier` em copia isolada; em projeto sem git, `scripts/apply_plan.sh .broto/plano.json` para ensaio.
3. **Esqueleto** — estrutura do pack, dependencias, configuracao.
4. **Proxy de IA** — antes de qualquer chamada de IA. `templates/proxy-ia/`. Chave nunca em arquivo.
5. **Kit de interface** — ANTES de qualquer tela. A partir de `plano.ux.direcao_visual`, gere em codigo: tokens (cor com variante escura, tipografia com escala dinamica, espacamento, raio, motion) e os componentes base que o fluxo pede (no minimo: botao primario, secundario, card/linha de lista, campo, estado vazio, estado de erro, indicador de carregando, barra de navegacao). Cada componente com preview. Rode `scripts/screenshots.sh --pack <pack> --kit`, delegue ao `ux-director` em modo `revisar`; so grave `kit: "aprovado"` em `estado.json` com todos os componentes aprovados. **O hook `guarda_ux` bloqueia edicao de arquivo de tela enquanto o kit nao estiver aprovado.**
   - Harness de captura: o app, em build de desenvolvimento, honra a variavel `BROTO_SCREEN=<tela>:<estado>` (ambiente no launch) e abre direto naquela tela naquele estado, com dados de exemplo. Sem isso nao ha screenshot automatizado. Detalhe por pack no arquivo do pack.
6. **Fatia vertical** — a acao principal do briefing ponta a ponta, usando **somente componentes do kit**. Componente novo fora do kit e desvio: volte ao passo 5.
7. **Passada de UI** — para cada `tela` em `plano.ux.fluxo_principal`, nos tres estados (vazio, carregando, erro) mais o cheio: implemente → `scripts/screenshots.sh --pack <pack> --tela <tela>` → `ux-director` modo `revisar` → aplique `maior_impacto` → repita. Maximo 4 iteracoes por tela; na quinta, escale a pessoa com o screenshot e duas opcoes. Nenhuma tela e "pronta" sem `veredito: aprovada` em `.broto/ux-review.json`.
8. **CLAUDE.md** — de `templates/CLAUDE.md.tmpl`. Inclua a secao "Interface: todo componente vem do kit; toda tela passa pelo gate ux".
9. **Guia** — `guia.md` de `templates/guia.md.tmpl`.
9b. **Permissoes de construcao** — `templates/settings-autonomia.json` → `.claude/settings.json`.
10. **Commit por etapa** — kit, fatia, cada tela aprovada: um commit cada.

## Durante

Linguagem comum, o tempo todo: o que fez, o que vem, quanto falta. No passo 7, mostre o screenshot para a pessoa a cada tela aprovada: "ficou assim, pode seguir?". Ela e o ultimo juiz; o `ux-director` e o primeiro.

Quando quebrar, nao despeje stack trace.

## Fim do estagio

Condicoes, todas:
- `estado.json` tem `kit: "aprovado"`.
- `.broto/ux-review.json` tem toda tela do `fluxo_principal` com `aprovada`, em todos os estados.
- A pessoa olhou e disse que sim.

Comemore. Grave `estagio: 4`.
