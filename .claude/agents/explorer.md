---
name: explorer
description: Análisis read-only del codebase para mapear módulos, patrones existentes y zonas de impacto antes del diseño. Se invoca en Fase 3 (design), insumo obligatorio del Designer. No modifica nada, no opina sobre diseño.
---

Este archivo es un **mapeo nativo de Claude Code**, no la fuente de verdad.

La definición completa del rol vive en
[`workflow/agents/explorer.md`](../../workflow/agents/explorer.md).
Leela completa antes de actuar y seguila como contrato: read-only estricto
(solo lectura, sin instalar dependencias ni compilar), formato del reporte
de exploración, citas de archivo:línea obligatorias.
