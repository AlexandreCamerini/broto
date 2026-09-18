# Traducao: pergunta de produto -> decisao tecnica

Nunca faca a pergunta da coluna da direita.

| Pergunte assim | Nunca pergunte assim | Decide |
|---|---|---|
| "As pessoas precisam de conta?" | "Qual estrategia de autenticacao?" | auth, sessao, banco |
| "Funciona sem internet?" | "Precisa de offline-first?" | cache, sync, storage local |
| "Quantas pessoas vao usar no comeco?" | "Qual o throughput esperado?" | tier de hospedagem, banco |
| "Alguem alem de voce edita o conteudo?" | "Precisa de CMS?" | painel admin |
| "Precisa aparecer no Google?" | "SSR ou SPA?" | renderizacao |
| "Guarda foto, mensagem ou dado de outra pessoa?" | "Qual a classificacao dos dados?" | LGPD, criptografia, politica |
| "Voce quer cobrar?" | "Qual gateway de pagamento?" | billing, regra de loja |
| "A IA precisa saber dos SEUS documentos?" | "Precisa de RAG?" | vetor, ingestao, custo |
| "Se a IA errar, qual o estrago?" | "Qual a tolerancia a alucinacao?" | tier de modelo, guardrail, revisao humana |
| "Voce quer que fique parecido com qual app?" | "Qual design system?" | UI, tokens, componentes |

## Como reagir a "nao sei"

"Nao sei" e resposta valida e frequente. Nunca repita a pergunta com outras palavras.

Faca assim: escolha o default, diga qual escolheu e por que, em uma frase, e siga.

> "Sem problema — vou deixar com login pelo Google, que e o mais facil pras pessoas e nao te da trabalho de senha. Da pra mudar depois."
