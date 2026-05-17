# Interface React/Tauri — @fom-oracle/frontend

Este é o shell desktop do FOM Oracle, construído com React, TypeScript, TailwindCSS e Tauri.

## Arquitetura

A aplicação segue uma estrutura modular por funcionalidades (features) e camadas de responsabilidade:

- `src/app`: Bootstrap da aplicação, layout global (`AppShell`), rotas e provedores (TanStack Query).
- `src/features`: Módulos de negócio independentes.
  - `home`: Dashboard inicial com resumo do progresso.
  - `system`: Componentes de infraestrutura da UI, como o banner de conexão com o sidecar.
- `src/shared`: Recursos compartilhados entre múltiplas features.
  - `api`: Cliente HTTP para a Local API (sidecar .NET), definições de contratos e tratamento de erros.
  - `config`: Gerenciamento de variáveis de ambiente e constantes.
  - `state`: Gerenciamento de estado global com Zustand.
  - `ui`: Componentes de UI atômicos e reutilizáveis (Card, StatusPill, etc).
- `src-tauri`: Configuração e código nativo do shell Tauri.

## Desenvolvimento

### Comandos principais

```bash
# Instalar dependências
pnpm install

# Iniciar em modo desenvolvimento (Web + Tauri)
pnpm run dev

# Executar testes unitários e de integração (Vitest)
pnpm run test

# Verificar tipagem TypeScript
pnpm run typecheck

# Executar lint
pnpm run lint

# Build para produção (nativo)
pnpm run build

# Build apenas do bundle web
pnpm run build:web

# Regenerar ícones do app desktop a partir do SVG mestre
pnpm run icons:generate
```

## Ícones do app desktop

- A fonte oficial do ícone é `frontend/src-tauri/icons/source/icon-512-transparent.svg`.
- A geração de ícones é manual por enquanto e deve ser executada com `pnpm run icons:generate` quando o SVG mestre for alterado.
- Os arquivos em `src-tauri/icons/` são artefatos gerados para bundle Tauri.

## Comunicação com o Sidecar

A UI se comunica com um sidecar .NET rodando localmente via HTTP. A URL base é configurada pela variável de ambiente `VITE_FOM_ORACLE_API_BASE_URL`.

O status dessa conexão é monitorado em tempo real pelo componente `ConnectionBanner`, que realiza health checks periódicos.
