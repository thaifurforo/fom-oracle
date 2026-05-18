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

## Segurança de dependências

- O gate `pnpm --dir frontend audit --prod --audit-level=high` é obrigatório na CI e bloqueia qualquer advisory `high` ou `critical` em dependência de produção.
- Advisories identificados como não-aplicáveis ao produto desktop local-first devem ser triados, documentados e registrados em `.catalog/concerns.md` com justificativa técnica explícita.
- Exceções devem ser tratadas via allowlist (ex.: `.npmrc` ou `pnpm audit-level`) ou correção direta da dependência; nunca silenciar o gate com `|| true` sem rastreabilidade formal no repositório.

## Assets visuais

- Ícone oficial do app desktop: `frontend/src-tauri/icons/source/icon-512-transparent.svg`.
- Arquivos em `frontend/src-tauri/icons/` são artefatos gerados de bundle, não fonte mestre.
- Mockups e artes de conceito devem ficar em `.catalog/assets/concept-art/`.
- Arquivos de concept art devem usar prefixo `concept-` e não podem ser usados diretamente em runtime/UI/bundle.
- Protótipos HTML de telas ficam em `.catalog/prototypes/T-XX-slug/prototype.html`, são artefatos de planejamento e também não podem ser usados diretamente em runtime/UI/bundle.
- A v1 é Windows desktop: o bundle Tauri mantém apenas `frontend/src-tauri/icons/icon.ico` e `frontend/src-tauri/icons/icon.png`.