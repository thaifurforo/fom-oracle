# FOM Oracle — Funcionalidades

## Mapa de Funcionalidades

| Funcionalidade | US | Status | Escopo v1 |
|---|---|---|---|
| Scaffold do workspace e bootstrap | US-01 / T-01 | ✅ Entregue | Sim |
| Shell React/Tauri | US-01 / T-02 | ⏳ Pendente | Sim |
| Runtime sidecar .NET + healthcheck | US-01 / T-03 | ⏳ Pendente | Sim |
| Guardrails de tipagem e camadas | US-01 / T-04 | ⏳ Pendente | Sim |
| Persistência local base | US-01 / T-05 | ⏳ Pendente | Sim |
| Descoberta de saves | US-02 | ⏳ Pendente | Sim |
| Refresh e snapshots | US-03 | ⏳ Pendente | Sim |
| Painel e home estratégica | US-04 | ⏳ Pendente | Sim |
| Prioridades dinâmicas | US-05 | ⏳ Pendente | Sim |
| Catálogo local do jogo | US-06 | ⏳ Pendente | Sim |
| Recomendações explicáveis | US-07 | ⏳ Pendente | Sim |
| Restauração de sessão e resiliência | US-08 | ⏳ Pendente | Sim |
| Avaliação de inventário e utilidade de itens | US-09 | ⏳ Pendente | Sim |
| Avaliação de presentes de NPCs | US-10 | ⏳ Pendente | Sim |
| Recomendações item-aware e mission-aware | US-11 | ⏳ Pendente | Sim |

## Interações de Funcionalidade

- Avaliação de inventário alimenta a home estratégica com sugestões como doar ao museu, vender excesso, guardar item para missão, produzir item útil ou reservar presente.
- Avaliação de presentes de NPCs alimenta tanto o painel social quanto a avaliação de inventário quando um item é bom presente.
- Recomendações estratégicas reutilizam sinais de inventário, presentes, receitas, eventos, aniversários, missões priorizadas, skills e equipamentos desbloqueáveis.
- A prioridade `missões` deve permitir selecionar missões específicas, não apenas o tema geral de quests.

## Regras

- Toda funcionalidade nova deve ser registrada aqui com US de origem e status.
- Status possiveis: `⏳ Pendente`, `🔄 Em andamento`, `✅ Entregue`, `❌ Cancelada`.
- Funcionalidades entregues em milestones anteriores não são removidas — recebem status `✅ Entregue`.
