# [Nombre del Proyecto] — Plan de Implementación

> **Versión:** 0.1
> **Fecha:** [COMPLETAR]
> **Autor:** [COMPLETAR]

---

## Historial de Cambios

| Versión | Fecha | Descripción |
|---------|-------|-------------|
| 0.1 | [FECHA] | Versión inicial. |

---

## 1. Contexto de Ejecución

[Describe el equipo, el contexto de trabajo y las prioridades que guían este plan]

- **Equipo:** [tamaño, roles, dedicación — ej: un desarrollador a tiempo parcial]
- **Prioridades:** [qué se optimiza — ej: valor validable temprano, bajo costo inicial]
- **Restricciones:** [tiempo, presupuesto, dependencias externas, deuda técnica preexistente]

---

## 2. Recursos y Herramientas

### 2.1 Stack de Desarrollo

| Área | Herramienta | Notas |
|------|-------------|-------|
| IDE principal | [COMPLETAR] | |
| Control de versiones | Git + GitHub | Repositorio [privado/público] |
| Gestión de tareas | [COMPLETAR] | [ej: GitHub Projects, Linear, Jira] |
| Diseño UI | [COMPLETAR] | [ej: Figma] |
| API testing | [COMPLETAR] | [ej: Bruno, Postman] |
| DB local | [COMPLETAR] | [ej: PostgreSQL vía Docker] |
| Contenedores | [COMPLETAR] | [ej: Docker Desktop] |
| Documentación | Markdown en repo (`/docs`) | |

### 2.2 Servicios Cloud

| Servicio | Tier Inicial | Costo estimado/mes |
|----------|--------------|--------------------|
| [Servicio 1 — ej: App Service] | [Tier — ej: B1] | ~$X USD |
| [Servicio 2 — ej: Base de datos] | [Tier] | ~$X USD |
| [Servicio 3 — ej: Cache] | [Tier] | ~$X USD |
| [Servicio 4 — ej: Functions] | [Tier] | ~$X USD |
| [Servicio 5 — ej: Storage] | [Tier] | ~$X USD |
| **Total estimado MVP** | | **~$X USD/mes** |

### 2.3 Dependencias de Software

**Backend:**

- [Dependencia 1 — nombre y propósito]
- [Dependencia 2]

**Frontend:**

- [Dependencia 1]
- [Dependencia 2]

<!--
  Agregar secciones adicionales para Mobile, Data Engine, etc. si aplica.
-->

### 2.4 Cuentas y Accesos Necesarios

- [ ] Cuenta de GitHub (repositorio del proyecto)
- [ ] Cuenta de [proveedor cloud]
- [ ] [Cuenta de servicio externo 1]
- [ ] [Cuenta de servicio externo 2]

---

## 3. Workflow de Trabajo

### 3.1 Estrategia de Branching

```
main (producción, siempre deployable)
  └── develop (integración)
        ├── feature/nombre-feature
        ├── fix/nombre-bug
        └── chore/nombre-tarea
```

- **`main`:** solo recibe merges desde `develop` vía PR. Cada merge es un release.
- **`develop`:** rama de integración continua. CI corre en cada push.
- **`feature/*`:** una rama por funcionalidad, vida corta (idealmente < 1 semana).

### 3.2 Convenciones de Commits

```
feat: agregar [feature]
fix: corregir [bug]
docs: actualizar [documento]
chore: [tarea de mantenimiento o dependencias]
test: agregar tests para [módulo]
refactor: [descripción del refactor]
perf: [mejora de rendimiento]
```

### 3.3 Estructura del Repositorio

```
[nombre-proyecto]/
├── .github/
│   └── workflows/          # Pipelines CI/CD
├── docs/                   # Documentos de proyecto
├── [carpeta-backend]/      # [descripción]
│   ├── [subcarpeta]/
│   └── [subcarpeta]/
├── [carpeta-frontend]/     # [descripción]
│   └── [subcarpeta]/
├── [carpeta-infra]/        # IaC (Bicep, Terraform, etc.)
└── docker-compose.yml      # Entorno local
```

### 3.4 Gestión de Tareas

Columnas del tablero Kanban:

- **Backlog** — Tareas identificadas, sin priorizar
- **Sprint** — Tareas del sprint actual
- **En progreso** — WIP (máximo [N] tareas simultáneas)
- **En revisión** — PR abierto, esperando merge
- **Hecho** — Completado y deployado

Cada tarea incluye: descripción, criterios de aceptación, estimación (S/M/L), fase a la que pertenece.

---

## 4. Fases de Implementación

<!--
  Definir las fases como bloques de trabajo que producen un entregable observable.
  Cada fase debe terminar con algo funcional y testeable.
  Este documento es un borrador vivo: revisar al final de cada fase.
-->

### Fase 0 — [Nombre] ([duración estimada: N–M semanas])

**Objetivo:** [Una frase que resume qué se logra al terminar esta fase]

**Tareas:**

- [ ] [Tarea 1]
- [ ] [Tarea 2]
- [ ] [Tarea 3]
- [ ] [...]

**Criterio de completitud:** [Condición observable que indica que la fase está terminada]

**Casos de uso cubiertos:** [Referencias a CU del documento functional.md — ej: CU-01 (parcial)]

---

### Fase 1 — [Nombre] ([duración estimada])

**Objetivo:** [...]

**Tareas:**

- [ ] [Tarea 1]
- [ ] [Tarea 2]
- [ ] [...]

**Criterio de completitud:** [...]

**Casos de uso cubiertos:** [...]

---

### Fase 2 — [Nombre] ([duración estimada])

**Objetivo:** [...]

**Tareas:**

- [ ] [Tarea 1]
- [ ] [...]

**Criterio de completitud:** [...]

**Casos de uso cubiertos:** [...]

---

### Fase 3 — [Nombre] ([duración estimada])

**Objetivo:** [...]

**Tareas:**

- [ ] [Tarea 1]
- [ ] [...]

**Criterio de completitud:** [...]

**Casos de uso cubiertos:** [...]

---

<!--
  Agregar Fase N según la complejidad del proyecto.
  La última fase puede ser un backlog de funcionalidades avanzadas o post-MVP.
-->

### Fase N — Funcionalidades Avanzadas (backlog priorizable)

[Listar las funcionalidades que se incorporarán en función del feedback de usuarios y métricas de adopción]

- [ ] [Feature avanzada 1]
- [ ] [Feature avanzada 2]

---

## 5. Métricas de Éxito por Fase

| Fase | Métrica clave |
|------|---------------|
| Fase 0 | [Condición observable que valida la fase — ej: N entidades en BD, pipeline sin errores] |
| Fase 1 | [Condición observable — ej: API responde < Xms en p95, N flujos de negocio funcionan] |
| Fase 2 | [Condición observable — ej: N usuarios beta registrados, tasa de conversión > X%] |
| Fase 3 | [Condición observable] |

---

## 6. Riesgos del Plan y Mitigaciones

| Riesgo | Impacto | Mitigación |
|--------|---------|------------|
| [Riesgo técnico 1] | Alto / Medio / Bajo | [Acción de mitigación] |
| [Riesgo de negocio 1] | Alto / Medio / Bajo | [Acción de mitigación] |
| [Riesgo de equipo / recursos] | Alto / Medio / Bajo | [Acción de mitigación] |
| [Riesgo de terceros / dependencias externas] | Alto / Medio / Bajo | [Acción de mitigación] |

---

## 7. Próximos Pasos Inmediatos (Semana 1)

1. **Día 1–2:** [Actividad concreta]
2. **Día 2–3:** [Actividad concreta]
3. **Día 3–4:** [Actividad concreta]
4. **Día 5:** [Actividad concreta — verificación / hito]

> **Decisión de inicio:** [Explica brevemente por qué se empieza por lo que se empieza. Ej: "Comenzar por el modelo de datos porque es la base de todas las fases siguientes y es más barato modelarlo bien una vez que migrar después."]

---

## 8. Registro de Decisiones (ADR simplificado)

<!--
  Documentar las decisiones importantes de gestión y técnicas tomadas durante el proyecto.
  Incluir la razón para que future-you entienda el contexto sin tener que reconstruirlo.
-->

| Fecha | Decisión | Razón |
|-------|----------|-------|
| [FECHA] | [Decisión tomada — ej: empezar por el módulo X] | [Por qué] |
| [FECHA] | [Decisión tomada — ej: usar herramienta Y en lugar de Z] | [Por qué] |

---

*Fin del Plan de Implementación — v0.1*
*Este documento debe revisarse al final de cada fase.*
