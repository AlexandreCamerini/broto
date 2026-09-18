# Pack: multi

Mesmo app em iOS + Android + web.

## Decisao de abordagem
- Interface simples, muito conteudo, atualizacao frequente -> base web com empacotamento nativo.
- Interface rica, gesto, camera, desempenho -> framework multiplataforma compilado para nativo.

`arch-decider` escolhe. Nao ofereca a escolha a pessoa.

## Ordem de lancamento — sempre
1. **Web primeiro.** Publica em horas, gera feedback real e nao depende de review.
2. Android depois. Review mais rapido.
3. iOS por ultimo. Review mais rigoroso, pre-requisitos mais caros.

Isso reduz o risco de a pessoa gastar semanas e descobrir que ninguem queria o app.

## Gates
Uniao dos gates de `web`, `ios` e `android` que se aplicam ao alvo ja lancado. Nao cobre gate de plataforma ainda nao publicada.

## Armadilhas
- Codigo compartilhado demais gera interface que parece estranha nas tres plataformas. Compartilhe logica, nao aparencia.
- Tres pipelines de release e tres vezes o trabalho de manutencao. So faca multi se o briefing exigir.
