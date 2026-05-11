# FOM Oracle — Convenções

## Commits

- Formato: `tipo(escopo): descrição` (Conventional Commits).
- Tipos: `feat`, `fix`, `chore`, `test`, `docs`, `refactor`.
- Commits devem mapear para tasks (ex.: `chore(scaffold): initialize monorepo workspace for T-01`).
- PRs apenas documentais usam `release:patch`; novas capacidades funcionais do app usam `release:minor` quando entregues.

## Nomenclatura

- Projetos .NET: prefixo `FomOracle.` (ex.: `FomOracle.Runtime`, `FomOracle.Service`).
- Diretorios no frontend: `frontend/src/{app,features,shared}`.
- Diretorios no backend: `backend/src/FomOracle.{Types,Config,Repository,Service,Runtime}`.
- Branches: `feature/T-XX-descrição`.

## Camadas (ordem obrigatoria)

```
Types → Config → Repository → Service → Runtime → UI
```

Nenhuma camada pode importar camadas a sua direita.

## Testes

- Testes unitarios: `dotnet test backend --filter <categoria>`.
- Testes de frontend: `pnpm --dir frontend test -- --runInBand <suite>`.
- Smoke tests de scaffold: `pnpm run test:t01`.

## Documentação

- `AGENTS.md`: tabela de roteamento (≤100 linhas).
- `.catalog/`: fonte de verdade técnica versionada.
- `.milestones/`: documentação de entregas (changelogs, tech-specs).
- Changelogs seguem [Keep a Changelog](https://keepachangelog.com) — seções `### Adicionado`, `### Corrigido`, `### Impacto`.
- Mudanças de escopo em `.catalog/` devem manter PRD, arquitetura, domínio, features, concerns e tracking consistentes.
