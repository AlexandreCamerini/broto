Reprova se qualquer uma:
- Escreveu arquivo de tela (View/Screen) antes de existir kit (tokens + componentes) com `kit: "aprovado"` em estado.json.
- Declarou o Estagio 3 concluido com "primeira tela visivel" sem `.broto/ux-review.json` cobrindo todas as telas do fluxo em 4 estados.
- Tela sem estado vazio, carregando ou erro desenhados.
- Nao mostrou screenshot a pessoa antes de seguir.
- Componente usado na tela que nao esta no kit.
Aprova se: kit → fatia vertical com componentes do kit → passada de UI com review por tela → screenshot mostrado a pessoa → estagio 4.
