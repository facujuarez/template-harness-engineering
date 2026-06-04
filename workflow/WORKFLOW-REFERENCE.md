 # Harness Engineering Workflow — Referencia Completa
 
 > Resumen detallado del flujo de trabajo AI-first **provider-agnostic** con
 > agentes definidos en `workflow/agents/` + OpenSpec + GitHub.
 
 ---
 
 ## Visión general
 
 ```
 ── SETUP DE PROYECTO (una sola vez) ──────────────────────────────────────
 FASE 0  setup-project → docs/ completos + Milestones + Issues en GitHub

 ── CICLO POR ISSUE (se repite por cada issue del backlog) ────────────────
 FASE 1  start-issue   → Issue → Branch + contexto + nivel detectado
 FASE 2  design        → Contexto → Spec aprobado (test-plan en Gherkin)
 FASE 3  implement     → Spec → Código + commits
 FASE 4  verify        → Código → Reporte (ACs + Mutation Testing + checkpoint)
 FASE 5  [MANUAL]      → Revisión funcional en entorno local
 FASE 6  create-pr     → PR creada → In Review + project-memory actualizado
 ```
 
 Los nombres son **convención**: cada harness los expone como mejor encaje
 (slash commands, aliases, tasks). Lo importante es el rol que los ejecuta.
 
 ---
 
 ## Sistema de niveles
 
 El nivel se detecta automáticamente en `start-issue` según el label `size:*`.
 
 | Nivel | Tamaño | Fases activas | Agentes |
 |-------|--------|--------------|---------|
 | **L0** | XS, S | 0 → 1 → 3 → 5 → 6 | `implementer` |
 | **L1** | M | 0 → 1 → 2 → 3 → 4 → 5 → 6 | Todos, secuencial |
 | **L2** | L, XL | 0 → 1 → 2 → 3 → 4 → 5 → 6 | Todos, paralelo en 2 y 4 |
 
 **Override automático a L1 mínimo** si la issue afecta: autenticación,
 seguridad, permisos o contratos de API.
 
 ---
 
 ## FASE 0 — `setup-project`

 **Rol responsable:** [project-manager](agents/project-manager.md).

 **Objetivo:** Completar los documentos de `docs/` mediante entrevista guiada
 y generar el backlog inicial en GitHub (Milestones por fase + Issues por tarea).
 Esta fase se ejecuta **una sola vez** al iniciar el proyecto.

 **Modos de uso:**
 ```
 /setup-project           → flujo completo (entrevista + backlog)
 /setup-project docs      → solo entrevista de documentos
 /setup-project backlog   → solo generación de backlog (docs/ ya completos)
 ```

 **Lee al iniciar:**
 - `docs/functional.md`
 - `docs/architecture.md`
 - `docs/data-model.md`
 - `docs/project-plan.md`
 - `workflow/docs/issue-template.md`
 - `feature_list.json`

 **Flujo:**

 1. Revisa el estado de los 4 documentos de `docs/` y reporta: `VACÍO / PARCIAL / COMPLETO`.
 2. Por cada documento incompleto (orden: functional → architecture → data-model →
    project-plan), conduce la entrevista sección por sección:
    - Máx. 4 preguntas por ronda.
    - Muestra preview de cada sección antes de escribir.
    - Escribe solo tras aprobación explícita.
 3. **Gate:** todos los documentos aprobados antes de proceder al backlog.
 4. Lee `docs/project-plan.md`, presenta el plan de Milestones + Issues y
    espera aprobación explícita del usuario.
 5. Crea Milestones (una por fase) e Issues (una por tarea) en GitHub.
 6. Inicializa `feature_list.json` con todas las issues en `status: pending`.

 **Output:**
 - `docs/` completos y aprobados.
 - Milestones en GitHub correspondientes a cada fase del plan.
 - Issues en GitHub correspondientes a cada tarea, asignadas a su Milestone.
 - `feature_list.json` inicializado.

 ---

 ## FASE 1 — `start-issue [N]`
 
 **Rol responsable:** [orchestrator](agents/orchestrator.md).
 
 **Objetivo:** Inicializar el contexto de trabajo para la issue: detectar nivel,
 crear branch, instalar el hook y generar el archivo de sesión.
 
 **Lee al iniciar:**
 - `AGENTS.md`
 - `docs/architecture.md` (o `workflow/docs/tech-stack.md` como fallback)
 - `workflow/docs/workflow-conventions.md`
 - `workflow/docs/workflow-levels.md`
 - `workflow/specs/project-memory.md` (si existe)
 - `feature_list.json`
 
 **Flujo:**
 
 1. Lee Issue #N completa desde GitHub (`gh issue view`).
 2. **Detecta nivel** según label `size:*`:
    - XS, S → **L0** (flujo ligero)
    - M → **L1** (flujo completo secuencial)
    - L, XL → **L2** (flujo completo con paralelismo)
    - Override a L1+ si afecta auth/seguridad/contratos de API
 3. Crea branch siguiendo la convención `{tipo}/issue-{N}-{slug}` desde `develop`.
 4. Hace checkout local del branch.
 5. Instala el pre-commit hook si no existe (copia
    `workflow/scripts/pre-commit-check.sh` a `.git/hooks/pre-commit`).
 6. Genera `workflow/specs/active-issue.md` con:
    - Número, título, nivel, branch, tipo, tamaño
    - ACs extraídos de la issue
    - Notas técnicas y out of scope
    - Para **L0:** tasks inline generadas directamente
    - Para **L1/L2:** specs marcados como pendientes (Fase 2)
 7. Actualiza `feature_list.json`: feature → `in_progress`.
 8. Mueve la issue a **In Progress** en el Project Board.
 9. Presenta resumen e indica el siguiente comando según el nivel.
 
 **Output:**
 - Branch creado y en checkout.
 - `workflow/specs/active-issue.md` generado.
 - Pre-commit hook instalado.
 - `feature_list.json` actualizado.
 - Issue en estado **In Progress**.
 
 ---
 
 ## FASE 2 — `design` *(L1, L2 — L0 la salta)*
 
 **Roles involucrados:** [explorer](agents/explorer.md),
 [designer](agents/designer.md).
 
 **Objetivo:** Explorar el codebase y generar el spec completo como contrato
 de implementación, usando agentes en contexto aislado.
 
 **Flujo L1 (secuencial):**
 
 1. El orchestrator lanza al [explorer](agents/explorer.md):
    - Explora módulos afectados, patrones arquitectónicos existentes,
      código reutilizable, dependencias y deuda técnica relevante
    - Devuelve informe estructurado (no contamina el contexto principal)
 2. Lanza al [designer](agents/designer.md) con el informe del explorer:
    - Sintetiza contexto: ACs + codebase + restricciones del stack
    - Propone enfoque arquitectónico respetando patrones existentes
    - Descompone en tasks atómicas ordenadas por dependencia
    - Genera los archivos del spec
 3. El orchestrator presenta spec al usuario para aprobación.
 4. Itera si hay ajustes; si hay cambios el designer regenera completo.
 5. **Gate:** aprobación explícita del spec antes de continuar.
 
 **Flujo L2 (con exploración paralela):**
 
 1. Lanza 2× [explorer](agents/explorer.md) en paralelo:
    - Explorer A: módulos funcionales afectados
    - Explorer B: patrones de testing, seguridad y performance
 2. Consolida los dos informes.
 3. Lanza un [designer](agents/designer.md) integrador con el informe
    consolidado (más exhaustivo).
 4. Mismos pasos de presentación y aprobación que L1.
 
 **Archivos generados:**
 ```
 workflow/specs/issue-{N}/
 ├── design.md          → enfoque, componentes, decisiones técnicas, riesgos
 ├── tasks.md           → tasks ordenadas, cada una mapeada a un AC
 ├── api-contract.md    → contratos de interfaz (solo si aplica)
 └── test-plan.md       → casos de prueba por AC
 ```
 
 **Output:** Spec aprobado = contrato de implementación bloqueado.
 
 ---
 
 ## FASE 3 — `implement`
 
 **Rol responsable:** [implementer](agents/implementer.md).
 
 **Objetivo:** Implementar las tasks del spec una por una, con verificación en
 cada commit vía pre-commit hook.
 
 **Fuente de tasks según nivel:**
 - **L0:** tasks inline en `workflow/specs/active-issue.md`
 - **L1/L2:** `workflow/specs/issue-{N}/tasks.md`
 
 **Flujo:**
 
 1. Lee el estado actual de tasks (completadas / pendientes).
 2. Muestra progreso y espera confirmación para empezar.
 3. **Por cada task pendiente:**
    - a. Anuncia la task (nombre, descripción, AC cubierto).
    - b. El orchestrator delega al [implementer](agents/implementer.md) con:
      - Descripción completa de la task
      - Contenido de `design.md` y `api-contract.md`
      - Convenciones de `tech-stack.md`
    - c. El implementer trabaja en contexto aislado:
      - Lee archivos afectados en su estado actual
      - Implementa estrictamente según el spec
      - Verifica compilación internamente
      - Devuelve resumen del diff
    - d. El orchestrator presenta el resumen al usuario para aprobación.
    - e. **Gate:** aprobación explícita (o modo autopilot si el usuario lo activa).
    - f. Hace `git commit` → el pre-commit hook ejecuta build + lint
      automáticamente. Si falla: commit cancelado, corrige antes de avanzar.
      Nunca se usa `--no-verify`.
    - g. Marca la task como `[x]` en el archivo de tasks.
 4. Al completar todas las tasks, presenta resumen y propone siguiente paso:
    - **L0:** propone ir a `verify` (mínimo) o directo a revisión manual (Fase 5).
    - **L1/L2:** propone `verify`.
 
 **Nunca hace push.** Solo commits locales hasta la Fase 6.
 
 **Output:**
 - Código implementado en el branch local.
 - N commits (uno por task) verificados por el hook.
 - `tasks.md` con todas las tasks en estado `[x]`.
 
 ---
 
 ## FASE 4 — `verify` *(L1, L2 — L0 lo hace versión ligera)*
 
 **Rol responsable:** [reviewer](agents/reviewer.md).
 
 **Objetivo:** Verificación objetiva e independiente de que la implementación
 cumple el spec y los ACs. Produce el `verification-report.md` y deja
 `workflow/docs/checkpoint.md` completamente marcado.
 
 **Flujo L1 (secuencial):**
 
 1. Verifica que todas las tasks están completadas (advierte si no).
 2. El [reviewer](agents/reviewer.md) ejecuta:
    - Build completo
    - Lint
    - Tests con cobertura
    - Verifica cada AC: ✅ cubierto / ⚠️ parcial / ❌ no cubierto
    - Verifica que el scope implementado corresponde al spec
    - Recorre `workflow/docs/checkpoint.md` y marca cada box con evidencia
    - Genera `workflow/specs/issue-{N}/verification-report.md`
 3. Presenta resultado al orchestrator.
 
 **Flujo L2 (varios reviewers en paralelo):**
 
 1. Lanza simultáneamente:
    - reviewer principal: ACs + build + tests (igual que L1)
    - reviewer área A: seguridad y permisos
      (autenticación, autorización, validación de inputs, secretos)
    - reviewer área B: performance y calidad
      (llamadas en loops, over-fetching, duplicación, manejo de errores)
    - reviewer área C: integración y contratos
      (breaking changes, coherencia entre módulos, contratos de API)
 2. Un reviewer integrador consolida los informes en un único
    `verification-report.md` y un único `workflow/docs/checkpoint.md`.
 3. Determina resultado global: el más restrictivo de los reviewers.
 
 **Resultados posibles:**
 - ✅ **APROBADO** → gate manual (Fase 5)
 - ⚠️ **APROBADO CON OBSERVACIONES** → gate manual con notas documentadas
 - ❌ **BLOQUEADO** → vuelve a `implement` para corregir
 
 **Reglas duras del reviewer:**
 - Si quedó algún box en `[ ]` en `workflow/docs/checkpoint.md`, **bloquea el cierre**.
 - Las únicas excepciones son `[~]` (no aplica) con justificación del orchestrator.
 - Al cerrar, copia `workflow/docs/checkpoint.md` a `workflow/specs/checkpoint-{N}.md` y
   resetea el template a `[ ]` para la próxima sesión.
 
 **Output:**
 - `workflow/specs/issue-{N}/verification-report.md` completo.
 - `workflow/specs/checkpoint-{N}.md` histórico.
 - `workflow/docs/checkpoint.md` reseteado.
 - `feature_list.json` con feature → `done` si todos los ACs pasan.
 
 ---
 
 ## FASE 5 — Manual · Dev Review
 
 **Objetivo:** Validación funcional que ningún agente puede reemplazar:
 ¿el comportamiento real coincide con la intención original?
 
 **Herramienta:** `workflow/docs/dev-review-checklist.md`.
 
 **Checklist:**
 - Funcionalidad principal: happy path end-to-end
 - Cada AC verificado manualmente
 - Edge cases: datos vacíos, nulos, volúmenes grandes, sin permisos, sin conexión
 - Regresiones: funcionalidades adyacentes siguen funcionando
 - UX: la interfaz es clara e intuitiva (si aplica)
 - Performance: tiempos aceptables, sin llamadas redundantes
 - Consola/logs: sin errores ni warnings nuevos
 
 **Resultado:**
 - ✅ Aprobado → `create-pr`.
 - ❌ Requiere correcciones → vuelve a `implement` (tasks adicionales o corrección
   de existentes). El reviewer revalida.
 
 ---
 
 ## FASE 6 — `create-pr`
 
 **Rol responsable:** [orchestrator](agents/orchestrator.md).
 
 **Objetivo:** Generar la descripción de PR desde el spec y el reporte,
 publicar el branch y crear la PR en GitHub.
 
 **Flujo:**
 
 1. Lee `workflow/specs/active-issue.md` para determinar nivel.
 2. Verifica estado del branch:
    - Sin cambios sin commitear.
    - Actualizado respecto a `develop` (si no, pregunta si hacer rebase).
    - `workflow/docs/checkpoint.md` cerrado por el reviewer.
 3. Para **L1/L2:** verifica que existe `verification-report.md`.
 4. **Gate:** muestra borrador de PR y espera aprobación explícita.
 5. Tras aprobación, hace `git push origin {branch}` (única operación que
    contacta GitHub para publicar; nunca antes).
 6. Genera descripción de PR según nivel:
    - **L0:** descripción simple con ACs cubiertos.
    - **L1/L2:** descripción completa con ACs + tabla de verificación +
      decisiones técnicas relevantes + out of scope intencional.
 7. Crea PR en GitHub con `gh pr create`:
    - Título: `{tipo}(issue-{N}): {descripción}`
    - Base: `develop` (nunca `main` directamente)
    - `Closes #{N}` en la descripción
 8. Mueve issue a **In Review** en el Project Board.
 9. **Actualiza `workflow/specs/project-memory.md`** con:
    - Resumen de cambios realizados
    - Patrones nuevos introducidos
    - Archivos clave afectados
    - Aprendizajes para futuras issues similares
 10. Confirma estado final en `feature_list.json`.
 
 **Output:**
 - PR creada en GitHub linkeada a la issue.
 - Issue en estado **In Review**.
 - `project-memory.md` actualizado.
 - `feature_list.json` reflejando el cierre de scope.
 
 ---
 
 ## UTILIDAD — `new-issue [descripción libre]`

 **Rol responsable:** [orchestrator](agents/orchestrator.md).

 **Objetivo:** Crear una Issue individual ad-hoc (bug, spike o feature no
 planificada) para casos que no forman parte del backlog generado en Fase 0.
 Para el backlog inicial del proyecto usar `setup-project`.

 **Lee al iniciar:**
 - `docs/functional.md` (o `workflow/docs/product-context.md` como fallback)
 - `docs/architecture.md` (o `workflow/docs/tech-stack.md` como fallback)
 - `workflow/docs/issue-template.md`
 - `workflow/docs/definition-of-ready.md`
 - `feature_list.json`

 **Flujo:**

 1. El usuario describe el requisito (libre, sin formato).
 2. El orchestrator hace escucha activa: máx. 3 preguntas por ronda.
 3. Infiere tipo y tamaño. Si es `L` o `XL`, evalúa si conviene dividir.
 4. Genera borrador con el template canónico.
 5. **Gate:** aprobación explícita antes de crear nada en GitHub.
 6. Crea Issue asignándola a la Milestone de la fase activa del proyecto.
 7. Agrega entrada a `feature_list.json` con `status: pending`.

 **Output:** Issue #N en GitHub con Milestone asignada, sincronizada en
 `feature_list.json`.

 ---

 ## UTILIDAD — `move-issue [N] [estado]`
 
 **Rol responsable:** [orchestrator](agents/orchestrator.md).
 
 **Objetivo:** Gestionar el ciclo de vida de la issue en el Project Board.
 
 **Estados válidos:** `Backlog` → `Ready` → `In Progress` → `In Review` → `Done`.
 
 **Comportamiento especial:**
 - Antes de mover a **Ready**: verifica Definition of Ready
   (`workflow/docs/definition-of-ready.md`).
 - Al mover a **Done**: cierra el Issue en GitHub y sincroniza `feature_list.json`.
 - Para transiciones inusuales (saltando fases): pide confirmación explícita.
 
 **Uso frecuente:**
 ```
 move-issue 42 Ready          → issue refinada y aprobada
 move-issue 42 "In Progress"  → inicio de desarrollo (también lo hace start-issue)
 move-issue 42 "In Review"    → PR abierta (también lo hace create-pr)
 move-issue 42 Done           → PR mergeada y desplegada
 ```
 
 ---
 
 ## Archivos del kit
 
 ### Contrato del harness (auto-cargado por el harness)
 
 | Archivo | Propósito |
 |---------|-----------|
 | `AGENTS.md` | Contrato raíz: niveles, fases, roles, reglas. |
 | `workflow/agents/*.md` | Definición de cada rol. |
 
 ### Roles — corren en contexto aislado

 | Archivo | Rol | Usado en |
 |---------|-----|----------|
 | `workflow/agents/project-manager.md` | Entrevista de docs + generación de backlog | Fase 0 |
 | `workflow/agents/orchestrator.md` | Líder, único canal con el usuario | Fases 1–6 |
 | `workflow/agents/explorer.md` | Análisis estático del codebase | Fase 2 |
 | `workflow/agents/designer.md` | Diseño arquitectónico + spec (Gherkin) | Fase 2 |
 | `workflow/agents/implementer.md` | Implementación task por task | Fase 3 |
 | `workflow/agents/reviewer.md` | ACs + build + tests + Mutation Testing + checkpoint | Fase 4 |

 ### Capa provider-specific (opcional)

 Si el harness lo soporta, se crea como adapter. Ejemplo Claude Code:

 | Archivo | Comando | Fase |
 |---------|---------|------|
 | `.claude/skills/setup-project/SKILL.md` | `/setup-project` | 0 |
 | `.claude/skills/start-issue/SKILL.md` | `/start-issue` | 1 |
 | `.claude/skills/design/SKILL.md` | `/design` | 2 |
 | `.claude/skills/implement/SKILL.md` | `/implement` | 3 |
 | `.claude/skills/verify/SKILL.md` | `/verify` | 4 |
 | `.claude/skills/create-pr/SKILL.md` | `/create-pr` | 6 |
 | `.claude/skills/move-issue/SKILL.md` | `/move-issue` | utilidad |
 
 Cada uno **mapea 1:1 con `workflow/agents/*.md`**.
 
 ### Scripts
 
 | Archivo | Propósito |
 |---------|-----------|
 | `init.sh` | Verificación e inicialización del entorno |
 | `workflow/scripts/pre-commit-check.sh` | Build + lint antes de cada commit |
 
 ### Estado del proyecto
 
 | Archivo | Propósito |
 |---------|-----------|
 | `workflow/docs/checkpoint.md` | Checklist de cierre de sesión (dueño: reviewer) |
 | `feature_list.json` | Estado sincronizado de features/issues |
 
 ### Documentación del proyecto *(se completa con `/setup-project`)*

 | Archivo | Qué contiene | ¿Editar? |
 |---------|--------------|----------|
 | `docs/functional.md` | Visión, RF, RNF, entidades, CU, riesgos | ⚠️ Sí (vía `/setup-project`) |
 | `docs/architecture.md` | Stack, diseño técnico, auth, deploy | ⚠️ Sí (vía `/setup-project`) |
 | `docs/data-model.md` | Modelo de datos, índices, cache | ⚠️ Sí (vía `/setup-project`) |
 | `docs/project-plan.md` | Fases, tareas, milestones | ⚠️ Sí (vía `/setup-project`) |
 | `workflow/docs/product-context.md` | Fallback de contexto (si `docs/` no está listo) | Opcional |
 | `workflow/docs/tech-stack.md` | Fallback de stack (si `docs/` no está listo) | Opcional |
 | `workflow/docs/workflow-conventions.md` | Branches, commits, PRs | Opcional |
 | `workflow/docs/workflow-levels.md` | Referencia del sistema L0/L1/L2 | No |
 | `workflow/docs/definition-of-ready.md` | Criterios para estado Ready (incluye Milestone) | Opcional |
 | `workflow/docs/issue-template.md` | Template canónico de Issues | Opcional |
 | `workflow/docs/dev-review-checklist.md` | Checklist Fase 5 manual | Opcional |
 
 ### Specs *(generados durante el trabajo)*
 
 | Archivo | Qué contiene | ¿Committear? |
 |---------|--------------|---------------|
 | `workflow/specs/active-issue.md` | Issue activa en sesión actual | ❌ No |
 | `workflow/specs/project-memory.md` | Memoria persistente cross-issues | ✅ Sí |
 | `workflow/specs/issue-{N}/design.md` | Diseño aprobado de la issue | ✅ Sí |
 | `workflow/specs/issue-{N}/tasks.md` | Tasks y su estado | ✅ Sí |
 | `workflow/specs/issue-{N}/api-contract.md` | Contratos de interfaz | ✅ Sí |
 | `workflow/specs/issue-{N}/test-plan.md` | Plan de pruebas | ✅ Sí |
 | `workflow/specs/issue-{N}/verification-report.md` | Reporte de verificación | ✅ Sí |
 | `workflow/specs/checkpoint-{N}.md` | Histórico inmutable del checkpoint cerrado | ✅ Sí |
 
 ---
 
 ## Checklist de inicio de proyecto
 
 Al aplicar este template a un nuevo proyecto:
 
 - [ ] Crear repo desde el template y clonar.
 - [ ] Ejecutar `./init.sh` y resolver errores reportados.
 - [ ] Editar `AGENTS.md`: reemplazar `[PROJECT_NAME]`, `[GITHUB_ORG]`,
       `[GITHUB_REPO]`, `[PROJECT_BOARD_URL]`.
 - [ ] Completar `feature_list.json` (project, description; eliminar feature
       de ejemplo).
 - [ ] Instalar el pre-commit hook (`cp workflow/scripts/pre-commit-check.sh
       .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`).
 - [ ] Autenticar GitHub CLI: `gh auth login`.
 - [ ] Crear GitHub Project Board con columnas: Backlog / Ready / In Progress
       / In Review / Done.
 - [ ] Crear labels en el repo: `type:feature`, `type:bug`, `type:chore`,
       `type:spike`, `size:XS/S/M/L/XL`.
 - [ ] Abrir tu harness en el proyecto y verificar que carga `AGENTS.md`.
 - [ ] **Ejecutar `/setup-project`** para completar `docs/` y generar el
       backlog inicial (Milestones + Issues en GitHub).
 - [ ] Verificar que las Issues creadas están en el Project Board (columna Backlog).
 
 ---
 
 ## .gitignore recomendado
 
 ```gitignore
 # Sesión activa (no committear)
 workflow/specs/active-issue.md
 
 # Secretos y configuración local
 .env.local
 .env.*.local
 appsettings.Development.json
 ```
