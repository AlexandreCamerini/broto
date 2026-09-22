# Pack web — React, Vite, Capacitor

## Ferramentas
Node, `typescript-language-server` + plugin `typescript-lsp`, biome ou eslint+prettier, Playwright para captura.

## Tokens
`scripts/tokens.sh web` gera `src/kit/tokens.css` com variaveis em `:root`, redefinidas sob `prefers-color-scheme: dark` e sob `[data-theme="dark"]`. Tailwind, se houver, le do `tokens.css` — nunca valores literais na classe.

## Reuso do prototipo
O kit e distribuido como registry: cada componente e um JSON com o codigo, instalado por CLI no app. O componente do prototipo e literalmente o de producao. Se ja existe biblioteca propria da casa, parta dela e so adicione o que falta.

## Harness de captura
Rota `/__broto?tela=<id>&estado=<estado>` em build de desenvolvimento, montando a tela com dados de exemplo. `scripts/telas.sh` chama Playwright contra ela, em viewport de celular e de desktop.

## Provas
`build`, `smoke` (Playwright do caminho feliz), `a11y` (axe), `tipos` (`tsc --noEmit`), `lint`, `bundle` (teto declarado no `arch.yaml`), `contraste`.

## Armadilha
Webview com brief que pede sensacao nativa vai decepcionar. Se a jornada depende de gesto, transicao continua ou componente do sistema, diga isso no estado `contrato`, nao depois.
