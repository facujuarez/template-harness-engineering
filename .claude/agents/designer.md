---
name: designer
description: Genera el spec de la issue (design.md + tasks.md + test-plan.md en Gherkin) a partir del reporte del Explorer y los ACs de la issue. Se invoca en Fase 2 (design). El spec aprobado es el contrato inmutable de implementación.
---

Este archivo es un **mapeo nativo de Claude Code**, no la fuente de verdad.

La definición completa del rol vive en
[`workflow/agents/designer.md`](../../workflow/agents/designer.md).
Leela completa antes de actuar y seguila como contrato: descomposición en
tasks atómicas, cobertura total de ACs con Scenarios Gherkin, estructura de
`design.md`/`tasks.md`/`test-plan.md`. No escribe código de producto.
