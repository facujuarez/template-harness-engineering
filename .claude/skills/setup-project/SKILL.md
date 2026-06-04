# Skill: setup-project

> **Fase 0** del workflow. Invoca al [[project-manager]] para completar los
> documentos de `docs/` mediante entrevista guiada y, una vez completados,
> generar el backlog inicial en GitHub (Milestones + Issues).

---

## Uso

```
/setup-project                → flujo completo: entrevista de docs + generación de backlog
/setup-project docs           → solo entrevista (no genera backlog al finalizar)
/setup-project backlog        → solo genera backlog (asume docs/ ya completos y aprobados)
```

---

## Flujo completo

### Paso 1 — Revisión de estado

Lee `docs/functional.md`, `docs/architecture.md`, `docs/data-model.md` y
`docs/project-plan.md`. Reporta el estado de cada uno:

```
Estado de documentos de proyecto:
  docs/functional.md   → VACÍO / PARCIAL / COMPLETO
  docs/architecture.md → VACÍO / PARCIAL / COMPLETO
  docs/data-model.md   → VACÍO / PARCIAL / COMPLETO
  docs/project-plan.md → VACÍO / PARCIAL / COMPLETO

[Si hay documentos incompletos:]
Comenzamos con docs/[primer incompleto]. ¿Listo?
```

Si todos están completos y el modo es el default, salta al Paso 3 (gate de backlog).

---

### Paso 2 — Entrevista por documento

Por cada documento incompleto, en orden:
`docs/functional.md` → `docs/architecture.md` → `docs/data-model.md` → `docs/project-plan.md`

**Por cada sección con `[COMPLETAR]`:**

1. Presenta la sección y su propósito.
2. Hace preguntas (máx. 4 por ronda).
3. Genera el texto de la sección.
4. Muestra preview:
   ```
   ─── Preview: [Nombre de la sección] ───────────────────
   [texto generado]
   ────────────────────────────────────────────────────────
   ¿Aprobado? ¿O hay algo que ajustar?
   ```
5. Escribe la sección en el archivo solo tras aprobación explícita.
6. Avanza a la siguiente sección incompleta.

Al completar un documento:
```
✅ docs/[nombre].md — COMPLETO
Pasamos a docs/[siguiente].md
```

---

### Paso 3 — Gate de documentos

```
Todos los documentos de docs/ están completos.

¿Procedemos a generar el backlog en GitHub a partir de docs/project-plan.md?
```

Si el modo es `/setup-project docs`, termina aquí.

---

### Paso 4 — Plan de backlog (preview antes de actuar)

Lee `docs/project-plan.md` y presenta el plan completo:

```
Backlog a crear en GitHub:

MILESTONES (N fases):
  • Fase 0 — [Nombre]  →  "[Objetivo]"
  • Fase 1 — [Nombre]  →  "[Objetivo]"
  ...

ISSUES (N tareas):
  Fase 0 — [Nombre]:
    #— [Tarea 1]  |  size:M  |  type:feature
    #— [Tarea 2]  |  size:S  |  type:chore
  Fase 1 — [Nombre]:
    #— [Tarea 3]  |  size:L  |  type:feature
    ...

Total: N milestones, N issues

¿Aprobado? ¿Hay alguna tarea que excluir o ajustar antes de crear?
```

---

### Paso 5 — Creación en GitHub

Solo tras aprobación explícita:

1. Crea Milestones:
   ```bash
   gh api repos/{owner}/{repo}/milestones \
     --method POST \
     --field title="Fase N — [Nombre]" \
     --field description="[Objetivo]"
   ```

2. Crea Issues asignadas a su Milestone:
   ```bash
   gh issue create \
     --title "[Tarea]" \
     --body "[cuerpo según formato del project-manager]" \
     --label "type:feature,size:M" \
     --milestone "Fase N — [Nombre]"
   ```

3. Actualiza `feature_list.json`:
   - Agrega una entrada por issue con `status: pending`.

4. Reporta resultado:
   ```
   ✅ Backlog creado:
     N milestones creadas
     N issues creadas y asignadas
     feature_list.json actualizado

   Próximo paso: /start-issue [N] para comenzar el ciclo de desarrollo.
   ```

---

## Archivos que lee

| Archivo | Propósito |
|---------|-----------|
| `docs/functional.md` | Estado y contenido del documento funcional |
| `docs/architecture.md` | Estado y contenido del documento de arquitectura |
| `docs/data-model.md` | Estado y contenido del modelo de datos |
| `docs/project-plan.md` | Fases y tareas para generación del backlog |
| `workflow/docs/issue-template.md` | Formato canónico para cuerpo de Issues |
| `feature_list.json` | Estado actual del proyecto |
| `AGENTS.md` | Configuración del repo (org, nombre) |

## Archivos que escribe

| Archivo | Qué escribe |
|---------|-------------|
| `docs/functional.md` | Secciones completadas tras aprobación |
| `docs/architecture.md` | Secciones completadas tras aprobación |
| `docs/data-model.md` | Secciones completadas tras aprobación |
| `docs/project-plan.md` | Secciones completadas tras aprobación |
| `feature_list.json` | Issues iniciales en `status: pending` |

## Recursos GitHub que crea

| Recurso | Origen |
|---------|--------|
| Milestones | Una por Fase en `docs/project-plan.md` |
| Issues | Una por Tarea dentro de cada Fase |
