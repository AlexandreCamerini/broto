# Criterios de interface — booleanos

O `juiz` responde sim ou nao para cada um, olhando o screenshot. Sem nota, sem escala.

## Sempre (toda tela, todo estado)
1. Existe uma unica acao primaria visivel.
2. A acao primaria e o unico elemento com a cor primaria.
3. O titulo diz o que e a tela sem precisar ler o resto.
4. Nada compete visualmente com o conteudo principal.
5. No maximo tres tamanhos de fonte.
6. O estado retratado corresponde ao que foi pedido (vazio e vazio, erro mostra erro).

## Por estado
7. **Vazio**: ha ilustracao, icone ou instrucao acionavel — nao so texto cinza.
8. **Carregando**: ha esqueleto ou indicador no lugar do conteudo, nao a tela em branco.
9. **Erro**: diz o que houve E o que fazer agora.
10. **Cheio**: o dado de exemplo parece real, nao "Lorem" nem "Item 1".

## Comparacao (lado a lado com a referencia)
11. Colocada ao lado da referencia, esta tela nao parece um prototipo.
12. A densidade e o ritmo de espacamento sao coerentes com a direcao de arte escolhida.

## O que NAO e do juiz
Contraste, tamanho de alvo de toque, escala de fonte e rotulo de icone sao **medidos por script** (`scripts/gates/contraste.sh`, `scripts/gates/a11y.sh`). Modelo nao mede pixel; nao pergunte a ele.

## Veredito
Aprovada = todos os itens aplicaveis em "sim". Um "nao" reprova e o juiz devolve **uma** mudanca: a de maior impacto. Nunca uma lista de dez ajustes.
