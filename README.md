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
| `workflow/docs/harness-adapters.md` | Referencia de configuración por harness (Claude Code, Cursor, Copilot, etc.). Lo usa el Harness Configurator en Fase 0 - INIT. |
| `workflow/docs/checkpoint.md` | Checklist de cierre de sesión. Lo recorre el reviewer. Bloquea cierre con boxes vacíos. |
| `workflow/docs/` | Contexto del proyecto: producto, stack, convenciones, niveles, templates. |
| `workflow/specs/` | Specs activos por issue + memoria persistente cross-issues. |
| `init.sh` | Verifica entorno e inicializa el repo. |
| `workflow/scripts/pre-commit-check.sh` | Hook de build + lint antes de cada commit. |
| `workflow/SETUP.md` | Guía del paso `/init-harness` (Fase 0 - INIT): qué genera cada harness, troubleshooting. |
| `workflow/WORKFLOW-REFERENCE.md` | Referencia detallada del flujo. |

---

## Quickstart

### 1. Crear el repo desde la plantilla

En GitHub: **Use this template → Create a new repository**. Luego clona y entra al directorio.

```bash
git clone git@github.com:<tu-org>/<tu-repo>.git && cd <tu-repo>
```

### 2. Verificar el entorno

```bash
./init.sh
```

Verifica prerrequisitos (`git`, `gh`, `bash`, `jq`), estructura del repo y validez de `feature_list.json`. Es idempotente — resolvé los errores marcados y volvé a correrlo.

### 3. Completar el contrato del proyecto

- Editá `AGENTS.md`: reemplazá `[PROJECT_NAME]`, `[GITHUB_ORG]`, `[GITHUB_REPO]`, `[PROJECT_BOARD_URL]`.
- Editá `feature_list.json`: reemplazá `project` y `description`, eliminá la feature de ejemplo.

### 4. (Recomendado) GitHub CLI + Project Board

```bash
gh auth login   # permisos: repo + project
```

Creá un GitHub Project Board (columnas: Backlog / Ready / In Progress / In Review / Done) y los labels `type:feature`, `type:bug`, `type:chore`, `type:spike`, `size:XS/S/M/L/XL`. Copiá la URL del board a `AGENTS.md`.

### 5. Configurar el harness — `/init-harness`

Abrí el harness que vas a usar (Claude Code, Cursor, Copilot, etc.) en este directorio — lee `AGENTS.md` automáticamente. Ejecutá:

```
/init-harness claude-code   # o cursor, copilot, aider, continue, etc.
```

Esto genera la capa provider-specific (`.claude/`, `.cursor/`, etc.) mapeando 1:1 los roles de `workflow/agents/`. Detalle completo, troubleshooting y qué se genera por harness: **[`workflow/SETUP.md`](workflow/SETUP.md)**.

### 6. Configurar el proyecto — `/setup-project`

```
/setup-project
```

El Project Manager te entrevista para completar `docs/`, genera el `README.md` definitivo del proyecto (reemplaza este) y crea el backlog inicial en GitHub (Milestones + Issues). Detalle completo: **[`workflow/WORKFLOW-REFERENCE.md`](workflow/WORKFLOW-REFERENCE.md#fase-0--setup-completo-del-proyecto)**.

### 7. Listo

Tu proyecto está configurado para el ciclo por issue (`/start-issue`, `/design`, `/implement`, `/verify`, `/create-pr`). El pre-commit hook (build + lint) se instala automáticamente en el primer `/start-issue`. Ver el flujo completo en [`workflow/WORKFLOW-REFERENCE.md`](workflow/WORKFLOW-REFERENCE.md).

---

## Roles de un vistazo

```
── INIT ────────────────────────────────────────────────────────────────────
Usuario ──▶ Lee SETUP.md ──▶ /init-harness [harness] ──▶ Harness Configurator
                                                          genera .claude/, etc.

── SETUP ───────────────────────────────────────────────────────────────────
/setup-project ──▶ Project Manager ──▶ entrevista docs/ + README.md
                                               ▼
                                      backlog en GitHub

── CICLO POR ISSUE ─────────────────────────────────────────────────────────
Usuario ──▶ Orchestrator ──▶ Explorer ──▶ Designer ──▶ Implementer ──▶ Reviewer
                ▲                                                         │
                └────── checkpoint verde + reporte ───────────────────────┘
                                    │
                          Doc Updater → docs/ + README.md actualizados → PR
```

Detalle en `workflow/agents/`:

| Rol | Archivo | Fase |
|-----|---------|------|
| **[Harness Configurator](workflow/agents/harness-configurator.md)** | Configura capa provider-specific (`.claude/`, `.cursor/`, etc.). | 0 - INIT |
| **[Project Manager](workflow/agents/project-manager.md)** | Entrevista `docs/`, genera `README.md` y backlog en GitHub. | 0 - SETUP |
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

## Adaptación a tu harness (Init)

`AGENTS.md` + `workflow/agents/` es la **fuente de verdad**. El **Harness Configurator** genera la capa
provider-specific automáticamente en **Init** (`/init-harness`), creando:

- **Claude Code:** `.claude/agents/` + `.claude/skills/` (mapeos 1:1 a workflow/)
- **Cursor:** `.cursor/rules/` (reglas nativas)
- **GitHub Copilot:** `.copilot/rules/` (reglas consolidadas)
- **Otros:** adaptar según capacidades del harness

Ver [`workflow/SETUP.md`](workflow/SETUP.md) para la guía paso a paso y `workflow/docs/harness-adapters.md` para la referencia técnica completa.

En caso de conflicto, **`AGENTS.md` y `workflow/agents/` prevalecen** sobre la
capa provider-specific. Los adaptadores son **referenciales**, no fuentes de verdad.
