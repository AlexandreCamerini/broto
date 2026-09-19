# Pack: ios

Para iPhone/iPad com distribuicao pela App Store.

## Pre-requisitos inegociaveis
- Mac com Xcode
- Conta Apple Developer paga (custo anual) — **avise sobre isso no Estagio 2**, nao no 5
- Apple ID com 2FA

## Toolchain padrao
- SwiftUI nativo quando o app e so iOS
- Dados locais: persistencia nativa do sistema
- Backend/IA: proxy proprio; nunca chave no bundle
- Distribuicao de teste: TestFlight

## Harness de captura (obrigatorio, passo 5 do Estagio 3)
No `App` (ponto de entrada), em `#if DEBUG`: leia `ProcessInfo.processInfo.environment["BROTO_SCREEN"]` (formato `tela:estado`). Se presente, injete um `PreviewData` correspondente e apresente aquela tela naquele estado como raiz, pulando login/onboarding. `kit:<componente>` abre uma galeria do componente. Sem isso `scripts/screenshots.sh` nao tem como capturar e o gate `ux` falha por falta de evidencia. Em Release o bloco nao existe.

No destino Mac, o mesmo harness le a variavel via `open -n --env`; a captura e por `screencapture -l<windowid>`.

## Gates do pack
| id | limite |
|---|---|
| `build` | `xcodebuild` para simulador sem erro (archive assinado fica para o Estagio 5) |
| `ux` | toda tela do fluxo, nos 4 estados, `aprovada` no review; no projeto com dois destinos, iPhone E Mac |
| `perf` | cold start <= 2s em dispositivo de 2 geracoes atras |
| `a11y` | VoiceOver navega a acao principal; Dynamic Type sem corte de texto |
| `privacy` | privacy manifest declarado e coerente com o que o app coleta |
| `assets` | icone e capturas em todos os tamanhos exigidos |

## Distribuicao — passo a passo assistido
1. Bundle ID no portal da Apple
2. Certificado e perfil (Xcode automatico quando possivel)
3. Politica de privacidade em URL publica
4. Ficha da App Store: nome, subtitulo, descricao, palavras-chave, capturas
5. Archive -> upload -> TestFlight
6. Convidar 1 pessoa real para testar antes de submeter
7. Submissao para review

## Armadilhas
- Tela escrita sem Xcode instalado e tela escrita as cegas. Preflight bloqueia o Estagio 3 sem `xcodebuild -version`.
- "Tela minima" da fatia vertical nao e tela final. O estagio so fecha com a passada de UI completa.
- Review rejeita app que e "so um site empacotado". Precisa de funcao nativa real.
- Bem digital vendido dentro do app: comissao da Apple e obrigatoriedade de In-App Purchase.
- Privacy manifest incompleto derruba o upload, nao o review — o erro aparece tarde.
- Senha de certificado: a pessoa digita. Voce nunca pede nem guarda.
