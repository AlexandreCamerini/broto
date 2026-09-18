# Estagio 4 — Provar

Objetivo: `.broto/gates.json` sem falha bloqueante. "Funciona" so pode ser dito aqui.

Critica textual nao vale como prova. Tudo neste estagio executa e retorna veredito.

## Execucao

`qa-runner` (Sonnet) roda:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/verify_gates.sh" --pack <pack> --out .broto/gates.json
```

A saida obedece `templates/gate-result.schema.json`. Cada gate tem `id`, `status` (`pass|fail|skip`), `bloqueante` (bool), `medido`, `limite`, `como_corrigir`.

Gates universais em `references/gates.md`. Gates extras vem do pack.

## Bloqueantes (nao passa)

- build/compilacao falha
- teste da acao principal falha
- segredo detectado no bundle ou no historico do git
- acessibilidade: violacao critica (contraste, foco de teclado, rotulo ausente)
- IA sem teto de gasto configurado
- IA: taxa de acerto do eval abaixo do minimo declarado no plano

## Nao bloqueantes (avisa e registra)

- cobertura de teste abaixo da meta
- tamanho de bundle acima do orcamento
- dependencia desatualizada sem CVE

## Ao falhar

Voce conserta. Nao devolve a lista para a pessoa. Loop:

1. leia o `como_corrigir` do gate
2. corrija
3. rode so aquele gate de novo
4. maximo 3 tentativas por gate; na quarta, escale para a pessoa explicando a escolha em duas linhas

## Ao passar

Mostre um placar curto e humano:

> "Testei 11 coisas. Todas passaram. O app carrega em 1,2s, funciona no teclado, nao vaza chave nenhuma, e a IA acertou 19 de 20 perguntas de teste."

Grave `estagio: 5`.
