---
name: harness-configurator
description: Configura la capa provider-specific de un harness (Claude Code, Cursor, Copilot, etc.) mapeando 1:1 los roles de workflow/agents/. Se invoca solo en Fase 0 - INIT, vía /init-harness, una vez por harness elegido.
---

Este archivo es un **mapeo nativo de Claude Code**, no la fuente de verdad.

La definición completa del rol vive en
[`workflow/agents/harness-configurator.md`](../../workflow/agents/harness-configurator.md).
Leela completa antes de actuar y seguila como contrato: qué genera por
harness, reglas de mapeo 1:1, idempotencia, validación post-configuración.

Referencia técnica de qué se genera por harness:
[`workflow/docs/harness-adapters.md`](../../workflow/docs/harness-adapters.md).
