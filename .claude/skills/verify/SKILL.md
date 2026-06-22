---
name: verify
description: Verifica que la implementación cumple el spec y los ACs - build, lint, tests, Mutation Testing, y recorre workflow/docs/checkpoint.md. Usar cuando el usuario pide /verify, o cuando todas las tasks de la issue activa están completas y hay que validar antes del gate manual. No aplica formalmente a L0.
---

**Fase:** 4 (L1, L2 — L0 hace versión ligera) · **Rol invocado:** [reviewer](../../../workflow/agents/reviewer.md)

## Cómo ejecutar

1. Verificá que todas las tasks de `tasks.md` están `[x]` (advertí si no).
2. Delegá al subagente `reviewer` (ver [agents/reviewer.md](../../agents/reviewer.md))
   usando [`prompt.txt`](prompt.txt) — en L2, podés lanzar reviewers en paralelo por área
   (seguridad, performance, integración) y consolidar.
3. El reviewer recorre `workflow/docs/checkpoint.md` y genera `verification-report.md`.

**Regla dura:** si queda algún `[ ]` sin justificación en `checkpoint.md`, el
reviewer bloquea el cierre y vuelve a `/implement`.
**Siguiente paso:** gate manual (Fase 5, `workflow/docs/dev-review-checklist.md`).
