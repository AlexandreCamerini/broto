# Broto v2.2 — patch de interface e de gates

## Causa raiz corrigida
1. `plano.schema.json` nao tinha `ux`: a saida do ux-director era descartada no plano. Agora `plano.ux` e obrigatorio (referencias com captura, fluxo com 3 estados, direcao visual, criterios de aceite verificaveis por screenshot).
2. Estagio 3 encerrava em "primeira tela visivel" e a fatia vertical virava a tela final. Agora: kit de componentes aprovado → fatia vertical so com o kit → passada de UI tela a tela com review por screenshot → pessoa olha.
3. `verify_gates.sh` tratava gate bloqueante sem comando como `skip`: pack ios passava verde sem compilar. Agora e `fail`, e o pack ios ganhou comandos reais (`xcodebuild`, `swift test`, XcodeGen). `ia-*` so bloqueiam se o plano tem IA.

## Arquivos (copiar por cima do repo, mesmos caminhos)
- templates/plano.schema.json            (+ secao ux)
- agents/ux-director.md                  (modos pesquisar / revisar)
- agents/qa-runner.md                    (screenshots + review + gates)
- skills/broto/SKILL.md                  (lei 6, saida do estagio 3, ux-review.json)
- skills/broto/stages/2-decidir.md       (ux integral no plano; "vai parecer assim")
- skills/broto/stages/3-construir.md     (kit, harness, passada de UI)
- skills/broto/references/gates.md       (gate ux; bloqueante sem comando = fail)
- skills/broto/packs/ios.md              (harness BROTO_SCREEN, gates ux/build)
- scripts/verify_gates.sh                (fail sem comando; comandos ios; gate ux)
- scripts/screenshots.sh                 NOVO
- scripts/ux_gate.sh                     NOVO
- hooks/hooks.json                       (+ guarda_ux no PreToolUse)
- hooks/scripts/guarda_ux.sh             NOVO
- evals/ui-generica/                     NOVO

## Depois de copiar
1. `version` → 2.2.0 em plugin.json e marketplace.json; commit; push; `/plugin marketplace update semente`; `/reload-plugins`.
2. `claude plugin validate .`
3. Rode o eval `ui-generica`.

## Aplicar no secv2 (projeto ja construido)
1. `ux-director` modo `pesquisar` de novo a partir de `.broto/briefing.md` → cole em `plano.ux`; revalide o plano.
2. Volte `estado.json` para `estagio: 3` sem `kit`; o hook passa a bloquear telas.
3. Passo 5 (kit + harness BROTO_SCREEN no `App`), passo 6 (refatorar a tela minima para usar o kit), passo 7 (passada de UI).
4. `/broto:provar`. O gate `build` agora compila de verdade; espere falhas que antes estavam escondidas.

## Divida que fica
- `screenshots.sh` localiza o `.app` pelo DerivedData; em projetos com varios schemes pode pegar o errado. Ajuste `XCSCHEME` se necessario.
- Captura macOS depende de Acessibilidade liberada para o Terminal (System Events).
- Pack android e web: captura so via `scripts.screenshot` (Playwright); android nao implementado.
- O revisor e Sonnet por custo. Se as reprovacoes vierem rasas, suba para Opus no frontmatter do ux-director; nao mexa no gate.
