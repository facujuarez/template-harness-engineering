# Definition of Ready

> Una Issue está "Ready" cuando cumple TODOS estos criterios.
> El skill `/new-issue` verifica esto antes de mover a Ready.
> El skill `/start-issue` advierte si una issue no cumple el DoR.

---

## Contenido mínimo obligatorio

- [ ] **Título claro** — describe la funcionalidad, no es genérico ("Mejoras UI" ❌, "Añadir filtro por fecha en listado de facturas" ✅)
- [ ] **Contexto de negocio** — explica por qué existe esta issue
- [ ] **Objetivo en formato correcto** — "Permitir que [usuario] pueda [acción] para [beneficio]"
- [ ] **Al menos 2 criterios de aceptación** — testeables e independientes entre sí
- [ ] **Out of scope definido** — al menos una línea de qué NO incluye

## Criterios de aceptación válidos

Cada AC debe ser:
- [ ] **Verificable:** se puede saber sin ambigüedad si se cumple o no
- [ ] **Independiente:** no depende de que otro AC se haya verificado primero
- [ ] **Con verbo de comportamiento:** "El sistema...", "El usuario puede...", "Al hacer X ocurre Y"

## Técnico

- [ ] **Sin dependencias bloqueantes sin resolver** — si depende de otra issue, esa debe estar en Done o en PR
- [ ] **Stack implicado coherente** — los componentes mencionados existen en el proyecto
- [ ] **Decisiones de arquitectura no triviales señaladas** — no resueltas, solo señaladas

## Tamaño

- [ ] **Estimación asignada** (XS/S/M/L/XL)
- [ ] **Si es L o XL:** se ha evaluado si dividir. Si se decide no dividir, hay justificación.

## Proceso

- [ ] **Label de tipo asignado:** `type:feature` / `type:bug` / `type:chore` / `type:spike`
- [ ] **Añadida al GitHub Project**

---

## Referencia rápida de tamaños

| Tamaño | Descripción | Tiempo estimado |
|--------|-------------|-----------------|
| XS | Cambio puntual y acotado (config, copy, estilo menor) | < 2h |
| S | Feature pequeña o bugfix con impacto limitado | 2h - 1 día |
| M | Feature completa con diseño, implementación y tests | 1-3 días |
| L | Feature grande o con impacto cross-cutting | 3-5 días |
| XL | Epic — debería dividirse en múltiples issues | > 1 semana |
