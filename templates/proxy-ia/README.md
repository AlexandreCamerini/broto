# Proxy de IA — obrigatorio

Este proxy existe por um motivo simples: **chave de API dentro do app e chave publica**.

Ele tambem entrega, de graca:
- rate limit por usuario
- teto de gasto global
- log de custo por chamada
- troca de modelo sem republicar o app
- guardrail de entrada e saida

## Como usar
1. Copie `handler.js` (ou o equivalente da sua stack) para a camada de servidor do app.
2. Coloque a chave em `.broto/segredos.env` (ja esta no `.gitignore`).
3. O cliente chama **o seu endpoint**, nunca o provedor.

## Checklist antes de publicar
- [ ] chave existe apenas no servidor / painel do provedor de hospedagem
- [ ] rate limit por usuario ativo
- [ ] teto global configurado no proxy E no painel do provedor de IA
- [ ] entrada com limite de tamanho
- [ ] saida do modelo nunca renderizada como HTML cru
- [ ] conteudo de terceiros isolado como dado, com instrucao explicita ao modelo
