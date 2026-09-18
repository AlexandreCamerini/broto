<p align="center"><img src="brand/logo/broto-wordmark.svg" width="240" alt="broto"></p>
<p align="center"><b>Projeto que nasce certo.</b><br>Do briefing ao repo instrumentado. Barato, guiado, com você no controle.</p>

```
/broto novo "app de hidratação para iPhone e Watch, sem dados compartilhados"
```

Broto é um plugin do Claude Code da família [Semente](https://semente.dev). Ele faz quatro perguntas, pesquisa os melhores apps do seu nicho hoje, escreve o design antes do código, decide arquitetura dentro do teto de custo que você deu, e monta o ambiente de desenvolvimento com os cinco sinais que fazem um agente de código acertar mais: tipo, lint, correção, contexto e UX. Nada é escrito no seu repositório antes de você dizer sim.

## Para quem
Qualquer pessoa que cria software com agentes: do leigo ao orquestrador experiente. O perfil que você preenche uma vez (`/broto setup`) regula quanto ele explica.

## Instalar
```
/plugin marketplace add <owner>/broto
/plugin install broto@<marketplace>
/reload-plugins
/broto setup
```

## Comandos
| Comando | O que faz |
|---|---|
| `/broto` | menu guiado |
| `/broto setup` | seu perfil: custo, plataforma, exigência de UX, nível (8 perguntas, todas com default) |
| `/broto novo "<descrição>"` | projeto do zero |
| `/broto refactor <caminho>` | projeto existente |
| `/broto status` | o que está pronto, o que falta, custo mensal |

## O que ele entrega
```
docs/design-research.md   3 apps correlatos + 2 novidades de UX, com fonte e data
docs/design-brief.md      navegação, direção de arte com tokens, aposta, critérios de aceite
docs/adr/0001-*.md        decisão de arquitetura com custo mensal datado e gatilho de revisão
.claude/setup-plan.json   plano de ambiente já criticado (cortes e vetos registrados)
GUIA.md                   tudo acima em linguagem simples + o que VOCÊ instala, com "confira com"
CLAUDE.md (≤60 linhas)    o contrato que o agente lê em toda sessão
```

## Princípios
1. **Cinco sinais, custo mínimo.** Ferramenta sem sinal é dívida.
2. **Design antes de código.** Com referências vivas do mercado, datadas.
3. **Custo em dólar em toda decisão.** Preço confirmado ao vivo, nunca de memória.
4. **Núcleo portátil, casca nativa.** Use o máximo do OS na casca; o núcleo não importa SDK de plataforma. Ver `references/platform-fit.md`.
5. **Humano aprova.** Nada é escrito, instalado ou pago sem gate.

## Marca
Identidade completa em `brand/BRAND.md` (posicionamento, voz, cores com contraste testado, tipografia, logo em SVG, tokens CSS/JSON).

## Dívida conhecida
- Preços e "melhores apps" envelhecem; tudo fica datado, mas quem reabre é você.
- Dart/Flutter não tem plugin LSP oficial: sinal de tipo via hook `dart analyze`.
- `swift-lsp` exige projeto resolvido; o primeiro verify em repo Xcode novo pode falhar até o resolve de pacotes.
- Gate de UX por screenshot precisa de simulador; não existe em CI sem macOS.
- Nome "Broto" sem busca de marca registrada.

## Licença
MIT.
