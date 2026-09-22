# Os cinco estados, em detalhe

## contrato

Objetivo: duas coisas que qualquer passo seguinte consegue ler e qualquer gate consegue cobrar.

**`journey.yaml`** — o que a pessoa faz. Telas, estados, eventos, caminho feliz. Formato em `templates/journey.schema.json`. Regra que evita a jornada de papel: **toda tela tem os quatro estados** (cheio, vazio, carregando, erro) e **uma unica acao primaria**. Tela com duas acoes primarias e indecisao de produto; volte e pergunte.

**`arch.yaml`** — como o sistema responde. Entidades, campos, operacoes, fronteira nucleo/casca, e a decisao de hospedagem com custo mensal em dolar (`references/hospedagem.md`). O nucleo nao importa SDK de plataforma; a casca usa o maximo do sistema operacional.

Em projeto existente, `scout` reconstroi os dois a partir do codigo e marca cada item como `origem: codigo`. O que ele nao conseguir inferir, voce pergunta.

Saida ao fim: uma frase de sete linhas em linguagem comum, com o custo mensal, e `estado: arte`.

## arte

O estado que separa app de referencia de app generico. Nao pule, nao resuma, nao decida sozinho.

`designer` executa `references/arte.md`: pesquisa 3 produtos do nicho com captura real, propoe **3 direcoes visuais distintas** (nao 3 variacoes da mesma), cada uma com nome, uma frase de intencao, paleta, tipografia e uma captura de referencia. Renderiza as tres como amostra visivel — nao descreve em prosa.

A pessoa escolhe uma. Isso e o primeiro dos dois gates humanos e nao e negociavel: e a unica chance de "nao gosto dessa cara" antes de existir codigo.

Escolhida a direcao, `scripts/tokens.sh` gera `tokens.json` (DTCG) e dele o arquivo nativo do pack: `DesignSystem.swift`, `tokens.css` ou `tokens.dart`. A partir daqui, cor, fonte, espacamento, raio e duracao de animacao **so existem como token**.

## kit

Componentes e telas vazias, em codigo de producao, antes de qualquer logica.

Componentes minimos: acao primaria, acao secundaria, linha de lista ou card, campo, estado vazio, estado de erro, indicador de carregando, navegacao. Cada um com preview.

Telas vazias: uma por tela do `journey.yaml`, com os quatro estados, montadas so com componentes do kit e dados de exemplo. Aqui nasce o harness de captura (ver o pack).

Verificacao: `scripts/telas.sh` captura, `scripts/gates/kit.sh` prova que nao ha valor cru fora do kit, `juiz` responde os criterios booleanos, a pessoa ve as telas.

Sair daqui com o kit aprovado e o que impede a "tela minima" de virar tela final.

## construcao

Preencher logica nas telas que ja passaram. O hook `guarda.sh` bloqueia escrita de tela enquanto o kit nao estiver aprovado, e bloqueia componente novo fora do kit depois disso.

Ordem: a acao primaria do caminho feliz ponta a ponta primeiro; o resto da jornada depois. Commit por tela concluida.

Mudou a jornada no meio? `scripts/gates/deriva.sh` diz quais telas foram invalidadas. So elas voltam para o kit, nao o projeto inteiro.

## prova

`scripts/gates.sh` roda tudo. Falhou, `construtor` corrige a causa (nunca o gate) e reexecuta so aquele gate, ate 3 vezes; na quarta, escale em duas linhas.

Placar humano no fim: "13 provas, 12 passaram; a lista reprovou porque o botao principal some no modo escuro".

Segundo gate humano: a pessoa ve o app e aprova. So entao publicar.
