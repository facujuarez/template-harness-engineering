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

1. `docs/functional.md` — contexto del producto, usuarios y requerimientos
2. `docs/architecture.md` — stack tecnológico, comandos de build/test/lint
3. `docs/project-plan.md` — fases y contexto de ejecución *(si existe)*
4. `feature_list.json` (estado actual de features/issues)

---

## Roles de agentes

Cada rol vive como un archivo en `workflow/agents/`. Un harness puede mapearlos
a subagents nativos (`.claude/agents/`, `.cursor/agents/`, etc.) o ejecutarlos
secuencialmente en una sola sesión. La definición canónica es la de
`workflow/agents/`.

| Rol | Archivo | Responsabilidad |
|-----|---------|-----------------|
| **Harness Configurator** | [workflow/agents/harness-configurator.md](workflow/agents/harness-configurator.md) | Init. Configura capa provider-specific (`.claude/`, `.cursor/`, etc.) mapeando 1:1 a `workflow/agents/`. |
| **Project Manager** | [workflow/agents/project-manager.md](workflow/agents/project-manager.md) | Setup. Entrevista y completa `docs/`. Genera README.md y backlog en GitHub. |
| **Orchestrator** | [workflow/agents/orchestrator.md](workflow/agents/orchestrator.md) | Líder. Detecta nivel, delega, aplica gates, único canal hacia el usuario. |
| **Explorer** | [workflow/agents/explorer.md](workflow/agents/explorer.md) | Análisis read-only del codebase. Insumo del Designer. |
| **Designer** | [workflow/agents/designer.md](workflow/agents/designer.md) | Genera el spec (design + tasks + test-plan en Gherkin). |
| **Implementer** | [workflow/agents/implementer.md](workflow/agents/implementer.md) | Ejecuta tasks del spec, una a una. Respeta pre-commit. |
| **Reviewer** | [workflow/agents/reviewer.md](workflow/agents/reviewer.md) | Verifica ACs, build, tests y robustez por Mutation Testing. Dueño de `workflow/docs/checkpoint.md`. |
| **Doc Updater** | [workflow/agents/doc-updater.md](workflow/agents/doc-updater.md) | Fase 7. Detecta cambios en arquitectura, modelo de datos y requerimientos, y propone actualizaciones a `docs/`. |

---

## Sistema de niveles

El flujo se adapta al tamaño de la issue. El **Orchestrator** detecta el nivel
y activa solo las fases necesarias.

| Nivel | Tamaño | Flujo activo |
|-------|--------|--------------|
| **L0** | XS, S | `new-issue → start-issue → enrich-issue → implement → review → create-pr` |
| **L1** | M | Flujo completo secuencial |
| **L2** | L, XL | Flujo completo + agentes en paralelo en design y verify |

Detalle: `workflow/docs/workflow-levels.md`.

---

## Flujo completo

### Fase 0 — Setup completo del proyecto (una sola vez)

```
Fase 0 - INIT  init-harness [harness] → Harness Configurator:
│                                  1. Detecta el harness elegido (Claude Code, Cursor, Copilot, etc.)
│                                  2. Genera carpeta provider-specific (.claude/, .cursor/, etc.)
│                                     mapeando 1:1 a workflow/agents/*
│
Fase 0 - SETUP  setup-project          → Project Manager:
│                                  1. Completa docs/ + genera README.md (proyecto-específico)
│                                  2. Genera backlog en GitHub (Milestones + Issues)
│
└──────► Entregables: harness configurado + docs alineados + backlog en GitHub
```

### Ciclo por issue (L1 / L2, se repite por cada issue)

```
FASE 1  start-issue    → Orchestrator detecta nivel, crea branch, actualiza feature_list
FASE 2  enrich-issue   → Orchestrator refina issue: ACs, out-of-scope, edge cases, detalles técnicos
FASE 3  design         → Explorer + Designer producen el spec (test-plan en Gherkin)
FASE 4  implement      → Implementer ejecuta task por task + pre-commit hook
FASE 5  verify         → Reviewer: ACs + build + tests + Mutation Testing + checkpoint
FASE 6  [MANUAL]       → Dev review en entorno local (gate humano)
FASE 7  create-pr      → Doc Updater sincroniza docs/ → Orchestrator genera PR desde spec + reporte
```

---

## Comandos del workflow

Los nombres de comandos son convención; cada harness los expone como mejor
encaje (slash commands, aliases, tasks, etc.). Lo importante es el **rol que
los ejecuta** y la **fase que cubren**.

| Comando | Rol responsable | Fase | Niveles |
|---------|-----------------|------|---------|
| `init-harness [harness]` | Harness Configurator | 0 - INIT | — (una vez) |
| `setup-project` | Project Manager | 0 - SETUP | — (una vez) |
| `start-issue [N]` | Orchestrator | 1 | Todos |
| `enrich-issue` | Orchestrator | 2 | Todos |
| `design` | Explorer + Designer | 3 | L1, L2 |
| `implement` | Implementer | 4 | Todos |
| `verify` | Reviewer | 5 | L1, L2 |
| `create-pr` | Orchestrator | 7 | Todos |
| `new-issue [descripción]` | Orchestrator | utilidad | Todos |
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
| `docs/functional.md` | Visión del producto, RF, RNF, entidades, CU. **Fuente primaria.** |
| `docs/architecture.md` | Stack, diseño técnico, comandos build/test/lint. **Fuente primaria.** |
| `docs/data-model.md` | Modelo de datos, entidades, índices, cache. |
| `docs/project-plan.md` | Fases, tareas, milestones del proyecto. |
| `workflow/docs/checkpoint.md` | Template de checklist de cierre de sesión (Reviewer). |
| `feature_list.json` | Estado sincronizado de features/issues. |
| `init.sh` | Verificación e inicialización del entorno. |
| `workflow/docs/workflow-conventions.md` | Branches, commits, PRs. |
| `workflow/docs/definition-of-ready.md` | Criterios para estado Ready (incluye Milestone). |
| `workflow/docs/issue-template.md` | Template canónico de Issues. |
| `workflow/docs/dev-review-checklist.md` | Checklist Fase 5 (manual). |
| `workflow/docs/workflow-levels.md` | Referencia del sistema de niveles. |
| `workflow/specs/active-issue.md` | Issue y nivel activos en sesión. |
| `workflow/specs/project-memory.md` | Memoria persistente cross-issues. |
| `workflow/specs/checkpoint-<N>.md` | Copia por issue del checkpoint cerrado. |
| `workflow/specs/issue-{N}/doc-update-report.md` | Cambios aplicados a `docs/` al cerrar la issue. |

---

## Reglas generales

1. **Nunca crear Issues, branches ni PRs sin aprobación explícita del usuario.**
2. **El spec aprobado en Fase 3 es el contrato.** Nada fuera de él.
3. **Un task a la vez en L0/L1.** En L2 los agentes pueden paralelizar tareas
   independientes en Fase 3 (exploración por área) y Fase 5 (verificación por área).
4. **Los gates manuales son intencionales.** No se saltan.
5. **Si hay ambigüedad, preguntar.** No asumir ni inventar.
6. **Actualizar `feature_list.json`, `workflow/specs/project-memory.md` y `docs/`** al
   cerrar cada issue. El Doc Updater propone los cambios a `docs/`; el Orchestrator
   obtiene aprobación explícita antes de escribir.
7. **El Reviewer bloquea el cierre de sesión** si `workflow/docs/checkpoint.md`
   tiene boxes en `[ ]`.

---

## Capa provider-specific (opcional)

Si el harness en uso soporta skills/subagents nativos (ej. Claude Code con
`.claude/skills/` y `.claude/agents/`, Cursor con `.cursor/rules/`, etc.),
crear esa capa **mapeando 1:1 contra `workflow/agents/*.md`**. La capa nativa
es un *adapter*, no una fuente de verdad. Si hay conflicto, `AGENTS.md` y
`workflow/agents/*.md` prevalecen.
