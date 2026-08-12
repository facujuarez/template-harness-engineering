---
name: project-status
description: Reporta el estado de la sesión activa (issue en curso, fase, progreso de tasks, checkpoint) sin efectos secundarios y sugiere el siguiente comando. Usar cuando el usuario pide /project-status, o para retomar trabajo interrumpido.
---

**Utilidad** · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Delegá al subagente `orchestrator` (ver [agents/orchestrator.md](../../agents/orchestrator.md))
   usando [`prompt.txt`](prompt.txt).
2. Es de **solo lectura**: no genera ni modifica artefactos, no requiere gate.
3. Si detecta inconsistencias entre `feature_list.json` y los artefactos en
   disco, las señala explícitamente en el reporte.
