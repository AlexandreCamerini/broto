# Nucleo portatil, casca nativa

Regra: **use o maximo do sistema operacional na casca; mantenha o nucleo (dominio, dados, regras) sem nenhuma API de plataforma.** Portabilidade nao e "escrever uma vez"; e "nao precisar reescrever o que importa".

## Fronteira
```
[nucleo]  modelo de dominio, casos de uso, regras, formato de dados  -> zero import de SDK de plataforma
[portas]  interfaces: Notificar, Persistir, Sincronizar, Sensor, Pagamento
[casca]   adaptadores nativos por OS + UI nativa
```
Teste de vazamento: `grep` por `import UIKit|SwiftUI|WidgetKit|android.|flutter/material` dentro de `core/`. Qualquer hit e defeito.

## Matriz de capacidades a explorar (a casca usa; o nucleo nunca ve)

| Capacidade | Apple | Android | Web |
|---|---|---|---|
| Widgets / glanceables | WidgetKit, Smart Stack, complicacoes watchOS | App Widgets, Glance | nenhum (PWA badge) |
| Atividade ao vivo | Live Activities, Dynamic Island | Ongoing notifications, Live Updates | nenhum |
| Atalhos / intents | App Intents, Shortcuts, Siri, Spotlight | App Shortcuts, App Actions | Web Share, manifest shortcuts |
| Sync sem backend | CloudKit, SwiftData + iCloud | nenhum equivalente gratuito | nenhum |
| Sensores / saude | HealthKit, CoreMotion, CoreLocation | Health Connect, Sensors | Web APIs limitadas |
| Tema do sistema | Dynamic Type, materiais, Liquid Glass | Material You, cor dinamica | prefers-color-scheme |
| Pagamento | StoreKit 2 | Play Billing | Stripe/Pix |
| Continuidade | Handoff, Universal Links, Watch | App Links | PWA |

## Regra de decisao
1. O design brief lista quais capacidades a experiencia PEDE (nao "poderia usar").
2. Cada capacidade pedida vira uma porta no nucleo e um adaptador na casca.
3. Se a expansao futura nao tem equivalente (ex.: CloudKit no Android), o ADR registra a rota: qual servico substitui e o custo. Nao se paga hoje.
4. UI nunca e compartilhada entre OS por default. Componentes compartilhados so onde a marca exige identidade identica (ex.: semente-ui na web).
