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
- `DESIGN.md`: fonte normativa obrigatória para decisões de UI/UX e arquitetura de interface no frontend, após validação humana explícita.
- `.catalog/`: fonte de verdade técnica versionada.
- GitHub Issues, Project v2 e Milestones temáticas são a fonte de verdade para entregas.
- Toda a documentação do repositório, descrições de PR, issues, comentários de PR e release notes deve ser escrita em português brasileiro, com acentuação correta.
- Changelogs seguem [Keep a Changelog](https://keepachangelog.com) — seções `### Adicionado`, `### Alterado`, `### Corrigido`, `### Documentação`, `### Interno`.
- Mudanças de escopo em `.catalog/` devem manter PRD, arquitetura, domínio, features, concerns e tracking consistentes.
- Tasks de frontend devem declarar aderência ao `DESIGN.md` na issue e na PR.
- PRs de frontend/UI com impacto visual devem anexar prints ou fluxo gravado curto.
- PRs que alteram ou impactam o guia devem incluir seção `Impacto no DESIGN.md` com link da proposta aprovada.
- Alterações no `DESIGN.md` exigem validação humana explícita (review aprovado em PR ou aprovação rastreável na issue relacionada) antes de serem aplicadas em novas tasks de frontend.
- O gate de governança do CI valida somente a rastreabilidade mínima dessas informações; a qualidade visual e a suficiência das evidências são avaliadas por review humano.

## Assets visuais

- Ícone oficial do app desktop: `frontend/src-tauri/icons/source/icon-512-transparent.svg`.
- Arquivos em `frontend/src-tauri/icons/` são artefatos gerados de bundle, não fonte mestre.
- Mockups e artes de conceito devem ficar em `.catalog/assets/concept-art/`.
- Arquivos de concept art devem usar prefixo `concept-` e não podem ser usados diretamente em runtime/UI/bundle.
