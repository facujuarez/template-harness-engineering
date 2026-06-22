---
name: move-issue
description: Mueve una issue entre estados del GitHub Project Board (Backlog/Ready/In Progress/In Review/Done), validando la Definition of Ready antes de mover a Ready y sincronizando feature_list.json. Usar cuando el usuario pide /move-issue [N] [estado].
---

**Utilidad** · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Delegá al subagente `orchestrator` (ver [agents/orchestrator.md](../../agents/orchestrator.md))
   usando [`prompt.txt`](prompt.txt), completando `[N]` y `[estado]`.
2. Si el destino es **Ready**, verificá `workflow/docs/definition-of-ready.md` primero.
3. Si el destino es **Done**, cerrá la Issue en GitHub y sincronizá `feature_list.json`.
4. Para transiciones inusuales (saltar fases), pedí confirmación explícita.
