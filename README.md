# FOM Oracle

FOM Oracle é um aplicativo desktop Windows local-first para leitura de saves de Fields of Mistria, consolidação de progresso, avaliação de inventário e presentes, e recomendações estratégicas diárias.

## Estado atual

Este repositório está na etapa `T-02`. O objetivo desta etapa foi estabelecer o shell inicial utilizando React e Tauri, configurando a base da interface e a comunicação com a Local API.

O escopo planejado da v1 inclui um motor heurístico explicável para cruzar save, inventário completo, missões, receitas, eventos, aniversários, preferências de NPCs e prioridades do jogador. Machine learning não faz parte da v1.

## Estrutura do Repositório

```text
.
|-- .catalog/                (documentação de produto, arquitetura e protótipos)
|-- backend/
|   |-- src/
|   `-- README.md
|-- frontend/
|   |-- src-tauri/           (runtime desktop Tauri/Rust e assets nativos)
|   `-- src/                 (aplicação React)
|       |-- app/
|       |-- features/
|       `-- shared/
|-- scripts/                 (automações de bootstrap, release e governança)
|-- tests/                   (sensores de scaffolding/release/design governance)
|-- AGENTS.md
|-- DESIGN.md
|-- FomOracle.sln
|-- package.json
|-- pnpm-lock.yaml
`-- pnpm-workspace.yaml
```

## Inicialização

### Requisitos

- `pnpm`
- `.NET SDK`
- PowerShell 7 / PowerShell Core (`pwsh`)
- Rust (para build nativo do Tauri)

### Comandos

```powershell
pnpm run bootstrap:frontend
pnpm run bootstrap:backend
```

Ou, para executar os dois:

```powershell
pnpm run bootstrap
```

> **Nota:** No estágio atual (`T-02`), `pnpm run bootstrap` executa `bootstrap:frontend` e `bootstrap:backend`. O backend **falhará intencionalmente** (exit code != 0) enquanto a solução não contiver projetos reais. Este é o comportamento esperado até a `T-03`.

### Comandos do Frontend (T-02)

```powershell
# Iniciar em modo dev (web + tauri)
pnpm --dir frontend run dev

# Rodar testes
pnpm --dir frontend run test

# Verificar tipos
pnpm --dir frontend run typecheck
```

### Comportamento esperado na T-02

- `bootstrap:frontend` prepara o ambiente web e Tauri.
- O shell abre com um dashboard inicial e um banner de status da conexão com o sidecar.
- A comunicação com o sidecar é simulada ou via health check na URL configurada.

## Verificação da T-01/T-02

```powershell
pnpm run test:t01
pnpm run test:design-governance
pnpm --dir frontend run test
```

## Próximas tarefas

- `T-03`: runtime inicial do sidecar .NET
- `T-04`: guardrails de tipagem e camadas
- `T-05`: persistência local base
- `US-09`: avaliação de inventário e utilidade de itens
- `US-10`: avaliação de presentes de NPCs
- `US-11`: recomendações item-aware e mission-aware
