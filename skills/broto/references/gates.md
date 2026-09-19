# Gates universais

Todo gate executa e retorna veredito. Formato em `templates/gate-result.schema.json`.

| id | O que mede | Bloqueante | Limite padrao |
|---|---|---|---|
| `build` | projeto compila / empacota | sim | sem erro |
| `smoke` | acao principal do briefing funciona ponta a ponta | sim | passa |
| `segredos` | nenhuma chave no bundle, no repo ou no historico git | sim | zero ocorrencia |
| `deps-cve` | dependencia com vulnerabilidade critica conhecida | sim | zero critica |
| `a11y` | contraste, foco de teclado, rotulo de elemento interativo | sim | zero violacao critica |
| `ux` | cada tela do fluxo principal, em cada estado, passa os `criterios_aceite` de `plano.ux` | sim | zero tela reprovada; review mais novo que codigo e screenshots |
| `lint` | erro de lint | nao | zero erro |
| `tipos` | erro de tipagem | nao | zero erro |
| `perf` | tempo ate interativo / cold start | nao | pack define |
| `bundle` | tamanho do pacote entregue | nao | pack define |
| `ia-eval` | acerto no conjunto de avaliacao | sim (se ha IA) | >= declarado no plano |
| `ia-teto` | teto de gasto configurado no proxy e no provedor | sim (se ha IA) | valor de `teto_gasto_brl` |
| `ia-injecao` | entrada maliciosa nao vira instrucao | sim (se ha IA) | zero escape |

## Gate bloqueante sem comando e FALHA, nao skip

Se o pack nao fornece comando para um gate bloqueante, o resultado e `fail` com `medido: "sem comando para este pack"`. Antes, virava `skip` e o projeto passava verde sem compilar. Skip so existe para gate nao-bloqueante ou nao-aplicavel (`ia-*` sem IA).

## Por que "referencia de mercado" precisa ser gate

Afirmar que o app segue as melhores praticas nao vale nada. Medir vale.

- acessibilidade: WCAG 2.1 AA e o piso
- performance web: Core Web Vitals dentro do orcamento do plano
- mobile: cold start abaixo do limite do pack
- IA: taxa de acerto do eval e custo por interacao
- **interface: screenshot real de cada tela e estado, julgado contra rubrica fixada no plano**

Se um criterio nao pode ser medido por um comando, ele nao entra como promessa. O gate `ux` obedece a regra do mesmo jeito que `ia-eval`: o comando e `scripts/screenshots.sh` + `ux-director` em modo `revisar`; a rubrica (`criterios_aceite`) foi congelada no Estagio 2 e o revisor so ve imagens, nunca codigo. Juiz por LLM com rubrica fixa ja e aceito em `ia-eval`; `ux` e o mesmo mecanismo apontado para a tela.

## Regra de correcao

`qa-runner` conserta e reexecuta. Maximo 3 tentativas por gate. Na quarta, escale a pessoa com duas linhas. Para `ux`, a correcao e sempre o `maior_impacto` da tela reprovada, uma por vez.
