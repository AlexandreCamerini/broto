# Hospedagem — decidir com numero, nao com habito

Regra: **o app so ganha backend se precisar**. A pergunta que decide e uma so — "duas pessoas diferentes, ou dois aparelhos, precisam ver o mesmo dado?". Se nao, nao ha servidor, e o custo e zero.

## Tabela de decisao (confirme os precos ao vivo; nunca de memoria)

| Perfil | O que usar | Onde | Ordem de grandeza |
|---|---|---|---|
| Sem backend, so Apple | SwiftData + CloudKit | iCloud da propria pessoa | zero, alem da conta de desenvolvedor anual |
| Sem backend, multi | armazenamento local + export | estatico em CDN | zero |
| CRUD leve | API + SQLite em volume | **Railway**, com sleep ligado | dentro do credito do plano de entrada |
| CRUD leve, teto zero | API + Postgres gerenciado | plataforma com tier gratuito permanente | zero, com partida a frio |
| Com IA | API + proxy com teto de gasto | **Railway** | credito + tokens |
| Tempo real | API + websocket + banco | **Railway** sem sleep | acima do credito; diga o numero antes |

Railway e o default quando ha backend. Justifique por escrito se sair dele.

## Onde o dinheiro vaza
- **Container ocioso custa igual a container ativo.** Ligue o modo que dorme em tudo que nao e producao. Conexao de banco aberta, telemetria e poller mantem acordado: verifique.
- **Banco gerenciado e um servico separado cobrando 24/7.** Em piloto de CRUD leve, arquivo em volume resolve e custa uma fracao.
- **Trafego entre servicos pela rede publica se paga por giga.** Use a rede interna.
- **Dimensione memoria, nao CPU.** Memoria e a linha que mais pesa.

## O que o arquiteto entrega
Em `arch.yaml`, a secao `hospedagem` com: perfil, escolha, custo mensal estimado, data da consulta de preco, flags de economia ligadas, e o gatilho que obriga revisar ("acima de N pessoas" ou "acima de US$ X").
