# FOM Oracle

FOM Oracle e um aplicativo desktop Windows local-first para leitura de saves de Fields of Mistria, consolidacao de progresso e recomendacoes estrategicas diarias.

## Estado atual

Este repositorio esta no scaffolding inicial da `T-01`. O objetivo desta etapa e estabelecer a estrutura do workspace, a solution .NET e os comandos base de bootstrap.

## Estrutura

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

## Bootstrap

### Requisitos

- `pnpm`
- `.NET SDK`

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

- `bootstrap:frontend` prepara o workspace `pnpm` do frontend.
- `bootstrap:backend` faz uma validacao explicita e **falha de forma intencional** enquanto a solution ainda nao contiver projetos reais.
- Esse fail-fast evita um falso positivo de bootstrap no backend antes da `T-03`.

## Gate da T-01

```powershell
pnpm -r --version
dotnet --info
```

## Testes da T-01

```powershell
pnpm run test:t01
```

Cobertura atual da T-01:
- smoke de estrutura do scaffold
- contrato do script `bootstrap-backend.ps1`
- verificacao de fail-fast para solution ausente ou vazia

## Proximas tasks

- `T-02`: shell inicial React/Tauri
- `T-03`: runtime inicial do sidecar .NET
- `T-04`: guardrails de tipagem e camadas
- `T-05`: persistencia local base

