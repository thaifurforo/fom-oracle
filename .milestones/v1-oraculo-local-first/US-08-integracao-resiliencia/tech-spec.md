# Spec Técnica — US-08 Restauração de sessão, resiliência e verificação integrada

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story fecha o ciclo recorrente do produto e endurece os fluxos principais antes de iterações posteriores.

## Solução

### Fluxo
1. Restaurar contexto de save/prioridades no startup.
2. Cobrir os fluxos críticos com testes de contrato e integração.
3. Ajustar logging, erros de UX e readiness operacional da v1.

## Tarefas

### T-25 — Restore de sessão no startup
**Descrição:** implementar leitura de preferências válidas no startup e re-hidratação do contexto do usuário.
**Where:** `backend/src/FomOracle.Service`, `frontend/src/app`
**Done when:** ao reabrir o app, save e prioridades válidas são restaurados automaticamente.
**Gate:** `pnpm --dir frontend test -- --runInBand startup-restore`
**Depends:** T-08, T-17, T-24
**Reuses:** preference repository
**Parallel:** sim

### T-26 — Testes de contrato e integração dos fluxos críticos
**Descrição:** criar cobertura automatizada para discover/select, refresh e recommendations end-to-end no sidecar.
**Where:** `backend/tests/`, `frontend/src/shared`
**Done when:** os fluxos críticos possuem suites automatizadas que falham em regressão de contrato.
**Gate:** `dotnet test backend` e `pnpm --dir frontend test`
**Depends:** T-12, T-23
**Reuses:** Local API contracts
**Parallel:** sim

### T-27 — Logging, surfacing de erros e readiness da v1
**Descrição:** endurecer logging estruturado, mensagens de erro para usuário e checklist de readiness da milestone.
**Where:** `backend/src/FomOracle.Runtime`, `frontend/src/features/*`
**Done when:** falhas conhecidas aparecem com mensagens claras e logs locais suficientes para diagnóstico.
**Gate:** `dotnet test backend` e `pnpm --dir frontend test`
**Depends:** T-24, T-26
**Reuses:** infraestrutura de logging e error states existentes
**Parallel:** não

## Impactos

- Fecha o loop de confiabilidade da v1.
- Melhora debuggabilidade e experiência recorrente.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
