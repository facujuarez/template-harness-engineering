# Harness Adapters — Configuración por proveedor

> Referencia para Project Manager. Define qué archivos y estructura se generan
> para cada harness en la **Setup** (setup-project).

---

## Claude Code (Recomendado)

**Carpeta base:** `.claude/`

### Estructura generada

```
.claude/
  ├── agents/
  │   ├── orchestrator.md          → mapeo 1:1 de workflow/agents/orchestrator.md
  │   ├── explorer.md              → mapeo 1:1 de workflow/agents/explorer.md
  │   ├── designer.md              → mapeo 1:1 de workflow/agents/designer.md
  │   ├── implementer.md           → mapeo 1:1 de workflow/agents/implementer.md
  │   ├── reviewer.md              → mapeo 1:1 de workflow/agents/reviewer.md
  │   └── doc-updater.md           → mapeo 1:1 de workflow/agents/doc-updater.md
  │
  ├── skills/
  │   ├── start-issue/
  │   │   ├── SKILL.md
  │   │   └── prompt.txt
  │   ├── design/
  │   ├── implement/
  │   ├── verify/
  │   ├── create-pr/
  │   ├── new-issue/
  │   └── move-issue/
  │
  └── settings.json               → configuración de hooks, permissions, etc.
```

### Qué contiene cada archivo

- **`.claude/agents/*.md`** — referencias a `workflow/agents/*.md` con contexto local.
  Nunca duplica contenido; siempre apunta a la fuente canónica.
  
- **`.claude/skills/*/SKILL.md`** — definición nativa de skills para Claude Code.
  Cada skill mapea a una fase del workflow:
  - `start-issue` → Orchestrator (Fase 1)
  - `design` → Designer + Explorer (Fase 2)
  - `implement` → Implementer (Fase 3)
  - `verify` → Reviewer (Fase 4)
  - `create-pr` → Orchestrator + Doc Updater (Fase 6)
  - Utilitarios: `new-issue`, `move-issue`

- **`.claude/settings.json`** — hooks pre-commit, permisos, variables de entorno.

---

## Cursor

**Carpeta base:** `.cursor/`

### Estructura generada

```
.cursor/
  ├── rules/
  │   ├── orchestrator.md
  │   ├── designer.md
  │   ├── implementer.md
  │   └── ... (otros roles)
  │
  └── .cursorignore
```

### Qué contiene

- **`.cursor/rules/*.md`** — rules nativas de Cursor que mapean a `workflow/agents/*.md`.
- **`.cursorignore`** — patrones de archivos a ignorar.

---

## GitHub Copilot

**Carpeta base:** `.copilot/`

### Estructura generada

```
.copilot/
  ├── rules/
  │   └── rules.md
  │
  └── README.md
```

### Qué contiene

- **`.copilot/rules/rules.md`** — reglas únicas consolidadas para Copilot
  (menos granular que Claude Code o Cursor, ya que Copilot soporta fewer roles nativos).
- Referencia a `workflow/agents/` para roles detallados.

---

## Continue, Aider, OpenHands, etc.

**Carpeta base:** `.{harness}/` (ej: `.continue/`, `.aider/`)

### Estructura generada

Adaptar según capacidades nativas del harness:
- Si soporta agents/roles: crear carpeta `agents/` con mapeos 1:1.
- Si soporta rules/prompts: crear carpeta `rules/` o `prompts/`.
- Si soporta configuración JSON: crear `config.json` o `settings.json`.

Ejemplo para **Continue**:
```
.continue/
  ├── config.json
  └── rules/
      └── base.md
```

---

## Reglas de mapeo

1. **Nunca duplicar** contenido de `workflow/agents/*.md`. Solo referenciar.
2. **1:1 mapping** — cada rol en `workflow/agents/` corresponde a un archivo en la capa provider-specific.
3. **Fuente de verdad:** `workflow/agents/*.md` prevalece siempre. Si hay conflicto, la capa nativa
   cede.
4. **Actualización manual:** cuando se actualiza `workflow/agents/*.md`, revisar si la capa nativa
   requiere cambios de sincronización (anotación en commit message).

---

## Validación post-configuración

El Project Manager valida:
- ✓ Carpeta provider-specific creada con estructura correcta.
- ✓ Todos los roles mapeados.
- ✓ Referencias correctas a `workflow/agents/*.md`.
- ✓ Sin duplicados de contenido.
- ✓ Archivos de configuración (settings.json, config.json, etc.) listos.

Si alguna validación falla, reportar al usuario y no continuar hasta resolver.
