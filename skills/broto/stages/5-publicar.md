# Estagio 5 — Publicar

Objetivo: outra pessoa consegue usar o app. Este e o estagio onde quem nao e dev desiste — por isso ele e o mais assistido de todos.

Nunca comece sem `gates.json` verde.

## Passo 1 — Pre-voo de conformidade

`compliance-scout` (Haiku) confirma o que a loja/plataforma exige **hoje** (pesquise, nao lembre):

- politica de privacidade hospedada em URL publica
- declaracao de coleta de dados
- icones e capturas de tela nos tamanhos exigidos
- classificacao etaria
- se o app usa IA: aviso de conteudo gerado, canal de reporte

Falta alguma? Voce gera. Politica de privacidade: gere a partir do `briefing.md` e do que o app realmente coleta, e avise que um humano deve revisar antes de publicar.

## Passo 2 — Segredos em producao

- Nenhuma chave no repositorio. Confirme com `scripts/verify_gates.sh --only segredos`.
- Chaves entram pelo painel do provedor de hospedagem, pela pessoa, com voce guiando campo a campo.
- Teto de gasto do provedor de IA configurado **antes** do link ficar publico. Sem excecao.

## Passo 3 — Build e distribuicao

`release-engineer` (Sonnet) executa o caminho do pack:

| Pack | Caminho |
|---|---|
| `web` | build de producao -> deploy -> dominio -> HTTPS -> smoke test na URL publica |
| `ios` | assinatura -> archive -> TestFlight -> convite -> submissao |
| `android` | keystore -> AAB assinado -> teste interno -> producao |
| `multi` | web primeiro (feedback rapido), depois lojas |
| `ferramenta` | release no GitHub / npm / store de extensao |

Passo a passo de cada um no pack correspondente. Assinatura, certificado e senha: **a pessoa digita, voce nunca pede nem guarda**.

## Passo 4 — Prova de que esta no ar

Nao anuncie sucesso sem verificar de fora:

- `web`: requisicao a URL publica, status 200, conteudo esperado
- loja: link do TestFlight/teste interno aberto e funcional
- IA: uma chamada real em producao, com custo registrado

## Passo 5 — Entrega

Atualize `guia.md` com: onde esta no ar, como atualizar, quanto custa, para onde olhar quando quebrar, e como voltar aqui (`/broto:status`).

Grave `estagio: publicado`. Diga o link em voz alta. Esse e o segundo momento que faz alguem continuar.

## Estagio 6 implicito — Evoluir

Depois da publicacao, `/broto:novo` retoma pela lista `## Depois (versao 2)` do briefing, e o ciclo recomeca no Estagio 1 apenas para o proximo recorte.
