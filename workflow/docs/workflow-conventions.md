# Workflow Conventions

> Convenciones del proyecto para branches, commits y PRs.
> El agente IA las lee al crear branches, hacer commits y generar PRs.

---

## Branches

### Formato
```
{tipo}/issue-{N}-{slug}
```

### Tipos
| Tipo | Cuándo usar |
|------|-------------|
| `feature` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `chore` | Tarea técnica sin valor funcional directo (actualizar deps, refactor, config) |
| `spike` | Investigación o prueba de concepto |
| `docs` | Solo documentación |

### Reglas del slug
- Lowercase siempre
- Palabras separadas por guiones (`-`)
- Máximo 5-6 palabras
- Sin artículos ni preposiciones innecesarias
- Debe ser legible como descripción corta de la feature

### Ejemplos
```
feature/issue-42-export-reporte-ventas-pdf
fix/issue-87-error-login-usuarios-externos
chore/issue-103-actualizar-sdk-graph
spike/issue-55-evaluar-libreria-pdf
```

### Base branch
- **Siempre desde `develop`**, nunca desde `main`
- Excepción: hotfixes críticos en producción → desde `main` con rama `hotfix/`

---

## Commits

### Formato (Conventional Commits)
```
{tipo}({scope}): {descripción en imperativo}

{cuerpo opcional — qué y por qué, no cómo}

Refs #N
```

### Tipos de commit
| Tipo | Cuándo usar |
|------|-------------|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `refactor` | Refactorización sin cambio funcional |
| `test` | Añadir o corregir tests |
| `chore` | Tareas de mantenimiento |
| `docs` | Solo documentación |
| `style` | Formato, espacios (sin cambio de lógica) |
| `build` | Cambios en build system o dependencias |

### Reglas
- **Descripción en imperativo:** "Añade X", "Corrige Y", "Elimina Z" (no "Añadido", "Corregido")
- **Scope:** nombre del módulo, componente o área afectada
- **Sin punto final** en la primera línea
- **Máximo 72 caracteres** en la primera línea
- **Siempre referencia la issue** con `Refs #N` o `Closes #N`

### Ejemplos
```
feat(reports): añade exportación a PDF en reporte de ventas

Implementa generación de PDF usando iTextSharp con branding corporativo.
El archivo se descarga directamente sin guardar en servidor.

Refs #42
```

```
fix(auth): corrige redirección incorrecta en login con SSO externo

Refs #87
```

---

## Pull Requests

### Título
```
{tipo}({issue-N}): {descripción concisa de la feature}
```

Ejemplos:
```
feat(issue-42): exportar reporte de ventas mensual a PDF
fix(issue-87): corregir redirección en login SSO externo
```

### Base branch
- **Siempre hacia `develop`**
- Solo el proceso de release hace merge de `develop` → `main`

### Labels de PR
- Mismos labels de tipo que la issue (`type:feature`, `type:bug`, etc.)
- `size:*` según el tamaño estimado de la issue

### Reglas
- PR debe estar **linkeada a la issue** con `Closes #N` en la descripción
- No se hace merge sin **CI/CD verde**
- No se hace merge sin **al menos una revisión** (o auto-aprobación documentada en proyectos en solitario)
- El **verification report** debe estar adjunto o referenciado en la PR

---

## Flujo de merge

```
feature/issue-N  →  develop  →  [staging review]  →  main  →  [PRO]
```

- `develop` → staging: automático vía CI/CD
- `main` → PRO: manual o gated por CI/CD
