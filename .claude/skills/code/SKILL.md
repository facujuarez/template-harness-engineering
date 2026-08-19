---
name: code
description: Ejecuta las tasks del spec aprobado (o las tasks inline en L0) una por una, sin commits intermedios. Usar cuando el usuario pide /code, o quiere avanzar la siguiente task pendiente de la issue activa.
---

**Fase:** 4 · **Rol invocado:** [developer](../../../workflow/agents/developer.md)

## Cómo ejecutar

1. Leé la fuente de tasks según el nivel: tasks inline en
   `docs/memory/active-issue.md` (L0) o `docs/specs/issue-N/tasks.md` (L1/L2).
2. Mostrá el progreso (completadas/pendientes) y esperá confirmación para empezar.
3. Delegá al subagente `developer` (ver [agents/developer.md](../../agents/developer.md))
   usando [`prompt.txt`](prompt.txt) para la siguiente task pendiente.
4. Presentá el resumen del diff al usuario para aprobación. **Sin commit aquí.**

**Gate:** aprobación explícita por task (o modo autopilot si el usuario lo activó).
**Siguiente paso:** repetir hasta agotar tasks, luego `/verify` (L1/L2) o revisión manual (L0).
El commit único se consolida en `/commit` (Fase 7).
