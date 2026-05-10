# AGENTS.md

## Projeto
FOM Oracle

## Documentos-fonte
- PRD principal: [.catalog/PRD.md](.catalog/PRD.md)
- Arquitetura: [.catalog/architecture.md](.catalog/architecture.md)
- Stack: [.catalog/stack.md](.catalog/stack.md)
- Domínio: [.catalog/domain.md](.catalog/domain.md)
- Funcionalidades: [.catalog/features.md](.catalog/features.md)
- Convenções: [.catalog/conventions.md](.catalog/conventions.md)
- Preocupações: [.catalog/concerns.md](.catalog/concerns.md)
- Convenções de acompanhamento do projeto: [.catalog/project-tracking.md](.catalog/project-tracking.md)

## Diretriz arquitetural obrigatória

Ordem de camadas:

```text
Types → Config → Repository → Service → Runtime → UI
```

### Regras
- UI não implementa regra de negócio.
- UI não acessa filesystem, SQLite ou parsing diretamente.
- Todo acesso a save, instalação do jogo e persistência local passa por Repository/Service no core .NET.
- O frontend React fala apenas com a Local API do sidecar.
- Dados do save e da instalação local do jogo têm prioridade sobre wiki e fontes externas.

## Estrutura-alvo

### Frontend
- `frontend/src/app`: bootstrap, rotas e shell
- `frontend/src/features`: módulos de tela e fluxos
- `frontend/src/shared`: cliente da API local, tipos de transporte, utilitários visuais

### Core
- `backend/src/FomOracle.Types`
- `backend/src/FomOracle.Config`
- `backend/src/FomOracle.Repository`
- `backend/src/FomOracle.Service`
- `backend/src/FomOracle.Runtime`

## Sensores mínimos esperados
- TypeScript strict mode
- .NET nullable enabled
- ESLint com regra de boundaries
- NetArchTest para enforcement de camadas
- Testes unitários do parser e recommendation service
- Testes de contrato da Local API

## Diretriz de produto
- O app abre direto no assistente estratégico.
- O topo da tela mostra resumo do painel do save.
- Recomendações exibem justificativas humanas, sem score técnico exposto.

## Diretriz de dados
- Fonte primária: save do jogador + instalação local do jogo.
- Fonte secundária: wiki e referências externas apenas para lacunas.
- Se houver conflito entre fonte local e externa, a local vence na v1, salvo evidência de corrupção.
