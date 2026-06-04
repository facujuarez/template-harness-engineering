# [Nombre del Proyecto] — Modelo de Datos

| Campo | Detalle |
|-------|---------|
| **Proyecto** | [COMPLETAR] |
| **Tipo** | Base de datos |
| **Estado** | Borrador |
| **Autor** | [COMPLETAR] |
| **Última actualización** | [FECHA] |

---

## Historial de versiones

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 0.1 | [FECHA] | Versión inicial. Modelo completo. |

---

## 1. Diagrama de entidades

```
[Entidad1] (1) ────────────────────── (N) [Entidad2]
     │                                        │
     └──── (N) [Entidad3] ──── (N) ───────────┘
                   │            (via [tabla_relacion])
                   │
                   ├──── (N) [Entidad4]
                   │     (via [tabla_relacion])
                   │
                   └──── (N) [Entidad5]
                         (via [tabla_relacion])


[EntidadUsuario] (1) ──── (N) [TablaRelacionUsuario] ──── (1) [Entidad2]
     │
     ├──── (N) [EntidadFavoritos] ──── (1) [Entidad3]
     │
     └──── (N) [EntidadPreferencias] ──── (1) [Entidad4]

[Completar con el diagrama real de entidades del sistema]
```

---

## 2. Entidades

<!--
  Documentar cada tabla de la base de datos con sus columnas, tipos y constraints.
  Ordenar de mayor a menor dependencia (entidades base primero, relaciones al final).
-->

### 2.1 `[nombre_tabla]`

[Descripción de qué representa esta entidad en el dominio del sistema]

| Columna | Tipo | Nulable | Descripción |
|---------|------|---------|-------------|
| `id` | `uuid` | NO | PK, generado en BD |
| `[columna_1]` | `varchar([N])` | NO | [descripción] |
| `[columna_2]` | `varchar([N])` | SÍ | [descripción] |
| `[columna_enum]` | `varchar([N])` | NO | `[valor1]` / `[valor2]` / `[valor3]` |
| `[columna_bool]` | `boolean` | NO | [descripción]. Default: `[valor]` |
| `[columna_num]` | `numeric([p],[s])` | SÍ | [descripción] |
| `created_at` | `timestamptz` | NO | Fecha de creación |
| `updated_at` | `timestamptz` | NO | Última modificación |

**Constraints:**

- `UNIQUE ([columna])`

---

### 2.2 `[nombre_tabla]`

[Descripción]

| Columna | Tipo | Nulable | Descripción |
|---------|------|---------|-------------|
| `id` | `uuid` | NO | PK |
| `[fk_columna]` | `uuid` | NO | FK → `[tabla_referenciada].id` |
| `[columna]` | `varchar([N])` | NO | [descripción] |
| `[columna]` | `[tipo]` | SÍ | [descripción] |
| `created_at` | `timestamptz` | NO | Fecha de creación |
| `updated_at` | `timestamptz` | NO | Última modificación |

---

### 2.3 `[nombre_tabla]`

[Descripción]

| Columna | Tipo | Nulable | Descripción |
|---------|------|---------|-------------|
| `id` | `uuid` | NO | PK |
| `[columna]` | `[tipo]` | [SÍ/NO] | [descripción] |
| `[columna_array]` | `varchar([N])[]` | NO | Array: `[valor1]`, `[valor2]`. Default: `{}` |
| `created_at` | `timestamptz` | NO | Fecha de creación |

**Constraints:**

- `UNIQUE ([columna])`

**Notas:**

- [`needs_review` u otro campo especial]: se activa cuando [condición 1], [condición 2].

---

<!--
  Agregar sección 2.N para cada entidad del sistema.
  Incluir también las tablas de relación N:M con su PK compuesta.
-->

### 2.N `[nombre_tabla_relacion]`

[Tabla de relación N:M entre [EntidadA] y [EntidadB]]

| Columna | Tipo | Nulable | Descripción |
|---------|------|---------|-------------|
| `[entidad_a_id]` | `uuid` | NO | FK → `[tabla_a].id` |
| `[entidad_b_id]` | `uuid` | NO | FK → `[tabla_b].id` |
| `[columna_adicional]` | `varchar([N])` | SÍ | [dato adicional de la relación] |

**Constraints:**

- `PRIMARY KEY ([entidad_a_id], [entidad_b_id])`

---

## 3. Índices

```sql
-- Búsqueda principal (query más frecuente del sistema)
CREATE INDEX ix_[tabla]_[columnas]
  ON [tabla] ([columna1], [columna2]);

-- Filtro por [criterio]
CREATE INDEX ix_[tabla]_[columna]
  ON [tabla] ([columna], status);

-- Full-text search en [tabla]
CREATE INDEX ix_[tabla]_fts
  ON [tabla] USING GIN (
    to_tsvector('[idioma]', coalesce([columna_titulo], '') || ' ' || coalesce([columna_desc], ''))
  );

-- Filtro por array ([columna] de tipo array)
CREATE INDEX ix_[tabla]_[columna]_gin
  ON [tabla] USING GIN ([columna]);

-- Lookup único (login, registro, identificación externa)
CREATE UNIQUE INDEX ix_[tabla]_[columna_unica]
  ON [tabla] ([columna]);

-- Índice parcial (solo registros que cumplen una condición)
CREATE INDEX ix_[tabla]_[nombre]
  ON [tabla] ([columna1], [columna2])
  WHERE [condicion] = true;

-- Join frecuente
CREATE INDEX ix_[tabla_relacion]_[fk_columna]
  ON [tabla_relacion] ([fk_columna]);
```

---

## 4. Estrategia de cache

| Key pattern | TTL | Contenido | Invalidación |
|-------------|-----|-----------|--------------|
| `[recurso]:all` | [ej: 24h] | [Lista completa de X] | [Manual / post-operación] |
| `[recurso]:[id]` | [ej: 6h] | [Detalle de X por ID] | [Post-actualización] |
| `user:[id]:[recurso]` | [ej: 1h] | [Datos personalizados del usuario] | [Post-cambio en perfil / recurso] |

---

## 5. Migraciones planificadas

<!--
  Registrar aquí las migraciones a medida que se generan.
  Usar nombres descriptivos con fecha como prefijo.
-->

| Nombre | Contenido | Fase |
|--------|-----------|------|
| `[YYYYMMDD]_InitialCreate` | Todas las entidades del modelo completo | Fase 0 |
| `[YYYYMMDD]_Seed[Entidad]` | Datos iniciales de [entidad] | Fase 0 |

> Las migraciones posteriores se registran aquí a medida que se generan.

---

## 6. Decisiones de diseño

<!--
  Documentar las decisiones importantes sobre el esquema de datos:
  qué se eligió, las alternativas descartadas y por qué.
  Esto evita que futuros cambios deshagan decisiones ya consideradas.
-->

### UUIDs como PKs

[Explicar si se usan UUIDs o bigint autoincremental, y por qué. Ej: UUIDs para evitar enumeración de recursos en la API y permitir generación de IDs sin round-trip a la BD]

### [Decisión sobre tipos de datos — ej: arrays vs tablas de relación]

[Explicar por qué se eligió almacenar ciertos datos como array nativo vs una tabla separada]

### [Decisión sobre normalización]

[Explicar el nivel de normalización elegido y los trade-offs]

### [Decisión sobre la tabla de tokens / sesiones]

[Si existe una tabla de refresh tokens u otra tabla de seguridad, explicar por qué se diseñó así y qué alternativas se descartaron]

### [Decisión N — título descriptivo]

[...]

---

*Este documento debe actualizarse cada vez que se genera una nueva migración o se modifica el schema.*
