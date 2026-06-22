---
name: implement
description: Ejecuta las tasks del spec aprobado (o las tasks inline en L0) una por una, con commit verificado por el pre-commit hook en cada una. Usar cuando el usuario pide /implement, o quiere avanzar la siguiente task pendiente de la issue activa.
---

**Fase:** 3 · **Rol invocado:** [implementer](../../../workflow/agents/implementer.md)

## Cómo ejecutar

1. Leé la fuente de tasks según el nivel: tasks inline en
   `workflow/specs/active-issue.md` (L0) o `workflow/specs/issue-N/tasks.md` (L1/L2).
2. Mostrá el progreso (completadas/pendientes) y esperá confirmación para empezar.
3. Delegá al subagente `implementer` (ver [agents/implementer.md](../../agents/implementer.md))
   usando [`prompt.txt`](prompt.txt) para la siguiente task pendiente.
4. Presentá el resumen del diff al usuario antes del commit.

**Gate:** aprobación explícita por task (o modo autopilot si el usuario lo activó).
**Siguiente paso:** repetir hasta agotar tasks, luego `/verify` (L1/L2) o revisión manual (L0).
