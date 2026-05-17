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
- `DESIGN.md`: fonte normativa obrigatória para decisões de UI/UX e arquitetura de interface no frontend.
- `.catalog/`: fonte de verdade técnica versionada.
- `.catalog/prototypes/T-XX-slug/prototype.html`: protótipo HTML de planejamento para tela nova ou mudança visual relevante.
- GitHub Issues, Project v2 e Milestones temáticas são a fonte de verdade para entregas.
- Toda a documentação do repositório, descrições de PR, issues, comentários de PR e release notes deve ser escrita em português brasileiro, com acentuação correta.
- Changelogs seguem [Keep a Changelog](https://keepachangelog.com) — seções `### Adicionado`, `### Alterado`, `### Corrigido`, `### Documentação`, `### Interno`.
- Mudanças de escopo em `.catalog/` devem manter PRD, arquitetura, domínio, features, concerns e tracking consistentes.
- Tasks de frontend/UI com tela nova ou mudança visual relevante devem seguir o fluxo operacional: ler `DESIGN.md`, gerar prompt para geração de protótipo, usar Stitch MCP quando disponível, salvar ou atualizar protótipo em `.catalog/prototypes`, revisar e ajustar o HTML contra o `DESIGN.md`, pedir validação humana no fluxo de trabalho e só então implementar React.
- PRs de frontend/UI com impacto visual devem anexar prints ou fluxo gravado curto.
- PRs de frontend/UI podem informar o caminho do protótipo quando ele existir.
- PRs que alteram ou impactam o guia devem incluir seção `Impacto no DESIGN.md` e atualizar o próprio `DESIGN.md`.

## Assets visuais

- Ícone oficial do app desktop: `frontend/src-tauri/icons/source/icon-512-transparent.svg`.
- Arquivos em `frontend/src-tauri/icons/` são artefatos gerados de bundle, não fonte mestre.
- Mockups e artes de conceito devem ficar em `.catalog/assets/concept-art/`.
- Arquivos de concept art devem usar prefixo `concept-` e não podem ser usados diretamente em runtime/UI/bundle.
- Protótipos HTML de telas ficam em `.catalog/prototypes/T-XX-slug/prototype.html`, são artefatos de planejamento e também não podem ser usados diretamente em runtime/UI/bundle.
