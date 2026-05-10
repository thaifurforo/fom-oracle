# Spec Tecnica — US-03 Atualizacao de save e snapshots normalizados

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Contexto

Esta story transforma o save selecionado em um snapshot persistido e versionavel, com status de compatibilidade e erros mapeados para a UI.

## Solucao

### Fluxo
1. Ler o arquivo do save ativo e calcular fingerprint.
2. Parsear/normalizar o save para um modelo minimo de snapshot.
3. Persistir snapshot e status.
4. Expor refresh endpoint e refletir seu resultado na UI.

## Tarefas

### T-10 — Leitura bruta do save e fingerprint
**Descricao:** implementar acesso ao arquivo do save ativo, metadados e fingerprint do conteudo.
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Types`
**Done when:** existe leitura raw padronizada com fingerprint reprodutivel por save.
**Gate:** `dotnet test backend --filter SaveFingerprint`
**Depends:** T-08
**Reuses:** save repository
**Parallel:** nao

### T-11 — Parser/normalizer inicial de snapshot
**Descricao:** criar pipeline inicial de parsing para produzir snapshot minimo com summary e campos essenciais.
**Where:** `backend/src/FomOracle.Service`
**Done when:** um save suportado gera snapshot minimo consistente para uso do dashboard.
**Gate:** `dotnet test backend --filter SnapshotParsing`
**Depends:** T-10
**Reuses:** Types de snapshot
**Parallel:** nao

### T-12 — Endpoint de refresh, compatibilidade e erros
**Descricao:** implementar `POST /saves/refresh` com persistencia do snapshot, status de compatibilidade e warnings.
**Where:** `backend/src/FomOracle.Runtime`, `backend/src/FomOracle.Service`
**Done when:** refresh responde `success|partial|failed` sem sobrescrever ultimo estado valido em caso de falha.
**Gate:** `dotnet test backend --filter SaveRefresh`
**Depends:** T-11
**Reuses:** parser/normalizer
**Parallel:** nao

### T-13 — UX de refresh e feedback de status
**Descricao:** integrar botao de refresh na UI com estados de carregamento, sucesso, parcialidade e erro.
**Where:** `frontend/src/features/save-refresh`
**Done when:** o usuario consegue atualizar o save e entender o status retornado sem reiniciar o app.
**Gate:** `pnpm --dir frontend test -- --runInBand save-refresh`
**Depends:** T-09, T-12
**Reuses:** cliente HTTP compartilhado
**Parallel:** nao

## Impactos

- Introduz o conceito de snapshot persistido.
- Estabelece a fronteira de compatibilidade do parser.

## Referencias

- User story: `./user-story.md`
- `.catalog/domain.md`
