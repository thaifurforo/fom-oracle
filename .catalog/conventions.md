# FOM Oracle — Convenções

## Commits

- Formato: `tipo(escopo): descrição` (Conventional Commits).
- Tipos: `feat`, `fix`, `chore`, `test`, `docs`, `refactor`.
- Commits devem mapear para tasks (ex.: `chore(scaffold): initialize monorepo workspace for T-01`).
- PRs apenas documentais, correções de bug, testes, infraestrutura sem breaking change e tasks parciais de US usam `release:patch`.
- PRs ou tasks que finalizam uma user story ou uma capacidade funcional compatível usam `release:minor`.
- PRs ou tasks que finalizam uma épica, um MVP ou uma mudança breaking usam `release:major`.
- As labels `release:patch`, `release:minor` e `release:major` são a fonte de verdade para o impacto de versão.

## Nomenclatura

- Projetos .NET: prefixo `FomOracle.` (ex.: `FomOracle.Runtime`, `FomOracle.Service`).
- Diretórios no frontend: `frontend/src/{app,features,shared}`.
- Diretórios no backend: `backend/src/FomOracle.{Types,Config,Repository,Service,Runtime}`.
- Branches: `feature/T-XX-descrição`.

## Camadas (ordem obrigatória)

```
Types → Config → Repository → Service → Runtime → UI
```

Nenhuma camada pode importar camadas a sua direita.

## Testes

- Testes unitários: `dotnet test backend --filter <categoria>`.
- Testes de frontend: `pnpm --dir frontend test -- --runInBand <suite>`.
- Smoke tests de scaffold: `pnpm run test:t01`.

## Documentação

- `AGENTS.md`: tabela de roteamento (≤100 linhas).
- `.catalog/`: fonte de verdade técnica versionada.
- GitHub Issues, Project v2 e Milestones temáticas são a fonte de verdade para entregas.
- Toda a documentação do repositório, descrições de PR, issues, comentários de PR e release notes deve ser escrita em português brasileiro, com acentuação correta.
- Changelogs seguem [Keep a Changelog](https://keepachangelog.com) — seções `### Adicionado`, `### Alterado`, `### Corrigido`, `### Documentação`, `### Interno`.
- Mudanças de escopo em `.catalog/` devem manter PRD, arquitetura, domínio, features, concerns e tracking consistentes.
