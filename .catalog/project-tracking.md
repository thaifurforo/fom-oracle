# Project Tracking — FOM Oracle

## Ferramenta Atual

**Tool:** GitHub Issues + GitHub Projects v2 + GitHub Milestones + GitHub Releases

**Repositório:** `thaifurforo/fom-oracle`
**Project:** `Fields of Mistria Oracle` — <https://github.com/users/thaifurforo/projects/2>

O tracking permanente do projeto fica no GitHub:

- **GitHub Issues:** fonte de verdade para User Stories e tasks técnicas.
- **GitHub Project v2:** board operacional de status, prioridade, tamanho e visibilidade.
- **GitHub Milestones:** agrupamento por release incremental `v0.x.0`.
- **GitHub Releases:** histórico versionado e changelog detalhado da aplicação.

## Estrutura

### Issues

- Cada User Story usa uma issue-mãe `US-XX — [título]`.
- Cada task técnica usa uma issue `T-XX — [título]`.
- A issue de US lista suas tasks em checklist com links para as issues `T-XX`.
- A issue de task referencia sua US-mãe, release milestone, RFs, prioridade, tamanho, branch rule, `Where`, `Done when`, `Gate`, `Depends` e `Parallel`.

### Project

O Project `Fields of Mistria Oracle` usa os campos:

- `Status`: `Backlog`, `Ready`, `In progress`, `In review`, `Testing`, `Done`.
- `Priority`: `P0`, `P1`, `P2`.
- `Size`: `XS`, `S`, `M`, `L`, `XL`.
- `Milestone`, `Repository`, `Linked pull requests`, `Parent issue` e `Sub-issues progress` quando disponíveis pelo GitHub.

### Milestones de Release

- `v0.1.0 — Fundação do workspace`
- `v0.2.0 — Saves e snapshots`
- `v0.3.0 — Painel, prioridades e catálogo local`
- `v0.4.0 — Recomendações estratégicas`
- `v0.5.0 — Resiliência e readiness local-first`

## Release v1.0.0

`v1.0.0 — Local-first MVP` é a release estável que agrega todos os milestones incrementais `v0.1.0` a `v0.5.0`.

- Não mover as US/tasks existentes para um milestone `v1.0.0`; cada item permanece no milestone incremental onde será entregue.
- A publicação final é rastreada pela issue `Release readiness — v1.0.0 Local-first MVP`.
- O draft release `v1.0.0` deve ser publicado somente depois que todos os milestones `v0.x.0`, US e tasks mapeadas estiverem fechados.
- O changelog final deve ser agregado das release notes incrementais e revisado antes da publicação.

## Convenções

- Labels de rastreabilidade:
  - `user-story`
  - `task`
  - `tech-solution`
  - `rf-01` a `rf-13`
  - `release:v0.1.0` a `release:v0.5.0`
  - `release:v1.0.0`
- Labels de changelog/release notes:
  - `feature`
  - `bug`
  - `documentation`
  - `tests`
  - `infra`
  - `changelog`
  - `breaking-change`
  - `ignore-for-release`
- PRs devem usar `Closes #N` para fechar a issue principal da entrega.
- Quando uma task implementa parte de uma US, o PR deve mencionar a US-mãe e fechar a issue `T-XX`.
- Changelogs seguem o formato Keep a Changelog nas GitHub Releases, com seções `Added`, `Changed`, `Fixed`, `Docs` e `Internal`.

## Migração de `.milestones/`

A pasta `.milestones/` foi usada como fonte inicial do breakdown da v1 e migrada para GitHub em 2026-05-11.

Após a validação da migração:

- Progresso passa a ser acompanhado apenas em Issues + Project.
- Planejamento de versão passa a ser acompanhado em GitHub Milestones.
- Changelog versionado passa a ser mantido em GitHub Releases.
- `.milestones/` deve ser removida em PR próprio para evitar fonte dupla de verdade.
