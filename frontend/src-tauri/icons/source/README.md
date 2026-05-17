# Fonte oficial de ícones do app

Este diretório guarda a fonte oficial dos ícones do aplicativo desktop.

## Regra

- O arquivo mestre é `icon-512-transparent.svg`.
- Não manter cópias oficiais desse SVG em outros locais do repositório.

## Geração

- A v1 mantém apenas os artefatos Windows desktop `frontend/src-tauri/icons/icon.ico` e `frontend/src-tauri/icons/icon.png`.
- Não há script padrão de geração ampla de ícones, pois ele recria artefatos de outras plataformas e canais de distribuição fora do escopo atual.
- Se o SVG mestre mudar, gere manualmente apenas os artefatos Windows necessários e valide as referências em `frontend/src-tauri/tauri.conf.json`.

## Não fazer

- Não usar arquivos de arte conceitual como ícone oficial do app.
- Não reintroduzir ícones de outras plataformas ou canais de distribuição sem decisão explícita de suporte.
