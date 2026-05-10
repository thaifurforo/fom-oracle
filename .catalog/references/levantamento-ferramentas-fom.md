# **Análise de Sistemas de Otimização e Planejamento de Dados em Fields of Mistria: Uma Perspectiva de Engenharia de Dados e Economia Virtual**

A ascensão de simuladores de vida e RPGs de fazenda na última década, exemplificada pelo sucesso fenomenal de títulos como Stardew Valley, criou um subgênero de jogadores que não buscam apenas o relaxamento, mas a otimização matemática rigorosa de sistemas virtuais. O lançamento de Fields of Mistria, desenvolvido pelo NPC Studio, consolidou-se como um marco nesse gênero ao utilizar o motor GameMaker para entregar uma experiência que une a estética de anime dos anos 90 com mecânicas modernas de simulação.1 No entanto, a complexidade inerente ao jogo, que envolve mais de 600 itens fabricáveis, sistemas de alquimia, árvores de habilidades e ciclos econômicos sazonais, gerou a necessidade imediata de softwares de terceiros capazes de processar dados de arquivos de salvamento para fornecer sugestões estratégicas.4

A demanda por um software similar ao Travellers Rest Planner para Fields of Mistria é uma resposta direta à densidade de informações do jogo. Jogadores buscam ferramentas que não apenas cataloguem itens, mas que realizem cálculos de Retorno sobre Investimento (ROI) com base no estado atual de seus personagens, inventários e progresso no mundo.6 O ecossistema de ferramentas em torno de Fields of Mistria evoluiu rapidamente, passando de planilhas manuais para analisadores de arquivos binários e, mais recentemente, para assistentes baseados em Inteligência Artificial que utilizam protocolos de contexto de modelo para interpretar dados de jogo em tempo real.6

## **Arquitetura Técnica e Acessibilidade dos Arquivos de Salvamento**

O ponto de partida para qualquer software de planejamento baseado em dados reais é o acesso ao arquivo de salvamento do jogador. Em Fields of Mistria, esses arquivos são armazenados localmente no sistema operacional Windows, especificamente no diretório %USERPROFILE%/AppData/Local/FieldsOfMistria/saves.1 Diferente de jogos que utilizam formatos de texto simples e editáveis, como XML, o Fields of Mistria utiliza uma extensão .sav binária, o que representa uma barreira técnica para a leitura direta por scripts simples.8

### **O Papel do Vaultc na Engenharia de Reversa de Dados**

Para viabilizar ferramentas de planejamento, a comunidade depende do Vaultc, um utilitário de linha de comando desenvolvido pelo próprio NPC Studio e disponibilizado via GitHub.10 O Vaultc funciona como uma ponte crítica entre o formato binário proprietário do jogo e a estrutura de dados legível por máquinas, especificamente o formato JSON. A importância do Vaultc é tamanha que ele serve de base para quase todos os editores e analisadores de save disponíveis, permitindo que o arquivo .sav seja desempacotado em uma série de arquivos JSON temáticos, como player.json, npcs.json e farm.json.11

A execução técnica do processo de desempacotamento envolve o uso do terminal ou PowerShell, onde o comando vaultc.exe unpack traduz o estado do jogo em variáveis que softwares externos podem processar.8 Esta transparência de dados permite que desenvolvedores de ferramentas identifiquem não apenas o ouro total do jogador, mas também variáveis ocultas, como o progresso exato em direção ao próximo nível de habilidade ou a probabilidade de certos eventos aleatórios ocorrerem.6

### **Estrutura de Dados Estratégicos Identificados nos Arquivos JSON**

| Arquivo JSON | Dados Extraídos para Planejamento | Relevância para a Otimização |
| :---- | :---- | :---- |
| player.json | Ouro (tesserae), essência mágica, mana atual e inventário. | Permite calcular o capital disponível para sementes e ingredientes.9 |
| npcs.json | Pontos de coração, histórico de presentes e status de relacionamento. | Identifica quais NPCs estão próximos de subir de nível, otimizando a escolha de presentes.8 |
| farm.json | Localização de plantações, construções e máquinas de processamento. | Essencial para planejadores de layout que buscam eficiência espacial.13 |
| world.json | Coleção do museu, ranking da cidade e estado dos festivais. | Ajuda ferramentas a sugerir quais itens faltam para completar o progresso de 100%.7 |

## **Análise de Ferramentas de Planejamento e Sugestão Automatizada**

Atualmente, não existe um único "super-aplicativo" que reúna todas as funções do Travellers Rest Planner, mas sim uma constelação de ferramentas que, quando combinadas, superam as capacidades de softwares de planejamento tradicionais. Estas ferramentas dividem-se em três categorias principais: analisadores web baseados em upload, assistentes de IA com sincronização ao vivo e simuladores de decisão heurística.

### **Mistria Wrapped e o Ecossistema HozBlic**

A plataforma disponível em hozblic.github.io é, talvez, a aplicação web mais acessível e visualmente refinada para o acompanhamento de progresso.14 Originalmente concebida como um rastreador de presentes e itens do museu, ela introduziu uma funcionalidade inovadora chamada "Mistria Wrapped". Ao fazer o upload do arquivo de salvamento (após a conversão para JSON ou através de parsing interno), a ferramenta gera uma análise estatística profunda do comportamento do jogador.14

Esta análise inclui gráficos sobre o consumo de itens, horários de alimentação e eficiência na conclusão de objetivos. Embora seu foco seja retrospectivo, a ferramenta atua como um planejador de sugestões ao destacar visualmente o que "falta" para o jogador atingir metas específicas, como a doação de peixes sazonais ou insetos lendários.14 A interface permite que o usuário identifique instantaneamente se um item em seu inventário é necessário para o museu ou se é um presente "amado" por um NPC específico, reduzindo o desperdício de recursos valiosos.17

### **Savecraft.gg: A Integração de IA e Model Context Protocol (MCP)**

Para usuários que buscam sugestões ativas e cálculos em tempo real, o Savecraft.gg representa o estado da arte em termos de planejamento de jogos. Ele opera através de um daemon que monitora as alterações nos arquivos de salvamento e serve esses dados para assistentes de IA (como Claude ou ChatGPT) via MCP.6 Esta abordagem é a que mais se aproxima do pedido de "software que traz sugestões das melhores coisas para plantar e cozinhar", pois permite uma interação em linguagem natural fundamentada em dados concretos.6

Ao utilizar o Savecraft.gg, o jogador pode realizar consultas complexas que seriam impossíveis em uma planilha estática. Por exemplo, ao perguntar "Qual a melhor forma de gastar meus 10.000 tesserae considerando que estou no dia 3 da Primavera e já tenho o perk de economia de energia?", a IA processa os dados do player.json e as tabelas de referência de culturas para fornecer um plano de plantio que maximiza o lucro sazonal.6 A segurança deste sistema é garantida pelo uso de sandboxing via WebAssembly (WASM), onde os plugins de parsing de save não têm acesso direto ao sistema de arquivos do usuário, emitindo apenas JSON estruturado para a nuvem.6

### **Stardew Crop Planner e Algoritmos de Decisão Heurística**

Apesar do nome, o software disponível em stardewcropplanner.com é explicitamente compatível com Fields of Mistria devido à sobreposição de algoritmos de simulação econômica.18 Ele utiliza uma árvore de decisão heurística para encontrar a programação de plantio ideal. O software considera o capital inicial, o número de ladrilhos disponíveis e a duração da estação para simular milhões de combinações possíveis.18

Para Fields of Mistria, este planejador é particularmente útil para calcular o valor de culturas de colheita múltipla (multiharvest). O algoritmo deve levar em conta que, em Mistria, algumas culturas custam 300 tesserae e levam 5 dias para crescer, mas produzem colheitas subsequentes a cada 3 dias.19 A matemática subjacente para determinar a viabilidade de uma cultura multiharvest em relação a uma de colheita única é expressa pela fórmula de lucro sazonal:

![][image1]  
Onde ![][image2] é determinado pelo tempo restante na estação:

![][image3]

## **Economia do Cultivo e Otimização da Margem de Lucro**

Uma ferramenta de sugestão eficaz deve estar baseada em dados de mercado precisos. Em Fields of Mistria, a lucratividade não é linear e é fortemente influenciada por habilidades passivas desbloqueadas na estátua do dragão.20 A análise de dados de jogo revela que certas culturas, embora caras, oferecem um ROI significativamente superior ao longo de uma estação completa de 28 dias.19

### **Comparação de Lucratividade de Culturas Sazonais**

| Estação | Cultura | Custo (t) | Venda (t) | Crescimento/Regrow | Lucro Sazonal Est. (por 100 sementes) |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Primavera | Ervilhas | 300 | 135 | 5 / 3 dias | 78.000 19 |
| Primavera | Morangos | 300 | 125 | 5 / 3 dias | 70.000 19 |
| Primavera | Repolho | 70 | 180 | 9 dias | 33.000 19 |
| Verão | Milho | 300 | 125 | 5 / 3 dias | 70.000 19 |
| Verão | Melancia | 70 | 180 | 9 dias | 33.000 19 |
| Outono | Cebola | 300 | 135 | 5 / 3 dias | 78.000 19 |
| Outono | Trigo | 300 | 150 | 9 / 3 dias | 75.000 19 |

As sugestões de softwares automatizados frequentemente priorizam Ervilhas (Peas) e Cebolas (Onions) como as campeãs de produtividade financeira bruta.19 No entanto, a análise de segunda ordem sugere que o jogador deve considerar o "custo de oportunidade" da energia e do tempo de processamento. Por exemplo, o Trigo, embora ligeiramente menos lucrativo na venda direta do que as Ervilhas, pode ser processado em Farinha, aumentando seu valor base de 150 para 175 tesserae, e posteriormente cozido em Pão (190t), o que altera drasticamente o lucro final por ladrilho ao longo do tempo.9

### **O Impacto das Habilidades (Perks) na Sugestão de Plantio**

As ferramentas de IA que leem o arquivo player.json levam em conta os "Skill Perks" ativos, que são modificadores de jogo cruciais. Se o jogador possui o perk "Prize Winning", há uma chance de 5% de ganhar moedas adicionais ao colher qualquer cultura, o que favorece plantas de colheita múltipla e rápida.20 Outro perk crítico é o "Harvest Time", que reduz em um dia o tempo de crescimento de culturas lentas, tornando o Repolho e a Melancia mais eficientes do que o indicado nas tabelas base do jogo.20

## **Otimização Culinária e Processamento de Valor Agregado**

A sugestão de "melhores coisas para cozinhar" exige que o software análise a diferença entre o valor de mercado dos ingredientes crus versus o valor do prato final, subtraindo o custo de energia ou o tempo de processamento no moinho (Mill).12

### **Análise de ROI em Receitas e Culinária Profissional**

A culinária em Fields of Mistria é uma das formas mais potentes de gerar capital, mas também pode ser uma armadilha financeira. Softwares de planejamento identificaram que certas receitas populares, como o Mocha, resultam em um lucro negativo de \-130 tesserae se todos os ingredientes forem comprados.23 Inversamente, pratos de alta complexidade oferecem margens excepcionais.

| Prato Cozinhado | Ingredientes Principais | Lucro Líquido (t) | Vantagem de Otimização |
| :---- | :---- | :---- | :---- |
| Seafood Snow Pea Noodles | Ervilha de Neve, Frutos do Mar | \+285 | Melhor lucro por unidade.23 |
| Lobster Roll | Lagosta, Pão | \+265 | Alto valor agregado para pesca e moagem.23 |
| Rosemary Garlic Noodles | Ervilha, Alho, Alecrim | \+235 | Ingredientes fáceis de forragear.23 |
| Strawberry Shortcake | Morango, Leite, Ovo | \+510 (bruto) | Sinergia total com pecuária.12 |

O uso de softwares de sugestão permite que o jogador identifique o "ponto de equilíbrio" da culinária. Por exemplo, se o jogador possui o perk que permite que a culinária ocasionalmente devolva ingredientes ou produza pratos duplos, o lucro esperado de receitas como "Noodles" ou "Bread" sobe exponencialmente, tornando a compra de ingredientes em massa (como farinha no mercado) uma estratégia de arbitragem financeira viável.12

## **Ferramentas de Planejamento de Layout e Engenharia de Fazenda**

Um aspecto fundamental de softwares como o Travellers Rest Planner é a visualização espacial. Em Fields of Mistria, o planejamento do layout da fazenda é vital para minimizar o tempo de deslocamento e otimizar a área de irrigação.2

### **Mistria Editor e Planejádores de Grade**

O Mistria-Editor é uma ferramenta executável (.exe) que permite carregar o arquivo farm.json para editar a disposição dos objetos na fazenda fora do jogo.13 Esta ferramenta é essencial para:

1. **Posicionamento de Estruturas**: planejar o local de grandes celeiros (Barns) e galinheiros (Coops) que podem ser expandidos até o tamanho Extra-Large.22  
2. **Zoneamento Eficiente**: Criar zonas distintas para plantio, pecuária e estações de artesanato, economizando tempo de movimentação in-game.2  
3. **Gerenciamento de Obstáculos**: Visualizar áreas que o jogador ainda não desbloqueou, como a expansão a leste do rio, para planejar o crescimento futuro da infraestrutura.25

Existem também planejadores baseados em planilhas criados pela comunidade (como os de u/urlovebot e u/L3monZ3sty) que funcionam como maquetes digitais. Eles incluem contadores de materiais para caminhos de pedra, cercas e árvores frutíferas, permitindo que o jogador saiba exatamente quantos recursos coletar antes de iniciar uma reforma massiva na fazenda.25

## **Ecossistema de Mods e Utilidades de Qualidade de Vida**

Para aqueles que preferem sugestões "dentro do jogo" em vez de um software externo, a cena de modding de Fields of Mistria, facilitada por gerenciadores como o Vortex e o FLiSaMM, oferece ferramentas que automatizam a tomada de decisão.28

* **Crop Timers**: Este mod resolve a necessidade de cálculos manuais ao exibir sobre cada planta o número exato de dias até a colheita, permitindo um planejamento visual imediato.30  
* **Donate It**: Adiciona indicadores visuais em itens que o jogador possui, mas que ainda não foram doados ao museu, agindo como um guia de completismo baseado no save.30  
* **Potion Mastery**: Otimiza o custo de saúde e mana permitindo a criação de poções e xaropes que, de outra forma, exigiriam gastos elevados na clínica.4  
* **Skill Perk Management**: A capacidade de ativar e desativar perks no Altar do Dragão permite que o jogador alterne entre modos de "lucro máximo" e "descoberta de itens" dependendo da necessidade do dia.22

## **Dinâmicas de Pecuária e Genética de Animais**

Embora o foco inicial de muitos jogadores seja o plantio, a pecuária em Fields of Mistria introduz um sistema de camadas (tiers) que requer planejamento a longo prazo para ser lucrativo.21 Ferramentas de sugestão automatizadas podem analisar o status dos animais no save para recomendar ciclos de procriação.

O sistema de cores e raridades segue uma lógica de progressão onde o cruzamento de animais de Tier 1 tem a chance de gerar descendentes de Tier 2, e assim sucessivamente.21 A obtenção de animais de alto nível desbloqueia produtos de qualidade superior, que são ingredientes essenciais para as receitas de culinária mais rentáveis do jogo.12 Softwares de planejamento ajudam a rastrear quais combinações genéticas ainda não foram exploradas pelo jogador, garantindo que o progresso no "Almanaque de Animais" seja constante.7

## **Segurança de Dados e Considerações Técnicas para o Usuário**

Ao utilizar scripts locais ou softwares .exe para analisar arquivos de salvamento, o usuário deve estar ciente da integridade dos dados. O uso de gerenciadores como o FLiSaMM é altamente recomendado, pois eles permitem a criação de backups automáticos antes de qualquer tentativa de edição ou análise profunda.28 A própria desenvolvedora, NPC Studio, alerta que o uso de ferramentas de desempacotamento de save deve ser feito com cautela, sugerindo que os jogadores nunca excluam seus arquivos .sav originais até confirmarem que as modificações ou análises não corromperam o estado do jogo.11

Além disso, a transição para a versão 1.0 e atualizações subsequentes (como o Patch v0.15.3) podem alterar a estrutura interna dos arquivos JSON, exigindo que ferramentas como o Vaultc sejam atualizadas regularmente para manter a compatibilidade.14 O erro comum "o termo vaultc.exe não é reconhecido" geralmente deriva de problemas de caminho de diretório (PATH) no sistema operacional, algo que usuários de scripts locais devem configurar corretamente para garantir o funcionamento das ferramentas.11

## **Conclusões e Recomendações de Fluxo de Trabalho**

A análise abrangente do ecossistema de software para Fields of Mistria indica que, embora não exista um clone exato do Travellers Rest Planner, a infraestrutura de dados disponível é superior em termos de flexibilidade e potencial de análise. Para obter o máximo de sugestões baseadas no seu save, recomenda-se o seguinte fluxo de trabalho tecnológico:

1. **Extração de Dados**: Utilizar o Vaultc para converter o arquivo .sav em JSON, permitindo a leitura por ferramentas externas.10  
2. **Análise de Progresso**: Fazer o upload do JSON para o hozblic.github.io para visualizar estatísticas de jogo e identificar lacunas no museu e relacionamentos.14  
3. **Otimização Ativa via IA**: Configurar o Savecraft.gg para permitir que assistentes de IA análisem o estado do jogo e forneçam sugestões personalizadas sobre o que plantar e cozinhar com base no capital e inventário atuais.6  
4. **Planejamento de Safra**: Utilizar o Stardew Crop Planner para definir o cronograma de plantio multiharvest mais lucrativo para o restante da estação atual.18  
5. **Aprimoramento in-game**: Instalar mods como Crop Timers e Donate It para integrar as sugestões de otimização diretamente na interface visual do jogo.30

Este conjunto de ferramentas forma um sistema de suporte à decisão de nível profissional, transformando a experiência de Fields of Mistria em um exercício de eficiência baseada em dados. Com a evolução contínua da comunidade de modding e o suporte oficial do NPC Studio às ferramentas de manipulação de save, a tendência é que essas soluções se tornem cada vez mais integradas e automatizadas, atendendo plenamente à demanda por planejamento estratégico complexo no jogo.

#### **Referências citadas**

1. Fields of Mistria Cloud Saves \- SteamDB, acessado em maio 9, 2026, [https://steamdb.info/app/2142790/ufs/](https://steamdb.info/app/2142790/ufs/)  
2. Fields of Mistria Character Customization: My Cute Farmer Girl Farmsona Reveal\! \- Lemon8, acessado em maio 9, 2026, [https://www.lemon8-app.com/@myriad\_of\_roses/7413034633531900421?region=us](https://www.lemon8-app.com/@myriad_of_roses/7413034633531900421?region=us)  
3. 49 Famous Games Made with GameMaker \- Game Design Skills, acessado em maio 9, 2026, [https://gamedesignskills.com/game-design/famous-gamemaker-games/](https://gamedesignskills.com/game-design/famous-gamemaker-games/)  
4. acessado em maio 9, 2026, [https://store.steampowered.com/news/posts/?feed=steam\_community\_announcements\&enddate=1715698779](https://store.steampowered.com/news/posts/?feed=steam_community_announcements&enddate=1715698779)  
5. Is Fields of Mistria worth playing for fans of Stardew Valley? \- Quora, acessado em maio 9, 2026, [https://www.quora.com/Is-Fields-of-Mistria-worth-playing-for-fans-of-Stardew-Valley](https://www.quora.com/Is-Fields-of-Mistria-worth-playing-for-fans-of-Stardew-Valley)  
6. GitHub \- joshsymonds/savecraft.gg: Parse video game save files, serve structured game state to AI assistants via MCP, acessado em maio 9, 2026, [https://github.com/joshsymonds/savecraft.gg](https://github.com/joshsymonds/savecraft.gg)  
7. Fields of Mistria Master Spreadsheet/Checklist : r/FieldsOfMistriaGame, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1f34exo/fields\_of\_mistria\_master\_spreadsheetchecklist/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1f34exo/fields_of_mistria_master_spreadsheetchecklist/)  
8. How to get ANYTHING you want in Fields of Mistria. (With images) \- Steam Community, acessado em maio 9, 2026, [https://steamcommunity.com/sharedfiles/filedetails/?id=3544734865](https://steamcommunity.com/sharedfiles/filedetails/?id=3544734865)  
9. Modding & Save Editing Tutorial \- Fields of Mistria \- Steam Community, acessado em maio 9, 2026, [https://steamcommunity.com/sharedfiles/filedetails/?id=3305826941](https://steamcommunity.com/sharedfiles/filedetails/?id=3305826941)  
10. NPC-Studio \- GitHub, acessado em maio 9, 2026, [https://github.com/NPC-Studio](https://github.com/NPC-Studio)  
11. Basic guide on how to use Vaultc to unpack and repack your save files\! \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1eyl4eo/basic\_guide\_on\_how\_to\_use\_vaultc\_to\_unpack\_and/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1eyl4eo/basic_guide_on_how_to_use_vaultc_to_unpack_and/)  
12. Any tips with earning currency? : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1en2jk1/any\_tips\_with\_earning\_currency/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1en2jk1/any_tips_with_earning_currency/)  
13. brysonwood/Mistria-Editor: A simple graphical editor for designing and modifying starting farm layouts. \- GitHub, acessado em maio 9, 2026, [https://github.com/brysonwood/Mistria-Editor](https://github.com/brysonwood/Mistria-Editor)  
14. Progress tracker, v.0.15.1 : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1rjqnvu/progress\_tracker\_v0151/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1rjqnvu/progress_tracker_v0151/)  
15. Completion Help : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1ql4s07/completion\_help/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1ql4s07/completion_help/)  
16. Bug net : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1rcul7b/bug\_net/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1rcul7b/bug_net/)  
17. Interactive gift guide v.0.14.0 : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1mdf17v/interactive\_gift\_guide\_v0140/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1mdf17v/interactive_gift_guide_v0140/)  
18. mschult2/stardew-planner: Stardrew Valley crop planting scheduler website. Blazor WebAssembly. \- GitHub, acessado em maio 9, 2026, [https://github.com/mschult2/stardew-planner](https://github.com/mschult2/stardew-planner)  
19. Numbers of Mistria: A guide for Crop Yields \- Steam Community, acessado em maio 9, 2026, [https://steamcommunity.com/sharedfiles/filedetails/?id=3366720391](https://steamcommunity.com/sharedfiles/filedetails/?id=3366720391)  
20. Farming | Fields of Mistria Wiki \- Fandom, acessado em maio 9, 2026, [https://fields-of-mistria.fandom.com/wiki/Farming](https://fields-of-mistria.fandom.com/wiki/Farming)  
21. new player, what should I know? : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1hxmsqi/new\_player\_what\_should\_i\_know/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1hxmsqi/new_player_what_should_i_know/)  
22. Patch Notes: Fields of Mistria's First Major Update \- Cinelinx, acessado em maio 9, 2026, [https://www.cinelinx.com/games/game-news/patch-notes-fields-of-mistrias-first-major-update/](https://www.cinelinx.com/games/game-news/patch-notes-fields-of-mistrias-first-major-update/)  
23. Recipes Spreadsheet\! : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1iue30l/recipes\_spreadsheet/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1iue30l/recipes_spreadsheet/)  
24. how similar is this to stardew? : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1qzkmsg/how\_similar\_is\_this\_to\_stardew/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1qzkmsg/how_similar_is_this_to_stardew/)  
25. Updated Farm Layout Planner : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1jj78zl/updated\_farm\_layout\_planner/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1jj78zl/updated_farm_layout_planner/)  
26. Fields of Mistria's Third Major Update & Patch Notes are here\! \- SteamDB, acessado em maio 9, 2026, [https://steamdb.info/patchnotes/19294566/](https://steamdb.info/patchnotes/19294566/)  
27. Updated Recipe Profits Spreadsheet \+ Farm Planner : r/FieldsOfMistriaGame \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/FieldsOfMistriaGame/comments/1jmsytd/updated\_recipe\_profits\_spreadsheet\_farm\_planner/](https://www.reddit.com/r/FieldsOfMistriaGame/comments/1jmsytd/updated_recipe_profits_spreadsheet_farm_planner/)  
28. zmarotrix/FLiSaMM: A tool to help you manage your save files and mods in "Fantasy Life i: The Girl who Steals Time" \- GitHub, acessado em maio 9, 2026, [https://github.com/zmarotrix/FLiSaMM](https://github.com/zmarotrix/FLiSaMM)  
29. Review: Fields of Mistria · Issue \#18187 · Nexus-Mods/Vortex \- GitHub, acessado em maio 9, 2026, [https://github.com/Nexus-Mods/Vortex/issues/18187](https://github.com/Nexus-Mods/Vortex/issues/18187)  
30. Fields of Mistria Mods \- Nexus Mods, acessado em maio 9, 2026, [https://www.nexusmods.com/fieldsofmistria/mods/](https://www.nexusmods.com/fieldsofmistria/mods/)  
31. Looking for breeding/genetic games\! : r/gamingsuggestions \- Reddit, acessado em maio 9, 2026, [https://www.reddit.com/r/gamingsuggestions/comments/113z8kb/looking\_for\_breedinggenetic\_games/](https://www.reddit.com/r/gamingsuggestions/comments/113z8kb/looking_for_breedinggenetic_games/)

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAmwAAAAiCAYAAADiWIUQAAAGNUlEQVR4Xu3cachtUxjA8UeGjBkzz5lnmacyj5EMUTJEGTIUEilcSobMcyhTyPzBWMQ1fBAf+GBK+aBESCJJKay/tZaz3nXPfbnvcJ239/+rp3P22vues9dep/Zzn7X2GyFJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJmiWW7Bs0ZZYNr68kSQvdaSn+LPFdef02xVLtQTPE2ineKO/p1y8x6NsypX2Psv1Z5ONHySoxON+tmvba9lXT9n/aK8XyfeMkLJJi38i/vwtTPJNi2xSbtwdJkjTbkQi81myvkeKHZnumIAlrEx38nmLPZnvxFAc026NmToozUnzatJG8LNZsj4L2/CaDxO/HFDt37R9325IkzXp/pLi62d4wxTfN9kzxYsw7XUdl6vBmm2RtYSU/6/QNMaj0zc/9kSt/nHd1QvN+VLzfN0zQLSmO6xuTuX2DJEmzGQkOyRlJGtZL8Xl5nUmoCraJWUXic1t5f0mKM5t9042pvtsjV/XwXMxbSepdVF5fSbFbef9EeR0lF6dYrm9cQCTObWLaWrFvkCRpNts/xX2REx6iJhfTjáTw7b5xEnYo0fs5crWGfu0ydteEfB8LVqEjáTsnxfP9jiGovq1V3q8Weap6gxQX/HPE/B0c+dz4vsdS/DZ29zz2K6+Ljmn970iOa5Lf4rzrb6mNVduDCsZrqip1C4p+L903SpI0qqiUHNU3LgSs06qVr6kwv4TtyxRfRJ52I5mZrImcM1OjD/eNQ5AAtVO6VJ9I9to1eOOp58Zi/XfbHR0SzrqO7/h2xwIgYWNtXe/e+cSt7UEF4zW3b4w8Thv1jVOMfj/QN0qSNKqo4vCnGnrcNF9IcW3ZPjrFsyl2L9ssFr8mxbEploh8A7wzxfqRb87bxGA9Fnjq9MkYJIc8zTneU4DHjBPDnmAl2Tmkb4y8ru3XFEc0bSQaB0ZOXA4rbZtG7i9tp6fYOMXL5TjU/tdEqPZnWJLYYmqTadB+enSYOd32HZGTtraid3nk8+NzqKo9kmL7yNeSawoSt7si96difG6MPG7s499vF3k6/ORyDH08MQZjfGTkzxj2RCjr6qimTQbJKQ8ctDgvzrNaPfI51Irg9WWba3JPDMaJ6WOmjjkeVPU4jutOcrllOe6UGPS7Vj0PTfFgjN5Tw5Ik/X1jrn/Gg5vXPmN3/10BI/EiGeBmWG/O7fTcqeWVZICkj+Tlw8iJBNvcLPkc9r8U+QZdb5ITqVSNh+8a9plUEL/u2rip14X8JGQ8kXhT5ASAqbtNIveFJI/z3TvG9r/tz7Aksbqs2+YcSTh7fOd7kceCpK5OU5IUkiSCBOXx8n6FyGNSp0+55vSdaw2SSvbRd9DOeJMIrRy5XzUJfLS81jHmc+oY/xT5NzBs2vTpvmGCdor8O+R7HkyxRbNvlRQfRU4oWdPGODFudZzeicE40R+C9yTpJNOMKf1dt7RzLP8G9Jvx2D/yusazwoRNkjQDsZ7qgxLc+Lm5kYTV6TkqIXVK7KHyys10bgwSBRIAKj/svzRyEsG6NW6s0/HkI0lPv1idhye27to4j7r+ivP7LHKlpuLGzudQ4SLZqf1nkT39b/szbB3XdKBi9EmzzTnVpItE5s0YjA3JCvtqcsz5cv4Va9yqmuTVPpKI1s85L/L4k/T0Pu0bJoExIJFds9+R7Bj57+nxd/UYp9arkcfp6rK9QQmuU/sfkDpOTC/XpL7t93hVT0mSRtp1kR9G4MZHwkMVgsoGU1JUmKhYUBFiuoybKlUQpke56depOY7hhnhQ5Kk71jIxRbhRiqtS7FqOmyp831N94xCc87kprijbJCZM/VLdAucJqltMQdb+s5/+t/1hWnjYgvqpxnU9P/K1p6q3fuSpUSpTJBwkWldGTrRrwsVTqayfI2klQb4kctXu9RSblfdzIv/72kf+Hh993Dvyd/Eb6JHA/dvTrlPhhhQnpbg5cr8YJ/pRx4nzw1vNNteAafe7I1cUuW61YkiFkqpn7Tft/Bbo99kpVirHSZKkaUbyMdWJoAaYQiZRlCRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiTNDn8BgLrwxPWe5XIAAAAASUVORK5CYII=>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEcAAAAYCAYAAACoaOA9AAADhUlEQVR4Xu2YWahOURiGPxkyzzIWhwuJKFMppWOWSEREEeGCMlwQUqckSWZSxiSzDJndOIZw6UKUaykkN25IeB/fWuesvZ2O4fwn5f/fejp7r7X+vff61vt9a+9jVlJJJZX071Qu3olvgVuiWdLfWtxJ+uGiaJGM+a/VQBwUn8UnMSLb/UPTxQXLBq4o1E4cFyvMnbHPPGCpVou5ubai0CCxU3QVL8QrUZb0NxKHwriiE45YGo4rzN2zvKrXrKO5s3BY0WmHGBKOB4gP4oloE9pGir3huKgU6w3uQKTQafFVTAxtuKqo601agAkKwSFI7E51qTcEe5v4Yr7joW7ivngteoe231FjsVj0SNqahPZ6UVpvokgn0or0Gm11rze48q7ol7SNNX9/apm0/UoE5bD5xoGiy6dUjSigcAu1ZFi+Q5pnXpifi625vj8VNeueZQO8VmxOzv9GncVjywa9YMrXm1TcmG2dANVUb/qYp+NlMc080Nh7trgk9oteYSzO3BOOUVNxVaw3d8JJy6YKztggron55tcmwFfEpDBmkfl93ohjYmBopwxwv3PmaRw3GsRb/UZxw3xO+Xe5jEgZPgWa5zuCKsR7+3llhpsHpb35Q5Iebc0DMsf8priRB2xl/madBri7eGnVY3ERoKHmLusZ+jáJ/uZOniHOioZhbD7opCgBpWbyW4Ie3cn5FvMg9xU3RYfQlxH5/tGqv5X4ZJicGeFiW+dbK00H6tEjMTWc80CAY6grsYawYk/NJ1ZbveGhWXkmiqOumweV6/GKsdB8El3CuBhk6g1Bj0Ue8RtcgXuiO6PT4rWfiVXmm0LBxaSpQ/ldhvRMawiTqBTjrPZ6Q/qyc7EQpBPXLg99qcrEw/AX1VTkeQZSFeHOB5Z9TkrBbvFWbE/aCya2dJzTKZyz8oPFEbEgtLFy583TIFqfFWQirDjOiM4jBagdpBMpSgDSOoHzcBjXwTl8FI8yT4/b5mlLyhE0ghN3Lq5L6owR483vEVMXt1WE44KKorvLfIVwB7sdk2FypCAFlEnMNA/cLHFKrAm/jU6JK0qQjpp/9JKyPPgB8xRhdQkq1yFwZ8Q68+ATtMpwHl9WJ4gTYqX5fxl4HuoM92TcMrEk9JGm9aZYa1JRKKkPsWBGsbqxjYnm/xfEhpD+hvrAdRibKr0OYhykYgHi9fMviDU9c0kllVS/+g7gLJ6QQD6RcwAAAABJRU5ErkJggg==>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAmwAAAAwCAYAAACsRiaAAAAJvUlEQVR4Xu3deYgsVxXH8SMqatS4xN2EJC5xRSMuGBEyanBX4oJRjBvihlHR4IIbIyIoohDjRoyaKK4RFdwXdKKiYkSMqAGJMIroHxLFoIKGoPfLqUPdV6/7TU/e65nped8PHLq7qrtnuvqF+eXcurciJEmSJEmSJEmSJEmSJEmSJEmSJEmSJEmSJEmSJEmSJEmSJEmSJGk3vH66QdqmX043SJKkI2urwHZMq/+2+l+ra4f7m63O6Z6DOwx1NHpkqz/OqTO65+1XBjZJkpZsq8CGp7Z6yWQbge2x3eMTW12ve3w0+Xx3/7JWdx7u36zV8d2+/crAJknSki0S2DZa3Way7YGtPjXcv2Gr+3f7yuOmGwaPbnXcdOMKO6W7Tyey8Bn7EHtSqzNbXX/YzjHj2N2+1ZOG+zeNPD7cFo7jCcM2jjuvL7zm6bG7YdnAJknSki0S2K5qdYPJNkLExa1uERncNrt9BIsPtHpmq9+0+na3j27dc1v9tNV9uu37xTXTDYPTW50fGa7eGxnQ3t3qo60+FHmsPt3qC62e3eqKfFncpNUbW/152EddMOw7q9WVka/lPQhvu8HAJknSki0S2KYh5MatvhZ5ftZbWt2x1b+7/ZzrRojA1TEOp9Id+leru7Zai+sWMLbzmr4TtV10vfhc07pdzH9fPh+BaorXEFDpgt2t1dNavSky7H6pe95md/8/w+3zWz058pji4ZHfBz/r7TF21jiu9V0+arid5X4xuxs3bzvD3gTyWfuKgU2SpCXbKrDdKw4OIXRz/t495jk1CYFQQ5gj1IEOWz+cemxkSPluHDjstwhCFD9rURdONywRgebjkYFqisBKR22KbmM9n89V3wWf8/3DfXCs6jvglo7nRhx4XAl4p3WPj5RbxezP1DOwSZK0ZFsFtumEA4IJ3Ry6RIWwRuB4cWRgq6DEH3u6M9wS1OgS1USFCnXnRf4MhgPx+FYXxXiy/sNafaTVCyODHqEIDBVysj+vBfcZYv1G5O94aqu/tHresH/6vpdEvu+RwmfsJxz0+B3piJUKqu+LDGegi1bBiGNEvSuym8fnqO/pT5GBmRDHpAbQwftK5DH5YGQXkiHsD0cOp3JM8LYYPzNh762R31m/nePznlaPifwsfK/T8xenDGySJC3ZvMBGmPpn5En0f4tcooIuzuv6Jw3ObfXl7vGvWn2i1ata/bzbd3nkeW8MD9bQJsGE4MHwIEOsL231ssjgwGN+h7XIAFJdJoZbvx75OxJUbj3cEnoIRhUwalJEvS9Bst6X329t2H+4fhF5nCh+3z6clSsjz1fjePDZmVVL+AIBjgBW5wnSjfvi8DzQzeSYXRrj0ikcL44n57MR/MDrOQbcEuJ+NGxnG8fqoa2+M+yv7/2Wk+3VKf1JZJis9z4UA5skaWH8UeIP5nq3jT/O9+werzL+iNONort1JM0LbDuFoFX6Th7f2+8iO3afiew+favV2ZGhj+NB2KN7tBYZ4Ah+3L4y8lyxB7d6QozvS8ip97155PvudXeJ7X1HBDu6ZjVES5fsh5GhmgBHOCMs3nd4Pl3J2n5y5PHmta9p9YJW32/1lOG58xjYJEkLW4/sWFzRbWPZhOparDpmZa7F4oFt1jIbs2wnDCwDgaAQqOiEvTyya0Z3h1mVzJokWGxEhjSG6z4Z2V36ZmQ3aT0SIYz9DA+yjS5VvS9DjPW+hF/edy8jgBK+mFVLJ2wR34vxf1LoRPI/LXTr+PdAF68mKjBTlf38u6rt/Lfy5sjjRNh7dWQAJjQeioFNkrQwzsHhpGuG7fhjDf7w7DeLBrZZw3Kz7HZg0+ozsEmSFnbGcEvXgBl2nCzNydl7EcN100sY9fWs8akHMbBprzGwSZIWwknbNTuPE6UZGmW4i/NwtsIQW60z9YPYevin1riatxbXss0LbJxU3q8XxrBg/3jeOloGNh0uA5skaSFMOOixKjwnqG+1HAH6daa2E16YcXhdEfb6MDWtWq5hlnmBbcoOm3aKgU2StJD1yWOGRFkCoiYc9GtO0Wmiq8ZJ6w+IA9eZYsYiQayWg+BcOIZYWZeK5RRqjStOyK41vghfrEn2nBh/3pmt3hl5svssdAQ5mX5e8TvNY2DTXmNgkyQdErMDa/2r87vtBK3qmhGi+jWnWCOM4VM6Wfyh6deZ4pqXtRwCWDuLIEZgu3uMa1wx3Fqh7mdx8HpV/4gMg0dy2PSzkeuh8VnpIDLL71AMbNopBjZJ0mEjTPVrTnHBbRB4WAS21pkiiBHI6L6xov4zYgwzdNfoetUaVyydUGt81XPYRzeOFfkZ0mTl/Xkdtp1AIF3EKgU2vpvTh/ssR0EnlYB9p8gV/bU7DGySpMM2XXPqq5GhiwkJDG/WOlMEO24JbR+LDFt0teimvaHVPWJc4+pzMa7xxdAra3yxlhWhbi3yZz0iVsOqBLb6Hss74sBzF7n8k3aHgU2SpCVblcB278hzA0Gw5hzCfnIGw+OF8M2VEOrSTse2OmF4/KDhPgHwlKEKi8vyHPZNL9Ze77ndC9YfDQxskiQt2aoEth7dNc7lm+WvMS5hwgXmGUbl0lRXxzhE/YdWDxnuXxwZ/FgW5eTI63ZywXneoy5Q/+sYwx/nLnJ1BY0MbJIkLdkqBraNyA7bFJNNWIMPdMReG3kheTpn19STmqu6+xsxXiydJV4qpLHt95ETVJjkUQh4BD6NDGySJC3ZKgY2umt02aa42sWsz8OF3jnXsGx29+moFc5xrNnF3DLzl2HQ/qL0BMVVuGj8TjKwSZK0ZLMCzl7G8CWhadYVKRjy7INcBSsmJFQQY2JIXQGD89cIY6y9x/tuRA6LgkuEMSzK+W7nDNuYZXzusP2JkRdMf1HkOn5089jOY4ZbueA6s5M59+4VrX7b6vLICSl08cDMVias/LjViZEzllnTr/avCgObJElLtiqBjWHKi2Jcd+/ayPA0RXi4IHKZlZogsN7quOE+XbTThvuENNbeO3V4TBDkdQx7njVsA8Osl7S6LMbz4wh7rHXH70Vnj+DF8OvxkcGP2cWExNtGruHH2n4Mud4oxmPOLftYAoYhWLqALMdC+FslBjZJkpZsVQLbTticbjiEfpi0v8+yL3TMCF6s5wc6cJxHB86tI6TRrbs0MjQSIAl+DL+ePTxnlRjYJElaMgJbfx3To9FJrc6L7MwtegyOmTymg0fo6rFuH6ZXvJg+j8c1U3VVMEmj/s0wi1aSJC0Rga2GGectlaHFEbo4Z41lQGYN2e4XzJStfzOLXt9WkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJkiRJ0kz/BzLqlagrDGNrAAAAAElFTkSuQmCC>