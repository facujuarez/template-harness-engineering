---
name: design
description: Explora el codebase y genera el spec completo de la issue activa (design.md, tasks.md, test-plan.md en Gherkin). Usar cuando el usuario pide /design, o cuando una issue de nivel L1/L2 necesita diseño antes de implementar. No aplica a L0.
---

**Fase:** 3 (L1, L2 — L0 la salta) · **Roles invocados:** [explorer](../../../workflow/agents/explorer.md) + [designer](../../../workflow/agents/designer.md)

## Cómo ejecutar

1. Leé `workflow/specs/active-issue.md` para conocer la issue y el nivel activos.
2. Delegá al subagente `explorer` (ver [agents/explorer.md](../../agents/explorer.md))
   usando [`prompt.txt`](prompt.txt) — en L2, lanzá 2 explorers en paralelo (áreas distintas).
3. Con el reporte del explorer, delegá al subagente `designer`
   (ver [agents/designer.md](../../agents/designer.md)) para generar el spec completo.
4. Presentá el spec al usuario.

**Gate:** aprobación explícita del spec antes de continuar a `/implement`.
