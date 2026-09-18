# Pack: ferramenta

Para CLI, extensao de navegador, bot (chat/mensageria), automacao.

## Toolchain padrao
- CLI: linguagem com binario unico ou runtime ja presente na maquina alvo
- Extensao: manifest atual da loja de extensoes
- Bot: webhook em servidor proprio, com fila para picos
- IA: proxy proprio; em CLI local, a chave pode ficar no ambiente do usuario — **nunca commitada**

## Gates do pack
| id | limite |
|---|---|
| `build` | binario/pacote gera sem erro |
| `smoke` | comando principal executa e retorna codigo 0 |
| `ajuda` | `--help` documenta todos os comandos |
| `permissoes` | extensao pede o minimo de permissoes possivel |
| `idempotencia` | rodar duas vezes nao quebra nem duplica |

## Distribuicao
- CLI: release no GitHub com binarios + instrucao de instalacao em uma linha
- Extensao: pacote na loja do navegador (review existe e demora)
- Bot: deploy no provedor + registro do webhook + teste de ponta a ponta

## Armadilhas
- Extensao que pede permissao ampla e rejeitada ou desinstalada.
- CLI destrutiva sem `--dry-run` e confirmacao e pedido de desastre.
- Bot sem rate limit por usuario vira conta alta em um dia.
