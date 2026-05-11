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

`v1.0.0 — Local-first MVP` é a primeira release estável do produto.

- O draft release `v1.0.0` deve ser publicado somente depois que todas as issues de minor releases anteriores vinculadas por label `release:vMAJOR.MINOR.PATCH` estiverem fechadas.
- O changelog final deve ser agregado das release notes incrementais e revisado antes da publicação.

## Automação de Release

Releases não são publicadas automaticamente por merge de PR, fechamento de issue ou milestone em 100%. O caminho suportado é o workflow manual `Publish Release`.

- `publish=false`: valida readiness e, se solicitado, regenera release notes sem publicar o draft.
- `publish=true`: publica o draft release existente apenas após todos os gates passarem.
- Publicação só é permitida a partir de `main`.
- O input `version` aceita qualquer tag no formato `vMAJOR.MINOR.PATCH`.
- Quando existir milestone cujo título começa com a tag da release, por exemplo `v0.6.0 — ...`, ele será associado à release.
- Release patch `vA.B.C`, com `C > 0`, valida apenas os gates básicos da própria release.
- Release minor `vA.B.0`, com `B > 0`, exige que não existam issues abertas com labels patch filhas `release:vA.B.P`, onde `P > 0`.
- Release major `vN.0.0` exige que não existam issues abertas com labels minor menores que ela, como `release:v0.5.0` para `v1.0.0` ou `release:v1.3.0` para `v2.0.0`.
- Releases `v0.*.*` são publicadas como prerelease; releases `v1.0.0` e posteriores são publicadas como estáveis e latest.
- Após publicar uma release, o workflow fecha o milestone correspondente quando ele existir.

## Convenções

- Labels de rastreabilidade:
  - `user-story`
  - `task`
  - `tech-solution`
  - `rf-01` a `rf-13`
  - `release:vMAJOR.MINOR.PATCH`, sempre como versão exata, por exemplo `release:v0.6.0` ou `release:v0.6.1`
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
