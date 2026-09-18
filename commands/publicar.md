---
description: Coloca o app no ar ou na loja, passo a passo
---

Use a skill `broto`, Estagio 5 (`skills/broto/stages/5-publicar.md`).

Antes de qualquer coisa, verifique `.broto/gates.json`. Se houver falha bloqueante ou o arquivo nao existir, rode `/broto:provar` primeiro e diga isso a pessoa.

Depois: `compliance-scout` levanta as exigencias vigentes, `release-engineer` conduz a publicacao.

Lembretes que valem como regra:
- teto de gasto de IA configurado antes de a URL ficar publica
- senha, certificado e credencial de loja: a pessoa digita, voce nunca pede
- nenhuma submissao ou publicacao em producao sem confirmacao explicita
- sucesso so e anunciado depois de acessar o endereco publico de fora
