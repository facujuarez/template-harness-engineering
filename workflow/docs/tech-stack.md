# Tech Stack

> ⚠️ Este archivo debe ser completado antes de usar el workflow.
> El agente IA lo lee para seguir las convenciones del proyecto
> y adaptar los comandos de build, test y lint correctamente.

---

## Stack principal

<!--
  Lista las tecnologías del proyecto con la versión o contexto relevante.
  
  Ejemplo (SPFx + .NET):
  - Frontend: SPFx 1.18 + React 17 + TypeScript 5
  - Backend: .NET 8 Web API + C#
  - ORM: Entity Framework Core 8
  - Cloud: Azure (App Service, Cosmos DB, Blob Storage)
  - Autenticación: MSAL / Azure AD
  - Graph API: Microsoft Graph SDK v5
-->

| Capa | Tecnología | Versión |
|------|-----------|---------|
| Frontend | [COMPLETAR] | [ver] |
| Backend | [COMPLETAR] | [ver] |
| Base de datos | [COMPLETAR] | [ver] |
| Cloud/Infraestructura | [COMPLETAR] | |
| Autenticación | [COMPLETAR] | |

---

## Comandos de proyecto

<!--
  CRÍTICO: el agente IA usa estos comandos en `verify` y `implement`.
  Asegúrate de que son correctos para tu proyecto.
-->

### Build
```bash
# [COMPLETAR — ejemplo:]
dotnet build --configuration Release
# o
npm run build
```

### Tests
```bash
# [COMPLETAR — ejemplo:]
dotnet test
# o
npx jest --coverage
# o
npx vitest run --coverage
```

### Lint
```bash
# [COMPLETAR — ejemplo:]
dotnet format --verify-no-changes
# o
npm run lint
# o
npx eslint src/ --ext .ts,.tsx
```

### Type check (si aplica)
```bash
# [COMPLETAR — ejemplo:]
npx tsc --noEmit
```

### Dev server (referencia, no lo usa el agente IA)
```bash
# [COMPLETAR — ejemplo:]
npm run serve
# o
dotnet run
```

---

## Estructura del proyecto

<!--
  Describe la estructura de directorios principal.
  Ayuda al agente IA a saber dónde crear/modificar archivos.
  
  Ejemplo:
  src/
  ├── webparts/          → SPFx web parts
  ├── components/        → Componentes React compartidos
  ├── hooks/             → Custom hooks
  ├── services/          → Lógica de negocio y llamadas a API
  ├── models/            → Tipos e interfaces TypeScript
  └── utils/             → Utilidades genéricas
  
  api/
  ├── Controllers/       → Controladores .NET
  ├── Services/          → Lógica de negocio
  ├── Models/            → DTOs y entidades
  └── Infrastructure/   → Repositorios, EF, etc.
-->

```
[COMPLETAR con la estructura real del proyecto]
```

---

## Convenciones de código

<!--
  Convenciones específicas que el agente IA debe seguir.
  
  Ejemplo:
  - Nombres de archivos: PascalCase para componentes (.tsx), camelCase para servicios (.ts)
  - Interfaces: prefijo 'I' solo en .NET (IUserService), sin prefijo en TypeScript
  - Estilos: CSS Modules (no inline styles, no styled-components)
  - Estado global: React Context + useReducer (no Redux)
  - Llamadas a API: siempre en /services, nunca directas desde componentes
  - Errores: todos los errores deben loguearse en ApplicationInsights
-->

### Naming
- [COMPLETAR]

### Arquitectura / Patrones
- [COMPLETAR]

### Lo que NO hacer en este proyecto
- [COMPLETAR]

---

## Librerías y utilidades clave

<!--
  Lista las librerías más importantes con su propósito.
  El agente IA las usará al diseñar soluciones en `design`.
  
  Ejemplo:
  - @pnp/sp: llamadas a SharePoint REST API
  - @microsoft/microsoft-graph-client: llamadas a Graph API
  - react-query: gestión de estado del servidor y caching
  - zod: validación de schemas en runtime
  - date-fns: manipulación de fechas
-->

| Librería | Propósito |
|----------|-----------|
| [COMPLETAR] | [para qué se usa] |

---

## Entornos

| Entorno | Branch | URL/Recurso |
|---------|--------|-------------|
| Desarrollo local | feature/* | localhost |
| Staging / Dev | develop | [URL] |
| Producción | main | [URL] |

---

## Credenciales y secretos

<!--
  NO pongas secretos aquí. Solo indica cómo se gestionan.
  
  Ejemplo:
  - Variables de entorno: archivo .env.local (no commiteado)
  - Secretos de Azure: Key Vault, accedido via Managed Identity
  - Configuración local: appsettings.Development.json (no commiteado)
-->

Los secretos se gestionan mediante: [COMPLETAR]
