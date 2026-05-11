# FOM Oracle — Preocupações e Dívida Técnica

## Dívida Técnica Ativa

| Item | Categoria | Severidade | Origem | Notas |
|---|---|---|---|---|
| Solution .NET vazia (sem projetos) | Infra | Baixa | T-01 | O `FomOracle.sln` foi criado vazio como placeholder. T-03 e T-05 vão popular os projetos. |

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
