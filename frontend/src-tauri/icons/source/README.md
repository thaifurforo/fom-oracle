# Fonte oficial de ícones do app

Este diretório guarda a fonte oficial dos ícones do aplicativo desktop.

## Regra

- O arquivo mestre é `icon-512-transparent.svg`.
- Não manter cópias oficiais desse SVG em outros locais do repositório.

## Geração

- Rode `pnpm --dir frontend run icons:generate` para regenerar os ícones do Tauri.
- Os arquivos gerados em `frontend/src-tauri/icons/` (png/ico/icns) são os artefatos usados no bundle.

## Não fazer

- Não usar arquivos de arte conceitual como ícone oficial do app.
- Não editar manualmente os ícones gerados em `frontend/src-tauri/icons/`.
