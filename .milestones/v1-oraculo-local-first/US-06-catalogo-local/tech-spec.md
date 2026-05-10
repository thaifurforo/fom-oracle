# Spec Tecnica — US-06 Catalogo local do jogo e hierarquia de fontes

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story implementa a diretriz central do produto: preferir dados da instalacao local e do save antes de recorrer a fontes externas.

## Solucao

### Fluxo
1. Descobrir a instalacao local do jogo e sua versao.
2. Extrair metadados/catálogo local viavel para a v1.
3. Persistir o catalogo e marcar a origem de cada fonte.
4. Preparar fallback controlado para fontes externas quando faltarem dados.

## Tarefas

### T-19 — Descoberta da instalacao local e versionamento
**Descricao:** localizar instalacao do jogo, ler metadados basicos e registrar a versao detectada.
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Service`
**Done when:** existe fluxo de discovery que retorna caminho e versao da instalacao ou status de ausencia.
**Gate:** `dotnet test backend --filter GameInstallation`
**Depends:** T-03
**Reuses:** config de paths
**Parallel:** sim

### T-20 — Extracao do catalogo local e registry de fontes
**Descricao:** implementar pipeline inicial de extracao para dados locais utilizaveis na v1 e registrar a hierarquia de fontes.
**Where:** `backend/src/FomOracle.Service`, `backend/src/FomOracle.Repository`
**Done when:** o backend gera um catalogo local versionado com `source_type` rastreavel e fallback externo separado.
**Gate:** `dotnet test backend --filter KnowledgeCatalog`
**Depends:** T-19
**Reuses:** modelo `knowledge_source`
**Parallel:** nao

## Impactos

- Reduz dependencia da wiki.
- Alimenta diretamente o recommendation service.

## Referencias

- User story: `./user-story.md`
- `.catalog/domain.md`
