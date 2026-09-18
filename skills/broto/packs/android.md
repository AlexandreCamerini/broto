# Pack: android

Para Android com distribuicao pelo Google Play.

## Pre-requisitos
- Conta de desenvolvedor Google Play (taxa unica)
- JDK e SDK Android

## Toolchain padrao
- Kotlin com Compose quando o app e so Android
- Dados locais: persistencia nativa
- Backend/IA: proxy proprio
- Distribuicao de teste: trilha de teste interno

## Gates do pack
| id | limite |
|---|---|
| `build` | AAB assinado sem erro |
| `perf` | cold start <= 2s em aparelho de gama media |
| `a11y` | TalkBack navega a acao principal; area de toque >= 48dp |
| `privacy` | formulario de seguranca de dados coerente com o app |
| `assets` | icone adaptativo e capturas nos tamanhos exigidos |

## Distribuicao
1. keystore de upload gerado e **guardado pela pessoa** (perder = perder o app)
2. AAB assinado
3. ficha da loja + formulario de seguranca de dados
4. trilha de teste interno com 1 testador real
5. producao

## Armadilhas
- Perder o keystore e irreversivel. Diga isso em voz alta e confirme que foi salvo fora da maquina.
- Formulario de seguranca de dados inconsistente com o codigo trava a publicacao.
- Fragmentacao de tela: teste em pelo menos duas densidades.
