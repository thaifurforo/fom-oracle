# Project Tracking — FOM Oracle

## Ferramenta Atual

**Tool:** `milestone-files`
**Localização:** `.milestones/`

Formato: arquivos markdown versionados no repositório, sem integração com
sistema externo (GitHub Issues, Jira, Linear, etc.).

## Estrutura

```
.milestones/
  [milestone-name]/
    milestone.md              ← visão geral, US checkboxes, roadmap
    US-XX-[nome]/
      user-story.md            ← descrição da US
      tech-spec.md             ← decomposição em tarefas
      changelog.md             ← histórico de entregas
```

## Convenções

- Toda User Story tem arquivo separado com `user-story.md`, `tech-spec.md` e `changelog.md`.
- Tasks dentro de `tech-spec.md` seguem formato `T-XX` e podem ser marcadas como:
  - ✅ Concluída
  - 🔄 Em andamento
  - ⏳ Pendente
- O `milestone.md` mantém checkboxes `[ ]` por US com tasks listadas inline.
- Changelogs seguem [Keep a Changelog](https://keepachangelog.com).

## Evolução Futura

Quando o projeto precisar de rastreamento mais refinado (múltiplos
milestones simultâneos, dependências entre repos, cards por task),
migrar para:

1. **GitHub Projects (v2)** — issues por task, milestone tracking nativo
2. **ou** planilha de rastreamento compartilhada

Até lá, `milestone-files` é suficiente para o ritmo e tamanho atuais.
