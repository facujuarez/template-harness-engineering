# [PROJECT_NAME] — Harness Engineering Workflow

> Contrato **provider-agnostic** para agentes de IA que operan en este repositorio.
> Reemplaza convenciones específicas de un proveedor (ej. `CLAUDE.md`). Cualquier
> harness compatible con el estándar `AGENTS.md` (Claude Code, Cursor, Aider,
> Continue, OpenHands, Codex, etc.) debe leer este archivo como fuente de verdad.

---

## Proyecto

- **Nombre:** [PROJECT_NAME]
- **Repositorio:** [GITHUB_ORG]/[GITHUB_REPO]
- **GitHub Project Board:** [PROJECT_BOARD_URL]
- **Branch principal:** `main`
- **Branch de desarrollo:** `develop`

Antes de cualquier acción, el agente activo debe leer:

1. `workflow/docs/product-context.md`
2. `workflow/docs/tech-stack.md`
3. `feature_list.json` (estado actual de features/issues)

---

## Roles de agentes

Cada rol vive como un archivo en `workflow/agents/`. Un harness puede mapearlos
a subagents nativos (`.claude/agents/`, `.cursor/agents/`, etc.) o ejecutarlos
secuencialmente en una sola sesión. La definición canónica es la de
`workflow/agents/`.

| Rol | Archivo | Responsabilidad |
|-----|---------|-----------------|
| **Orchestrator** | [workflow/agents/orchestrator.md](workflow/agents/orchestrator.md) | Líder. Detecta nivel, delega, aplica gates, único canal hacia el usuario. |
| **Explorer** | [workflow/agents/explorer.md](workflow/agents/explorer.md) | Análisis read-only del codebase. Insumo del Designer. |
| **Designer** | [workflow/agents/designer.md](workflow/agents/designer.md) | Genera el spec (design + tasks + test-plan). |
| **Implementer** | [workflow/agents/implementer.md](workflow/agents/implementer.md) | Ejecuta tasks del spec, una a una. Respeta pre-commit. |
| **Reviewer** | [workflow/agents/reviewer.md](workflow/agents/reviewer.md) | Verifica ACs, build, tests. Dueño de `workflow/docs/checkpoint.md`. Bloquea cierre si quedan boxes vacíos. |

---

## Sistema de niveles

El flujo se adapta al tamaño de la issue. El **Orchestrator** detecta el nivel
y activa solo las fases necesarias.

| Nivel | Tamaño | Flujo activo |
|-------|--------|--------------|
| **L0** | XS, S | `new-issue → start-issue → implement → review → create-pr` |
| **L1** | M | Flujo completo secuencial |
| **L2** | L, XL | Flujo completo + agentes en paralelo en design y review |

Detalle: `workflow/docs/workflow-levels.md`.

---

## Flujo completo (L1 / L2)

```
FASE 0  new-issue      → Orchestrator captura y refina requisito → Issue en GitHub
FASE 1  start-issue    → Orchestrator detecta nivel, crea branch, genera contexto
FASE 2  design         → Explorer + Designer producen el spec
FASE 3  implement      → Implementer ejecuta task por task + pre-commit hook
FASE 4  verify         → Reviewer cubre ACs + build + tests + workflow/docs/checkpoint.md
FASE 5  [MANUAL]       → Dev review en entorno local (gate humano)
FASE 6  create-pr      → Orchestrator genera PR desde spec + reporte
```

---

## Comandos del workflow

Los nombres de comandos son convención; cada harness los expone como mejor
encaje (slash commands, aliases, tasks, etc.). Lo importante es el **rol que
los ejecuta** y la **fase que cubren**.

| Comando | Rol responsable | Fase | Niveles |
|---------|-----------------|------|---------|
| `new-issue [descripción]` | Orchestrator | 0 | Todos |
| `start-issue [N]` | Orchestrator | 1 | Todos |
| `design` | Explorer + Designer | 2 | L1, L2 |
| `implement` | Implementer | 3 | Todos |
| `verify` | Reviewer | 4 | L1, L2 |
| `create-pr` | Orchestrator | 6 | Todos |
| `move-issue [N] [estado]` | Orchestrator | utilidad | Todos |

---

## Hooks activos

- **pre-commit:** ejecuta build + lint antes de cada `git commit` durante la
  implementación. Si falla, el commit se cancela.
  Script: `workflow/scripts/pre-commit-check.sh`

---

## Memoria persistente del proyecto

- `workflow/specs/project-memory.md` acumula patrones, decisiones y aprendizajes
  cross-issues. Los agentes lo leen al iniciar y lo actualizan al cerrar issue.
- `feature_list.json` es el estado **sincronizado** de features/issues. El
  Orchestrator lo lee al inicio de cada fase; el Implementer y el Reviewer lo
  actualizan al cambiar de estado.

Ambos se commitean junto con los specs.

---

## Archivos de contexto

| Archivo | Qué contiene |
|---------|-------------|
| `AGENTS.md` | Este archivo. Contrato del harness. |
| `workflow/agents/*.md` | Definición de cada rol. |
| `workflow/docs/checkpoint.md` | Template de checklist de cierre de sesión (Reviewer). |
| `feature_list.json` | Estado sincronizado de features/issues. |
| `init.sh` | Verificación e inicialización del entorno. |
| `workflow/docs/product-context.md` | Qué es el producto, usuarios, módulos. |
| `workflow/docs/tech-stack.md` | Stack, comandos de build/test/lint, estructura. |
| `workflow/docs/workflow-conventions.md` | Branches, commits, PRs. |
| `workflow/docs/definition-of-ready.md` | Criterios para estado Ready. |
| `workflow/docs/issue-template.md` | Template canónico de Issues. |
| `workflow/docs/dev-review-checklist.md` | Checklist Fase 5 (manual). |
| `workflow/docs/workflow-levels.md` | Referencia del sistema de niveles. |
| `workflow/specs/active-issue.md` | Issue y nivel activos en sesión. |
| `workflow/specs/project-memory.md` | Memoria persistente cross-issues. |
| `workflow/specs/checkpoint-<N>.md` | Copia por issue del checkpoint cerrado. |

---

## Reglas generales

1. **Nunca crear Issues, branches ni PRs sin aprobación explícita del usuario.**
2. **El spec aprobado en Fase 2 es el contrato.** Nada fuera de él.
3. **Un task a la vez en L0/L1.** En L2 los agentes pueden paralelizar tareas
   independientes en Fase 2 (exploración por área) y Fase 4 (verificación por área).
4. **Los gates manuales son intencionales.** No se saltan.
5. **Si hay ambigüedad, preguntar.** No asumir ni inventar.
6. **Actualizar `feature_list.json` y `workflow/specs/project-memory.md`** al
   cerrar cada issue.
7. **El Reviewer bloquea el cierre de sesión** si `workflow/docs/checkpoint.md`
   tiene boxes en `[ ]`.

---

## Capa provider-specific (opcional)

Si el harness en uso soporta skills/subagents nativos (ej. Claude Code con
`.claude/skills/` y `.claude/agents/`, Cursor con `.cursor/rules/`, etc.),
crear esa capa **mapeando 1:1 contra `workflow/agents/*.md`**. La capa nativa
es un *adapter*, no una fuente de verdad. Si hay conflicto, `AGENTS.md` y
`workflow/agents/*.md` prevalecen.
