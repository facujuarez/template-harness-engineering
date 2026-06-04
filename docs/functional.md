# [Nombre del Proyecto] — Análisis Funcional y Especificación de Requerimientos

> **Versión:** 0.1
> **Fecha:** [COMPLETAR]
> **Autor:** [COMPLETAR]

---

## Historial de Cambios

| Versión | Fecha | Descripción |
|---------|-------|-------------|
| 0.1 | [FECHA] | Versión inicial. |

---

## 1. Nombre y Visión del Producto

**Nombre:** [COMPLETAR]

**Tagline:** *"[Frase corta que resume el valor del producto]"*

**Visión:** [Describe el producto en 2-3 frases. ¿Qué problema resuelve? ¿Para quién? ¿Qué lo diferencia?]

---

## 2. Problema que Resuelve

[Describe el problema de negocio o de usuario que motiva este producto. ¿Por qué existe? ¿Qué pasa hoy sin esta solución?]

- [Punto de dolor 1]
- [Punto de dolor 2]
- [Punto de dolor 3]

---

## 3. Objetivos del Proyecto

1. [Objetivo principal]
2. [Objetivo secundario]
3. [...]

---

## 4. Alcance Inicial (MVP)

El MVP contempla:

- [Feature principal 1]
- [Feature principal 2]
- [...]

Fuera de alcance para MVP:

- [Feature diferida 1]
- [Feature diferida 2]

---

## 5. Usuarios Objetivo

### Perfil primario — "[Nombre del perfil]"

[Descripción: edad, contexto, necesidad principal, comportamiento esperado con el sistema]

### Perfil secundario — "[Nombre del perfil]"

[Descripción]

### Perfil terciario — "[Nombre del perfil]" *(si aplica)*

[Descripción]

---

## 6. Requerimientos Funcionales

<!--
  Organizar los RF por módulo o área funcional.
  Cada RF debe ser verificable: evitar "el sistema debe ser rápido",
  preferir "el sistema debe responder en menos de 1 segundo bajo carga normal".
-->

### RF-01 — [Nombre del módulo o área funcional]

| ID | Requerimiento |
|----|---------------|
| RF-01.1 | [COMPLETAR] |
| RF-01.2 | [COMPLETAR] |
| RF-01.3 | [COMPLETAR] |

### RF-02 — [Nombre del módulo o área funcional]

| ID | Requerimiento |
|----|---------------|
| RF-02.1 | [COMPLETAR] |
| RF-02.2 | [COMPLETAR] |

### RF-03 — [Nombre del módulo o área funcional]

| ID | Requerimiento |
|----|---------------|
| RF-03.1 | [COMPLETAR] |

<!--
  Agregar secciones RF-0N según la cantidad de módulos del sistema.
  Referencia de módulos en la sección 8.
-->

---

## 7. Requerimientos No Funcionales

### RNF-01 — Rendimiento

- [Tiempos de respuesta esperados bajo carga normal]
- [Throughput o volumen de operaciones esperado]

### RNF-02 — Disponibilidad

- [SLA de disponibilidad mensual: ej. 99%]
- [Política de mantenimiento y ventanas permitidas]

### RNF-03 — Escalabilidad

- [Rango de usuarios o volumen de datos que debe soportar sin cambios estructurales]
- [Puntos de escala críticos a considerar desde el diseño]

### RNF-04 — Seguridad

- [Requisitos de autenticación y autorización]
- [Estándares o regulaciones de seguridad aplicables]
- [Protección de datos sensibles]

### RNF-05 — Privacidad

- [Datos personales que se procesan y base legal]
- [Regulaciones de privacidad aplicables]
- [Datos que NO deben almacenarse]

### RNF-06 — Usabilidad

- [Métricas de experiencia de usuario (ej: onboarding en menos de N minutos)]
- [Soporte de modos de visualización (claro/oscuro)]
- [Estándares de accesibilidad (ej: WCAG AA)]

### RNF-07 — Mantenibilidad

- [Cobertura de tests mínima en lógica de negocio crítica]
- [Criterios de calidad de código]
- [Independencia de módulos para facilitar cambios]

---

## 8. Módulos Principales

<!--
  Describir las grandes áreas funcionales del sistema.
  Estos módulos se corresponden con las secciones RF-0N de la sección 6.
-->

### Módulo 1 — [Nombre]

[Descripción del módulo: responsabilidades, límites, dependencias con otros módulos]

### Módulo 2 — [Nombre]

[Descripción]

### Módulo 3 — [Nombre]

[Descripción]

<!--
  Agregar módulos según la arquitectura del sistema.
-->

---

## 9. Entidades Principales

<!--
  Listar las entidades del dominio con sus atributos principales.
  No es necesario incluir todos los campos técnicos (ej: timestamps);
  enfocarse en los atributos de negocio. El detalle completo de DB está en data-model.md.
-->

### Entidad: `[NombreEntidad]`

[Descripción breve: qué representa esta entidad en el dominio]

| Atributo | Tipo | Descripción |
|----------|------|-------------|
| id | UUID | Identificador único |
| [atributo] | [tipo] | [descripción] |
| createdAt | datetime | Fecha de creación |

### Entidad: `[NombreEntidad]`

[Descripción]

| Atributo | Tipo | Descripción |
|----------|------|-------------|
| id | UUID | Identificador único |
| [atributo] | [tipo] | [descripción] |

<!--
  Repetir para cada entidad principal del dominio.
-->

---

## 10. Casos de Uso

<!--
  Documentar los flujos de valor principales del sistema.
  Cada CU describe una interacción completa que produce un resultado de valor para el actor.
  Incluir flujos alternativos para las variantes más relevantes.
-->

### CU-01 — [Nombre del caso de uso]

**Actor:** [Quién inicia la acción]
**Precondición:** [Qué debe ser verdad antes de que comience el flujo. "Ninguna" si no aplica.]

**Flujo:**

1. [Paso 1: acción del actor]
2. [Paso 2: respuesta del sistema]
3. [...]

**Flujo alternativo — [descripción del escenario alternativo]:**

- [Descripción del paso donde diverge]
- [Resolución del flujo alternativo]

**Resultado:** [Qué logra el actor al finalizar el flujo exitosamente]

---

### CU-02 — [Nombre del caso de uso]

**Actor:** [COMPLETAR]
**Precondición:** [COMPLETAR]

**Flujo:**

1. [COMPLETAR]

**Resultado:** [COMPLETAR]

---

<!--
  Agregar CU-0N para cada caso de uso del sistema.
  Los CU deben cubrir todos los RF documentados en la sección 6.
-->

---

## 11. Restricciones y Supuestos

**Restricciones:**

- [Limitación técnica, legal o de negocio que condiciona el diseño]
- [...]

**Supuestos:**

- [Premisa que se asume verdadera para el diseño y que, si cambia, impacta el sistema]
- [...]

---

## 12. Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|------------|
| [Riesgo 1] | Alta / Media / Baja | Alto / Medio / Bajo | [Acción de mitigación] |
| [Riesgo 2] | Alta / Media / Baja | Alto / Medio / Bajo | [Acción de mitigación] |

---

*Fin del Documento de Análisis Funcional — v0.1*
