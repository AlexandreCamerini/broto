# Broto

Do escopo à loja. Um plugin do Claude Code que conduz alguém **que não programa** desde "tenho uma ideia" até o aplicativo publicado, testado e com custo sob controle.

Família Semente.

## O que ele faz de diferente

A maioria dos geradores de projeto entrega um repositório configurado e vai embora. O Broto cobre o ciclo inteiro — e o ponto onde as pessoas realmente desistem não é a criação, é a publicação.

| Estágio | Entrega |
|---|---|
| 1. Descobrir | Briefing em português comum, escopo cortado para a versão 1 |
| 2. Decidir | Arquitetura decidida (não um menu), plano validado por schema, custo declarado |
| 3. Construir | App rodando com a ação principal funcionando de ponta a ponta |
| 4. Provar | Gates executáveis com veredito em JSON — "funciona" vira fato medido |
| 5. Publicar | Conformidade, assinatura, deploy, loja, verificação externa |

## Princípios inegociáveis

- **Chave de API nunca no cliente.** Todo app com IA nasce com proxy, rate limit e teto de gasto. É gate bloqueante, não recomendação.
- **Uma pergunta por vez, em linguagem de produto.** Nunca "qual estratégia de auth?" — sempre "as pessoas precisam de conta?".
- **Default opinativo.** Menu técnico para leigo é paralisia. O plugin decide, anuncia e segue.
- **Prova, não promessa.** Qualidade de referência de mercado só vale se for medível por comando: contraste, Core Web Vitals, cold start, acerto do eval de IA, ausência de segredo no histórico do git.
- **Não-destrutivo.** Dry-run é o padrão. Branch própria, commit por etapa, diff antes.
- **Custo antes do lançamento.** Três cenários (10/100/1000 usuários), preço consultado na hora — nunca de memória.

## Instalação

```bash
/plugin marketplace add AlexandreCamerini/broto
/plugin install broto@semente
```

Em desenvolvimento do próprio plugin, prefira carregar direto da pasta:

```bash
claude --plugin-dir ~/dev/broto
```

## Uso

| Comando | Para |
|---|---|
| `/broto:novo` | começar ou retomar |
| `/broto:status` | onde estou e qual o próximo passo |
| `/broto:provar` | rodar os gates agora |
| `/broto:publicar` | ir para a publicação |
| `/broto:custo` | quanto a IA vai custar por mês |

Linguagem natural também funciona — "acho que tá pronto pra mostrar pros outros" cai no estágio 5.

## Arquitetura de agentes

Cada nó no tier mais barato que vence a barra. Orquestração e decisão no topo.

| Agente | Tier | Papel |
|---|---|---|
| `scout` | Haiku | levantamento de fatos, sem opinião |
| `compliance-scout` | Haiku | exigências de loja, LGPD, acessibilidade — sempre pesquisadas |
| `ux-director` | Sonnet | referências reais com URL, todos os estados de tela |
| `toolchain-planner` | Sonnet | plano em comandos executáveis, com verificação por etapa |
| `qa-runner` | Sonnet | executa gates, corrige, nunca afrouxa limite |
| `release-engineer` | Sonnet | assinatura, deploy, loja, verificação externa |
| `ai-architect` | Opus | modelo por tarefa, guardrails, eval, custo |
| `arch-decider` | Opus | decisão final, resolve conflito por prioridade declarada |

## Requisitos

`git`, `jq`, e o toolchain do pack escolhido (Node, Xcode ou JDK). `scripts/preflight.sh` verifica e diz o que falta.

## Estado do projeto do usuário

Tudo em `.broto/` na raiz do projeto gerado. Versionado, exceto `.broto/segredos.env`.

## Licença

MIT
