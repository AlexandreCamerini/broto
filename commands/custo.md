---
description: Calcula quanto o app vai custar por mes conforme cresce
---

Use a skill `broto`.

Delegue ao agente `ai-architect`, que deve:

1. Ler `.broto/plano.json` (se nao existir, perguntar as premissas: quantas pessoas, quantas interacoes por pessoa, tamanho tipico de entrada e resposta).
2. **Buscar a tabela de precos vigente.** Nunca usar preco de memoria.
3. Calcular tres cenarios: 10, 100 e 1000 usuarios ativos por mes.
4. Contabilizar o desconto de cache de prefixo e o custo do escalonamento de tier.

Apresente em reais, em tabela de tres linhas, e diga em uma frase qual a maior alavanca de reducao neste app especifico (normalmente: cache de prefixo, tier menor na tarefa de maior volume, ou limite de tamanho de entrada).

Se nao houver teto de gasto configurado, avise que isso e gate bloqueante para publicar.
