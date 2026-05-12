# FOM Oracle

FOM Oracle é um aplicativo desktop Windows local-first para leitura de saves de Fields of Mistria, consolidação de progresso, avaliação de inventário e presentes, e recomendações estratégicas diárias.

## Estado atual

Este repositório está na estrutura inicial da `T-01`. O objetivo desta etapa é estabelecer a estrutura do espaço de trabalho, a solução .NET e os comandos base de inicialização.

O escopo planejado da v1 inclui um motor heurístico explicável para cruzar save, inventário completo, missões, receitas, eventos, aniversários, preferências de NPCs e prioridades do jogador. Machine learning não faz parte da v1.

## Estrutura do Repositório

```text
.
|-- .catalog/
|-- .milestones/
|-- backend/
|   |-- src/
|   `-- tests/
|-- frontend/
|   `-- src/
|       |-- app/
|       |-- features/
|       `-- shared/
|-- AGENTS.md
|-- FomOracle.sln
|-- package.json
`-- pnpm-workspace.yaml
```

## Inicialização

### Requisitos

- `pnpm`
- `.NET SDK`
- PowerShell 7 / PowerShell Core (`pwsh`)

### Comandos

```powershell
pnpm run bootstrap:frontend
pnpm run bootstrap:backend
```

Ou, para executar os dois:

```powershell
pnpm run bootstrap
```

### Comportamento esperado na T-01

- `bootstrap:frontend` prepara o espaço de trabalho `pnpm` do frontend.
- `bootstrap:backend` faz uma validação explícita e **falha de forma intencional** enquanto a solução ainda não contiver projetos reais.
- Essa falha imediata evita um falso positivo de inicialização no backend antes da `T-03`.

## Verificação da T-01

```powershell
pnpm -r --version
dotnet --info
```

## Testes da T-01

```powershell
pnpm run test:t01
```

Cobertura atual da T-01:
- verificação rápida da estrutura do scaffold
- contrato do script `bootstrap-backend.ps1`
- verificação de falha imediata para solução ausente ou vazia

## Próximas tarefas

- `T-02`: shell inicial React/Tauri
- `T-03`: runtime inicial do sidecar .NET
- `T-04`: guardrails de tipagem e camadas
- `T-05`: persistência local base
- `US-09`: avaliação de inventário e utilidade de itens
- `US-10`: avaliação de presentes de NPCs
- `US-11`: recomendações item-aware e mission-aware
