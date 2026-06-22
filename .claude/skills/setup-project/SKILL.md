---
name: setup-project
description: Conduce la entrevista guiada que completa docs/functional.md, docs/architecture.md, docs/data-model.md y docs/project-plan.md, genera el README.md del proyecto y crea el backlog inicial en GitHub (Milestones + Issues). Usar cuando el usuario pide /setup-project, completar la documentación del proyecto, o generar el backlog inicial. Requiere que /init-harness ya se haya ejecutado.
---

**Fase:** 0 - SETUP · **Rol invocado:** [project-manager](../../../workflow/agents/project-manager.md)

Se ejecuta una sola vez, después de la Fase 0 - INIT.

## Modos de uso

```
/setup-project             → flujo completo (entrevista + backlog)
/setup-project docs        → solo entrevista de documentos
/setup-project backlog     → solo generación de backlog (docs/ ya completos)
```

## Cómo ejecutar

1. Leé `workflow/agents/project-manager.md` completo (fuente de verdad del rol).
2. Verificá que la capa provider-specific ya existe (Fase 0 - INIT completa);
   si no, pedile al usuario correr `/init-harness` primero.
3. Delegá al subagente `project-manager` (ver [agents/project-manager.md](../../agents/project-manager.md))
   usando la plantilla de [`prompt.txt`](prompt.txt), completando el modo elegido.
4. Respetá los gates de aprobación por sección y por documento — nunca escribir sin aprobación explícita.

**Siguiente paso:** Ciclo por issue (`/start-issue [N]`) — ver
[workflow/WORKFLOW-REFERENCE.md](../../../workflow/WORKFLOW-REFERENCE.md) para el flujo completo.
