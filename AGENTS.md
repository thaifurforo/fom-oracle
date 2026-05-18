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
- Preocupações: [.catalog/concerns.md](.catalog/concerns.md) — consultar para dívida técnica e preocupações ativas; registrar aqui itens fora de escopo identificados em review; remover itens resolvidos do arquivo e descrever a resolução no PR correspondente
- Convenções de acompanhamento do projeto: [.catalog/project-tracking.md](.catalog/project-tracking.md)
- Design frontend: [DESIGN.md](DESIGN.md)

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
- Regras de inventário, presentes, receitas, missões e recomendações pertencem ao core .NET, nunca à UI.

## Diretrizes de engenharia obrigatórias
- Toda implementação e todo code review devem verificar aderência a `DRY`, `KISS`, `YAGNI`, `SOLID` e `DDD`.
- Essa avaliação deve considerar simultaneamente o escopo específico da task/PR e a consistência global do projeto.

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
- Avaliações de inventário e presentes alimentam as recomendações do dia, mas devem permanecer explicáveis como ações concretas.

## Diretriz de frontend/design
- `DESIGN.md` é obrigatório para decisões de UI/UX e arquitetura de interface.
- Tasks de frontend devem declarar aderência ao `DESIGN.md`.
- Para tela nova ou mudança visual relevante, o agente deve tentar gerar protótipo, preferencialmente utilizando Google Stitch MCP, antes da implementação React.
- Se não for possível utilizar o Google Stitch MCP, o agente deverá gerar o protótipo HTML por conta própria, confirmando a mudança da abordagem com o usuário antes de iniciar.
- O agente deve revisar o protótipo gerado contra o `DESIGN.md`, ajustar o HTML quando necessário e pedir validação humana no fluxo de trabalho antes de implementar.
- Protótipos HTML, quando existirem, ficam em `.catalog/prototypes/T-XX-slug/prototype.html` e não entram em runtime, UI ou bundle.
- PRs de frontend/UI com impacto visual exigem evidência visual.
- Novos padrões de UI/UX exigem alteração explícita no `DESIGN.md`.
- Concept art fica em `.catalog/assets/concept-art/` e não entra em runtime, UI ou bundle.

## Diretriz de dados
- Fonte primária: save do jogador + instalação local do jogo.
- Fonte secundária: wiki e referências externas apenas para lacunas.
- Se houver conflito entre fonte local e externa, a local vence na v1, salvo evidência de corrupção.
- Motor de decisão da v1: heurístico, determinístico e testável; machine learning fica fora do escopo da v1.

## Regra de idioma
- Toda a documentação do repositório, descrições de PR, issues, comentários de PR e release notes devem ser escritas em português brasileiro, com acentuação correta.
