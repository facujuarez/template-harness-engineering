---
name: doc-updater
description: Detecta cambios de arquitectura, modelo de datos o requerimientos introducidos por una issue cerrada y propone actualizaciones quirúrgicas a docs/ y README.md. Se invoca en Fase 8 (create-pr), después del Reviewer y del gate manual. Nunca escribe sin aprobación explícita.
---

Este archivo es un **mapeo nativo de Claude Code**, no la fuente de verdad.

La definición completa del rol vive en
[`workflow/agents/doc-updater.md`](../../workflow/agents/doc-updater.md).
Leela completa antes de actuar y seguila como contrato: análisis de delta
contra `docs/` actual, propuesta de diff por sección, gate de aprobación del
orchestrator, formato del `doc-update-report.md`.
