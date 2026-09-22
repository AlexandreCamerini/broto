---
description: Broto — do briefing ao app publicavel. Sem argumento, continua de onde parou.
argument-hint: "[descricao do app | caminho do repo]"
---

Ative a skill `broto`.

Entrada: $ARGUMENTS

Se `.broto/estado.json` existir, continue de onde parou e diga em uma linha onde estamos.
Se nao existir e a entrada for um caminho, e um projeto existente: comece por reconstruir o contrato.
Se nao existir e a entrada for texto, e um projeto novo.
Se nao houver entrada nem estado, pergunte apenas: "o que voce quer construir?".
