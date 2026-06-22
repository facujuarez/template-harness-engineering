---
name: create-pr
description: Sincroniza docs/ vía Doc Updater, publica la branch y crea el Pull Request en GitHub con la descripción generada desde el spec y el reporte de verificación. Usar cuando el usuario pide /create-pr, después de que el gate manual (Fase 5) fue aprobado.
---

**Fase:** 6 · **Roles invocados:** [orchestrator](../../../workflow/agents/orchestrator.md) + [doc-updater](../../../workflow/agents/doc-updater.md)

## Cómo ejecutar

1. Leé `workflow/specs/active-issue.md` para el nivel y verificá que el branch
   está limpio, al día con `develop`, y `checkpoint.md` cerrado por el reviewer.
2. Delegá al subagente `doc-updater` (ver [agents/doc-updater.md](../../agents/doc-updater.md))
   usando [`prompt.txt`](prompt.txt) para obtener las propuestas de actualización de `docs/`.
3. Presentá el borrador de PR + las propuestas de docs al usuario.

**Gate:** aprobación explícita del PR y de los cambios de docs (todos, parcial o ninguno)
antes de cualquier `git push` o `gh pr create`.
**Después:** actualizar `workflow/specs/project-memory.md` y mover la issue a In Review.
