# Pack: web

Para site, webapp, dashboard, SaaS, PWA instalavel.

## Toolchain padrao
- Runtime: Node LTS
- App: framework React com roteamento e renderizacao no servidor
- Estilo: utilitario com tokens de design; componentes acessiveis por padrao
- Dados: Postgres gerenciado com camada de auth pronta
- Proxy de IA: rota server-side do proprio app (nao expor chave ao browser)
- Hospedagem: plataforma com deploy por git push e HTTPS automatico

Se o usuario ja tem stack validada, respeite-a e adapte os gates.

## Gates do pack
| id | limite |
|---|---|
| `perf` | LCP <= 2.5s e INP <= 200ms no perfil movel |
| `bundle` | JS inicial <= 200KB comprimido |
| `a11y` | zero violacao critica em axe nas rotas principais |
| `pwa` | instalavel, se o briefing pediu "abre no celular" |
| `seo` | title, description e og por rota, se o briefing pediu Google |

## Distribuicao
1. build de producao local passando
2. repositorio no GitHub
3. conectar a plataforma de hospedagem ao repo
4. variaveis de ambiente pelo painel, digitadas pela pessoa
5. dominio proprio, se houver; senao o dominio gratuito da plataforma
6. smoke test contra a URL publica

## Armadilhas
- Chave de IA em variavel exposta ao cliente (prefixo publico). Gate `segredos` pega; nao dependa disso, previna.
- Renderizar markdown do modelo como HTML sem sanitizar -> XSS.
- Banco gratuito que hiberna: a primeira visita demora. Avise a pessoa em vez de deixar parecer quebrado.
- Custo de funcao serverless com resposta em streaming longa: confira o limite de duracao do plano.
