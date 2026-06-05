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
| `workflow/agents/` | Definición de cada rol: orchestrator, explorer, designer, implementer, reviewer. |
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
# 1. Crear repo nuevo desde este template en GitHub, luego clonarlo:
git clone git@github.com:<tu-org>/<tu-repo>.git
cd <tu-repo>

# 2. Verificar e inicializar el entorno:
./init.sh

# 3. Reemplazar placeholders del template:
#    - AGENTS.md         → [PROJECT_NAME], [GITHUB_ORG]/[GITHUB_REPO], [PROJECT_BOARD_URL]
#    - feature_list.json → project, description
#    Luego ejecutar /setup-project para completar docs/ mediante entrevista guiada
```

A partir de aquí, abre el harness de tu elección (Claude Code, Cursor, etc.).
El agente cargará `AGENTS.md` y `workflow/agents/*.md` y operará bajo los roles
definidos. Tu primer comando suele ser `new-issue` (o el equivalente que tu
harness mapee al orchestrator).

---

## Roles de un vistazo

```
Usuario ──▶ Orchestrator ──▶ Explorer ──▶ Designer ──▶ Implementer ──▶ Reviewer
                  ▲                                                       │
                  └───── checkpoint.md verde + reporte ───────────────────┘
```

Detalle en `workflow/agents/`:

- **[Orchestrator](workflow/agents/orchestrator.md)** — líder, único canal con el usuario.
- **[Explorer](workflow/agents/explorer.md)** — análisis read-only del codebase.
- **[Designer](workflow/agents/designer.md)** — produce el spec (contrato).
- **[Implementer](workflow/agents/implementer.md)** — ejecuta el spec, una task por commit.
- **[Reviewer](workflow/agents/reviewer.md)** — verifica todo, dueño de `workflow/docs/checkpoint.md`.

---

## Niveles de flujo

| Nivel | Tamaño | Flujo |
|---|---|---|
| **L0** | XS, S | new-issue → start-issue → implement → review → create-pr |
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
