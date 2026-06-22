---
name: new-issue
description: Crea una issue ad-hoc (bug, spike o feature no planificada) en GitHub a partir de una descripción libre del usuario, siguiendo el template canónico y la Definition of Ready. Usar cuando el usuario pide /new-issue o describe un requisito que no forma parte del backlog generado en Fase 0.
---

**Utilidad** · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Leé `docs/functional.md`, `docs/architecture.md`,
   `workflow/docs/issue-template.md` y `workflow/docs/definition-of-ready.md`.
2. Delegá al subagente `orchestrator` (ver [agents/orchestrator.md](../../agents/orchestrator.md))
   usando [`prompt.txt`](prompt.txt), completando `[descripción]` con lo que dijo el usuario.
3. Escucha activa: máximo 3 preguntas por ronda para llegar a Definition of Ready.

**Gate:** aprobación explícita del borrador antes de crear la Issue en GitHub.
