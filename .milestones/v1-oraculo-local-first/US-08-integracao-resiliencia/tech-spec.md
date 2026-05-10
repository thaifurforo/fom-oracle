# Spec Tecnica — US-08 Restauracao de sessao, resiliencia e verificacao integrada

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story fecha o ciclo recorrente do produto e endurece os fluxos principais antes de iteracoes posteriores.

## Solucao

### Fluxo
1. Restaurar contexto de save/prioridades no startup.
2. Cobrir os fluxos criticos com testes de contrato e integracao.
3. Ajustar logging, erros de UX e readiness operacional da v1.

## Tarefas

### T-25 — Restore de sessao no startup
**Descricao:** implementar leitura de preferencias validas no startup e re-hidratacao do contexto do usuario.
**Where:** `backend/src/FomOracle.Service`, `frontend/src/app`
**Done when:** ao reabrir o app, save e prioridades validas sao restaurados automaticamente.
**Gate:** `pnpm --dir frontend test -- --runInBand startup-restore`
**Depends:** T-08, T-17, T-24
**Reuses:** preference repository
**Parallel:** sim

### T-26 — Testes de contrato e integracao dos fluxos criticos
**Descricao:** criar cobertura automatizada para discover/select, refresh e recommendations end-to-end no sidecar.
**Where:** `backend/tests/`, `frontend/src/shared/api`
**Done when:** os fluxos criticos possuem suites automatizadas que falham em regressao de contrato.
**Gate:** `dotnet test backend` e `pnpm --dir frontend test`
**Depends:** T-12, T-23
**Reuses:** Local API contracts
**Parallel:** sim

### T-27 — Logging, surfacing de erros e readiness da v1
**Descricao:** endurecer logging estruturado, mensagens de erro para usuario e checklist de readiness da milestone.
**Where:** `backend/src/FomOracle.Runtime`, `frontend/src/features/*`
**Done when:** falhas conhecidas aparecem com mensagens claras e logs locais suficientes para diagnostico.
**Gate:** `dotnet test backend` e `pnpm --dir frontend test`
**Depends:** T-24, T-26
**Reuses:** infraestrutura de logging e error states existentes
**Parallel:** nao

## Impactos

- Fecha o loop de confiabilidade da v1.
- Melhora debuggabilidade e experiencia recorrente.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
