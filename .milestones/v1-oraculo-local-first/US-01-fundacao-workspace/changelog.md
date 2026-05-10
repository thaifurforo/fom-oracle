# Changelog — US-01 - Fundacao do workspace e shell local

Todas as alteracoes significativas nesta user story serao documentadas neste arquivo.

Formato baseado em [Keep a Changelog](https://keepachangelog.com).

## [2026-05-09]

### Adicionado
- Estrutura raiz do monorepo: `package.json`, `pnpm-workspace.yaml`, `FomOracle.sln`, `.gitignore`
- Diretórios-alvo do frontend: `frontend/src/app`, `frontend/src/features`, `frontend/src/shared/api`
- Diretórios-alvo do backend: `backend/src/`, `backend/tests/`
- Scripts de bootstrap: `scripts/bootstrap-backend.ps1`, `scripts/run-t01-tests.ps1`
- Testes smoke da T-01: `tests/T01.Scaffold.Tests.ps1` (estrutura do scaffold, contrato do bootstrap, fail-fast em solution vazia)
- `README.md` com instrucoes de bootstrap e estado atual do projeto
- Documentacao-base de governanca: `.catalog/architecture.md`, `.catalog/stack.md`, `.catalog/domain.md`
- Estrutura de milestones: `.milestones/v1-oraculo-local-first/` com user stories, tech-specs e changelogs para US-01 a US-08

### Impacto
- Define a espinha dorsal do repositorio para todas as proximas US.
- Estabelece os gates de bootstrap e validacao smoke.
- Cria a base de governanca que protege as decisoes arquiteturais durante a implementacao.
