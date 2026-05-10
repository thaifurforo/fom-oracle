# [US-08] — Restauracao de sessao, resiliencia e verificacao integrada

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Historia

Como jogador,
quero que o app restaure meu contexto, trate erros com clareza e tenha verificacao integrada dos fluxos criticos,
para que eu confie no uso recorrente.

## Criterios de Aceite

- **CA-01:** o app reabre restaurando save e prioridades quando validos.
- **CA-02:** existem testes de contrato/integracao para descoberta, refresh e recomendacao.

## Fora do escopo

- Auto-update do aplicativo.
- Telemetria remota.

## Referencias

- Milestone: `../milestone.md`
- Spec tecnica: `./tech-spec.md`
