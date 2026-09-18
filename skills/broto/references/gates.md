# Gates universais

Todo gate executa e retorna veredito. Formato em `templates/gate-result.schema.json`.

| id | O que mede | Bloqueante | Limite padrao |
|---|---|---|---|
| `build` | projeto compila / empacota | sim | sem erro |
| `smoke` | acao principal do briefing funciona ponta a ponta | sim | passa |
| `segredos` | nenhuma chave no bundle, no repo ou no historico git | sim | zero ocorrencia |
| `deps-cve` | dependencia com vulnerabilidade critica conhecida | sim | zero critica |
| `a11y` | contraste, foco de teclado, rotulo de elemento interativo | sim | zero violacao critica |
| `lint` | erro de lint | nao | zero erro |
| `tipos` | erro de tipagem | nao | zero erro |
| `perf` | tempo ate interativo / cold start | nao | pack define |
| `bundle` | tamanho do pacote entregue | nao | pack define |
| `ia-eval` | acerto no conjunto de avaliacao | sim (se ha IA) | >= declarado no plano |
| `ia-teto` | teto de gasto configurado no proxy e no provedor | sim (se ha IA) | configurado |
| `ia-injecao` | entrada maliciosa nao vira instrucao | sim (se ha IA) | zero escape |

## Por que "referencia de mercado" precisa ser gate

Afirmar que o app segue as melhores praticas nao vale nada. Medir vale.

- acessibilidade: WCAG 2.1 AA e o piso, nao o teto
- performance web: Core Web Vitals dentro do orcamento declarado no plano
- mobile: cold start abaixo do limite do pack
- IA: taxa de acerto do eval e custo por interacao, ambos registrados a cada rodada

Se um criterio de qualidade nao pode ser medido por um comando, ele nao entra no plano como promessa.

## Regra de correcao

`qa-runner` conserta e reexecuta. Maximo 3 tentativas por gate. Na quarta, escale a pessoa com duas linhas: o que falha e quais sao as duas opcoes.
