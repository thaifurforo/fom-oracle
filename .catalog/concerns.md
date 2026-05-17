# FOM Oracle — Preocupações e Dívida Técnica Ativa

Este arquivo é a fonte única de dívida técnica ativa e preocupações ativas do repositório.
Itens resolvidos não permanecem aqui: ao concluir a correção, remova o item deste arquivo e descreva a resolução no PR correspondente.

## Quando registrar um item aqui

- Quando surgir dívida técnica ativa durante implementação, review ou estabilização.
- Quando um comentário de review apontar um problema real, mas fora do escopo ativo do PR.
- Quando um risco ativo exigir reavaliação posterior para não expandir o escopo da entrega atual.

## O que não entra aqui

- Histórico de itens resolvidos.
- Melhorias já entregues no PR atual.
- Ideias soltas sem problema concreto, origem identificável ou próxima ação sugerida.

## Como registrar itens vindos de review fora de escopo

1. Confirmar que o item está fora do escopo ativo do PR.
2. Responder no review, em português brasileiro, que não será implementado neste PR por escopo.
3. Registrar a dívida técnica ativa nesta seção com todos os campos mínimos.
4. Reavaliar o item em PR ou task futura, sem ampliar o PR atual sem nova aprovação.

## Campos mínimos obrigatórios

Cada item novo originado de review fora de escopo deve informar:

- Descrição curta.
- Categoria e severidade.
- Origem no formato `PR #N / thread <id> / reviewer <login>`.
- Motivo de estar fora do escopo.
- Ação sugerida para reavaliação.
- Data de registro no formato ISO `YYYY-MM-DD`.

## Regra de resolução

- Ao resolver uma dívida técnica, remova o item deste arquivo.
- Registre no PR correspondente qual item foi resolvido e como a resolução foi feita.

## Itens ativos

| Descrição | Categoria | Severidade | Origem | Motivo / contexto ativo | Ação sugerida | Data |
|---|---|---|---|---|---|---|
| Solution .NET vazia (sem projetos) | Infra | Baixa | T-01 | O `FomOracle.sln` foi criado vazio como placeholder. | Popular a solution nas tasks T-03 e T-05. | 2026-05-10 |
| Escopo de inteligência de itens pode crescer demais | Produto/Técnica | Média | US-09/US-11 | Há risco de expandir a engine antes de consolidar sinais rastreáveis e explicáveis. | Entregar avaliações incrementais antes de otimização mais ampla. | 2026-05-10 |
| Catálogo de receitas, presentes, eventos e missões futuras pode estar incompleto | Dados | Alta | US-06/US-09/US-10 | A instalação local e o save podem não cobrir todas as lacunas da v1. | Priorizar fonte local, marcar lacunas com `source_trace` e degradar sem bloquear o restante. | 2026-05-10 |
| Inventário grande pode prejudicar usabilidade | UX | Média | US-09 | A v1 ainda pode sofrer com volume alto de itens. | Exigir busca e filtros por tipo e localização de item. | 2026-05-10 |
| Machine learning pode reduzir explicabilidade se antecipado | Arquitetura | Média | ADR-06 | Antecipar ML conflita com a regra de heurística determinística da v1. | Manter ML fora do escopo da v1; considerar apenas calibragem futura auditável. | 2026-05-10 |
| Orçamento de CPU e memória precisa ser contido durante o jogo | Performance | Alta | US-08 / T-38 | Refresh frequente pode introduzir recomputações e consumo excessivo. | Medir baseline real e limitar polling e processamento redundante. | 2026-05-10 |
| Acesso ao save não pode bloquear o jogo nem competir com o arquivo | Integridade/IO | Alta | US-08 / T-38 | Leituras longas ou invasivas podem disputar acesso com o jogo. | Ler em modo read-only, usar snapshot temporário e preservar o último estado válido. | 2026-05-10 |
| CSP do shell não cobre hosts alternativos da API local | Segurança/Runtime | Média | PR #55 / thread PRRT_kwDOSZGoZs6CpHU8 / reviewer copilot-pull-request-reviewer | A PR entrega o shell inicial com API local por loopback; suportar outros hosts ou esquemas amplia a superfície além do escopo atual. | Reavaliar quando houver task específica para suportar outras origens da API local. | 2026-05-17 |
| Gate de audit da CI pode bloquear dependências sem triagem formal | CI/Processo | Média | PR #55 / thread PRRT_kwDOSZGoZs6CpbRv / reviewer copilot-pull-request-reviewer | A PR trata do shell inicial; mudar a política do audit afeta governança de pipeline, não a entrega funcional desta task. | Reavaliar quando existir política explícita para triagem de advisories na CI. | 2026-05-17 |
| Gate de audit da CI pode bloquear dependências sem triagem formal | CI/Processo | Média | PR #55 / thread PRRT_kwDOSZGoZs6Cpw11 / reviewer copilot-pull-request-reviewer | A PR trata do shell inicial; mudar a política do audit afeta governança de pipeline, não a entrega funcional desta task. | Reavaliar quando existir política explícita para triagem de advisories na CI. | 2026-05-17 |
