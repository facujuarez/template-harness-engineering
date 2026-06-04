# [Nombre del Proyecto] — Diseño de Sistema y Arquitectura

> **Versión:** 0.1
> **Fecha:** [COMPLETAR]
> **Autor:** [COMPLETAR]

---

## Historial de Cambios

| Versión | Fecha | Descripción |
|---------|-------|-------------|
| 0.1 | [FECHA] | Versión inicial. |

---

## 1. Visión Técnica

[Describe en 3-5 puntos los principios y prioridades que guían la arquitectura. ¿Qué se optimiza: simplicidad, escalabilidad, costo, velocidad de desarrollo?]

- **[Principio 1]:** [descripción y por qué es prioritario]
- **[Principio 2]:** [descripción]
- **[Principio 3]:** [descripción]

---

## 2. Arquitectura General

```
┌──────────────────────────────────────────────────┐
│                    CLIENTES                      │
│                                                  │
│  ┌──────────────────┐   ┌──────────────────────┐ │
│  │   [Cliente 1]    │   │     [Cliente 2]      │ │
│  │  (ej: Web App)   │   │  (ej: Mobile App)    │ │
│  └────────┬─────────┘   └──────────┬───────────┘ │
└───────────┼──────────────────────  ┼─────────────┘
            └──────────┬─────────────┘
                       ▼
┌──────────────────────────────────────────────────┐
│                  API / GATEWAY                   │
│          [Tecnología — ej: API Management]       │
│         (Rate limiting · Auth · Routing)         │
└──────────────────────┬───────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────┐
│                 BACKEND CORE                     │
│                                                  │
│  ┌────────────────────────────────────────────┐  │
│  │          [Framework — ej: ASP.NET Core]    │  │
│  │                                            │  │
│  │  ┌──────────────┐  ┌──────────────────┐   │  │
│  │  │  [Servicio 1]│  │  [Servicio 2]    │   │  │
│  │  └──────────────┘  └──────────────────┘   │  │
│  └────────────────────────────────────────────┘  │
└──────────────────────┬───────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  [Base de    │ │    [Cache]   │ │  [Storage]   │
│    datos]    │ │  (ej: Redis) │ │  (ej: Blob)  │
└──────────────┘ └──────────────┘ └──────────────┘

[Completar y ajustar el diagrama según la arquitectura real del sistema]
```

---

## 3. Stack Tecnológico

### Backend

| Componente | Tecnología | Versión | Justificación |
|------------|------------|---------|---------------|
| API principal | [COMPLETAR] | [ver] | [Por qué se eligió] |
| ORM | [COMPLETAR] | [ver] | [Por qué se eligió] |
| Base de datos | [COMPLETAR] | [ver] | [Por qué se eligió] |
| Cache | [COMPLETAR] | [ver] | [Por qué se eligió] |
| Autenticación | [COMPLETAR] | [ver] | [Por qué se eligió] |
| Validación | [COMPLETAR] | [ver] | [Por qué se eligió] |
| Testing | [COMPLETAR] | [ver] | [Por qué se eligió] |

### Frontend

| Componente | Tecnología | Versión | Justificación |
|------------|------------|---------|---------------|
| Framework | [COMPLETAR] | [ver] | [Por qué se eligió] |
| UI Components | [COMPLETAR] | [ver] | [Por qué se eligió] |
| State Management | [COMPLETAR] | [ver] | [Por qué se eligió] |
| HTTP Client | [COMPLETAR] | [ver] | [Por qué se eligió] |

<!--
  Agregar secciones adicionales si el proyecto tiene capas extra:
  Mobile, Data Engine, Admin Panel, Workers, etc.
-->

### Infraestructura

| Componente | Tecnología |
|------------|------------|
| Cloud | [Proveedor — ej: Azure / AWS / GCP] |
| App hosting | [COMPLETAR] |
| CI/CD | [COMPLETAR] |
| Secrets | [COMPLETAR] |
| Monitoring | [COMPLETAR] |
| Logs | [COMPLETAR] |
| Storage | [COMPLETAR] |

---

## 4. Diseño de la API

### Convenciones

- **Protocolo:** [REST / GraphQL / gRPC]
- **Versionado:** [ej: URL `/api/v1/...` / Header]
- **Formato de respuesta:** [ej: JSON con envelope `{ data, meta, errors }`]
- **Autenticación:** [ej: Bearer Token (JWT) en header `Authorization`]
- **Paginación:** [ej: parámetros `page` y `pageSize`, default 20, max 100]

### Endpoints Principales

```
# [Módulo 1 — descripción]
[MÉTODO]  /api/v1/[recurso]               [descripción]
[MÉTODO]  /api/v1/[recurso]/:id           [descripción]

# [Módulo 2 — descripción]
[MÉTODO]  /api/v1/[recurso]               [descripción]

# [Módulo N — descripción]
[MÉTODO]  /api/v1/[recurso]               [descripción]
```

### Query Parameters para Filtrado *(si aplica)*

```
GET /api/v1/[recurso]?
  [param1]=[valor]
  [param2]=[valor]
  page=1
  pageSize=20
  orderBy=[criterio]
```

---

## 5. Modelo de Datos — Vista General

<!--
  Incluir el diagrama conceptual de entidades y sus relaciones.
  El detalle completo de columnas, índices y constraints está en data-model.md.
-->

```
[Entidad1] (1) ──────────────────── (N) [Entidad2]
     │                                       │
     └──── (N) [Entidad3] ──── (N) ──────────┘
                  │             (via [tabla_relacion])
                  │
                  └──── (N) [Entidad4]

[Completar con el diagrama de entidades del sistema]
```

### Estrategia de Cache

| Key pattern | TTL | Contenido | Invalidación |
|-------------|-----|-----------|--------------|
| `[patrón:id]` | [tiempo] | [qué contiene] | [cuándo se invalida] |
| `[patrón:all]` | [tiempo] | [qué contiene] | [cuándo se invalida] |

---

## 6. Autenticación y Seguridad

### Proveedores de Autenticación

| Proveedor | Flujo | Campo identificador |
|-----------|-------|---------------------|
| [ej: Email + contraseña] | [Registro y login propio] | `local` |
| [ej: Google OAuth 2.0] | [Login social] | `google` |

### Flujo de Autenticación Principal

```
[Describir el flujo paso a paso]

1. Cliente → [acción]
2. Sistema → [respuesta]
3. [...]
```

### Gestión de Tokens

```
Access Token:
- TTL: [duración]
- Contiene: [claims incluidos]
- Almacenamiento: [dónde se guarda en el cliente]

Refresh Token:
- TTL: [duración]
- Almacenamiento: [dónde se guarda en el cliente]
- Rotación: [política de rotación]
```

### Consideraciones de Seguridad

- [Consideración de seguridad 1]
- [Consideración de seguridad 2]
- **Rate limiting:** [política por endpoint]
- **CORS:** [configuración]
- **Headers de seguridad:** [lista de headers configurados]

---

## 7. Lineamientos de UI/UX

<!--
  Esta sección aplica principalmente si el proyecto incluye una capa de presentación propia.
  Si se usa un design system externo, referenciar en lugar de duplicar.
-->

### Principios de Diseño

1. **[Principio 1]:** [descripción y por qué es prioritario para este producto]
2. **[Principio 2]:** [descripción]
3. **[Principio 3]:** [descripción]

### Paleta de Colores

```
Primario:     #[hex]  ([nombre — uso principal])
Secundario:   #[hex]  ([nombre — CTAs, acciones])
Acento:       #[hex]  ([nombre — estados positivos])
Alerta:       #[hex]  ([nombre — advertencias])
Error:        #[hex]  ([nombre — errores, estados negativos])
Neutro claro: #[hex]
Fondo:        #[hex]  (light) / #[hex]  (dark)
```

### Tipografía

- **Familia:** [fuente principal]
- **Heading 1:** [tamaño] / [peso]
- **Heading 2:** [tamaño] / [peso]
- **Body:** [tamaño] / [peso]
- **Caption:** [tamaño] / [peso]
- **Tamaño mínimo interactivo:** [px]

### Componentes Clave

<!--
  Describir los componentes de UI más importantes del sistema,
  idealmente con un mockup ASCII que ilustre la estructura visual.
-->

#### [Nombre del componente principal]

```
┌────────────────────────────────────────────┐
│  [Mockup ASCII del componente]             │
│                                            │
└────────────────────────────────────────────┘
```

**Estados visuales:**
- **[Estado 1]:** [descripción visual]
- **[Estado 2]:** [descripción visual]

### Navegación

```
[Describir la estructura de navegación principal]

[Móvil — Tab Bar / Bottom Nav:]
├── [Sección 1]
├── [Sección 2]
└── [Sección N]

[Web — Header / Sidebar:]
├── [Sección 1]
└── [Sección N]
```

### Accesibilidad

- Contraste mínimo [WCAG AA / AAA] en todos los textos.
- Elementos interactivos con área táctil mínima de [44x44px].
- [Otro requisito de accesibilidad]

---

## 8. Estrategia de Despliegue

### Ambientes

| Ambiente | Propósito | Trigger |
|----------|-----------|---------|
| Development | Local del desarrollador | Manual |
| Staging | Validación pre-release | Push a `develop` |
| Production | Usuarios finales | Tag release en `main` |

### Pipeline CI/CD

```yaml
# Push a develop:
1. [Paso 1: ej. Build y test]
2. [Paso 2: ej. Build imagen Docker]
3. [Paso 3: ej. Deploy a staging]
4. [Paso 4: ej. Smoke test]

# Tag release:
1. [Mismos pasos anteriores]
2. [Paso adicional: ej. Deploy a production]
3. [Paso adicional: ej. Notificación de deploy]
```

### Infraestructura como Código *(si aplica)*

[Describir la herramienta IaC utilizada (Bicep, Terraform, CDK) y dónde se encuentra el código]

---

## 9. Observabilidad

### Métricas Clave a Monitorear

| Métrica | Umbral de alerta |
|---------|-----------------|
| API response time p95 | > [N]ms |
| Error rate | > [N]% en [N] minutos |
| [Métrica de negocio crítica] | [Umbral] |
| DB connection pool | > [N]% |
| [Métrica específica del sistema] | [Umbral] |

### Dashboards

- [Dashboard 1: qué monitorea]
- [Dashboard 2: qué monitorea]

---

## 10. Decisiones de Diseño y Trade-offs

<!--
  Documentar las decisiones técnicas importantes: qué se eligió, qué se descartó y por qué.
  Este registro ayuda a futuros colaboradores a entender el razonamiento sin tener que preguntar.
-->

### [Decisión 1 — título descriptivo]

[Explica la decisión tomada, las alternativas consideradas y la razón por la que se eligió esta opción sobre las demás]

### [Decisión 2 — título descriptivo]

[...]

### [Decisión N — título descriptivo]

[...]

---

*Fin del Documento de Diseño de Sistema — v0.1*
