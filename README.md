# Broto v4

Do briefing ao app publicavel. Um comando.

```
/broto "app de controle de plantas pro iPhone"
```

## Os seis invariantes

1. Todo artefato tem um leitor e um gate.
2. O contrato manda — `journey.yaml` e `arch.yaml` sao a fonte de verdade.
3. O prototipo e o produto — o kit aprovado e o codigo que vai para producao.
4. Prova, nao promessa — gate bloqueante sem comando falha, nunca pula.
5. Julgamento e booleano — sem nota de modelo; o que da para medir, mede-se por script.
6. A pessoa aprova duas vezes — a direcao de arte, e o app pronto.

## Como funciona

```
contrato  →  arte  →  kit  →  construcao  →  prova
            ▲ voce escolhe           voce aprova ▲
```

- **contrato**: `journey.yaml` (telas, 4 estados cada, uma acao primaria) + `arch.yaml` (entidades, operacoes, nucleo/casca, hospedagem com custo mensal datado).
- **arte**: 3 direcoes visuais distintas, com referencias reais e amostra visivel. Voce escolhe. Vira `tokens.json` (DTCG) e dele o arquivo nativo: `DesignSystem.swift`, `tokens.css` ou `tokens.dart`.
- **kit**: componentes e telas vazias em codigo de producao, so com tokens, sobre componentes nativos. Capturados, julgados por criterio booleano, vistos por voce.
- **construcao**: logica nas telas ja aprovadas. Hook bloqueia tela antes do kit.
- **prova**: `gates.sh` roda tudo. Placar em portugues no fim.

## Cinco agentes

`scout` (haiku) le o repo · `arquiteto` (opus) arquitetura e hospedagem · `designer` (opus) jornada, arte e kit · `juiz` (sonnet) olha screenshot cego ao codigo · `construtor` (sonnet) implementa e prova.

## O que impede o retrabalho

| Problema classico | Mecanismo |
|---|---|
| Documento de UX que ninguem le | `journey.yaml` alimenta o kit e o gate `contrato` |
| Prototipo jogado fora | `gates/kit.sh` reprova valor cru fora do kit; o componente do kit e o de producao |
| "Tela minima" virando tela final | hook `guarda.sh` + gate `interface` com os 4 estados |
| Spec que deriva do codigo | `gates/deriva.sh` invalida **so** as telas cujo contrato mudou |
| Gate que passa verde sem rodar | bloqueante sem comando = fail |
| Nota de UI inventada por modelo | criterios booleanos; contraste e a11y medidos por script |

## Instalar

```
/plugin marketplace add <owner>/broto
/plugin install broto@semente
/reload-plugins
```
Ferramentas por plataforma no `skills/broto/packs/<pack>.md`.

## Divida conhecida

- Captura depende de harness `BROTO_TELA` no app; sem ele nao ha veredito (por design, mas e trabalho manual na primeira vez).
- `telas.sh` acha o `.app` pelo DerivedData; projeto com varios schemes pode pegar o errado.
- Dart nao tem LSP oficial: sinal de tipo mais lento no pack flutter.
- O juiz e um so. E proposital (dois modelos da mesma familia erram junto), mas significa que gosto continua sendo seu.
- Preco de hospedagem envelhece; o `arch.yaml` guarda a data, quem reabre e voce.
