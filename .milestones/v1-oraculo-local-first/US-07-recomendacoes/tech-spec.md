# Spec Tecnica — US-07 Recomendacoes estrategicas explicaveis

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story entrega o coracao do produto: transformar snapshot + prioridades + catalogo local em acoes ranqueadas com racional humano.

## Solucao

### Fluxo
1. Definir modelo de regra, categoria e rationale.
2. Implementar recommendation service v1.
3. Expor endpoint de geracao de recomendacoes.
4. Renderizar cards/lista na home estrategica.

## Tarefas

### T-21 — Modelo de regra e rationale humano
**Descricao:** definir contratos de regra, categoria, justificativa e estrutura do batch de recomendacoes.
**Where:** `backend/src/FomOracle.Types`, `backend/src/FomOracle.Service`
**Done when:** existe modelo tipado estavel para recommendation batch e itens explicaveis.
**Gate:** `dotnet test backend --filter RecommendationContracts`
**Depends:** T-17
**Reuses:** priority model
**Parallel:** nao

### T-22 — Recommendation service v1
**Descricao:** implementar regras iniciais sobre snapshot + prioridades + catalogo local para gerar ranking e rationale.
**Where:** `backend/src/FomOracle.Service`
**Done when:** o service gera lista deterministica e explicavel para casos de teste com fixtures.
**Gate:** `dotnet test backend --filter RecommendationService`
**Depends:** T-11, T-20, T-21
**Reuses:** snapshot model, priority service, knowledge catalog
**Parallel:** nao

### T-23 — Endpoint de recomendacoes e contratos de transporte
**Descricao:** expor `POST /recommendations/generate` e adaptar o payload de transporte para a UI.
**Where:** `backend/src/FomOracle.Runtime`, `frontend/src/shared/api`
**Done when:** a UI consegue solicitar recomendacoes para snapshot/perfil atuais via contrato estavel.
**Gate:** `dotnet test backend --filter RecommendationApi`
**Depends:** T-22
**Reuses:** Local API
**Parallel:** nao

### T-24 — UI de recomendacoes na home estrategica
**Descricao:** renderizar lista/cards de recomendacoes, categorias e justificativas humanas na home principal.
**Where:** `frontend/src/features/recommendations`, `frontend/src/features/strategic-home`
**Done when:** a home mostra recomendacoes atualizadas a partir do backend sem expor score tecnico.
**Gate:** `pnpm --dir frontend test -- --runInBand recommendations`
**Depends:** T-18, T-23
**Reuses:** strategic-home
**Parallel:** nao

## Impactos

- Entrega o nucleo de valor do produto.
- Exige fixtures e testes mais cuidadosos do que as stories anteriores.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
