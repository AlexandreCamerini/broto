# Estagio 1 — Descobrir

Objetivo: sair daqui com `.broto/briefing.md` escrito em portugues comum e confirmado pela pessoa.

Nunca escreva codigo neste estagio. Nunca pergunte nada tecnico.

## Abertura

Uma frase, sem lista:

> "Me conta em poucas palavras o que voce quer construir. Pode ser bem solto — eu organizo depois."

Deixe a pessoa falar livre. Nao interrompa com estrutura.

## As sete perguntas

Depois da fala livre, faca **uma por vez**, na ordem. Pule qualquer uma que a fala livre ja respondeu — e diga que pulou ("voce ja me disse que e pra celular, entao proximo").

1. **Quem usa isso?** ("so voce", "seus clientes", "qualquer pessoa na internet")
2. **Onde a pessoa usa?** ("no celular", "no computador", "nos dois")
3. **Qual e a acao principal?** Complete: "a pessoa abre o app e ______".
4. **As pessoas precisam de conta?** ("nao", "sim, so email", "sim, com login do Google/Apple")
5. **Guarda informacao de alguem?** (nome, foto, mensagem, pagamento, saude)
6. **Tem cobranca?** ("nao", "assinatura", "pagamento avulso")
7. **A inteligencia artificial faz o que aqui?** Ofereca exemplos concretos se travar: responde perguntas, resume texto, gera imagem, organiza o que a pessoa escreveu, conversa.

Se a resposta 7 for "nao sei" ou "nao tem", pergunte uma vez: "tem alguma tarefa chata que o app poderia fazer sozinho?". Se continuar nao, registre `ia: nenhuma` e siga — app sem IA e valido.

## Traducao interna (nao mostre)

| Resposta | Consequencia tecnica |
|---|---|
| "so no celular" + "iPhone" | pack `ios` |
| "celular" sem preferencia | pack `multi` |
| "computador"/"site"/"link" | pack `web` |
| "qualquer pessoa na internet" | auth publica, rate limit, moderacao |
| guarda dado de terceiro | LGPD: politica de privacidade obrigatoria, `compliance-scout` no estagio 2 |
| cobranca | gateway + regra de loja (Apple/Google levam comissao de bem digital) |
| IA != nenhuma | proxy obrigatorio, eval harness, teto de custo |

## Escopo: corte agora

Quem nao e dev sempre descreve a versao 3. Seu trabalho e achar a versao 1.

Pergunte: **"Se o app fizesse apenas UMA coisa e fizesse muito bem, qual seria?"**

Escreva o resto em `briefing.md` sob `## Depois (versao 2)`. Nao discuta; guarde. A pessoa precisa ver que a ideia dela nao foi jogada fora.

## Saida

Escreva `.broto/briefing.md`:

```markdown
# Briefing — <nome do app>

## Em uma frase
<o que o app faz, do ponto de vista de quem usa>

## Quem usa
## Onde usa
## Acao principal
## Contas e login
## Dados guardados
## Dinheiro
## O que a IA faz
## Versao 1 — so isto
## Depois (versao 2)
```

Leia de volta para a pessoa em no maximo 10 linhas e pergunte: **"E isso? Alguma coisa errada ou faltando?"**

So depois do "sim", grave `.broto/estado.json` com `estagio: 2` e avance.
