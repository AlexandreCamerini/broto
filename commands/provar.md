---
description: Testa o app de verdade e diz o que passou e o que nao passou
---

Use a skill `broto`, Estagio 4 (`skills/broto/stages/4-provar.md`).

Delegue ao agente `qa-runner`. Ele executa `scripts/verify_gates.sh`, corrige o que falha (ate 3 tentativas por gate) e grava `.broto/gates.json`.

Ao final, relate em placar humano, nao em log. Exemplo: "testei 11 coisas, 10 passaram; a que falhou e o contraste do botao principal — ja corrigi e passou."

Nunca declare que passou sem o comando ter rodado.
