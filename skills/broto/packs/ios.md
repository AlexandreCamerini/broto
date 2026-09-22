# Pack ios — SwiftUI, iPhone e Mac

## Ferramentas
Xcode completo (nao so Command Line Tools), `xcodegen` se o projeto usa `project.yml`, `swiftformat`, `swiftlint`. Plugin `swift-lsp` do diretorio oficial para erro de tipo no mesmo turno. Sem Xcode, o estado `kit` nao comeca: tela escrita sem compilar e tela escrita as cegas.

## Tokens
`scripts/tokens.sh ios` gera `Kit/DesignSystem.swift`: `enum Cor`, `enum Tipo`, `enum Espaco`, `enum Movimento`, com variante clara e escura via `Color(light:dark:)`. Tipografia sempre por `Font.custom(..., relativeTo:)` ou estilo do sistema — nunca `.system(size:)` cru, senao a escala dinamica quebra.

## Harness de captura (obrigatorio no estado `kit`)
No ponto de entrada, dentro de `#if DEBUG`: leia `ProcessInfo.processInfo.environment["BROTO_TELA"]` no formato `tela:estado`. Presente, monte aquela tela naquele estado com dados de exemplo como raiz, pulando login e onboarding. `kit:<componente>` abre a galeria do componente. Logue `BROTO_PRONTO` quando a primeira tela montar. Em Release nada disso existe.

Sem harness nao ha screenshot, sem screenshot nao ha veredito, e sem veredito nada e "pronto".

## Reuso do prototipo
As Views do kit sao as Views de producao. Ganham `@State`, `@Observable` e chamadas ao nucleo; nao sao recriadas. `scripts/gates/kit.sh` reprova `Color(red:`, `Color(hex:`, `.font(.system(size:`, `.padding(<numero cru>)` e `.cornerRadius(<numero cru>)` fora de `Kit/`.

## Provas do pack
| gate | comando |
|---|---|
| `build` | `xcodebuild` para simulador, sem assinatura |
| `smoke` | XCUITest da acao primaria da jornada |
| `a11y` | XCUITest com `performAccessibilityAudit()` |
| `perf` | tempo do launch ate `BROTO_PRONTO` |
| `assets` | icone 1024 no catalogo e capturas nos tamanhos da loja |
| `privacidade` | manifesto de privacidade declara as APIs que o codigo usa, e existe texto de permissao para cada permissao pedida |

`privacidade` fica mesmo em piloto: nao e burocracia, e bloqueio de build e de submissao.

## Armadilhas
- `swift-lsp` so responde com pacotes resolvidos; rode o resolve antes do primeiro verify.
- Projeto com dois destinos: capture iPhone **e** Mac; o que funciona num nao funciona no outro.
- Mac Catalyst entrega iPad esticado. Dois destinos nativos com nucleo compartilhado custa quase o mesmo e entrega Mac de verdade.
