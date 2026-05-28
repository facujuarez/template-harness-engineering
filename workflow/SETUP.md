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

workflow/
├── agents/
│   ├── orchestrator.md         → rol líder: detecta nivel, delega, gestiona gates
│   ├── explorer.md             → rol read-only: análisis estático del codebase
│   ├── designer.md             → rol que genera el spec (contrato)
│   ├── implementer.md          → rol que ejecuta tasks del spec
│   └── reviewer.md             → rol verificador, dueño de workflow/docs/checkpoint.md
├── docs/
│   ├── checkpoint.md           → checklist de cierre de sesión (dueño: reviewer)
│   ├── product-context.md      → ⚠️ DEBES COMPLETAR ESTE
│   ├── tech-stack.md           → ⚠️ DEBES COMPLETAR ESTE
│   ├── workflow-conventions.md → branches, commits, PRs
│   ├── workflow-levels.md      → sistema de niveles L0/L1/L2
│   ├── definition-of-ready.md  → criterios para Ready
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
│   ├── orchestrator.md   → wrapper apuntando a workflow/agents/orchestrator.md
│   ├── explorer.md       → idem
│   ├── designer.md       → idem
│   ├── implementer.md    → idem
│   └── reviewer.md       → idem
└── skills/
    ├── new-issue/SKILL.md     → /new-issue   Fase 0
    ├── start-issue/SKILL.md   → /start-issue Fase 1
    ├── design/SKILL.md        → /design      Fase 2
    ├── implement/SKILL.md     → /implement   Fase 3
    ├── verify/SKILL.md        → /verify      Fase 4
    ├── create-pr/SKILL.md     → /create-pr   Fase 6
    └── move-issue/SKILL.md    → /move-issue  utilidad
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
ejemplo cuando empieces a crear las reales (lo hace el orchestrator durante
`new-issue`).

---

## Paso 5 — Completar workflow/docs/product-context.md

Describí tu producto: qué es, usuarios, módulos principales.

---

## Paso 6 — Completar workflow/docs/tech-stack.md

**El archivo más crítico para la calidad del código generado.**

Completá:
- Stack tecnológico con versiones
- **Comandos exactos de build, test y lint**
- Estructura de directorios
- Convenciones de código

El `pre-commit-check.sh` detecta el tipo de proyecto automáticamente
(dotnet, spfx, node/vite) pero podés editar el script si tu stack
tiene particularidades.

---

## Paso 7 — Instalar el pre-commit hook

```bash
cp workflow/scripts/pre-commit-check.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Alternativa: el orchestrator lo instala automáticamente al ejecutar
`start-issue [N]` por primera vez en el repo.

---

## Paso 8 — Configurar GitHub CLI

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

## Paso 9 — Configurar GitHub Project Board

1. Tu repo → **Projects** → **New Project** → **Board**
2. Configurá el campo **Status** con estas columnas:
   - `📋 Backlog` / `✅ Ready` / `🔧 In Progress` / `👀 In Review` / `✔️ Done`
3. Copiá la URL al `AGENTS.md`.

---

## Paso 10 — Configurar labels en el repo

```
type:feature  #0075ca    type:bug      #d73a4a
type:chore    #e4e669    type:spike    #cc317c
size:XS       #f9d0c4    size:S        #f9d0c4
size:M        #bfd4f2    size:L        #d4c5f9
size:XL       #e11d48
```

---

## Paso 11 — Verificar instalación

Abrí tu harness en el directorio. El agente debería cargar `AGENTS.md`
automáticamente y reconocer los roles en `workflow/agents/`. Probá un comando de
exploración (lectura) para confirmar que el contexto está cargado.

---

## Flujo de uso rápido

Los nombres de comandos abajo son **convención**; cada harness los expone
como mejor encaje (slash commands, aliases, tasks).

```bash
# Fase 0 — Nueva feature
new-issue quiero que los usuarios puedan filtrar el listado por fecha

# Fase 1 — Inicializar (detecta nivel automáticamente)
start-issue 42

# L0 (XS/S): saltar directamente a
implement

# L1/L2 (M, L, XL):
design       # genera spec vía explorer + designer
implement    # implementa task por task
verify       # reviewer cubre ACs + build + tests + workflow/docs/checkpoint.md

# Fase 5 — Manual: revisar en entorno local

# Fase 6
create-pr    # genera PR + actualiza project-memory

# Utilidades
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
- `workflow/specs/project-memory.md` — memoria del proyecto
- `workflow/specs/issue-N/` — spec y reporte de cada issue (documentación + trazabilidad)
- `workflow/specs/checkpoint-N.md` — histórico inmutable de checkpoints
- `feature_list.json` — estado sincronizado
