# Spec Tecnica — US-04 Painel consolidado e home estrategica

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story materializa a leitura do snapshot em visoes consumiveis pela interface principal do produto.

## Solucao

### Fluxo
1. Projetar summary e dominios do dashboard a partir do snapshot persistido.
2. Expor endpoint de dashboard.
3. Renderizar home estrategica com resumo no topo.
4. Renderizar paineis de dominio com suporte a dados parciais.

## Tarefas

### T-14 — Projecoes backend do dashboard
**Descricao:** criar query/projection para summary e dominios essenciais do painel.
**Where:** `backend/src/FomOracle.Service`, `backend/src/FomOracle.Runtime`
**Done when:** `GET /dashboard` responde summary e dominios principais a partir do ultimo snapshot valido.
**Gate:** `dotnet test backend --filter DashboardProjection`
**Depends:** T-11
**Reuses:** snapshot model
**Parallel:** sim

### T-15 — Home estrategica com resumo no topo
**Descricao:** construir tela principal do app com header de contexto, summary e placeholders para recomendacoes.
**Where:** `frontend/src/features/strategic-home`
**Done when:** a home abre apos save ativo com summary carregado do backend.
**Gate:** `pnpm --dir frontend test -- --runInBand strategic-home`
**Depends:** T-13, T-14
**Reuses:** shell UI
**Parallel:** nao

### T-16 — Paineis de dominio e estados parciais
**Descricao:** renderizar blocos de inventario, skills, relacionamentos, animais e quests com suporte a fallback parcial.
**Where:** `frontend/src/features/dashboard`
**Done when:** a UI mostra dominios do painel e sinaliza dados ausentes ou parciais com clareza.
**Gate:** `pnpm --dir frontend test -- --runInBand dashboard-panels`
**Depends:** T-14
**Reuses:** summary da home
**Parallel:** sim

## Impactos

- Torna visivel o valor do snapshot.
- Prepara a tela final onde as recomendacoes serao exibidas.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
