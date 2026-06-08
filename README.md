# template-harness-engineering

Template **provider-agnostic** para repositorios que adoptan los principios de
**Harness Engineering**: agentes de IA con roles definidos, gates manuales en
puntos clave, estado sincronizado en disco y un flujo predecible de
issue → diseño → implementación → review → PR.

Diseñado para usarse como punto de partida ("Use this template" en GitHub) en
proyectos donde el desarrollo está asistido por agentes de IA, sea cual sea el
harness en uso (Claude Code, Cursor, Aider, Continue, OpenHands, Codex, etc.).

---

## Qué hay aquí

| Archivo / carpeta | Para qué sirve |
|---|---|
| `AGENTS.md` | Contrato raíz multi-provider. Lo leen todos los agentes al iniciar. |
| `feature_list.json` | Estado sincronizado de features/issues. |
| `workflow/agents/` | Definición de cada rol: project-manager, orchestrator, explorer, designer, implementer, reviewer, doc-updater. |
| `workflow/docs/checkpoint.md` | Checklist de cierre de sesión. Lo recorre el reviewer. Bloquea cierre con boxes vacíos. |
| `workflow/docs/` | Contexto del proyecto: producto, stack, convenciones, niveles, templates. |
| `workflow/specs/` | Specs activos por issue + memoria persistente cross-issues. |
| `init.sh` | Verifica entorno e inicializa el repo. |
| `workflow/scripts/pre-commit-check.sh` | Hook de build + lint antes de cada commit. |
| `workflow/SETUP.md` | Guía de instalación completa. |
| `workflow/WORKFLOW-REFERENCE.md` | Referencia detallada del flujo. |

---

## Quickstart

```bash
git clone git@github.com:<tu-org>/<tu-repo>.git && cd <tu-repo>
./init.sh
# Reemplazar en AGENTS.md: [PROJECT_NAME], [GITHUB_ORG]/[GITHUB_REPO], [PROJECT_BOARD_URL]
# Reemplazar en feature_list.json: project, description
# Luego ejecutar /setup-project
```

Abre el harness de tu elección. El agente cargará `AGENTS.md` y operará bajo
los roles definidos. Tu primer comando es `/setup-project`: conduce la
entrevista guiada, genera `docs/`, crea el `README.md` del proyecto y publica
el backlog en GitHub (Milestones + Issues).

---

## Roles de un vistazo

```
── FASE 0 ──────────────────────────────────────────────────────────────────
Project Manager → entrevista docs/ → genera README.md → backlog en GitHub

── CICLO POR ISSUE ─────────────────────────────────────────────────────────
Usuario ──▶ Orchestrator ──▶ Explorer ──▶ Designer ──▶ Implementer ──▶ Reviewer
                ▲                                                          │
                └────── checkpoint verde + reporte ───────────────────────┘
                                    │
                          Doc Updater → docs/ + README.md actualizados → PR
```

Detalle en `workflow/agents/`:

| Rol | Archivo | Fase |
|-----|---------|------|
| **[Project Manager](workflow/agents/project-manager.md)** | Entrevista `docs/`, genera `README.md` y backlog en GitHub. | 0 |
| **[Orchestrator](workflow/agents/orchestrator.md)** | Líder, único canal con el usuario. Detecta nivel, aplica gates. | 1–6 |
| **[Explorer](workflow/agents/explorer.md)** | Análisis read-only del codebase. Insumo del Designer. | 2 |
| **[Designer](workflow/agents/designer.md)** | Produce el spec: design + tasks + test-plan en Gherkin. | 2 |
| **[Implementer](workflow/agents/implementer.md)** | Ejecuta el spec, una task por commit. | 3 |
| **[Reviewer](workflow/agents/reviewer.md)** | Verifica ACs, build, tests y Mutation Testing. Dueño de `checkpoint.md`. | 4 |
| **[Doc Updater](workflow/agents/doc-updater.md)** | Detecta cambios de la issue y propone actualizaciones a `docs/` y `README.md`. | 6 |

---

## Niveles de flujo

| Nivel | Tamaño | Flujo |
|---|---|---|
| **L0** | XS, S | new-issue → start-issue → implement → create-pr |
| **L1** | M | Flujo completo secuencial |
| **L2** | L, XL | Flujo completo + agentes en paralelo en design y review |

Ver `workflow/docs/workflow-levels.md`.

---

## Adaptación a tu harness

`AGENTS.md` + `workflow/agents/` es la **fuente de verdad**. Si tu harness
soporta una capa nativa (slash commands, subagents, rules), créala como
**adapter** mapeando 1:1 contra `workflow/agents/*.md`. Ejemplo para Claude Code:

```
.claude/
  ├── agents/
  │   ├── orchestrator.md   → wrapper que apunta a workflow/agents/orchestrator.md
  │   ├── designer.md       → idem
  │   └── ...
  └── skills/
      ├── new-issue/SKILL.md
      ├── start-issue/SKILL.md
      └── ...
```

En caso de conflicto, **`AGENTS.md` y `workflow/agents/` prevalecen** sobre la
capa provider-specific.
