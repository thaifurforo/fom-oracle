# FOM Oracle — Stack Técnica

## Stack recomendada

| Camada | Tecnologia | Justificativa | RNF atendido |
|---|---|---|---|
| UI | React 19 + TypeScript | Melhor velocidade de iteração para painel analítico, lista de recomendações, filtros e reordenação de prioridades | RNF-08, RNF-12, RNF-14 |
| Desktop Shell | Tauri v2 | Shell desktop leve, local-first, melhor custo de runtime que Electron | RNF-01, RNF-02, RNF-08 |
| UI State | TanStack Query + Zustand | Separar cache de leitura/commands do estado local efêmero da interface | RNF-06, RNF-08 |
| Styling | Tailwind CSS + design tokens locais | Agilidade para compor UI complexa sem prender a UI a kit visual rígido cedo demais | RNF-12, RNF-08 |
| Core Domain | .NET 9 + C# | Forte tipagem, modelagem de domínio, parsing, regras de negócio e integração com Windows/filesystem | RNF-02, RNF-03, RNF-04, RNF-14, RNF-15 |
| Application Layer | ASP.NET Core Minimal API local | Contrato explícito e testável entre shell/UI e core sidecar | RNF-06, RNF-09, RNF-13 |
| Persistence | SQLite + arquivos JSON de configuração | Persistência local simples para preferências, snapshots e catálogos derivados | RNF-01, RNF-07, RNF-10 |
| Decision Engine | Regras heurísticas em C# | Decisões determinísticas, explicáveis e testáveis para recomendações, inventário e presentes; machine learning fica fora da v1 | RNF-05, RNF-14 |
| Logging | Microsoft.Extensions.Logging + Serilog | Logs estruturados locais e diagnósticos reproduzíveis | RNF-09, RNF-13 |
| Tests | xUnit + FluentAssertions + NSubstitute | Boa harnessability para parser, services e regras de recomendação | RNF-13, RNF-14 |
| Structural checks | NetArchTest + ESLint boundaries | Enforce mecânico das camadas e dependências permitidas | RNF-06, RNF-14 |
| Build orchestration | pnpm + dotnet CLI | Tooling clara para UI e core, sem excesso de orquestração no início | RNF-02, RNF-14 |
| CI/CD | GitHub Actions + PowerShell Core (pwsh) | Pipeline de validação por PR com gate objetivo de aderência ao `DESIGN.md`, lint, build, teste, security scan e GC semanal automatizado | RNF-12, RNF-13, RNF-14 |

## Direção geral

- `Frontend desktop`: React/TypeScript dentro do Tauri.
- `Core sidecar`: processo .NET separado, responsável por leitura de save, extração, persistência e recomendação.
- `Comunicação`: HTTP local loopback entre UI e sidecar, com API interna versionada.
- `Fonte primária de dados`: save + arquivos da instalação local do jogo.
- `Fonte secundária`: wiki e outras fontes externas apenas para complementar lacunas.
- `Motor de decisão v1`: heurístico, determinístico, com pesos e rationale auditáveis; sem machine learning.

## Alternativas descartadas

### .NET UI nativa end-to-end
- Melhor aderência ao Windows.
- Rejeitada porque a UI precisa iterar rápido e tende a evoluir mais bem em React.

### Electron + React + sidecar .NET
- Mais simples em alguns fluxos do ecossistema web.
- Rejeitada por custo de runtime maior sem benefício proporcional para a v1.

### Machine learning no motor de recomendação v1
- Poderia calibrar ranking ou preferências com dados reais de uso.
- Rejeitado na v1 por exigir dados de treinamento, aumentar opacidade e conflitar com a necessidade de justificativas humanas precisas.
- Pode ser reavaliado no futuro como camada opcional de calibragem, sem substituir regras de domínio e hierarquia de fontes.
