# PRD — FOM Oracle

## 1. Visão Geral

### Nome do produto
FOM Oracle

### Objetivo principal
Criar um aplicativo desktop Windows local-first que leia o save do jogador de Fields of Mistria, consolide o estado atual do jogo em um painel completo e gere recomendações estratégicas diárias com base nas prioridades dinâmicas definidas pelo jogador.

### Problema
Fields of Mistria exige que o jogador tome decisões diárias considerando muitas variáveis ao mesmo tempo: dia, estação, inventário, dinheiro, skills, perks, Town Rank, quests, relacionamentos, progresso da mina, animais, coleções e objetivos pessoais que mudam ao longo da campanha. O jogo não oferece uma camada externa que transforme esse estado complexo em um plano de ação claro e priorizado.

### Oportunidade
Há espaço para um produto que leia o save local do jogador, interprete seu contexto real e recomende as melhores ações daquele dia com base em objetivos configuráveis. O produto deve unir duas frentes:

- um painel completo do save, para leitura consolidada do progresso;
- um assistente estratégico diário, para transformar estado em decisão acionável.

### Por que resolver agora
- O jogo está em evolução ativa e já possui comunidade orientada a otimização.
- Jogadores avançados dependem hoje de wiki, planilhas e ferramentas fragmentadas.
- O formato local de saves e a possibilidade de engenharia reversa tornam viável uma solução local-first aderente ao contexto real do jogador.

### Quem perde sem isso
- Jogadores que querem otimizar progresso sem consultar várias fontes paralelas.
- Completionists que precisam rastrear dependências e janelas sazonais.
- Jogadores que retornam a saves antigos e não sabem qual a melhor ação do dia.
- Jogadores que alternam frequentemente entre prioridades conflitantes.

### Posicionamento do produto
O produto será um painel completo + assistente estratégico, não apenas um visualizador de save e não apenas um checklist.

## 2. Escopo

### In
- Aplicativo desktop Windows local-first.
- Detecção automática da pasta padrão de saves de Fields of Mistria no Windows.
- Seleção manual da pasta de saves como fallback.
- Listagem dos saves encontrados para seleção.
- Seleção de um save ativo.
- Ação explícita de atualizar save para reler o estado mais recente.
- Painel completo do save com visão consolidada do progresso do jogador.
- Assistente estratégico diário com recomendações ranqueadas.
- Sistema de prioridades dinâmicas com múltiplas prioridades ordenadas da maior para a menor.
- Recomendações considerando múltiplos domínios do jogo: dia, estação, inventário, dinheiro, skills, perks, Town Rank, relacionamentos, mina, animais, quests, coleções e progresso geral.
- Sugestões em categorias práticas como agricultura, mina, coleta, social, crafting, culinária, economia, animais e progressão.
- Justificativas humanas para cada recomendação.
- Persistência local de preferências entre sessões.
- Priorizar extração de dados diretamente do save e, quando aplicável, de outros arquivos da instalação local do jogo via engenharia reversa.
- Usar wiki e outras fontes externas apenas como complemento subsidiário para dados inexistentes, inacessíveis ou não inferíveis de forma confiável a partir do save e da instalação local.

### Out
- Automação do jogo ou controle in-game.
- Escrita, modificação ou reparo de save na v1.
- Conta online obrigatória ou sincronização em nuvem obrigatória.
- Suporte multiplataforma além de Windows na v1.
- Overlay dentro do jogo na v1.
- Editor visual de fazenda ou planner espacial avançado na v1.
- Multiplayer, social ou comparação entre jogadores.
- Cobertura completa de mods e edge cases na v1.
- Atualização automática contínua do save sem ação explícita do usuário, salvo evolução futura.

## 3. Personas

### Persona 1 — Otimizador de Progresso
Quer usar cada dia com máxima eficiência. Alterna entre dinheiro, quests, Town Rank, skills e desbloqueios.

**Motivações**
- Maximizar progresso por dia.
- Reduzir decisões dispersas.
- Saber o melhor uso de tempo, energia e recursos.

**Frustrações**
- Muitas variáveis simultâneas.
- Esquecimento de oportunidades e bloqueios.
- Dificuldade para comparar objetivos concorrentes.

### Persona 2 — Completionist / Colecionador
Quer completar coleções, conquistas, relacionamentos, animais raros, receitas e progresso global.

**Motivações**
- Completar conteúdo com menos retrabalho.
- Evitar perder oportunidades sazonais.
- planejar dependências de longo prazo.

**Frustrações**
- Falta de visão consolidada do que falta.
- Dependências escondidas.
- Medo de gastar dias em ações subótimas.

### Persona 3 — Jogador de Retorno ao Save
Ficou um tempo sem jogar e precisa entender rapidamente o contexto atual do save.

**Motivações**
- Voltar ao save sem reestudar tudo.
- Retomar prioridades e gargalos.
- Receber um plano claro para o dia.

**Frustrações**
- Save difícil de reler mentalmente.
- Contexto fragmentado entre sistemas.
- Paralisia na tomada de decisão.

### Persona 4 — Planejador Flexível
Muda de foco com frequência e quer reordenar prioridades rapidamente.

**Motivações**
- Adaptar o plano ao objetivo atual.
- Experimentar estratégias diferentes.
- Misturar prioridades de curto e longo prazo.

**Frustrações**
- Ferramentas rígidas.
- Checklists estáticos.
- Recomendações genéricas que não respeitam preferência atual.

### Fora da v1
- Jogador casual fica mapeado como melhoria futura.

## 4. Requisitos Funcionais

### RF-01 — Descobrir e selecionar saves do jogador
O sistema deve localizar automaticamente a pasta padrão de saves de Fields of Mistria no Windows e listar os saves encontrados. Caso a detecção automática falhe ou o usuário use outro diretório, o sistema deve permitir seleção manual da pasta como fallback.

**Critérios de aceite**
- [ ] CA-01: ao abrir o app pela primeira vez, o sistema tenta localizar automaticamente a pasta padrão de saves no Windows.
- [ ] CA-02: se houver saves válidos na pasta detectada, eles são listados para seleção.
- [ ] CA-03: o usuário pode escolher manualmente outra pasta local caso a detecção automática falhe ou deseje usar outro local.
- [ ] CA-04: o sistema informa claramente quando nenhuma pasta ou save válido foi encontrado.

### RF-02 — Selecionar um save ativo
O sistema deve permitir que o usuário escolha qual save encontrado será usado como fonte ativa de análise.

**Critérios de aceite**
- [ ] CA-05: a interface lista os saves identificados com rótulos suficientes para diferenciá-los.
- [ ] CA-06: o usuário consegue definir um save como ativo com uma ação explícita.
- [ ] CA-07: o app mantém visível qual save está atualmente carregado.

### RF-03 — Atualizar os dados do save sob demanda
O sistema deve oferecer uma ação explícita de atualização do save para recarregar o estado mais recente do arquivo após progresso feito no jogo.

**Critérios de aceite**
- [ ] CA-08: existe um controle visível de atualizar save no fluxo principal.
- [ ] CA-09: ao acionar a atualização, o sistema relê o save ativo e atualiza painel e recomendações.
- [ ] CA-10: o sistema informa sucesso, falha ou inconsistência de leitura.
- [ ] CA-11: a atualização não exige reiniciar o aplicativo.

### RF-04 — Exibir painel consolidado do estado do save
O sistema deve apresentar um painel completo com visão estruturada dos principais domínios do jogo lidos do save.

**Critérios de aceite**
- [ ] CA-12: o painel exibe, no mínimo, dia/estação, recursos do jogador, inventário resumido, skills, perks, Town Rank, relacionamento com NPCs, progresso da mina, animais e quests em andamento.
- [ ] CA-13: os dados exibidos refletem o último carregamento bem-sucedido do save.
- [ ] CA-14: o usuário consegue identificar rapidamente gargalos, progressos e frentes abertas.

### RF-05 — Permitir configurar prioridades dinâmicas
O sistema deve permitir que o jogador escolha múltiplas prioridades de jogo e ordene essas prioridades da mais importante para a menos importante.

**Critérios de aceite**
- [ ] CA-15: o usuário pode selecionar uma ou mais prioridades ao mesmo tempo.
- [ ] CA-16: o usuário pode ordenar explicitamente as prioridades selecionadas.
- [ ] CA-17: o usuário pode trocar, remover ou reordenar prioridades a qualquer momento.
- [ ] CA-18: mudanças nas prioridades recalculam as sugestões sem precisar trocar de save.

### RF-06 — Gerar recomendações estratégicas diárias
O sistema deve transformar o estado atual do save e as prioridades escolhidas em uma lista ranqueada de atividades recomendadas para aquele dia de jogo.

**Critérios de aceite**
- [ ] CA-19: o sistema gera recomendações após o carregamento do save e definição de prioridades.
- [ ] CA-20: cada recomendação representa uma ação concreta ou um pequeno conjunto de ações concretas.
- [ ] CA-21: as recomendações são apresentadas em ordem de importância calculada.
- [ ] CA-22: a lista muda quando o save é atualizado ou quando as prioridades são alteradas.

### RF-07 — Explicar o racional das recomendações
O sistema deve mostrar por que cada sugestão foi feita, conectando a recomendação ao estado atual do save e às prioridades ativas.

**Critérios de aceite**
- [ ] CA-23: cada recomendação apresenta ao menos uma justificativa legível para o usuário.
- [ ] CA-24: a justificativa referencia fatores concretos, como estação, item faltante, quest ativa, vínculo com NPC, bloqueio de progressão ou oportunidade de lucro.
- [ ] CA-25: o usuário consegue distinguir recomendações de curto prazo das de valor estratégico maior.

### RF-08 — Cobrir múltiplos domínios de decisão do jogo
O motor de recomendação deve considerar todos os principais aspectos relevantes do save para tomada de decisão.

**Critérios de aceite**
- [ ] CA-26: o cálculo considera variáveis como dia, estação, inventário, dinheiro, skills/perks, Town Rank, relacionamento, mina, animais, quests e progresso de coleção quando disponíveis.
- [ ] CA-27: o sistema não se limita a agricultura; ele também recomenda ações relacionadas a minas, forrageamento, NPCs, crafting, culinária, animais e progressão geral.
- [ ] CA-28: a ausência de um subconjunto de dados não deve impedir a geração de recomendações possíveis com os dados restantes.

### RF-09 — Categorizar recomendações por tipo de atividade
O sistema deve organizar as recomendações em categorias que ajudem o jogador a entender o perfil da ação sugerida.

**Critérios de aceite**
- [ ] CA-29: cada recomendação pertence a pelo menos uma categoria, como agricultura, mina, coleta, social, animais, crafting, culinária, economia ou progresso.
- [ ] CA-30: o usuário consegue identificar rapidamente o tipo de esforço recomendado.

### RF-10 — Apoiar objetivos variados do jogador
O sistema deve suportar prioridades relacionadas a diferentes metas do jogo, incluindo progresso de quests, Town Rank, dinheiro, relacionamento, coleção, conquistas e animais.

**Critérios de aceite**
- [ ] CA-31: a interface oferece prioridades iniciais cobrindo pelo menos os objetivos explicitados no escopo do produto.
- [ ] CA-32: o motor de recomendação altera o peso das sugestões conforme a combinação e a ordem das prioridades selecionadas.

### RF-11 — Combinar dados locais primários com conhecimento complementar
O sistema deve combinar dados do save com uma base estruturada de conhecimento do jogo, priorizando dados extraídos diretamente do save e da instalação local do jogo sempre que possível, e recorrendo à wiki apenas para complementar lacunas.

**Critérios de aceite**
- [ ] CA-33: o cálculo das recomendações usa dados além do conteúdo bruto do save quando necessário.
- [ ] CA-34: a fonte prioritária de dados estruturais do jogo é a instalação local e os arquivos do próprio jogo, quando técnicamente extraíveis com confiabilidade.
- [ ] CA-35: a wiki e fontes comunitárias são usadas apenas para complementar dados inexistentes, inacessíveis ou não inferíveis de forma confiável via save/instalação.
- [ ] CA-36: o sistema documenta a origem dos dados usados pelo motor de recomendação em nível de fonte interna versus fonte externa.

### RF-12 — Lidar com erros e incompatibilidades de leitura
O sistema deve tratar casos de save corrompido, formato não suportado, diretório inválido ou versão incompatível do jogo de maneira compreensível.

**Critérios de aceite**
- [ ] CA-37: o usuário recebe mensagens claras quando a leitura do save falha.
- [ ] CA-38: o sistema diferencia ausência de arquivo, erro de parsing e incompatibilidade de versão quando possível.
- [ ] CA-39: falhas de leitura não corrompem o estado anteriormente carregado no app.

### RF-13 — Persistir preferências do usuário entre sessões
O sistema deve persistir localmente preferências operacionais do usuário entre execuções do aplicativo.

**Critérios de aceite**
- [ ] CA-40: o app persiste ao menos a pasta escolhida, o save selecionado por último e a configuração de prioridades mais recente.
- [ ] CA-41: ao reabrir o aplicativo, as preferências persistidas são restauradas quando ainda válidas.
- [ ] CA-42: se uma preferência restaurada não estiver mais válida, o sistema informa o problema e oferece recuperação.

## 5. Requisitos Não Funcionais

### RNF-01 — Operação local e privacidade por padrão
O aplicativo deve funcionar de forma local-first, processando saves e preferências localmente no Windows, sem exigir conta online.

### RNF-02 — Desempenho de leitura e atualização
A leitura inicial do save e a ação de atualizar save devem ocorrer com latência curta o suficiente para manter o fluxo de uso. Meta inicial: poucos segundos para saves suportados.

### RNF-03 — Robustez contra formatos variáveis
O sistema deve tolerar ausência parcial de dados, campos desconhecidos e pequenas variações de estrutura do save sem falhar completamente sempre que possível.

### RNF-04 — Preservação da integridade do save
O aplicativo não deve modificar, sobrescrever ou corromper o save original do jogador na v1.

### RNF-05 — Explicabilidade das recomendações
As recomendações precisam ser compreensíveis por um jogador avançado, com justificativas humanas e sem depender de score técnico exposto na interface.

### RNF-06 — Confiabilidade de estado
Painel, prioridades e recomendações devem refletir de forma consistente o último save carregado com sucesso e a configuração atual de prioridades.

### RNF-07 — Persistência local de preferências
O aplicativo deve persistir localmente preferências do usuário entre sessões, incluindo ao menos pasta escolhida, save recente e prioridades usadas por último.

### RNF-08 — Usabilidade para sessões curtas
A interface deve permitir que um jogador abra o app, confira o estado do save e obtenha recomendações úteis em poucos passos.

### RNF-09 — Observabilidade e diagnósticos locais
O aplicativo deve registrar erros e eventos técnicos relevantes localmente para diagnóstico de falhas de leitura, parsing e cálculo sem expor dados desnecessários.

### RNF-10 — Manutenibilidade da base de conhecimento
Os dados externos e internos usados pelo motor de recomendação devem ser organizados de forma atualizável, rastreável e separados do código principal sempre que possível.

### RNF-11 — Compatibilidade com versões suportadas do jogo
O sistema deve declarar explicitamente quais versões do jogo e do formato de save são suportadas e informar possível incompatibilidade quando detectada.

### RNF-12 — Acessibilidade e legibilidade básica
A interface deve ter legibilidade adequada, contraste suficiente, navegação clara e estrutura compreensível para uso prolongado em desktop.

### RNF-13 — Resiliência a falhas
Erros em uma parte do fluxo não devem derrubar toda a aplicação se ainda houver dados suficientes para funcionamento parcial.

### RNF-14 — Extensibilidade do motor de recomendação
A arquitetura deve permitir adicionar novas prioridades, novas regras e novos domínios do jogo sem reescrita ampla do núcleo.

### RNF-15 — Prioridade para fontes primárias locais de dados
O produto deve priorizar dados extraídos do save e da instalação local do jogo por engenharia reversa sempre que isso for viável, usando fontes externas como wiki apenas de forma subsidiária.

## 6. Fluxo de Usuário

1. O usuário abre o aplicativo pela primeira vez.
2. O sistema tenta detectar automaticamente a pasta padrão de saves de Fields of Mistria no Windows.
3. Se a detecção automática funcionar, o app lista os saves encontrados.
4. Se a detecção falhar ou o usuário preferir outro local, ele escolhe manualmente uma pasta de saves.
5. O usuário seleciona o save que deseja usar.
6. O sistema lê o save, carrega os dados e exibe o assistente estratégico como tela principal.
7. No topo da tela, o usuário vê um resumo do painel com o contexto essencial do save.
8. O usuário revisa o resumo e o restante do painel consolidado para entender rapidamente progresso, gargalos e oportunidades.
9. O usuário seleciona uma ou mais prioridades e ordena essas prioridades da mais importante para a menos importante.
10. O sistema recalcula e exibe recomendações estratégicas do dia com justificativas humanas.
11. O usuário pode ajustar prioridades a qualquer momento e ver novas recomendações.
12. Depois de jogar mais, o usuário aciona atualizar save.
13. O sistema relê o save ativo, atualiza o resumo do painel, o painel detalhado e as recomendações.
14. Ao fechar e reabrir o app, o sistema restaura preferências persistidas quando válidas.

### Fluxos alternativos
1. Se nenhum save for encontrado, o sistema informa o problema e oferece seleção manual de pasta.
2. Se o save estiver incompatível ou ilegível, o sistema informa o erro sem destruir o estado anteriormente carregado.
3. Se parte dos dados não puder ser interpretada, o sistema continua operando parcialmente sempre que possível.
4. Se o usuário trocar de save, o contexto, o painel e as recomendações passam a refletir o novo save ativo.

## 7. Métricas de Sucesso

### KPI-01 — Tempo até primeira recomendação útil
Medir quanto tempo o usuário leva, após abrir o app, para chegar a uma lista de recomendações estratégicas compreensíveis.

- Baseline atual: alto e manual, dependente de wiki, memória e ferramentas soltas.
- Meta inicial: poucos minutos na primeira sessão e menos de 1 minuto em sessões recorrentes após configuração inicial.

### KPI-02 — Frequência de uso do loop de atualização
Medir com que frequência usuários ativos usam o fluxo abrir app -> atualizar save -> revisar recomendações.

- Baseline atual: inexistente.
- Meta inicial: mostrar que o app virou parte do ritual recorrente de jogo.

### KPI-03 — Taxa de sucesso na leitura de save
Medir o percentual de tentativas em que o app detecta ou carrega corretamente um save suportado.

- Baseline atual: inexistente.
- Meta inicial: alta taxa de sucesso para saves em versões suportadas.

### KPI-04 — Taxa de ajuste de prioridades com novo consumo de recomendações
Medir se o usuário usa a flexibilidade do sistema para reordenar prioridades e consumir novas sugestões.

- Baseline atual: inexistente.
- Meta inicial: validar priorização dinâmica como recurso central do produto.

### KPI-05 — Clareza percebida das recomendações
Medir se o usuário entende por que cada sugestão apareceu e sente confiança para agir.

- Baseline atual: inexistente.
- Meta inicial: maioria dos usuários-alvo relatando que as justificativas são suficientes sem score técnico.

### KPI-06 — Cobertura prática do painel
Medir se o painel reduz a necessidade de consultas externas para entendimento do progresso.

- Baseline atual: dependência de múltiplas fontes.
- Meta inicial: o app se tornar a principal interface externa de leitura do save para usuários intermediários e avançados.

### KPI-07 — Retenção em sessões recorrentes
Medir se usuários voltam ao app em múltiplas sessões.

- Baseline atual: inexistente.
- Meta inicial: comprovar utilidade recorrente, não apenas curiosidade inicial.

## 8. Riscos e Dependências

### Dependências externas
- Estrutura real dos saves de Fields of Mistria e capacidade de interpretá-los com segurança.
- Fontes externas de conhecimento do jogo, como wiki e referências comunitárias, apenas para complementar lacunas.
- Evolução do jogo em Early Access, que pode alterar save, balanceamento e sistemas relevantes.
- Descoberta precisa de quais dados estão no save e quais estão disponíveis na instalação local do jogo.

### Riscos de produto
- O motor de recomendação pode ficar ambicioso demais para a v1.
- Recomendações podem parecer genéricas se a base de conhecimento estiver incompleta.
- O painel pode ficar denso demais e competir com a clareza do assistente estratégico.
- O produto pode exigir calibragem fina para não parecer excessivamente técnico.

### Riscos técnicos
- Mudanças de versão do jogo podem quebrar parsing ou interpretação.
- Saves podem ter variações inesperadas, campos ausentes, corrupção ou incompatibilidade com mods.
- Parte do modelo de decisão pode depender de dados não explícitos, exigindo heurísticas transparentes.
- A detecção automática da pasta de saves pode falhar em ambientes não padrão.
- A engenharia reversa da instalação local pode ser mais complexa do que o esperado.

### Riscos de dados e qualidade
- Informações da comunidade podem ficar desatualizadas após patches.
- Balanceamentos do jogo podem invalidar heurísticas antigas.
- Prioridades do usuário podem entrar em conflito e exigir arbitragem compreensível.
- Nem sempre existe uma única melhor atividade do dia; o sistema precisa evitar falsa precisão.
- Se a engenharia reversa da instalação local revelar poucos dados úteis, aumenta a dependência de fontes externas.

### Estratégias de mitigação
- Delimitar claramente o que a v1 recomenda bem.
- Separar parser, extratores, base de conhecimento e motor de recomendação.
- Informar compatibilidade por versão e degradar com elegância em leitura parcial.
- Exibir justificativas humanas claras.
- Validar cedo o núcleo de recomendação com saves reais diferentes.

## 9. Anexos / Decisões Adiadas

### Decisões já tomadas
- Plataforma da v1: desktop Windows local-first.
- Posicionamento do produto: painel completo + assistente estratégico.
- Entrada principal: detecção automática da pasta de saves com seleção manual como fallback.
- Tela principal: abrir direto no assistente estratégico com resumo do painel no topo.
- Persistência local de preferências: incluída na v1.
- Explicação das sugestões: apenas justificativas humanas, sem score técnico exposto.
- Persona casual: fora da v1, melhoria futura.
- Estratégia de dados: priorizar extração do save e da instalação local; usar wiki apenas como complemento subsidiário.

### Decisões adiadas
- Implementação exata do parser e dos extratores.
- Uso ou não de ferramenta auxiliar oficial/comunitária na pipeline de leitura.
- Taxonomia final de prioridades na v1.
- Estratégia detalhada para conflito entre múltiplas prioridades.
- Nível de profundidade do painel em cada domínio do jogo.
- Estratégia de compatibilidade com mods e saves alterados manualmente.
- Nome final do botão atualizar save.
- Política de atualização da base de conhecimento derivada da instalação local.
- Política exata de versionamento suportado do jogo.

### Referências de base
- [levantamento-ferramentas-fom.md](./references/levantamento-ferramentas-fom.md)
- Projeto de referência: `truix/travellers-rest-planner`
- Base de domínio: `fieldsofmistria.wiki.gg`
