# Spec Técnica — US-07 Recomendações estratégicas explicáveis

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story entrega o coração do produto: transformar snapshot + prioridades + catálogo local em ações ranqueadas com racional humano.

## Solução

### Fluxo
1. Definir modelo de regra, categoria e rationale.
2. Implementar recommendation service v1.
3. Expor endpoint de geração de recomendações.
4. Renderizar cards/lista na home estratégica.

## Tarefas

### T-21 — Modelo de regra e rationale humano
**Descrição:** definir contratos de regra, categoria, justificativa e estrutura do batch de recomendações.
**Where:** `backend/src/FomOracle.Types`, `backend/src/FomOracle.Service`
**Done when:** existe modelo tipado estável para recommendation batch e itens explicáveis.
**Gate:** `dotnet test backend --filter RecommendationContracts`
**Depends:** T-17
**Reuses:** priority model
**Parallel:** não

### T-22 — Recommendation service v1
**Descrição:** implementar regras iniciais sobre snapshot + prioridades + catálogo local para gerar ranking e rationale.
**Where:** `backend/src/FomOracle.Service`
**Done when:** o service gera lista determinística e explicável para casos de teste com fixtures.
**Gate:** `dotnet test backend --filter RecommendationService`
**Depends:** T-11, T-20, T-21
**Reuses:** snapshot model, priority service, knowledge catalog
**Parallel:** não

### T-23 — Endpoint de recomendações e contratos de transporte
**Descrição:** expor `POST /recommendations/generate` e adaptar o payload de transporte para a UI.
**Where:** `backend/src/FomOracle.Runtime`, `frontend/src/shared`
**Done when:** a UI consegue solicitar recomendações para snapshot/perfil atuais via contrato estável.
**Gate:** `dotnet test backend --filter RecommendationApi`
**Depends:** T-22
**Reuses:** Local API
**Parallel:** não

### T-24 — UI de recomendações na home estratégica
**Descrição:** renderizar lista/cards de recomendações, categorias e justificativas humanas na home principal.
**Where:** `frontend/src/features/recommendations`, `frontend/src/features/strategic-home`
**Done when:** a home mostra recomendações atualizadas a partir do backend sem expor score técnico.
**Gate:** `pnpm --dir frontend test -- --runInBand recommendations`
**Depends:** T-18, T-23
**Reuses:** strategic-home
**Parallel:** não

## Impactos

- Entrega o núcleo de valor do produto.
- Exige fixtures e testes mais cuidadosos do que as stories anteriores.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
