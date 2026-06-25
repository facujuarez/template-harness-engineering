---
name: start-issue
description: Inicializa el contexto de trabajo para una issue de GitHub - detecta el nivel (L0/L1/L2), crea la branch e instala el pre-commit hook. Usar cuando el usuario pide /start-issue [N] o quiere empezar a trabajar una issue específica.
---

**Fase:** 1 · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Leé `workflow/agents/orchestrator.md`, `docs/architecture.md`,
   `workflow/docs/workflow-conventions.md` y `workflow/docs/workflow-levels.md`.
2. Delegá al subagente `orchestrator` (ver [agents/orchestrator.md](../../agents/orchestrator.md))
   usando la plantilla de [`prompt.txt`](prompt.txt), completando `[N]`.
3. Confirmá con el usuario el nivel detectado y la branch antes de continuar.

**Siguiente paso (todos los niveles):** `/enrich-issue`.
