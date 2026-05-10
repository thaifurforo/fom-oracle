# Spec Técnica — US-01 Fundacao do workspace e shell local

**Milestone:** v1-oraculo-local-first
**Status:** 🔄 Em andamento (T-01 ✅)

## Contexto

Esta story estabelece a espinha dorsal do monorepo, do shell Tauri/React e do sidecar .NET, incluindo os sensores de tipagem e arquitetura que vão proteger o resto da implementação.

## Solução

### Fluxo
1. Criar estrutura de diretorios frontend/backend.
2. Subir shell React/Tauri e sidecar .NET separadamente.
3. Expor `GET /api/v1/health`.
4. Ativar guardrails de camada no frontend e no core.
5. Criar persistência local base para suportar preferências e snapshots nas US seguintes.

## Tarefas

### T-01 — Scaffolding do workspace e solucao multi-app
**Status:** ✅ Concluída em 2026-05-09
**Descrição:** criar estrutura raiz do monorepo, solution .NET, workspace frontend e scripts de desenvolvimento.
**Critérios de aceite relacionados:** CA-01
**Where:** raiz, `frontend/`, `backend/`, solution `.sln`
**Done when:** a arvore alvo do projeto existe e os comandos de bootstrap do frontend e backend estao documentados.
**Gate:** `pnpm -r --version` e `dotnet --info`
**Depends:** nenhuma
**Reuses:** nada
**Parallel:** não

### T-02 — Shell inicial React/Tauri
**Descrição:** criar shell UI minimo com rota inicial e cliente HTTP placeholder para o sidecar.
**Critérios de aceite relacionados:** CA-01
**Where:** `frontend/src/app`, `frontend/src/shared/api`
**Done when:** a aplicacao frontend inicia com tela placeholder e configuração de acesso ao sidecar.
**Gate:** `pnpm --dir frontend lint`
**Depends:** T-01
**Reuses:** nada
**Parallel:** não

### T-03 — Runtime inicial do sidecar .NET
**Descrição:** criar runtime ASP.NET Core local com DI, endpoint `GET /api/v1/health` e configuração basica.
**Critérios de aceite relacionados:** CA-01
**Where:** `backend/src/FomOracle.Runtime`
**Done when:** o sidecar sobe localmente e responde healthcheck.
**Gate:** `dotnet test backend`
**Depends:** T-01
**Reuses:** nada
**Parallel:** sim

### T-04 — Guardrails de tipagem e camadas
**Descrição:** configurar TypeScript strict, ESLint boundaries, nullable em C# e testes estruturais NetArchTest.
**Critérios de aceite relacionados:** CA-02
**Where:** `frontend/`, `backend/tests/`
**Done when:** existe falha automática para imports proibidos e configurações estritas nas duas stacks.
**Gate:** `pnpm --dir frontend lint` e `dotnet test backend`
**Depends:** T-01
**Reuses:** nada
**Parallel:** sim

### T-05 — Persistência local base
**Descrição:** estabelecer bootstrap de SQLite/config local e contratos minimos de persistência.
**Critérios de aceite relacionados:** CA-01
**Where:** `backend/src/FomOracle.Repository`, `backend/src/FomOracle.Config`
**Done when:** o runtime inicializa caminhos locais, banco local e contratos de repositório base sem erro.
**Gate:** `dotnet test backend`
**Depends:** T-03
**Reuses:** nada
**Parallel:** não

## Impactos

- Define a espinha dorsal do repositório.
- Cria os sensores que vão bloquear violações futuras.
- Atualiza a base para todas as próximas US.

## Referencias

- User story: `./user-story.md`
- `.catalog/architecture.md`
- `AGENTS.md`
