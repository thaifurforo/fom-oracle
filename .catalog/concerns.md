# FOM Oracle — Preocupações e Dívida Técnica

## Dívida Técnica Ativa

| Item | Categoria | Severidade | Origem | Notas |
|---|---|---|---|---|
| Solution .NET vazia (sem projetos) | Infra | Baixa | T-01 | O `FomOracle.sln` foi criado vazio como placeholder. T-03 e T-05 vão popular os projetos. |
| Escopo de inteligência de itens pode crescer demais | Produto/Técnica | Média | US-09/US-11 | Entregar avaliações incrementais, explicáveis e baseadas em sinais rastreáveis antes de tentar otimização perfeita. |
| Catálogo de receitas, presentes, eventos e missões futuras pode estar incompleto | Dados | Alta | US-06/US-09/US-10 | Priorizar instalação local/save, marcar lacunas com `source_trace` e degradar sem bloquear recomendações possíveis. |
| Inventário grande pode prejudicar usabilidade | UX | Média | US-09 | Exigir busca, filtros por tipo e localização de item na v1. |
| Machine learning pode reduzir explicabilidade se antecipado | Arquitetura | Média | ADR-06 | Manter v1 heurística; ML futuro só como calibragem opcional e auditável. |

## Dívida Técnica Resolvida

| Item | Resolução | Data |
|---|---|---|
| `.catalog/features.md` ausente | Criado com mapa de funcionalidades | 2026-05-10 |
| `.catalog/conventions.md` ausente | Criado com convenções do projeto | 2026-05-10 |
| `.catalog/concerns.md` ausente | Criado com dívida técnica inicial | 2026-05-10 |

## Riscos Conhecidos

Ver `.catalog/architecture.md` seção 9 — Riscos Técnicos.

## Regras

- Dívida técnica identificada durante implementação deve ser registrada aqui com severidade e plano de remediação.
- Dívida não endereçada na v1 deve ser movida para o backlog após a milestone.
- Ao resolver um item, movê-lo para "Dívida Técnica Resolvida" com data.
