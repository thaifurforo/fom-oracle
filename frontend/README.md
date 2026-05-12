# Frontend

Shell desktop React/Tauri do FOM Oracle.

## O que a T-02 entrega

- janela desktop Tauri com bootstrap inicial
- shell React com navegação por hash
- home do assistente estratégico como tela inicial
- cliente local para checar a API do sidecar
- estado visual de conexão para operação local-first

## Estrutura

- `src/app`: bootstrap, shell e rotas
- `src/features`: módulos por fluxo e tela
- `src/shared`: cliente da Local API, tipos de transporte e utilitários compartilhados

## Comandos

```powershell
pnpm --dir frontend run dev:web
pnpm --dir frontend run dev
pnpm --dir frontend run build:web
pnpm --dir frontend run build
pnpm --dir frontend test
pnpm --dir frontend run typecheck
```

## Requisitos

- `pnpm`
- Node.js compatível com o workspace
- Rust toolchain com `cargo` para executar `pnpm --dir frontend run dev` e `pnpm --dir frontend run build`

## Observação

O frontend não contém regra de negócio. Todo parsing, persistência local e heurística de recomendação ficam no core .NET.

