# Spec Técnica — US-05 Prioridades dinâmicas com persistência local

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story implementa o contrato de prioridades como insumo estável para o motor de recomendação.

## Solução

### Fluxo
1. Definir catálogo inicial de prioridades disponiveis.
2. Persistir seleção e ordem do usuário.
3. Expor endpoints de leitura e escrita.
4. Integrar reorder UI na home estratégica.

## Tarefas

### T-17 — Priority service e persistência de perfil
**Descrição:** implementar catálogo inicial, `GET /priorities` e `PUT /priorities`, incluindo persistência do perfil selecionado.
**Where:** `backend/src/FomOracle.Service`, `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Runtime`
**Done when:** o backend persiste e retorna prioridades ordenadas com ids estaveis.
**Gate:** `dotnet test backend --filter Priorities`
**Depends:** T-05
**Reuses:** persistência local base
**Parallel:** sim

### T-18 — UI de seleção e reordenacao de prioridades
**Descrição:** construir componente de seleção/ordernacao e integração com o perfil persistido.
**Where:** `frontend/src/features/priorities`
**Done when:** o usuário consegue alterar prioridades e a home reflete a nova configuração salva.
**Gate:** `pnpm --dir frontend test -- --runInBand priorities`
**Depends:** T-15, T-17
**Reuses:** strategic-home
**Parallel:** não

## Impactos

- Define a entrada dinâmica do planejamento.
- Será dependência direta do recommendation service.

## Referencias

- User story: `./user-story.md`
- `.catalog/domain.md`
