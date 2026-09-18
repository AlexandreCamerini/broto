# Estagio 2 — Decidir

Objetivo: `.broto/plano.json` valido contra `templates/plano.schema.json`, aprovado pela pessoa em linguagem comum.

## Passo 1 — Levantamento em paralelo

Dispare os quatro ao mesmo tempo, com o `briefing.md` como entrada:

- `scout` (Haiku) — o que ja existe no diretorio; versoes instaladas; SO; ferramentas disponiveis.
- `compliance-scout` (Haiku) — regras aplicaveis: loja, LGPD, acessibilidade, idade minima.
- `ux-director` (Sonnet) — 3 referencias de apps atuais que resolvem problema parecido; padroes de fluxo e de tela que sao estado da arte hoje; **com fonte verificavel, nunca de memoria**.
- `ai-architect` (Opus) — so se `ia != nenhuma`. Modelo por tarefa, tools necessarias, formato de saida, guardrails, harness de avaliacao, custo por interacao.

Enquanto rodam, diga a pessoa o que esta acontecendo em linguagem comum: "estou pesquisando como os melhores apps desse tipo resolvem isso, e calculando quanto a IA vai custar por usuario."

## Passo 2 — Decisao

`arch-decider` (Opus, effort alto) recebe as quatro saidas + briefing e produz `plano.json`.

Conflitos sao resolvidos por esta ordem de prioridade:

1. Seguranca e privacidade
2. A pessoa conseguir publicar sozinha
3. Custo de operacao previsivel
4. Qualidade percebida (UX, performance)
5. Elegancia tecnica — **ultimo lugar, sempre**

Regras duras do plano:
- Toda chave de IA atras de proxy. `templates/proxy-ia/` e o ponto de partida.
- Zero servico pago obrigatorio no dia 1, exceto o provedor de IA.
- Stack que a pessoa consiga rodar com um comando.
- Se houver empate tecnico, ganha o que tem melhor mensagem de erro.

## Passo 3 — Validacao

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/validate_plan.sh" .broto/plano.json
```

Se falhar, corrija e revalide. Nunca mostre plano invalido a pessoa.

## Passo 4 — Aprovacao humana

Traduza o plano em no maximo 8 linhas, **zero jargao**:

> "Vou construir assim:
> - Um app que abre no navegador e tambem instala no celular
> - As pessoas entram com a conta Google delas
> - A IA que responde e a mais barata que da conta; troco pela mais forte so nas perguntas dificeis
> - Seus dados ficam num banco gratuito ate ~500 usuarios
> - A chave da IA fica num servidor seu, nunca dentro do app
> - Custo estimado: R$ X por mes com 100 pessoas usando
> Pode ser?"

Registre cada decisao relevante em `.broto/decisoes.md` no formato: **decisao / porque / o que perderiamos com a alternativa**.

Grave `estagio: 3`.
