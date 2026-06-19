# Harness Engineering Workflow — Setup

> **⚠️ Leé esto primero.** Guía paso a paso para configurar tu proyecto desde cero
> con el workflow AI-first **provider-agnostic**.

---

## Visión general del setup

El setup tiene **tres fases principales**:

```
1. HARNESS  [MANUAL]         → Abrís el harness (Claude Code, Cursor, etc.)
                             Leés este archivo (SETUP.md)
                             
2. INIT     /init-harness    → Configurador genera .claude/, .cursor/, etc.
                             Mapea roles de workflow/agents/ a la capa nativa
                             
3. SETUP    /setup-project   → Project Manager completa docs/ + backlog en GitHub
```

Una vez completada la Fase 0, tu proyecto está 100% listo para el ciclo por issue.

---

## Flujo rápido (5 minutos)

Si ya tenés experiencia con este workflow:

```bash
1. git clone ... && cd <repo>
2. ./init.sh
3. Abrí tu harness → ejecutá /init-harness [claude-code|cursor|copilot|aider]
4. Una vez configurado, ejecutá /setup-project
5. Respondé la entrevista guiada → backlog en GitHub listo
```

---

## Flujo completo paso a paso

### Paso 1 — Crear repo desde el template

En GitHub: **Use this template → Create a new repository**. Luego clona y entra
al directorio.

```bash
git clone git@github.com:<tu-org>/<tu-repo>.git
cd <tu-repo>
```

---

### Paso 2 — Ejecutar init.sh (Configuración del entorno)

```bash
./init.sh
```

Este script verifica:
- ✓ Prerrequisitos (`git`, `gh`, `bash`, `jq`)
- ✓ Estructura del repo (directorios y archivos canónicos)
- ✓ Permisos de scripts
- ✓ Validez de `feature_list.json`

Si reporta errores, resolvelos y volvé a correr (es **idempotente**).

---

### Paso 3 — Completar AGENTS.md

Reemplazá los placeholders en `AGENTS.md`:

```
[PROJECT_NAME]     → Nombre de tu proyecto
[GITHUB_ORG]       → Tu organización/usuario de GitHub
[GITHUB_REPO]      → Nombre del repositorio
[PROJECT_BOARD_URL] → URL del GitHub Project Board
```

Ejemplo:
```markdown
- **Nombre:** Mi Aplicación Web
- **Repositorio:** miorg/mi-app-web
- **GitHub Project Board:** https://github.com/miorg/mi-app-web/projects/1
```

---

### Paso 4 — Completar feature_list.json

Reemplazá `project` y `description`:

```json
{
  "project": "Mi Aplicación Web",
  "description": "Plataforma de e-commerce con panel de administración",
  "features": []
}
```

El backlog real lo genera `/setup-project` en el Paso 6.

---

### Paso 5 — Abrí tu harness y ejecutá /init-harness (FASE 0a)

**Este es el paso más importante de la configuración inicial.**

Abrí el harness que usarás (Claude Code, Cursor, GitHub Copilot, etc.) en este
directorio. El agente leerá `AGENTS.md` automáticamente.

Luego ejecutá:

```
/init-harness claude-code
```

(Reemplazá `claude-code` con tu harness: `cursor`, `copilot`, `aider`, `continue`, etc.)

**Qué hace /init-harness:**

1. Detecta el harness elegido.
2. Lee `workflow/docs/harness-adapters.md` para saber qué generar.
3. Genera la carpeta provider-specific:
   - **Claude Code:** `.claude/agents/` + `.claude/skills/`
   - **Cursor:** `.cursor/rules/`
   - **Copilot:** `.copilot/rules/`
   - **Otros:** adapta según capacidades del harness
4. Mapea 1:1 cada rol de `workflow/agents/*.md` a la capa nativa.
5. Valida que todo esté correcto.
6. Reporta: "✓ Harness configurado — podés usar /setup-project ahora"

---

### Paso 6 — Ejecutá /setup-project (FASE 0b)

Una vez que /init-harness terminó, ejecutá:

```
/setup-project
```

O con opciones específicas:

```
/setup-project docs      → solo entrevista de documentos
/setup-project backlog   → solo generación de backlog (si docs/ ya están completos)
/setup-project           → flujo completo (recomendado)
```

**Qué hace /setup-project:**

El agente `project-manager` comienza inspeccionando el estado de cada documento en `docs/`:

| Estado | Condición | Comportamiento del PM |
|--------|-----------|----------------------|
| `COMPLETO` | Sin `[COMPLETAR]`, contenido sustancial | Presenta resumen y pide confirmación. No entrevista. |
| `PARCIAL` | Mezcla de secciones completas y vacías | Retoma desde la primera sección incompleta. |
| `VACÍO` | Vacío o todo `[COMPLETAR]` | Conduce entrevista completa para ese documento. |

Si los 4 documentos ya existen y son válidos —caso típico al importar docs desde otro
proyecto— el PM los confirma con vos y avanza directamente al README y el backlog,
sin pasar por la entrevista.

Para documentos `PARCIAL` o `VACÍO`, conduce una entrevista estructurada:

1. **docs/functional.md** — ¿Qué es tu proyecto? Visión, usuarios, requerimientos.
2. **docs/architecture.md** — ¿Cómo se construye? Stack, diseño, comandos build/test.
3. **docs/data-model.md** — ¿Qué datos maneja? Entidades, índices, cache.
4. **docs/project-plan.md** — ¿Cuáles son las fases y tareas? Plazos y métricas.

Para cada sección incompleta:
- El PM hace máx. 4 preguntas por ronda (apertura amplia → cierre específico).
- Mostrará un preview de cada sección antes de escribir.
- Espera tu aprobación antes de guardar.

Una vez aprobados los 4 documentos y el `README.md`, crea en GitHub:
- **Milestones** — una por fase de `docs/project-plan.md`
- **Issues** — una por tarea, asignada a su Milestone
- **README.md** — resumen del proyecto (100% proyecto-específico, sin referencias a plantilla)

---

### Paso 7 — Instalar GitHub CLI y Project Board (opcional pero recomendado)

**GitHub CLI:**

```bash
gh auth login
```

Permisos necesarios del token:
- `repo` — leer y escribir en repos
- `project` — leer y escribir en GitHub Projects

**GitHub Project Board:**

1. Tu repo → **Projects** → **New Project** → **Board**
2. Configurá el campo **Status** con estas columnas:
   - `📋 Backlog` / `✅ Ready` / `🔧 In Progress` / `👀 In Review` / `✔️ Done`
3. Copiá la URL a `AGENTS.md` (en la sección `[PROJECT_BOARD_URL]`).

**Labels en el repo (opcional):**

```
type:feature  #0075ca    type:bug      #d73a4a
type:chore    #e4e669    type:spike    #cc317c
size:XS       #f9d0c4    size:S        #f9d0c4
size:M        #bfd4f2    size:L        #d4c5f9
size:XL       #e11d48
```

---

### Paso 8 — Pre-commit hook (se instala automáticamente)

El hook se instala la primera vez que ejecutas `start-issue [N]`.

Pero si lo querés instalar ahora:

```bash
cp workflow/scripts/pre-commit-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

El hook ejecuta `build + lint` antes de cada commit. Si falla, el commit se cancela.

---

## ¿Qué es cada carpeta?

```
AGENTS.md                   → Contrato raíz multi-provider (lee automáticamente el harness)
init.sh                     → Script de inicialización del entorno
feature_list.json           → Estado sincronizado de features/issues

docs/                       → ⚠️ DOCUMENTOS DE PROYECTO (completa con /setup-project)
├── functional.md           → Visión, RF, RNF, entidades, casos de uso
├── architecture.md         → Stack, diseño técnico, comandos build/test/lint
├── data-model.md           → Modelo de datos, índices, cache
└── project-plan.md         → Fases, tareas, milestones

README.md                   → Resumen del proyecto (generado por /setup-project)

workflow/                   → ⚠️ PILARES DEL FLUJO (no modificar)
├── agents/
│   ├── harness-configurator.md  → Init: configura el harness
│   ├── project-manager.md       → Setup: entrevista + docs + backlog
│   ├── orchestrator.md          → Líder: detecta nivel, delega, gates
│   ├── explorer.md              → Análisis read-only del codebase
│   ├── designer.md              → Genera el spec (test-plan en Gherkin)
│   ├── implementer.md           → Ejecuta tasks del spec
│   ├── reviewer.md              → Verifica ACs + Mutation Testing
│   └── doc-updater.md           → Sincroniza docs/ al cerrar issue
├── docs/
│   ├── harness-adapters.md      → Referencia: qué se genera por harness
│   ├── checkpoint.md            → Checklist de cierre de sesión (revisor)
│   ├── workflow-conventions.md  → Branches, commits, PRs
│   ├── workflow-levels.md       → Sistema de niveles L0/L1/L2
│   ├── definition-of-ready.md   → Criterios para Ready
│   ├── issue-template.md        → Template canónico de Issues
│   └── dev-review-checklist.md  → Checklist Fase 5 (manual)
├── scripts/
│   └── pre-commit-check.sh      → Hook de build + lint
└── specs/
    ├── project-memory.md        → Memoria persistente cross-issues
    ├── active-issue.md          → Issue activa en sesión (generado)
    └── checkpoint-<N>.md        → Histórico de checkpoints por issue

.{harness}/                 → GENERADO en Paso 5 (/init-harness)
├── agents/                 → Mapeos 1:1 a workflow/agents/ (Claude Code)
└── skills/                 → Skills del harness (start-issue, design, implement, etc.)
```

---

## Flujo de uso después del setup

Una vez que `/setup-project` terminó con éxito:

```bash
# ── FASE 1: Iniciar issue ─────────────────────────────────────────────
/start-issue 42          # detecta nivel automáticamente (L0/L1/L2)

# ── FASE 2-4: Según nivel ────────────────────────────────────────────
/design                  # L1/L2: genera spec con test-plan en Gherkin
/implement               # implementa task por task (todos los niveles)
/verify                  # L1/L2: ACs + build + tests + Mutation Testing

# ── FASE 5: Manual en entorno local ──────────────────────────────────

# ── FASE 6: Crear PR ─────────────────────────────────────────────────
/create-pr               # Doc Updater sincroniza docs/ → PR creada

# ── Utilidades ──────────────────────────────────────────────────────
/new-issue Mi descripción       # issue ad-hoc
/move-issue 42 Ready            # mover en Project Board
/move-issue 42 Done             # marcar como done
```

---

## Estructura de carpeta después de /init-harness (ejemplo: Claude Code)

```
.claude/
├── agents/
│   ├── harness-configurator.md  → referencia a workflow/agents/harness-configurator.md
│   ├── project-manager.md       → referencia a workflow/agents/project-manager.md
│   ├── orchestrator.md          → referencia a workflow/agents/orchestrator.md
│   ├── explorer.md              → referencia a workflow/agents/explorer.md
│   ├── designer.md              → referencia a workflow/agents/designer.md
│   ├── implementer.md           → referencia a workflow/agents/implementer.md
│   ├── reviewer.md              → referencia a workflow/agents/reviewer.md
│   └── doc-updater.md           → referencia a workflow/agents/doc-updater.md
│
├── skills/
│   ├── init-harness/
│   │   ├── SKILL.md             → /init-harness [harness]
│   │   └── prompt.txt
│   ├── setup-project/
│   │   ├── SKILL.md             → /setup-project
│   │   └── prompt.txt
│   ├── start-issue/
│   ├── design/
│   ├── implement/
│   ├── verify/
│   ├── create-pr/
│   ├── new-issue/
│   └── move-issue/
│
├── settings.json                → configuración de hooks, permissions, env vars
└── CLAUDE.md                    → contexto proyecto-específico (opcional)
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

**Archivos que SÍ se committean:**
- `docs/` — documentos de proyecto completados
- `README.md` — resumen del proyecto
- `workflow/specs/project-memory.md` — memoria del proyecto
- `workflow/specs/issue-N/` — spec y reporte de cada issue
- `workflow/specs/checkpoint-N.md` — histórico de checkpoints
- `feature_list.json` — estado sincronizado
- `.claude/` (o `.cursor/`, etc.) — configuración del harness para el repo

---

## Troubleshooting

**❌ /init-harness no existe**
→ Aún no configuraste el harness. Ese es exactamente el paso que hace /init-harness.
  El harness lee SETUP.md y ejecuta el comando de configuración.

**❌ /setup-project no existe después de /init-harness**
→ Verifica que .claude/skills/ (o .cursor/, etc.) se generó correctamente.
  Ejecutá nuevamente /init-harness.

**❌ init.sh reporta errores**
→ Es idempotente. Resolvé el error y volvé a correr `./init.sh`.

**❌ GitHub CLI no funciona**
→ Ejecutá `gh auth login` y asigná permisos `repo` + `project`.

**❌ ¿Ya tenés documentos completos importados de otro proyecto?**
→ Ejecutá `/setup-project` normalmente. El PM los detectará como `COMPLETO`, presentará
  un resumen de cada uno y pedirá confirmación antes de avanzar al README y el backlog.

**❌ ¿Ya confirmaste los docs y solo querés (re)generar el backlog?**
→ Ejecutá `/setup-project backlog` para saltar directamente a la generación de Milestones
  e Issues en GitHub.

---

## Referencias

- **AGENTS.md** — Contrato del harness y definición de roles
- **workflow/agents/\*.md** — Definición detallada de cada rol
- **workflow/docs/harness-adapters.md** — Qué se genera por harness
- **workflow/WORKFLOW-REFERENCE.md** — Referencia completa del flujo
- **README.md** — Resumen del proyecto (generado)
