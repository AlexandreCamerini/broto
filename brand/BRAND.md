# Broto — plataforma de marca

## Posicionamento
**Broto** é o plugin do Claude Code que faz um projeto nascer certo: do briefing ao ambiente instrumentado, com design antes de código, custo no teto que você definiu e um humano aprovando cada passo. Pertence à família **Semente** (semente.dev): a Semente é a ideia; o Broto é a ideia germinando.

- **Público:** quem cria software com agentes e não é (ou não quer ser) especialista em setup. Do orquestrador experiente ao leigo curioso.
- **Promessa:** "Você descreve. O Broto pergunta uma coisa de cada vez, propõe o melhor caminho barato, e só escreve depois que você diz sim."
- **Diferença:** todo outro bootstrap instala ferramentas. O Broto instala *sinais* (tipo, lint, correção, contexto, UX) e cobra custo em dólar de cada decisão.

## Naming
"Broto" = o que brota da semente. Curto, brasileiro, sem conflito de pronúncia em inglês (*broh-toh*). Comando: `/broto`. Nome de pacote: `broto`. Marca-mãe: Semente.
Risco registrado: não foi feita busca de marca registrada; antes de qualquer uso comercial, verificar INPI e npm.

## Tagline
**"Projeto que nasce certo."**
Alternativa curta para README: *"Do briefing ao repo instrumentado. Barato, guiado, com você no controle."*

## Voz e tom
Personalidade em três traços: **direto, cuidadoso, sem cerimônia**.
O que NÃO é: não é motivacional, não é corporativo, não é infantil, não usa emoji para amortecer.

| Contexto | Faça | Não faça |
|---|---|---|
| Onboarding | "Vou fazer 4 perguntas. Cada uma vem com minha recomendação; pode só dizer ok." | "Bem-vindo à jornada de setup do seu projeto!" |
| Recomendação | "SwiftUI. Seu brief pede sensação nativa e Android não é requisito." | "Existem várias opções, como SwiftUI, Flutter, React..." |
| Custo | "Isso custa US$5/mês no Railway. Sem backend custa zero. Recomendo zero." | "Há custos envolvidos que podem variar." |
| Erro | "O LSP não subiu. Provável: binário fora do PATH. Rode `which sourcekit-lsp` e cole aqui." | "Ops! Algo deu errado :(" |
| Corte do crítico | "Removi o MCP do Figma: nenhuma tarefa recorrente usa. Volta quando usar." | "Talvez fosse interessante reconsiderar..." |

## Identidade visual

### Conceito do logo
Um **prompt de terminal que brota**: o caractere `>` do shell, com uma folha nascendo da ponta. Diz em um glifo o que o produto é: o ponto onde um comando vira projeto vivo. Funciona em 16px porque é só duas formas.

Variações em `brand/logo/`: `broto-mark.svg` (símbolo), `broto-wordmark.svg` (símbolo + nome), `broto-mark-mono.svg` (P&B), `broto-app-icon.svg` (fundo cheio, cantos arredondados).
Área de proteção: altura do `>` em todo o entorno. Tamanho mínimo: 16px (símbolo), 96px (wordmark).
Proibido: rotacionar a folha, usar gradiente, colocar sobre foto sem chapada, esticar.

### Cor (tokens em `brand/tokens.css` / `tokens.json`)
| Token | Hex | Uso | Contraste testado |
|---|---|---|---|
| `--broto-verde` | `#1B7F47` | primária, sobre claro | 5.03:1 s/ branco (AA) |
| `--broto-verde-claro` | `#5FD08A` | primária no dark mode | 9.59:1 s/ `#0E1512` |
| `--broto-ambar` | `#8A5A10` | acento/aviso sobre claro | 5.91:1 s/ branco |
| `--broto-ambar-claro` | `#E3A23A` | acento no dark | 8.37:1 s/ `#0E1512` |
| `--broto-tinta` | `#14201A` | texto sobre claro | 16.78:1 |
| `--broto-papel` | `#FFFFFF` | fundo claro | |
| `--broto-tinta-dark` | `#E8F1EB` | texto no dark | 16.05:1 |
| `--broto-papel-dark` | `#0E1512` | fundo dark | |
| `--broto-ok` / `--broto-erro` | `#1B7F47` / `#B42318` | semânticas | |

Regra: o verde escuro `#1B7F47` NÃO vai sobre fundo dark (3.68:1, reprova). No dark usa-se `--broto-verde-claro`.

### Tipografia
Duas famílias, ambas livres:
- **Display:** *Space Grotesk* 600 (títulos, wordmark). Fallback: `system-ui`.
- **Texto e código:** *JetBrains Mono* 400/600 (o produto vive no terminal; a marca também). Fallback: `ui-monospace, SFMono-Regular, Menlo`.
Escala: 12 / 14 / 16 / 20 / 24 / 32.

## Aplicações
- README hero: wordmark + tagline + um bloco de código com `/broto novo "..."`.
- Ícone de app (lista de plugins): `broto-app-icon.svg`.
- Saída no terminal: prefixo `broto ›` nas mensagens do plugin, sem cor obrigatória.
