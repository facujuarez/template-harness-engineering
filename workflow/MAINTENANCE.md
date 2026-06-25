# Template Maintenance Guide

> Guía para quien modifica **esta plantilla** — no para quien la usa.
> Leé este archivo primero en cualquier sesión de mantenimiento.
> Después de este archivo, el único que necesitás leer es `workflow/WORKFLOW-REFERENCE.md`.

---

## Estado actual del workflow

### Fases del ciclo por issue

| Fase | Comando | Rol responsable | Niveles |
|------|---------|-----------------|---------|
| 0-INIT | `init-harness` | Harness Configurator | una vez |
| 0-SETUP | `setup-project` | Project Manager | una vez |
| 1 | `start-issue` | Orchestrator | todos |
| 2 | `enrich-issue` | Orchestrator | todos |
| 3 | `design` | Explorer + Designer | L1, L2 |
| 4 | `implement` | Implementer | todos |
| 5 | `verify` | Reviewer | L1, L2 |
| 6 | `[MANUAL]` | — (gate humano) | todos |
| 7 | `commit` | Orchestrator | todos |
| 8 | `create-pr` | Orchestrator + Doc Updater | todos |

### Flujos por nivel

| Nivel | Tamaño | Fases activas |
|-------|--------|---------------|
| L0 | XS, S | 0 → 1 → 2 → 4 → 6 → 7 → 8 |
| L1 | M | 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 |
| L2 | L, XL | 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 (paralelo en 3 y 5) |

### Contadores invariantes

| Recurso | Cantidad | Lista |
|---------|----------|-------|
| Agentes (`workflow/agents/`) | 8 | harness-configurator, project-manager, orchestrator, explorer, designer, implementer, reviewer, doc-updater |
| Skills Claude Code (`.claude/skills/`) | 11 | init-harness, setup-project, start-issue, enrich-issue, design, implement, verify, commit, create-pr, new-issue, move-issue |

---

## Decisiones de diseño no obvias

| Decisión | Razón |
|----------|-------|
| `active-issue.md` lo genera `enrich-issue` (Fase 2), **no** `start-issue` | `start-issue` es infraestructura pura (branch, hook, feature_list). El spec nace cuando la issue está enriquecida. |
| Commit único en Fase 7, sin commits por task en Fase 4 | Una issue = un commit limpio en el historial. El pre-commit hook valida el changeset completo de una sola vez. |
| `enrich-issue` antes de `design` | Garantiza que los ACs estén completos antes de que el designer genere el spec. Evita iteraciones de corrección a mitad del diseño. |
| Fase 6 es siempre MANUAL (gate humano) | Ningún agente puede validar que el comportamiento real coincide con la intención original del usuario. |
| `git push` vive en Fase 7 (`commit`), no en Fase 8 (`create-pr`) | `create-pr` solo necesita que el branch esté en origin; separar push de PR creation da un checkpoint explícito antes de abrir la PR. |

---

## Archivos a tocar por tipo de cambio

### Agregar una nueva fase

1. `workflow/WORKFLOW-REFERENCE.md`
   - Bloque de visión general (diagrama de texto)
   - Tabla de niveles (`Fases activas`)
   - Nueva sección `## FASE N — nombre`
   - Tabla de skills al final
2. `AGENTS.md`
   - Flujo completo (diagrama de texto)
   - Tabla de comandos
   - Tabla de niveles (si aplica)
3. `workflow/agents/orchestrator.md`
   - Sección **Delegación por fase**
4. `.claude/skills/{nombre}/SKILL.md` + `prompt.txt` ← nuevo
5. `workflow/agents/harness-configurator.md`
   - Lista de skills en responsabilidad 5
   - Árbol de archivos `.claude/skills/`
   - Contador de skills en el reporte y validación

### Renombrar o renumerar fases existentes

Mismos archivos que "agregar fase", más:
- `.claude/agents/orchestrator.md` (frontmatter `description`)
- `.claude/agents/doc-updater.md` (si afecta Fase 8)
- `.claude/agents/implementer.md` (si afecta Fase 4)
- Cualquier `SKILL.md` cuyo campo `**Fase:**` necesite actualizarse

Truco: `grep -rn "Fase N"` sobre `.claude/` y `workflow/` para encontrar todas las menciones.

### Cambiar responsabilidades de un agente

1. `workflow/agents/{agente}.md` — definición canónica
2. `.claude/agents/{agente}.md` — frontmatter `description`
3. `workflow/WORKFLOW-REFERENCE.md` — sección de la fase afectada
4. `workflow/agents/orchestrator.md` — si el orchestrator delega a ese agente

### Agregar un nuevo agente

1. `workflow/agents/{nombre}.md` — definición canónica
2. `.claude/agents/{nombre}.md` — referencia nativa
3. `AGENTS.md` — tabla de roles
4. `workflow/agents/harness-configurator.md`
   - Lista de roles en responsabilidad 4
   - Árbol de `.claude/agents/`
   - Contador de roles en reporte y validación (`8 roles esperados` → N+1)
5. `workflow/agents/orchestrator.md` — si el orchestrator delega a él

---

## Protocolo de sesión de mantenimiento

1. Leer este archivo (`workflow/MAINTENANCE.md`).
2. Si el cambio es de fase o skill: leer `workflow/WORKFLOW-REFERENCE.md` sección afectada.
3. Si el cambio es de agente: leer `workflow/agents/{agente}.md`.
4. Hacer los cambios siguiendo la tabla "Archivos a tocar".
5. Verificar con `grep -rn "Fase N"` que no quedaron referencias a la numeración vieja.
6. Actualizar los contadores en `harness-configurator.md` si corresponde.
7. Actualizar este archivo si el cambio altera fases, contadores o decisiones de diseño.
8. Commit con tipo `docs(workflow)` o `feat(workflow)` según corresponda.
