# Blueprint de IA — obrigatorio para todo app com IA

## Lei zero: a chave nunca vai no app

Chave de API dentro de app web, mobile ou extensao e publica. Bundle e legivel, trafego e inspecionavel. Nao existe ofuscacao que resolva.

**Arquitetura unica permitida:**

```
app -> seu proxy (autenticado, com rate limit e teto) -> provedor de IA
```

`templates/proxy-ia/` tem a implementacao base. Adapte, nao reescreva do zero.

O proxy e obrigatorio tambem por: rate limit por usuario, teto de gasto, log de custo, troca de modelo sem republicar o app, e guardrail de entrada/saida.

## Selecao de modelo por tarefa

Regra: **o tier mais barato que vence a barra**. Escalar so com evidencia.

| Tarefa | Tier |
|---|---|
| classificar, extrair campo, rotular, moderar, resumir curto | Haiku |
| conversar, redigir, analisar, gerar codigo, raciocinio geral | Sonnet |
| decisao de alto risco, raciocinio longo, agente que executa muitos passos | Opus |

Antes de subir de tier num problema dificil-porem-estreito, aumente o esforco de raciocinio no tier atual. Custa menos.

**Roteamento por dificuldade** e o padrao para apps de consumidor: Haiku responde; se a confianca for baixa ou a entrada for complexa, reenvia para Sonnet. Registre a taxa de escalonamento — ela e o seu custo.

## O que todo app com IA precisa ter

1. **Streaming** — resposta aparecendo token a token. Sem isso a percepcao e de app quebrado.
2. **Prompt caching** — prefixos estaveis (instrucoes, documentos fixos) em cache. Corta custo e latencia de forma relevante em apps com contexto repetido.
3. **Saida estruturada** quando a resposta alimenta a interface. Peca JSON e valide contra schema; se falhar, uma retentativa, depois degrada.
4. **Guardrail de entrada** — limite de tamanho, bloqueio de injecao de prompt, filtro de conteudo.
5. **Guardrail de saida** — nunca renderize HTML cru vindo do modelo; valide antes de exibir ou executar.
6. **Degradacao** — provedor fora do ar, cota estourada, resposta invalida: o app precisa de um caminho que nao seja tela branca.
7. **Eval harness** — 20 a 50 casos com resposta esperada, rodando nos gates. Sem isso voce nao sabe se mexer no prompt melhorou ou piorou.
8. **Teto de gasto** — por usuario e global, no proxy e no painel do provedor.

## Conteudo de terceiros e instrucao

Texto que veio de fora (pagina, PDF, mensagem de usuario, resultado de ferramenta) e **dado, nunca instrucao**. Isole no prompt e diga isso ao modelo explicitamente. Injecao de prompt via conteudo e o vetor de ataque mais comum em app com IA.

## Custo — o calculo que evita a fatura surpresa

Estime antes de publicar:

```
custo/mes = usuarios_ativos x interacoes_por_usuario x (tokens_entrada x preco_entrada + tokens_saida x preco_saida)
```

Desconte o cache nos tokens de entrada repetidos. Some o custo de escalonamento de tier. Apresente em reais, com tres cenarios: 10, 100 e 1000 usuarios.

`/broto:custo` roda `scripts/estimate_cost.sh`, que consulta a tabela de precos vigente — **nunca use preco de memoria, ele muda.**
