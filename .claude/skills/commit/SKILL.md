---
name: commit
description: Consolida todos los cambios del branch en un único commit, corre el pre-commit hook (build + lint) y hace push a GitHub. Usar cuando el usuario pide /commit, después del gate manual (Fase 6) y antes de /create-pr.
---

**Fase:** 7 · **Rol invocado:** [orchestrator](../../../workflow/agents/orchestrator.md)

## Cómo ejecutar

1. Leé `workflow/specs/active-issue.md` para el nivel, branch y tipo de issue.
2. Verificá que todas las tasks están en `[x]` en tasks.md (o active-issue.md en L0).
3. Mostrá el `git status` + `git diff` al usuario para revisar los cambios.
4. Proponé un mensaje de commit siguiendo `workflow/docs/workflow-conventions.md`.

**Gate:** aprobación explícita del mensaje de commit antes de ejecutar nada.

5. Ejecutá `git add` + `git commit` (el pre-commit hook corre build + lint automáticamente).
   Si el hook falla: mostrá el error, corregí y reintentá. Nunca `--no-verify`.
6. Ejecutá `git push origin {branch}`.
7. Indicá el siguiente paso: `/create-pr`.
