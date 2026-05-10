# Spec Tecnica — US-02 Descoberta de saves e selecao do save ativo

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story cobre descoberta automatica da pasta de saves, fallback manual, listagem de saves e escolha do save ativo persistido localmente.

## Solucao

### Fluxo
1. Resolver pasta padrao do Windows para Fields of Mistria.
2. Registrar save source detectado ou selecionado manualmente.
3. Listar saves validos com metadados minimos.
4. Persistir save ativo e conectar o fluxo de onboarding na UI.

## Tarefas

### T-06 — Resolver pasta padrao de saves
**Descricao:** implementar a regra de descoberta automatica da pasta padrao do jogo no Windows.
**Where:** `backend/src/FomOracle.Config`, `backend/src/FomOracle.Service`
**Done when:** existe servico isolado que retorna caminho padrao esperado e status de existencia.
**Gate:** `dotnet test backend --filter SavePath`
**Depends:** T-03
**Reuses:** Config de paths locais
**Parallel:** sim

### T-07 — Save source repository e endpoints discover/select
**Descricao:** persistir fontes de save e expor `GET /save-sources/discover` e `POST /save-sources/select`.
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Runtime`
**Done when:** a API devolve fontes detectadas e aceita registrar fonte manual.
**Gate:** `dotnet test backend --filter SaveSource`
**Depends:** T-05
**Reuses:** Persistencia local base
**Parallel:** sim

### T-08 — Listagem de saves e persistencia do save ativo
**Descricao:** implementar listagem de saves por fonte e selecao persistida do save ativo.
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Service`, `backend/src/FomOracle.Runtime`
**Done when:** `GET /saves` lista saves e `POST /saves/select` persiste o save ativo.
**Gate:** `dotnet test backend --filter SaveSelection`
**Depends:** T-07
**Reuses:** Save source repository
**Parallel:** nao

### T-09 — Onboarding UI de fonte e save
**Descricao:** construir a UI inicial para descobrir, escolher pasta manualmente, listar saves e selecionar o save ativo.
**Where:** `frontend/src/features/save-onboarding`
**Done when:** a UI consegue completar o fluxo de fonte + save usando a Local API.
**Gate:** `pnpm --dir frontend test -- --runInBand save-onboarding`
**Depends:** T-02, T-08
**Reuses:** cliente HTTP compartilhado
**Parallel:** nao

## Impactos

- Habilita todo o restante do produto.
- Introduz o primeiro fluxo usuario <-> Local API.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
