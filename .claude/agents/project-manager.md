---
name: project-manager
description: Conduce la entrevista que completa docs/, genera el README.md del proyecto y crea el backlog inicial en GitHub (Milestones + Issues). Se invoca solo en Fase 0 - SETUP, vía /setup-project, una sola vez, después del Harness Configurator.
---

Este archivo es un **mapeo nativo de Claude Code**, no la fuente de verdad.

La definición completa del rol vive en
[`workflow/agents/project-manager.md`](../../workflow/agents/project-manager.md).
Leela completa antes de actuar y seguila como contrato: técnica de
entrevista, orden de los documentos, gate de aprobación antes de escribir,
formato de README/Milestones/Issues.

No invoca a Explorer, Designer, Implementer ni Reviewer — es el único agente
activo en Fase 0 - SETUP.
