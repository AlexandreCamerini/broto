# Direcao de arte

Isto nao e "escolher cores". E a diferenca entre um app que parece software e um app que parece um produto.

## 1. Olhar antes de propor

Ate 6 buscas. Tres produtos: o lider do nicho, um desafiante recente, e **um de fora do nicho** cuja linguagem visual valha roubar (e daqui que sai originalidade; copiar o lider produz o segundo lugar). Para cada: URL verificada, captura salva em `.broto/refs/<nome>.png`, uma linha do que roubar e uma do que evitar.

Registre tambem o que o sistema operacional lancou nos ultimos 12 meses que a experiencia poderia usar — material, tipografia, movimento, superficie.

## 2. Tres direcoes distintas

Distintas de verdade. Se as tres tem a mesma paleta em tons diferentes, voce fez uma so. Cada direcao:

- **nome** curto ("Papel", "Noite", "Feira")
- **intencao** em uma frase: o que a pessoa sente ao abrir
- **paleta**: fundo, superficie, texto, primaria, sucesso, erro — claro e escuro
- **tipografia**: familia de display e de texto, escala
- **forma e movimento**: raio, densidade, duracao e curva padrao
- **referencia**: qual das tres capturas ancora esta direcao

Renderize as tres lado a lado como amostra visivel (uma tela do app, a mesma nas tres). Prosa nao decide nada.

## 3. Regras que valem para qualquer direcao escolhida

- **Um foco por tela.** A acao primaria e o unico elemento com a cor primaria.
- **Contraste**: 4.5:1 em texto, 3:1 em elemento de interface. Medido por `scripts/gates/contraste.sh`, nao por opiniao.
- **Tres tamanhos de fonte por tela**, no maximo.
- **Escuro nativo**, nao invertido: a paleta escura e desenhada, nao calculada.
- **Estado vazio desenhado.** Texto centralizado cinza nao e estado vazio.
- **Movimento tem funcao**: orienta de onde a coisa veio. Sem funcao, corte.
- **Componente nativo nao se reimplementa.** O kit customiza tokens sobre o componente do sistema — e assim que voce ganha acessibilidade, movimento e comportamento de graca.

## 4. O anti-generico

Antes de aprovar o kit, responda: **o que neste app so existe aqui?** Pode ser uma transicao, um jeito de mostrar dado, um vazio com personalidade, uma forma recorrente. Uma coisa basta. Se a resposta for "nada", o app vai ficar competente e esquecivel — diga isso a pessoa com essas palavras e proponha uma.

Nao invente aposta so para ter uma. Aposta forcada e pior que ausencia; registre "nenhuma" e o motivo.
