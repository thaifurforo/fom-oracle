# [US-08] — Restauração de sessão, resiliência e verificação integrada

**Milestone:** v1-oraculo-local-first
**Status:** ⏳ Pendente

## Historia

Como jogador,
quero que o app restaure meu contexto, trate erros com clareza e tenha verificação integrada dos fluxos críticos,
para que eu confie no uso recorrente.

## Critérios de Aceite

- **CA-01:** o app reabre restaurando save e prioridades quando validos.
- **CA-02:** existem testes de contrato/integração para descoberta, refresh e recomendação.

## Fora do escopo

- Auto-update do aplicativo.
- Telemetria remota.

## Referencias

- Milestone: `../milestone.md`
- Spec técnica: `./tech-spec.md`
