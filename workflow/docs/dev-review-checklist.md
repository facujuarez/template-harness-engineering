# Dev Review Checklist — Fase 5

> Revisión manual en entorno local antes de crear la PR.
> Esta fase es intencional y no puede ser automatizada.
> Copia este checklist al log de sesión o al comentario de la issue al completarla.

---

## Issue: #[N] — [Título]
**Branch:** [branch]  
**Fecha de revisión:** [fecha]

---

## ✅ Funcionalidad principal

- [ ] La feature funciona end-to-end en el flujo principal (happy path)
- [ ] El comportamiento coincide con el objetivo de la issue:
      *"Permitir que [usuario] pueda [acción] para [beneficio]"*
- [ ] La UI (si aplica) es clara e intuitiva para el usuario objetivo
- [ ] Los mensajes de error son comprensibles para el usuario final

---

## 📐 Criterios de aceptación

<!-- Copia los ACs de la issue y márcalos manualmente -->

- [ ] AC1: [descripción]
- [ ] AC2: [descripción]
- [ ] AC3: [descripción]

---

## 🔍 Edge cases

- [ ] ¿Qué pasa con datos vacíos o nulos?
- [ ] ¿Qué pasa con volúmenes grandes de datos?
- [ ] ¿Qué pasa si el usuario no tiene permisos?
- [ ] ¿Qué pasa si falla la conexión o un servicio externo?
- [ ] ¿Hay casos de concurrencia que considerar?

---

## 🚫 Regresiones

- [ ] Las funcionalidades adyacentes al área modificada siguen funcionando
- [ ] No hay errores en la consola del browser (si aplica)
- [ ] No hay warnings nuevos en los logs de la aplicación
- [ ] El build de producción (si se puede probar) está limpio

---

## ⚡ Performance (si aplica)

- [ ] Los tiempos de carga/respuesta son aceptables
- [ ] No hay llamadas redundantes a APIs o base de datos
- [ ] Si hay listados, la paginación funciona correctamente

---

## 📱 Compatibilidad (si aplica)

- [ ] Funciona en los browsers objetivo
- [ ] Funciona en mobile (si el producto lo requiere)
- [ ] Funciona con diferentes tamaños de pantalla (si aplica)

---

## 🔐 Seguridad (revisión básica)

- [ ] No se exponen datos sensibles en logs o en la UI
- [ ] Las validaciones de permisos funcionan correctamente
- [ ] Los inputs del usuario están validados

---

## 📝 Resultado de la revisión

**Decisión:**  
[ ] ✅ Aprobado — listo para `/create-pr`  
[ ] ⚠️ Aprobado con observaciones — documentadas abajo  
[ ] ❌ Requiere correcciones — volver a `/implement`

**Observaciones:**
[notas de la revisión manual]
