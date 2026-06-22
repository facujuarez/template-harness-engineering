---
name: init-harness
description: Configura la capa provider-specific de Claude Code (.claude/agents/, .claude/skills/, settings.json) mapeando 1:1 los roles de workflow/agents/. Usar cuando el usuario pide /init-harness, configurar el harness por primera vez, o regenerar la capa nativa tras un cambio en workflow/agents/.
---

**Fase:** 0 - INIT · **Rol invocado:** [harness-configurator](../../../workflow/agents/harness-configurator.md)

Se ejecuta una sola vez por harness elegido. Es idempotente — correrlo de
nuevo recrea la capa sin acumular duplicados.

## Cómo ejecutar

1. Leé `workflow/agents/harness-configurator.md` completo (fuente de verdad
   del rol, incluyendo sus reglas de aprobación y validación).
2. Leé `workflow/docs/harness-adapters.md` para la estructura esperada por harness.
3. Delegá al subagente `harness-configurator` (ver [agents/harness-configurator.md](../../agents/harness-configurator.md))
   usando la plantilla de [`prompt.txt`](prompt.txt), completando `[harness-name]`.
4. Validá la salida contra la checklist de "Validación post-configuración" del rol.
5. Reportá el resultado al usuario (✓ harness configurado / ✗ errores encontrados).

**Siguiente paso:** `/setup-project` — ver
[workflow/SETUP.md](../../../workflow/SETUP.md) para el detalle completo de este skill.
