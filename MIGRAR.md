# Migrar do Broto v2/v3 para o v4

O v4 nao e um patch: e menos plugin. Doze agentes viram cinco, o roteador sai, score vira booleano.

## O que morre e por que
- `roteador.md` e `agentes.json` — a `description` do agente ja e o roteamento. Tabela em markdown e contexto pago por sessao para reimplementar o que o modelo faz.
- `compliance-scout` e gates regulatorios — piloto. Fica so `privacidade` no pack ios, que e bloqueio de build.
- `ux-judge` + `ux_score.sh` — dois modelos da mesma familia com a mesma rubrica erram junto. Um juiz cego + contraste e a11y por script.
- `market-scout` — a pesquisa de referencia virou parte do estado `arte`, onde ela tem consumidor (a direcao visual) e gate (o criterio de comparacao).
- `discovery-interviewer` — entrevista de 12 perguntas e cerimonia para piloto. Oito perguntas dentro do estado `contrato`, sem agente dedicado.
- Estagios numerados — viraram estados nomeados, que voce pode revisitar.

## O que sobrevive
Gates executaveis, fail-closed, hook PreToolUse como trava, estado em arquivo, evals com graders. Era o que ja estava certo.

## O que e novo
`journey.yaml`/`arch.yaml` como contrato com gate proprio; o estado `arte` com tres direcoes e aprovacao humana; `tokens.sh` gerando token nativo; `gates/kit.sh` tornando o reuso mecanico em Swift e Dart, nao so em React; `gates/deriva.sh` respondendo a deriva de spec por tela.

## Passos
1. Instale o v4 num projeto novo pequeno. Nao migre o secv2 primeiro.
2. Rode os 5 evals contra v2.2 e v4. Compare.
3. Secv2: `scout` reconstroi `journey.yaml` e `arch.yaml` do codigo, `designer` roda o estado `arte` do zero, `gates/kit.sh` vai apontar cada cor crua. Conte com refatoracao real de interface, nao com remendo.
