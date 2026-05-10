# Spec Tecnica — US-05 Prioridades dinamicas com persistencia local

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story implementa o contrato de prioridades como insumo estavel para o motor de recomendacao.

## Solucao

### Fluxo
1. Definir catalogo inicial de prioridades disponiveis.
2. Persistir selecao e ordem do usuario.
3. Expor endpoints de leitura e escrita.
4. Integrar reorder UI na home estrategica.

## Tarefas

### T-17 — Priority service e persistencia de perfil
**Descricao:** implementar catalogo inicial, `GET /priorities` e `PUT /priorities`, incluindo persistencia do perfil selecionado.
**Where:** `backend/src/FomOracle.Service`, `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Runtime`
**Done when:** o backend persiste e retorna prioridades ordenadas com ids estaveis.
**Gate:** `dotnet test backend --filter Priorities`
**Depends:** T-05
**Reuses:** persistencia local base
**Parallel:** sim

### T-18 — UI de selecao e reordenacao de prioridades
**Descricao:** construir componente de selecao/ordernacao e integracao com o perfil persistido.
**Where:** `frontend/src/features/priorities`
**Done when:** o usuario consegue alterar prioridades e a home reflete a nova configuracao salva.
**Gate:** `pnpm --dir frontend test -- --runInBand priorities`
**Depends:** T-15, T-17
**Reuses:** strategic-home
**Parallel:** nao

## Impactos

- Define a entrada dinamica do planejamento.
- Sera dependência direta do recommendation service.

## Referencias

- User story: `./user-story.md`
- `.catalog/domain.md`
