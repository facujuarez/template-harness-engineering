# Sistema de Niveles de Workflow

> El nivel determina qué fases se ejecutan y si se usan subagents paralelos.
> Se detecta automáticamente en `/start-issue` según el tamaño (label `size:*`).

---

## Referencia de niveles

### Level 0 — Cambio ligero (XS, S)

**Cuándo:** Issues pequeñas y acotadas. El diseño es obvio, el riesgo es bajo.

**Fases activas:**
```
/new-issue → /start-issue → /enrich-issue → /implement → /commit → /create-pr
```

**Qué se omite:**
- `/design` — las tasks se definen inline en `enrich-issue`
- `/verify` formal — se sustituye por el pre-commit hook que corre en Fase 7 (`/commit`)
- `specs/issue-N/design.md` y `test-plan.md` — no se generan

**Cuándo NO usar L0 aunque el tamaño sea XS/S:**
- Si la issue afecta lógica de negocio crítica
- Si afecta autenticación, seguridad o permisos
- Si modifica contratos de API existentes

---

### Level 1 — Feature completa (M)

**Cuándo:** El trabajo tiene múltiples pasos, requiere decisiones de diseño
y afecta al menos un módulo del sistema.

**Fases activas:**
```
/new-issue → /start-issue → /enrich-issue → /design → /implement → /verify → [manual] → /commit → /create-pr
```

**Subagents activos (secuencial):**
- `codebase-explorer` → explora codebase antes del diseño
- `design-agent` → genera spec completo
- `implement-agent` → ejecuta cada task (sin commits)
- `verify-agent` → verifica cobertura y genera reporte

---

### Level 2 — Feature grande o compleja (L, XL)

**Cuándo:** La issue tiene alto impacto, múltiples áreas afectadas, o el
diseño requiere exploración profunda del codebase.

**Fases activas:** Igual que L1 (`/enrich-issue` incluido) pero con paralelismo en Design (Fase 3) y Verify (Fase 5).

**Design (paralelo):**
```
codebase-explorer  →─┐
                      ├→ design-agent (consolida y genera spec)
[análisis de ADRs] →─┘
```

**Verify (paralelo):**
```
verify-agent (ACs + build + tests)  →─┐
verify-parallel (seguridad + perf)  →─┤→ consolidación + reporte final
verify-parallel (integración)       →─┘
```

**Cuándo dividir una L/XL en múltiples M:**
- Si tiene más de 8 tasks en el spec
- Si afecta más de 3 módulos independientes
- Si tiene dependencias internas entre partes del trabajo

---

## Tabla de decisión rápida

| Condición | Nivel recomendado |
|-----------|-------------------|
| Cambio de copy, config, estilos menores | L0 |
| Bugfix acotado a un archivo/función | L0 |
| Nueva UI sin lógica compleja | L0/L1 |
| Nuevo endpoint o componente con lógica | L1 |
| Feature con integración de servicios externos | L1/L2 |
| Feature cross-cutting (auth, permisos, logging) | L2 |
| Refactor de módulo completo | L2 |
| Epic que debería dividirse | Divide en M's |

---

## Qué archivos genera cada nivel

| Archivo | L0 | L1 | L2 |
|---------|----|----|-----|
| `specs/active-issue.md` | ✅ | ✅ | ✅ |
| `specs/issue-N/tasks.md` | ✅ (inline) | ✅ | ✅ |
| `specs/issue-N/design.md` | ❌ | ✅ | ✅ |
| `specs/issue-N/api-contract.md` | ❌ | si aplica | si aplica |
| `specs/issue-N/test-plan.md` | ❌ | ✅ | ✅ |
| `specs/issue-N/verification-report.md` | ❌ | ✅ | ✅ |
