---
version: alpha
name: FOM Oracle Cozy Pastel Mistria
description: Sistema visual normativo do frontend do FOM Oracle, inspirado em fazenda, vilarejo, magia e estações, com base clara creme, verde pastoral, acentos rosa/lilás e bordas terrosas.
colors:
  primary: "#7ECF95"
  secondary: "#F5B66D"
  tertiary: "#EEC6DA"
  mystic: "#D8C8F1"
  neutral: "#FFF7E8"
  surface: "#FFFAF0"
  border: "#BD8E69"
  ink: "#33251F"
  muted: "#7F694F"
  danger: "#B94B5A"
  success: "#5F9F6B"
  warning: "#D88A45"
typography:
  h1:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 2rem
    fontWeight: 800
    lineHeight: 1.15
    letterSpacing: 0
  h2:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 1.5rem
    fontWeight: 800
    lineHeight: 1.2
    letterSpacing: 0
  h3:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 1.125rem
    fontWeight: 800
    lineHeight: 1.25
    letterSpacing: 0
  body-md:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 1rem
    fontWeight: 500
    lineHeight: 1.5
    letterSpacing: 0
  body-sm:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 0.875rem
    fontWeight: 500
    lineHeight: 1.45
    letterSpacing: 0
  label-caps:
    fontFamily: 'Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: 0.75rem
    fontWeight: 800
    lineHeight: 1.2
    letterSpacing: 0.08em
rounded:
  sm: 8px
  md: 12px
  lg: 16px
  pill: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
components:
  app-shell:
    backgroundColor: "{colors.neutral}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
    rounded: "{rounded.lg}"
    padding: 24px
  panel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
    rounded: "{rounded.lg}"
    padding: 24px
  card:
    backgroundColor: "{colors.neutral}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.md}"
    padding: 16px
  button-primary:
    backgroundColor: "{colors.secondary}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    fontWeight: 800
    rounded: "{rounded.sm}"
    border: "2px solid {colors.border}"
    boxShadow: "0 4px 0 0 {colors.border}"
    padding: 12px
    active:
      transform: "translateY(2px)"
      boxShadow: "0 2px 0 0 {colors.border}"
  button-secondary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    fontWeight: 800
    rounded: "{rounded.sm}"
    border: "2px solid {colors.border}"
    boxShadow: "0 4px 0 0 {colors.border}"
    padding: 12px
    active:
      transform: "translateY(2px)"
      boxShadow: "0 2px 0 0 {colors.border}"
  status-pill:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.ink}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: 8px
  status-pill-mystic:
    backgroundColor: "{colors.mystic}"
    textColor: "{colors.ink}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: 8px
  status-pill-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.surface}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: 8px
  status-pill-success:
    backgroundColor: "{colors.success}"
    textColor: "{colors.ink}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: 8px
  danger-marker:
    backgroundColor: "{colors.danger}"
    rounded: "{rounded.pill}"
    size: 8px
  success-marker:
    backgroundColor: "{colors.success}"
    rounded: "{rounded.pill}"
    size: 8px
  status-pill-warning:
    backgroundColor: "{colors.warning}"
    textColor: "{colors.ink}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: 8px
  recommendation-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
    rounded: "{rounded.lg}"
    padding: 20px
  summary-tile:
    backgroundColor: "{colors.neutral}"
    textColor: "{colors.muted}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.md}"
    padding: 16px
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    padding: 12px
  nav-item:
    backgroundColor: "{colors.border}"
    textColor: "{colors.ink}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.sm}"
    padding: 12px
---

# FOM Oracle — Guia de Design de Frontend

## Visão Geral

Este documento define o padrão oficial de UI/UX, identidade visual, design system e arquitetura de interface do frontend do FOM Oracle. Os tokens do front matter são normativos para cores, tipografia, espaçamento, formas e componentes; o Markdown explica como aplicar esses tokens em telas reais.

A direção visual aprovada é **cozy pastel Mistria**: um aplicativo de estratégia local-first com aparência acolhedora de companion de farming RPG. A UI deve parecer próxima de fazenda, vilarejo, magia, romance e passagem de estações, sem perder clareza de painel para jogadores que tomam decisões rápidas.

Conceitos de arte:

- Usar painéis claros creme/pêssego, bordas terrosas e sombras discretas que lembrem profundidade de UI pixel-art sem reproduzir assets do jogo.
- Usar verde como cor de ambiente, saúde do sistema, fazenda e estado operacional.
- Usar rosa para social, presentes, NPCs, eventos relacionais e oportunidades de afeto.
- Usar lilás para magia, progresso especial, desbloqueios raros e sinais de descoberta.
- Concept art e mockups devem ficar em `.catalog/assets/concept-art/`, usar prefixo `concept-` e nunca ser usados diretamente em runtime, UI ou bundle.

Princípios de produto:

- Abrir direto no assistente estratégico, com entendimento imediato do estado atual do save.
- Priorizar clareza de ação: cada recomendação deve ser legível como ação concreta.
- Evitar exposição de score técnico na UI; preferir justificativas humanas.
- Preservar previsibilidade visual: padrões de layout e feedback consistentes entre telas.
- Manter leitura confortável para uso prolongado em desktop, com responsividade mínima para janelas menores.

Arquitetura obrigatória de interface:

- `frontend/src/app`: bootstrap, rotas, shell e composição global.
- `frontend/src/features`: telas e fluxos orientados a domínio de produto.
- `frontend/src/shared`: cliente de API, tipos de transporte, utilitários e componentes de UI reutilizáveis.

Regras arquiteturais:

- UI é cliente fino: não implementa regra de negócio.
- UI não acessa filesystem, SQLite ou parsing diretamente.
- Toda regra de domínio deve vir do backend via Local API.
- Feature não importa internals de outra feature; extrações comuns devem ir para `shared`.
- Componentes de `shared/ui` devem ser genéricos e sem acoplamento a fluxo de negócio específico.

## Cores

A paleta combina uma base clara e acolhedora com acentos pastéis mais coloridos. O conjunto deve remeter ao visual geral de Fields of Mistria: céu claro, campo verde, madeira, painéis creme e detalhes rosa/lilás.

- **Primary (`#7ECF95`)**: verde pastoral para estrutura ativa, estado saudável, navegação selecionada e temas de fazenda.
- **Secondary (`#F5B66D`)**: âmbar/colheita para CTA principal, ações explícitas e destaques de progresso imediato. **Obrigatório para botões primários.**
- **Tertiary (`#EEC6DA`)**: rosa social para NPCs, presentes, aniversários, eventos e recomendações relacionais.
- **Mystic (`#D8C8F1`)**: lilás mágico para desbloqueios, raridades, magia, progresso especial e descobertas.
- **Neutral (`#FFF7E8`)**: creme base para fundo geral e áreas de leitura prolongada.
- **Surface (`#FFFAF0`)**: painel claro para cards, listas, formulários e seções de conteúdo.
- **Border (`#BD8E69`)**: borda terrosa para molduras, divisões e sensação artesanal.
- **Ink (`#33251F`)**: texto principal e ícones funcionais. **Texto de botões deve usar esta cor.**
- **Muted (`#7F694F`)**: metadados, labels, descrições secundárias e texto de apoio.
- **Danger (`#B94B5A`)**: falhas, inconsistências de save e ações destrutivas.
- **Success (`#5F9F6B`)**: carregamento bem-sucedido, conexão ativa e estados concluídos.
- **Warning (`#D88A45`)**: atenção, leitura parcial, conflito de dados e ação pendente.

Não usar uma tela dominada por apenas uma família de cor. Verde, creme e terroso formam a base; rosa e lilás entram como sinais semânticos, não como decoração aleatória.

## Tipografia

A tipografia funcional usa `Inter` com fallback para fontes de sistema. Não há dependência obrigatória de fonte pixelada na v1.

- Títulos usam peso alto, linhas curtas e hierarquia clara.
- Botões e CTAs devem usar peso **negrito/extra-bold** para destacar a ação sobre o fundo colorido.
- Labels podem usar caixa alta com espaçamento moderado, mas não devem ficar longos.
- Texto de recomendação usa frases objetivas em português brasileiro, com verbos de ação.
- Texto operacional não deve usar fonte pixelada, decorativa ou de baixa legibilidade.
- Letter spacing deve ser `0` em textos corridos e no máximo `0.08em` em labels curtos.

## Layout

O app abre direto no assistente estratégico. O topo da tela mostra resumo do painel do save; o corpo prioriza recomendações e fluxos de investigação, como inventário e presentes.

Padrões de layout:

- Usar `app-shell` como moldura principal com fundo creme e áreas de conteúdo organizadas.
- Usar `panel` para seções principais e `card` para itens repetidos, recomendações e blocos de resumo.
- Evitar hero marketing; a primeira tela deve ser a experiência real do assistente.
- Preferir densidade organizada a grandes áreas vazias: o produto é ferramenta de apoio recorrente.
- Preservar grid estável para tiles, listas e painéis para evitar deslocamentos durante loading ou atualização do save.
- Responsividade mínima deve cobrir desktop e janelas menores sem sobreposição de texto ou perda de ações principais.

Cada fluxo que consome dados deve cobrir estados:

- `loading`: indicador claro de carregamento sem deslocamentos bruscos de layout.
- `empty`: mensagem objetiva com próximo passo recomendável.
- `error`: mensagem compreensível com ação de recuperação, como tentar novamente.
- `success`: conteúdo principal com hierarquia visual consistente.

## Elevação e Profundidade

A profundidade deve sugerir painéis físicos e UI de RPG, sem transformar o app em skeuomorfismo pesado.

- **Botões Estilo RPG**: Devem possuir bordas terrosas de 2px e sombras sólidas inferiores (não difusas) de 4px para simular profundidade física.
- **Estado de Clique (Feedback)**: No clique, os botões e CTAs devem aplicar um deslocamento vertical (`translateY(2px)`) e redução da sombra, simulando a pressão física de um botão mecânico.
- Painéis principais podem usar borda terrosa de 1px a 2px e sombra curta vertical.
- Cards internos usam elevação menor que painéis para não competir com a estrutura.
- Evitar blur pesado, vidro escuro, gradientes corporativos e sombras muito difusas.
- Estados de foco devem ser visíveis por contorno e não depender apenas de cor.

## Formas

As formas devem ser acolhedoras e consistentes, com cantos arredondados moderados.

- `rounded.sm` (`8px`) para botões, inputs e controles compactos.
- `rounded.md` (`12px`) para cards e tiles.
- `rounded.lg` (`16px`) para painéis principais e molduras de seção.
- `rounded.pill` para status curtos e categorias.
- Não usar cards com arredondamento excessivo nem cards dentro de cards quando uma seção simples resolver.

## Componentes

Cada componente de UI deve começar pelos tokens do front matter. Variações novas só entram quando removem duplicação real ou representam um estado semântico novo.

- **App shell**: fundo `neutral`, texto `ink`, navegação clara e resumo do save sempre visível no topo da experiência principal.
- **Panel**: superfície `surface`, borda terrosa e espaço suficiente para agrupar fluxos principais.
- **Card**: superfície clara, conteúdo escaneável e hierarquia curta; usado para recomendações, tiles e itens repetidos.
- **Button primary**: usa `secondary`; possui borda terrosa física, sombra sólida de 4px e texto em negrito cor `ink`. Reservado para ações explícitas como atualizar save, confirmar seleção ou aplicar prioridade.
- **Button secondary**: usa `primary`; segue a mesma lógica de elevação e borda física do botão primário, mas em verde. Usado para navegação contextual, filtros e ações reversíveis.
- **Floating Action Button (Checklist)**: Deve seguir rigorosamente a estética de botão RPG elevado, com sombra sólida e borda física, garantindo destaque sobre o conteúdo da tela.
- **Status pill**: usa rosa, lilás, verde, warning ou danger conforme significado; nunca depender apenas da cor para comunicar estado.
- **Recommendation card**: deve mostrar ação concreta, justificativa humana e categoria prática, sem score técnico exposto.
- **Summary tile**: mostra dia, estação, save ativo, prioridade, conexão ou alerta com label curto e valor legível.
- **Input**: mantém fundo claro, texto escuro, foco visível e tamanho estável.
- **Nav item**: indica posição atual com contraste claro, sem depender apenas de uma mudança sutil de cor.

Textos de interface devem ser objetivos e em português brasileiro. Ícones podem complementar ações, mas não substituem rótulos quando a ação não for óbvia.

## Regras e Antipadrões

Governança:

- Este documento é a fonte normativa obrigatória para decisões de UI/UX, identidade visual e arquitetura de interface do frontend.
- Tasks de frontend não podem introduzir padrão novo de UI/UX sem atualizar explicitamente este documento.
- Para tela nova ou mudança visual relevante, o agente deve tentar gerar um protótipo com Google Stitch MCP ou gerar ele próprio como fallback, antes da implementação React.
- O agente deve revisar o protótipo contra este guia, ajustar o HTML quando necessário e pedir validação humana no fluxo de trabalho antes de implementar.
- O CI valida apenas regras objetivas de aderência ao guia; avaliação de qualidade visual e suficiência das evidências permanece responsabilidade do agente e do review humano.

Obrigatório:

- Usar tokens do `DESIGN.md` antes de criar estilos ad hoc.
- Descrever na PR como a mudança aderiu ao `DESIGN.md`.
- Incluir evidência visual na PR para toda task de frontend com impacto visual, como prints ou fluxo gravado curto.
- Se houver impacto no guia, incluir seção "Impacto no DESIGN.md" e atualizar este documento.
- Garantir navegação por teclado para fluxos principais.
- Manter contraste suficiente e hierarquia tipográfica legível.
- Usar semântica HTML adequada para headings, listas, botões e regiões.
- Não depender apenas de cor para transmitir estado.

Proibido:

- Implementar regra de negócio na UI.
- Acessar filesystem, SQLite, saves ou parsing diretamente pelo frontend.
- Copiar assets oficiais de Fields of Mistria para runtime, UI ou bundle.
- Usar concept art diretamente como asset de produto.
- Expor score técnico de recomendação na interface.
- Criar estilos visuais novos sem verificar tokens e componentes existentes.
- Usar fonte pixelada em texto operacional ou componentes densos.

Critério de pronto:

- Sem checklist de aderência ao `DESIGN.md` e sem evidência visual, a task de frontend não é considerada pronta.
