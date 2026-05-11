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
- `v0.6.0 — Inteligência de inventário e itens`
- `v0.7.0 — Presentes de NPCs e integração social`

As novas milestones `v0.6.0` e `v0.7.0` expandem o escopo funcional da v1 e devem ser consideradas parte do caminho de readiness do `v1.0.0`. A issue de release readiness consolida o checklist final após essas entregas.

## Versionamento e Releases

Releases automáticas são geradas por merge de PR em `main`.

- O PR é a fonte de verdade do impacto de versionamento.
- Todo PR para `main` deve fechar pelo menos uma issue com `Closes #N`, `Fixes #N` ou `Resolves #N`.
- Todo PR para `main` deve ter exatamente uma label de impacto: `release:patch`, `release:minor` ou `release:major`.
- Após o merge, o workflow copia a label de impacto do PR para as issues fechadas por ele.
- A próxima versão é calculada a partir da maior GitHub Release SemVer publicada; se não houver release, a base é `v0.0.0`.
- O cálculo segue SemVer tradicional: patch incrementa patch, minor incrementa minor e zera patch, major incrementa major e zera minor/patch.
- Releases `v0.*.*` são prereleases; releases `v1.0.0` e posteriores são estáveis/latest.

## Automação de Release

O único caminho suportado para publicação de release é o workflow automático pós-merge em `main`.

- `pr-release-gate.yml` valida PRs para `main` antes do merge.
- `auto-release.yml` publica uma GitHub Release quando um PR é mergeado em `main`.
- Releases não são publicadas por workflow manual, fechamento de milestone ou fechamento avulso de issue.
- A versão é calculada automaticamente a partir da maior GitHub Release SemVer publicada.
- Milestones são agrupamentos temáticos de roadmap, não números de versão.

## Convenções

- Labels de rastreabilidade:
  - `user-story`
  - `task`
  - `tech-solution`
  - `rf-01` a `rf-16`
  - `release:patch`
  - `release:minor`
  - `release:major`
- Labels de changelog/release notes:
  - `feature`
  - `bug`
  - `documentation`
  - `tests`
  - `infra`
  - `changelog`
  - `breaking-change`
  - `ignore-for-release`
- PRs para `main` devem usar closing keywords para fechar issues e devem ter exatamente uma label de impacto `release:*`.
- Quando uma task implementa parte de uma US, o PR deve mencionar a US-mãe e fechar a issue `T-XX`.
- Para bloquear merges de fato, a branch protection/ruleset de `main` deve exigir o check `PR Release Gate / validate-release-tracking`.
- Changelogs seguem o formato Keep a Changelog nas GitHub Releases, com seções `Added`, `Changed`, `Fixed`, `Docs` e `Internal`.

## Migração de `.milestones/`

A pasta `.milestones/` foi usada como fonte inicial do breakdown da v1 e migrada para GitHub em 2026-05-11.

Após a validação da migração:

- Progresso passa a ser acompanhado apenas em Issues + Project.
- Planejamento de versão passa a ser acompanhado em GitHub Milestones.
- Changelog versionado passa a ser mantido em GitHub Releases.
- `.milestones/` deve ser removida em PR próprio para evitar fonte dupla de verdade.
