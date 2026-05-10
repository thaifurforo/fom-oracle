# Spec Técnica — US-06 Catálogo local do jogo e hierarquia de fontes

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story implementa a diretriz central do produto: preferir dados da instalação local e do save antes de recorrer a fontes externas.

## Solução

### Fluxo
1. Descobrir a instalação local do jogo e sua versão.
2. Extrair metadados/catálogo local viavel para a v1.
3. Persistir o catálogo e marcar a origem de cada fonte.
4. Preparar fallback controlado para fontes externas quando faltarem dados.

## Tarefas

### T-19 — Descoberta da instalação local e versionamento
**Descrição:** localizar instalação do jogo, ler metadados básicos e registrar a versão detectada.
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Service`
**Done when:** existe fluxo de discovery que retorna caminho e versão da instalação ou status de ausência.
**Gate:** `dotnet test backend --filter GameInstallation`
**Depends:** T-03
**Reuses:** config de paths
**Parallel:** sim

### T-20 — Extracao do catálogo local e registry de fontes
**Descrição:** implementar pipeline inicial de extracao para dados locais utilizaveis na v1 e registrar a hierarquia de fontes.
**Where:** `backend/src/FomOracle.Service`, `backend/src/FomOracle.Repository`
**Done when:** o backend gera um catálogo local versionado com `source_type` rastreavel e fallback externo separado.
**Gate:** `dotnet test backend --filter KnowledgeCatalog`
**Depends:** T-19
**Reuses:** modelo `knowledge_source`
**Parallel:** não

## Impactos

- Reduz dependência da wiki.
- Alimenta diretamente o recommendation service.

## Referencias

- User story: `./user-story.md`
- `.catalog/domain.md`
