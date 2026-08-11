<!--
  stack.spfx.template.md — PERFIL DE STACK: SharePoint Framework (SPFx)

  Reemplaza config.spfx.template.yaml + references.spfx.template.md
  (mergeados en un único archivo; ambos duplicaban contenido y estaban
  escritos para el formato de config.yaml de OpenSpec, que este workflow no
  usa).

  Uso: acelerador opcional para el Project Manager durante la entrevista de
  `docs/architecture.md` (Fase 0 - SETUP) cuando el proyecto es una solución
  SPFx desplegada en SharePoint Online/Server. No se referencia
  automáticamente — el Project Manager lo ofrece como punto de partida si el
  usuario confirma que el stack coincide, y el usuario decide qué copiar
  hacia `docs/architecture.md`. Nunca se usa tal cual sin revisión:
  reemplazar cada `{{PLACEHOLDER}}` con el dato real del proyecto.
-->

# SPFx references — perfil de stack

## Project context

{{PROJECT_CONTEXT}} — dominio, organización, propósito. Mantener alineado con
`AGENTS.md` y `docs/architecture.md`.

Solución SPFx desplegada en SharePoint Online (o Server 2019, si el proyecto
lo requiere — ver `AGENTS.md`) como parte de la plataforma. El idioma de
dominio es **{{DOMAIN_LANGUAGE}}** — todo el texto de cara al usuario,
nombres de listas y campos de API usan identificadores en ese idioma.

## SharePoint and SPFx guidance

- **Baseline**: SPFx {{SPFX_VERSION}}, Node {{NODE_VERSION}}, React
  {{REACT_VERSION}}, TypeScript {{TS_VERSION}}, Fluent UI React v9,
  react-hook-form + zod para formularios, TanStack React Query para estado de
  servidor, spfx-fast-serve, Gulp 4.
- **Estructura de fuente**: layout en capas — `webparts/`, `extensions/`,
  `components/`, `shared/`, `hooks/`, `bll/`, `services/api/`, `services/sp/`,
  `contexts/`, `models/`, `dtos/`, `mappers/`, `schema/`, `globalLoc/`,
  `theme.ts`, `constantes.ts`, `errors/`.
- **Data flow**: web part → hook de React Query → clase BLL → service de
  API/SP → DTO → mapper → modelo de dominio → UI.
- **PnPContext**: inicializar una vez en `onInit` vía
  `PnPContext.init(context)`; acceder a SharePoint siempre a través de
  `PnPContext.sp`. Nunca instanciar clientes PnP ad hoc.
- **{{SHARED_LIBRARY}}**: librería interna compartida (wrappers de PnP,
  controles compartidos, helpers de contexto SPFx), si el proyecto la usa;
  usar solo su API pública, nunca importar detalles de implementación
  internos. Si se construye desde fuente en CI, no asumir disponibilidad vía
  npm registry.
- **Forms**: definir un schema de Zod en `src/schema/`, usar
  `react-hook-form` con el tipo inferido, y localizar todos los mensajes de
  validación.
- **Mapping**: nunca usar DTOs crudos en componentes de UI. Siempre mapear a
  través de funciones en `src/mappers/`.
- **State**: estado de servidor solo vía React Query; estado local de UI vía
  `useState`/`useReducer`.
- **Error handling**: clases de error de negocio dedicadas para casos
  esperados (ej. `CustomError`, `NoItemsToDisplayError`); propagar a través
  del estado `error` de React Query.
- **Permissions**: usar hooks dedicados de permisos/roles. Nunca bypassear
  chequeos de RBAC en lógica de UI.
- **Localization**: agregar strings nuevos a los archivos `loc/` del web
  part y a los strings globales compartidos. Nunca hardcodear texto de
  usuario en componentes.
- **Fluent UI v9**: usar componentes de `@fluentui/react-components`
  únicamente. No mezclar con Fluent UI v8. Theme tokens desde `src/theme.ts`.
- **Build**: `gulp bundle --ship && gulp package-solution --ship` para
  producción. `npm run serve` (spfx-fast-serve) para desarrollo local.
- **CI/CD**: {{CI_CD_INFO}}; targets de deploy: {{ENTORNOS}}.
- Respetar convenciones de build/serve en `gulpfile.js`, `config/serve.json`,
  `config/config.json` y `config/package-solution.json`.

## Tech Stack

- **SPFx**: {{SPFX_VERSION}}
- **Node.js**: {{NODE_VERSION}}
- **React**: {{REACT_VERSION}}
- **TypeScript**: {{TS_VERSION}}
- **Fluent UI React v9** (`@fluentui/react-components`) — librería de UI
  primaria
- **react-hook-form** + **zod** para validación de formularios
- **TanStack React Query** para estado de servidor y cache
- **{{SHARED_LIBRARY}}** — librería interna compartida (si aplica)
- **PnP JS / SPFI** — acceso a datos de SharePoint, inicializado a través de
  la clase singleton `PnPContext`
- **spfx-fast-serve** — servidor de desarrollo local
- **Gulp 4** — pipeline de build (`gulp bundle --ship`,
  `gulp package-solution --ship`)
- **ESLint** con `@microsoft/eslint-config-spfx`
- **CI/CD**: {{CI_CD_INFO}}; artefactos `.sppkg`
- **CLI for Microsoft 365** (`@pnp/cli-microsoft365`) para scripts de deploy
- **npm** como package manager

## Architecture

**Estructura de fuente en capas (`src/`):**

- `webparts/` — entry points de web parts SPFx (`.tsx`); arman el root de
  React, providers y property pane
- `extensions/` — entry points de extensiones SPFx; cada una con su propia
  subcarpeta `BLL/`
- `components/` — componentes React compartidos entre web parts
- `shared/` — utilidades transversales, hooks compartidos, contexts y
  componentes de UI reusados entre features
- `hooks/` — hooks de React Query específicos de feature, hooks de mutación
  BLL y hooks de acciones de formulario (organizados por dominio)
- `bll/` — clases de business logic layer; orquestan llamadas a services de
  API y SP, aplican reglas de negocio y devuelven modelos de dominio
  tipados
- `services/api/` — services cliente de API REST usando un wrapper
  `ApiClient` compartido
- `services/sp/` — services específicos de SharePoint para lookups de listas,
  usando PnP JS vía `PnPContext`
- `contexts/` — contexts de React y la clase singleton `PnPContext`;
  contexts a nivel de entidad bajo `contexts/entities/{entidad}/`
- `models/` — interfaces TypeScript de modelos de dominio
- `dtos/` — interfaces de Data Transfer Object que matchean los payloads de
  API backend y listas SP
- `mappers/` — funciones de mapeo puras entre DTOs y modelos de dominio
- `schema/` — schemas de validación Zod para todos los formularios
- `globalLoc/` — strings de localización SPFx compartidos
- `theme.ts` — definición centralizada de theme tokens de Fluent UI v9
- `constantes.ts` — constantes a nivel de aplicación
- `errors/` — clases de error custom

**Data flow:**
  Web part → hook de React Query → clase BLL → service de API (REST) / SP
  (PnP) → DTO → Mapper → modelo de dominio → UI

**Entry point pattern:**
  Cada web part inicializa `PnPContext.init(context)` una vez en `onInit`,
  envuelve el árbol de componentes con `FluentProvider` (theme del proyecto)
  y un `QueryClient` compartido vía TanStack React Query.

## Conventions

- **Language**: todo el texto de cara al usuario pasa por loc manifests de
  SPFx o strings globales — nunca hardcodeado en componentes.
- **Naming**: identificadores de dominio (models, DTOs, mappers, services,
  hooks, BLL) usan sustantivos del idioma de negocio ({{DOMAIN_LANGUAGE}})
  coherentes con el dominio.
- **Forms**: todos los formularios usan `react-hook-form` + schemas Zod de
  `src/schema/`. Mensajes de validación localizados.
- **State management**: estado de servidor exclusivamente vía TanStack React
  Query. Estado local de UI vía React `useState`/`useReducer`.
- **SharePoint access**: siempre a través de `PnPContext.sp` (inicializado
  una vez por web part/extensión). Nunca instanciar clientes PnP ad hoc.
- **Mapping**: nunca usar DTOs crudos directamente en componentes de UI.
  Siempre mapear a modelos de dominio vía funciones en `src/mappers/`.
- **Error handling**: clases de error dedicadas para casos de negocio
  esperados; propagar errores vía el estado `error` de React Query.
- **Permissions**: chequeos de rol/permiso vía hooks dedicados. Nunca
  bypassear chequeos de RBAC en lógica de UI.
- **Commits and branching**: ver `workflow/docs/workflow-conventions.md` y
  `AGENTS.md` para branches, commits y PRs del harness; CI/CD específico del
  proyecto en `docs/architecture.md`.
- **Build**: `gulp bundle --ship && gulp package-solution --ship` para
  producción. `npm run serve` (spfx-fast-serve) para desarrollo local.
- **Environments**: {{ENTORNOS}}; cada uno con su propio deploy de `.sppkg`.
- **Librería compartida interna** (`{{SHARED_LIBRARY}}`, si aplica): tratarla
  como dependencia interna — usar solo su API pública.

## Guidances

- **Antes de agregar una abstracción nueva**, revisar si ya existe un
  service, hook, método BLL, mapper o componente equivalente en el código.
- **Nuevos web parts** siguen el patrón establecido: el `.tsx` de entrada
  maneja `onInit`, `render`, `onDispose` y property pane; delega toda la
  lógica de negocio a hooks y clases BLL.
- **Nuevas features con formularios** deben definir un schema Zod en
  `src/schema/`, registrar un `useForm` de `react-hook-form` con el tipo
  inferido del schema, y localizar todos los mensajes de validación.
- **Nuevos endpoints de API** requieren: un DTO en `src/dtos/`, un mapper en
  `src/mappers/`, un método en el `*ApiService` correspondiente, un método
  `*BLL` correspondiente, y un hook de React Query en `src/hooks/`.
- **Nuevo acceso a listas SP** debe pasar por un service en `src/services/sp/`
  usando `PnPContext.sp`.
- **No hardcodear** tenant URLs, site paths, list IDs ni valores específicos
  de entorno en código fuente. Usar `constantes.ts` o configuración de
  property pane.
- **Fluent UI v9**: usar componentes de `@fluentui/react-components`. No
  mezclar con Fluent UI v8 legacy. Theme tokens desde `src/theme.ts`.
- **Accesibilidad y diseño responsive** deben preservarse en todos los
  cambios de UI.
- **Estados de loading, empty, error y permission-denied** deben manejarse
  explícitamente en todo componente que consuma datos.
- **Localization**: agregar strings nuevos al archivo de locale por defecto y
  al de {{DOMAIN_LANGUAGE}} en el `loc/` de cada web part, y a los strings
  globales cuando se comparten entre web parts.
- **CI**: si el proyecto depende de una librería interna construida desde
  fuente en CI, no asumir disponibilidad vía npm registry en CI.

## Front-end guidance

- Priorizar patrones React tipados; props y estado explícitos.
- Manejar loading, empty, error y permission-denied explícitamente en todo
  componente que consuma datos.
- Preservar accesibilidad y comportamiento responsive.
- Reusar componentes de UI, hooks, services y clientes de API existentes
  antes de introducir nuevos.

## Response style

- Asumir un ingeniero full stack senior; respuestas concisas, técnicas y
  orientadas a implementación.
- Ante múltiples opciones, preferir la que mejor encaje con SharePoint,
  SPFx, React y el resto del stack declarado en `docs/architecture.md`.
- Destacar el impacto por entorno cuando el cambio afecte {{ENTORNOS}}.
