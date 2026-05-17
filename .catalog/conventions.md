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

## Princípios de engenharia e revisão

- Toda nova implementação e todo PR devem ser avaliados cuidadosamente à luz de `DRY`, `KISS`, `YAGNI`, `SOLID` e `DDD`.
- A avaliação deve considerar o escopo local da task/PR, buscando uma solução simples, suficiente, coesa e sem abstração prematura.
- A avaliação deve considerar o escopo global do projeto, preservando camadas, limites entre UI/core, linguagem de domínio e sustentabilidade da evolução técnica.
- Em caso de dúvida ou trade-off, a decisão deve ser justificada com base no [.catalog/PRD.md](PRD.md), na [.catalog/architecture.md](architecture.md), no [.catalog/domain.md](domain.md) e nas restrições reais da entrega.
- Os princípios devem orientar julgamento técnico contextual, e não aplicação dogmática em implementação ou review.
- `DRY`: evitar duplicação de regra de negócio, decisão de domínio ou lógica espalhada entre camadas.
- `KISS`: preferir a solução mais simples compatível com o problema atual.
- `YAGNI`: não introduzir abstrações, extensibilidade ou infraestrutura sem necessidade comprovada pelo escopo.
- `SOLID`: manter responsabilidades coesas e dependências compatíveis com a ordem obrigatória de camadas.
- `DDD`: nomear e organizar o código a partir do domínio e das regras do problema, não de detalhes técnicos.

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

## Assets visuais

- Ícone oficial do app desktop: `frontend/src-tauri/icons/source/icon-512-transparent.svg`.
- A v1 é Windows desktop: o bundle Tauri mantém apenas `frontend/src-tauri/icons/icon.ico` e `frontend/src-tauri/icons/icon.png`.
- Ícones de outras plataformas ou canais de distribuição ficam fora do escopo da v1 e só devem voltar com decisão explícita de suporte.
- Mockups e artes de conceito devem ficar em `.catalog/assets/concept-art/`.
- Arquivos de concept art devem usar prefixo `concept-` e não podem ser usados diretamente em runtime/UI/bundle.
