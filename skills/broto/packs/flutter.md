# Pack flutter

## Ferramentas
Flutter SDK. Nao ha plugin LSP oficial de Dart: o sinal de tipo vem de `dart analyze` como hook depois de cada edicao, nao no mesmo turno. E mais lento; conte com isso ao escolher a stack.

## Tokens
`scripts/tokens.sh flutter` gera `lib/kit/tokens.dart` com `ThemeData` claro e escuro a partir do mesmo `tokens.json`. Nada de `Color(0xFF...)` em widget de tela.

## Reuso do prototipo
Widgets do kit sao os de producao. `scripts/gates/kit.sh` reprova `Color(0x`, `TextStyle(fontSize:` e `EdgeInsets` com numero cru fora de `lib/kit/`.

## Harness
`--dart-define=BROTO_TELA=tela:estado` monta a tela direto. `flutter screenshot` para captura; em iOS, o simulador tambem serve.

## Provas
`build`, `smoke` (`flutter test` de integracao), `analyze` (`--fatal-infos`), `a11y` (`meetsGuideline` nos testes de widget), `contraste`.
