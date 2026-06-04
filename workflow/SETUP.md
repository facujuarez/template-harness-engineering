# Harness Engineering Workflow — Setup

Guía de instalación completa del workflow AI-first **provider-agnostic** con
agentes definidos en `workflow/agents/` + OpenSpec + GitHub.
Incluye sistema de niveles, subagents, pre-commit hook y memoria persistente.

---

## Estructura completa

```
AGENTS.md                       → contrato raíz multi-provider (auto-cargado por el harness)
init.sh                         → verifica entorno e inicializa permisos
feature_list.json               → estado sincronizado de features/issues

docs/                           → ⚠️ DOCUMENTOS DE PROYECTO (completar con /setup-project)
├── functional.md               → visión, RF, RNF, entidades, casos de uso
├── architecture.md             → stack, diseño técnico, comandos build/test/lint
├── data-model.md               → modelo de datos, índices, cache
└── project-plan.md             → fases, tareas, milestones

workflow/
├── agents/
│   ├── project-manager.md      → Fase 0: entrevista docs/ + generación de backlog
│   ├── orchestrator.md         → rol líder: detecta nivel, delega, gestiona gates
│   ├── explorer.md             → rol read-only: análisis estático del codebase
│   ├── designer.md             → rol que genera el spec (test-plan en Gherkin)
│   ├── implementer.md          → rol que ejecuta tasks del spec
│   └── reviewer.md             → rol verificador: ACs + Mutation Testing + checkpoint
├── docs/
│   ├── checkpoint.md           → checklist de cierre de sesión (dueño: reviewer)
│   ├── product-context.md      → fallback de contexto si docs/ aún no está listo
│   ├── tech-stack.md           → fallback de stack si docs/ aún no está listo
│   ├── workflow-conventions.md → branches, commits, PRs
│   ├── workflow-levels.md      → sistema de niveles L0/L1/L2
│   ├── definition-of-ready.md  → criterios para Ready (incluye Milestone)
│   ├── issue-template.md       → template canónico de Issues
│   └── dev-review-checklist.md → checklist Fase 5
├── scripts/
│   └── pre-commit-check.sh     → hook de build + lint
└── specs/
    ├── project-memory.md       → memoria persistente cross-issues
    ├── active-issue.md         → issue activa en sesión (generado)
    └── checkpoint-<N>.md       → historial de checkpoints cerrados por issue
```

### Capa provider-specific (opcional)

Si el harness soporta una capa nativa, se crea como **adapter** que mapea 1:1
contra `workflow/agents/*.md`. Ejemplo para Claude Code:

```
.claude/
├── agents/
│   ├── project-manager.md → wrapper apuntando a workflow/agents/project-manager.md
│   ├── orchestrator.md    → idem
│   ├── explorer.md        → idem
│   ├── designer.md        → idem
│   ├── implementer.md     → idem
│   └── reviewer.md        → idem
└── skills/
    ├── setup-project/SKILL.md  → /setup-project  Fase 0
    ├── start-issue/SKILL.md    → /start-issue    Fase 1
    ├── design/SKILL.md         → /design         Fase 2
    ├── implement/SKILL.md      → /implement      Fase 3
    ├── verify/SKILL.md         → /verify         Fase 4
    ├── create-pr/SKILL.md      → /create-pr      Fase 6
    ├── new-issue/SKILL.md      → /new-issue      utilidad
    └── move-issue/SKILL.md     → /move-issue     utilidad
```

En caso de conflicto, **`AGENTS.md` + `workflow/agents/` prevalecen**.

---

## Paso 1 — Crear repo desde el template

En GitHub: **Use this template → Create a new repository**. Luego cloná y entrá
al directorio.

```bash
git clone git@github.com:<tu-org>/<tu-repo>.git
cd <tu-repo>
```

---

## Paso 2 — Ejecutar init.sh

```bash
./init.sh
```

Verifica:
- Prerrequisitos (`git`, `gh`, `bash`, `jq`; opcionales: `node`, `dotnet`, `python3`)
- Estructura canónica del harness
- Validez de `feature_list.json`
- Permisos de scripts (`chmod +x` automático)
- Estado del `workflow/docs/checkpoint.md`

Si reporta errores, resolvelos y volvé a correrlo (es idempotente).

---

## Paso 3 — Completar AGENTS.md

Reemplazá los placeholders:
- `[PROJECT_NAME]` → nombre de tu proyecto
- `[GITHUB_ORG]` → tu organización/usuario de GitHub
- `[GITHUB_REPO]` → nombre del repositorio
- `[PROJECT_BOARD_URL]` → URL del GitHub Project Board

---

## Paso 4 — Completar feature_list.json

Reemplazá `project` y `description` con los datos reales. Borrá la feature de
ejemplo; el backlog real lo genera `/setup-project` en el Paso 5.

---

## Paso 5 — Ejecutar /setup-project (Fase 0)

**El paso más importante.** Invoca al agente `project-manager` para completar
los documentos de `docs/` y generar el backlog inicial en GitHub.

```
/setup-project              → flujo completo (entrevista de docs + backlog)
/setup-project docs         → solo entrevista (sin crear backlog aún)
/setup-project backlog      → solo backlog (si docs/ ya están completos)
```

El agente conduce una entrevista estructurada por cada documento:

1. `docs/functional.md` — visión del producto, usuarios, RF, RNF, casos de uso
2. `docs/architecture.md` — stack tecnológico, diseño, comandos de build/test/lint
3. `docs/data-model.md` — entidades, índices, estrategia de cache
4. `docs/project-plan.md` — fases, tareas y criterios de éxito

Una vez aprobados los documentos, genera en GitHub:
- **Milestones** — una por fase de `docs/project-plan.md`
- **Issues** — una por tarea, asignada a su Milestone

> Si preferís completar los documentos manualmente antes de correr el workflow,
> podés editar los archivos en `docs/` y luego ejecutar `/setup-project backlog`
> para solo generar el backlog.

---

## Paso 6 — Instalar el pre-commit hook

```bash
cp workflow/scripts/pre-commit-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Alternativa: el orchestrator lo instala automáticamente al ejecutar
`start-issue [N]` por primera vez en el repo.

---

## Paso 7 — Configurar GitHub CLI

```bash
gh auth login
```

El orchestrator usa `gh` para todas las operaciones contra GitHub: crear
issues, mover en el Project Board, abrir PRs.

Permisos necesarios del token:
- `repo` — leer y escribir en repos
- `project` — leer y escribir en GitHub Projects

### Capa provider-specific (Claude Code)

Si usás Claude Code y querés el GitHub MCP nativo:

```bash
claude mcp add github \
  --transport stdio \
  -- npx -y @modelcontextprotocol/server-github
```

```bash
export GITHUB_TOKEN=ghp_tu_token_aquí
```

---

## Paso 8 — Configurar GitHub Project Board

1. Tu repo → **Projects** → **New Project** → **Board**
2. Configurá el campo **Status** con estas columnas:
   - `📋 Backlog` / `✅ Ready` / `🔧 In Progress` / `👀 In Review` / `✔️ Done`
3. Copiá la URL al `AGENTS.md`.

> Las Milestones las crea `/setup-project` automáticamente. No hace falta
> crearlas a mano.

---

## Paso 9 — Configurar labels en el repo

```
type:feature  #0075ca    type:bug      #d73a4a
type:chore    #e4e669    type:spike    #cc317c
size:XS       #f9d0c4    size:S        #f9d0c4
size:M        #bfd4f2    size:L        #d4c5f9
size:XL       #e11d48
```

---

## Paso 10 — Verificar instalación

Abrí tu harness en el directorio. El agente debería cargar `AGENTS.md`
automáticamente y reconocer los roles en `workflow/agents/`. Si ejecutaste
`/setup-project`, verificá que las Issues y Milestones aparecen en GitHub
y en el Project Board (columna Backlog).

---

## Flujo de uso rápido

Los nombres de comandos abajo son **convención**; cada harness los expone
como mejor encaje (slash commands, aliases, tasks).

```bash
# ── FASE 0: Setup del proyecto (una sola vez) ─────────────────────────
setup-project   # completa docs/ + Milestones + Issues en GitHub

# ── Por cada issue del backlog ─────────────────────────────────────────

# Fase 1 — Inicializar (detecta nivel automáticamente)
start-issue 42

# L0 (XS/S): saltar directamente a
implement

# L1/L2 (M, L, XL):
design          # genera spec con test-plan en Gherkin
implement       # implementa task por task
verify          # ACs + build + tests + Mutation Testing + checkpoint

# Fase 5 — Manual: revisar en entorno local

# Fase 6
create-pr       # genera PR + actualiza project-memory

# ── Utilidades ─────────────────────────────────────────────────────────
new-issue quiero que los usuarios puedan filtrar por fecha   # issue ad-hoc
move-issue 42 Ready
move-issue 42 Done
```

---

## .gitignore

```gitignore
# Sesión activa (no committear)
workflow/specs/active-issue.md

# Secretos locales
.env.local
.env.*.local
```

Archivos que **SÍ** se committean:
- `docs/` — documentos de proyecto completados
- `workflow/specs/project-memory.md` — memoria del proyecto
- `workflow/specs/issue-N/` — spec y reporte de cada issue (documentación + trazabilidad)
- `workflow/specs/checkpoint-N.md` — histórico inmutable de checkpoints
- `feature_list.json` — estado sincronizado
