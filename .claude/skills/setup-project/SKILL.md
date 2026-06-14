# setup-project

**Skill para configurar el proyecto: documentación + backlog en GitHub.**

---

## Qué hace

Ejecuta el agente `Project Manager` definido en
[workflow/agents/project-manager.md](../../workflow/agents/project-manager.md).

Su responsabilidad (Fase 0b):
- Verifica que la Fase 0a (harness configurado) está completa
- Conduce entrevista guiada: `docs/functional.md`, `docs/architecture.md`,
  `docs/data-model.md`, `docs/project-plan.md`
- Genera `README.md` del proyecto
- Crea Milestones e Issues en GitHub basado en `docs/project-plan.md`
- Inicializa `feature_list.json`

---

## Cómo usar

```
/setup-project
```

O solo completar documentos sin crear backlog:
```
/setup-project docs
```

O solo generar backlog si `docs/` ya está completo:
```
/setup-project backlog
```

---

## Antes de ejecutar

✓ Completaste Fase 0a: ejecutaste `/init-harness [tu-harness]`

El Project Manager verificará que:
- `./init.sh` pasó
- `AGENTS.md` tiene valores (no placeholders)
- `feature_list.json` es válido
- Capa provider-specific existe (`.claude/`, `.cursor/`, etc.)

---

## Durante la ejecución

El PM te hará preguntas sobre:

1. **docs/functional.md** — ¿Qué es tu proyecto?
   - Visión y propuesta de valor
   - Usuarios y casos de uso
   - Requerimientos funcionales y no-funcionales
   - Riesgos y limitaciones

2. **docs/architecture.md** — ¿Cómo se construye?
   - Stack tecnológico
   - Diseño arquitectónico
   - Comandos de build, test, lint
   - Decisiones técnicas importantes

3. **docs/data-model.md** — ¿Qué datos maneja?
   - Entidades principales
   - Relaciones
   - Índices y estrategia de cache

4. **docs/project-plan.md** — ¿Cuáles son las fases?
   - Fases del proyecto
   - Tareas por fase
   - Plazos (si aplica)
   - Criterios de éxito

**Técnica:**
- Máx. 4 preguntas por ronda
- Muestra preview antes de escribir
- Espera tu aprobación

---

## Después de ejecutar

Una vez que termina:

```
✓ docs/ completados y aprobados
✓ README.md generado
✓ Milestones creados en GitHub (Fase 1, Fase 2, ...)
✓ Issues creadas y asignadas a Milestones
✓ feature_list.json inicializado
✓ Proyecto 100% listo para ciclo por issue
```

Luego:
```
/start-issue [N]  → inicia la Fase 1 con una issue del backlog
```

---

## Archivos que se generan/actualizan

- `docs/functional.md` (completado)
- `docs/architecture.md` (completado)
- `docs/data-model.md` (completado)
- `docs/project-plan.md` (completado)
- `README.md` (generado, proyecto-específico)
- `feature_list.json` (actualizado con todas las issues)
- GitHub Milestones (creados)
- GitHub Issues (creadas, en Backlog)

---

## Referencia

- **Agent:** [Project Manager](../../workflow/agents/project-manager.md)
- **Setup completo:** [workflow/SETUP.md](../../workflow/SETUP.md)
- **Workflow reference:** [workflow/WORKFLOW-REFERENCE.md](../../workflow/WORKFLOW-REFERENCE.md)
