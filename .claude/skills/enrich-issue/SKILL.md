---
name: enrich-issue
description: Profundiza y completa la descripción de la issue activa - ACs, out-of-scope, edge cases, detalles técnicos y escenarios de prueba. Usar cuando el usuario pide /enrich-issue, después de /start-issue y antes de /design o /implement.
---

**Fase:** 2 · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Leé `workflow/agents/orchestrator.md`, `workflow/docs/issue-template.md`
   y `workflow/docs/definition-of-ready.md`.
2. Delegá al subagente `orchestrator` (ver [agents/orchestrator.md](../../agents/orchestrator.md))
   usando la plantilla de [`prompt.txt`](prompt.txt).
3. Presentá el borrador enriquecido al usuario para aprobación antes de escribir nada.

**Gate:** aprobación explícita antes de actualizar la issue en GitHub y generar `active-issue.md`.

**Siguiente paso según nivel:** L0 → `/implement` · L1/L2 → `/design`.
