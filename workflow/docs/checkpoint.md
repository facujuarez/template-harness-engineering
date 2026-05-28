# Checkpoint — Cierre de sesión

> Checklist propiedad del [[reviewer]] (`workflow/agents/reviewer.md`). Se recorre **al
> final** de la Fase 4 y al cerrar sesión. El reviewer marca `[x]` con
> evidencia, `[ ]` si no verifica, o `[~]` si el orchestrator justificó que
> no aplica para esta issue.
>
> **Regla bloqueante:** si al cierre de sesión queda algún `[ ]` sin
> justificación, el reviewer **rechaza el cierre** y devuelve la lista de
> pendientes al [[orchestrator]].
>
> Al cerrar issue, copiar este archivo a `workflow/specs/checkpoint-<N>.md` y
> resetear este template a todos `[ ]` para la próxima sesión.

---

**Issue:** #<N>
**Branch:** <feature/N-slug>
**Nivel:** <L0 | L1 | L2>
**Fecha cierre:** <YYYY-MM-DD>
**Reviewer:** <agent run id / nombre>

---

## 1. Spec y alcance

- [ ] Existe `workflow/specs/issue-<N>/design.md` aprobado.
- [ ] Existe `workflow/specs/issue-<N>/tasks.md`.
- [ ] Existe `workflow/specs/issue-<N>/test-plan.md`.
- [ ] Todas las tasks en `tasks.md` están marcadas `[x]`.
- [ ] No hay scope creep: los cambios en git diff coinciden con archivos del spec.

## 2. Acceptance Criteria

- [ ] Cada AC de la Issue tiene al menos un test asociado en `test-plan.md`.
- [ ] Cada test asociado existe en el repo (verificado por path).
- [ ] Cada test asociado pasa al correrlo.
- [ ] Ningún AC quedó sin verificar.

## 3. Build, lint, tests

- [ ] `build` corre sin errores (comando: ver `workflow/docs/tech-stack.md`).
- [ ] `lint` corre sin errores ni warnings ignorados sin justificación.
- [ ] Test suite completa pasa. Sin tests skipped sin justificación.
- [ ] Pre-commit hook se ejecutó en cada commit (no se usó `--no-verify`).

## 4. Calidad de código

- [ ] No hay `any` en TypeScript / cero warnings de nullable en C#.
- [ ] No hay secrets, connection strings ni credenciales hardcoded.
- [ ] No hay comentarios redundantes (solo "por qué" no obvio).
- [ ] No se introdujeron abstracciones especulativas.
- [ ] Naming consistente con las convenciones del proyecto.

## 5. Estado sincronizado

- [ ] `feature_list.json` refleja el nuevo estado de la feature.
- [ ] `workflow/specs/active-issue.md` está actualizado.
- [ ] `workflow/specs/project-memory.md` actualizado si hubo aprendizajes
      reutilizables.

## 6. Documentación

- [ ] El spec (`design.md`) documenta las decisiones no obvias.
- [ ] Si se introdujeron nuevos comandos / scripts / convenciones, están
      documentados en `workflow/docs/` correspondiente.
- [ ] Si se cambió la estructura del repo, `workflow/docs/tech-stack.md` se
      actualizó.

## 7. Listo para PR

- [ ] Branch al día con `develop` (o `main`, según convenciones del proyecto).
- [ ] Commit history limpio: commits atómicos, mensajes en imperativo en inglés.
- [ ] Sin archivos generados accidentales (build output, `.env`, etc.).
- [ ] `gh pr create` se ejecutará desde la branch correcta.

---

## Pendientes

> Si quedó algún `[ ]` arriba, detallar aquí qué falta y a quién se devuelve.

- _vacío_

---

## Justificaciones de `[~]` (no aplica)

> Marcar `[~]` solo con autorización explícita del orchestrator y justificar aquí.

- _vacío_

---

## Aprobación final del reviewer

- [ ] Todos los items arriba están en `[x]` o `[~]` con justificación.
- [ ] Reporte de verificación entregado al orchestrator.
- [ ] Copia histórica creada en `workflow/specs/checkpoint-<N>.md`.
- [ ] Este archivo reseteado a estado template para la próxima sesión.
