<!--
  stack.api.template.md — PERFIL DE STACK: ASP.NET Core API + SharePoint CSOM

  Reemplaza config.api.template.yaml + references.api.template.md (mergeados
  en un único archivo; ambos duplicaban contenido y estaban escritos para el
  formato de config.yaml de OpenSpec, que este workflow no usa).

  Uso: acelerador opcional para el Project Manager durante la entrevista de
  `docs/architecture.md` (Fase 0 - SETUP) cuando el proyecto es una API
  ASP.NET Core con persistencia en SharePoint CSOM y arquitectura en capas.
  No se referencia automáticamente — el Project Manager lo ofrece como punto
  de partida si el usuario confirma que el stack coincide, y el usuario
  decide qué copiar hacia `docs/architecture.md`. Nunca se usa tal cual sin
  revisión: reemplazar cada `{{PLACEHOLDER}}` con el dato real del proyecto.
-->

# API references — perfil de stack

## Project context

{{PROJECT_CONTEXT}} — dominio, organización, propósito. Mantener alineado con
`AGENTS.md` y `docs/architecture.md`.

ASP.NET Core 8 Web API que sirve al front-end del proyecto ({{FRONTEND_APPS}}).
El idioma de dominio es **{{DOMAIN_LANGUAGE}}** — controllers, DTOs, entidades
de dominio y campos de SharePoint usan identificadores en ese idioma,
coherentes con el negocio.

## ASP.NET Core API guidance

- **Baseline**: ASP.NET Core 8 Web API; persistencia SharePoint CSOM (**sin
  SQL, sin Entity Framework, sin clientes REST HTTP genéricos**); arquitectura
  en capas (`Api` → `Application` → `Infrastructure`, con `Domain` embebido en
  `Application`).
- **Estructura de fuente**: layout en capas — `Api/Controllers/`, `Api/DTO/`,
  `Api/Mappers/`, `Api/Configuration/`, `Application/Services/`,
  `Application/Domain/{Entities,Interfaces}/`,
  `Infrastructure/Persistence/{Repository,Entities,Mappers}/`.
- **Data flow**: controller → Application service (BLL) → repository
  interface → SharePoint repository (CSOM) → SP entity → Infrastructure
  mapper → domain entity → API mapper → DTO.
- **Controllers**: sin lógica de negocio; orquestación mínima, delegan todo a
  Application services.
- **DTOs**: solo en `Api/DTO`, sufijo `Dto`, DataAnnotations para validación,
  JSON PascalCase. Nunca mapear entidades de persistencia directamente a
  respuestas HTTP.
- **Services**: orquestan autenticación, carga, validación, consultas a
  repositorios, side effects y mapeo a DTOs.
- **Repositories**: siempre detrás de interfaces en
  `Application/Domain/Interfaces/Repository`; el acceso a SharePoint queda
  encapsulado en Infrastructure, nunca en controllers.
- **Mapping**: perfiles de AutoMapper — `Api/Mappers` (DTO↔domain),
  `Infrastructure/Persistence/Mappers` (SP↔domain); reusar resolvers
  existentes para mapeo complejo de `ListItem`.
- **DI**: único composition root en `Api/Configuration/Services.cs`. Scoped
  para services/repositories/Context; Singleton solo para utilidades
  thread-safe compartidas.
- **Build**: `dotnet build` / `dotnet test`. CI/CD según `docs/architecture.md`.

## Tech Stack

- **.NET**: ASP.NET Core 8 (Web API)
- **Lenguaje**: C#
- **Persistencia**: SharePoint CSOM (Client-Side Object Model) — sin SQL, sin
  Entity Framework, sin clientes REST HTTP genéricos
- **Mapping**: AutoMapper (Profiles para DTO↔Domain y SP↔Domain)
- **Validación**: DataAnnotations + ModelState (FluentValidation solo como
  excepción, a confirmar con el equipo)
- **Versionado de API**: rutas `api/v{version:apiVersion}/[controller]`
- **Serialización**: System.Text.Json, PascalCase (camelCase automático
  deshabilitado en `Program.cs`)
- **Inyección de dependencias**: contenedor built-in de ASP.NET Core, único
  composition root en `Api/Configuration/Services.cs`
- **Testing**: xUnit + Moq, con builders en `TestData`
- **CI/CD**: {{CI_CD_INFO}}
- **NuGet** / `dotnet` CLI como tooling de paquetes/build

## Naming

| Elemento | Convención |
|---|---|
| Controllers | `{Entity}Controller` |
| DTOs | `{Name}Dto` |
| DTOs de Create/Update | `Create{Entity}Dto` / `Update{Entity}Dto` |
| Filtros de paginación | `{EntityPlural}PaginationFiltersDto` |
| Services | `{Entity}Service` |
| Interfaces de service | `I{Entity}Service` |
| Repositories | `{Entity}SPRepository` / `Base/SP{Type}Repository` |
| Interfaces de repository | `I{Entity}Repository` / `IItemRepository<T>` |
| Mappers de API | `{EntityPlural}Mapper` |
| Mappers de Infrastructure | `{Entity}SPMapper` |
| Entidades de SharePoint | `SP{Entity}` |
| Helpers | `{Entity}Helper` / `I{Entity}Helper` |
| Namespaces | `{{PROJECT_NAMESPACE}}.API.<Layer>...` (ej. `Api.Controllers`, `Application.Domain.Entities`) |

## Architecture

**Estructura de fuente en capas:**

- `Api/Controllers/` — entry points HTTP (`{Entity}Controller`); delgados, sin
  lógica de negocio
- `Api/DTO/` — DTOs de request/response (`{Name}Dto`, `Create{Entity}Dto`,
  `Update{Entity}Dto`, `{EntityPlural}PaginationFiltersDto`) con
  DataAnnotations
- `Api/Mappers/` — perfiles de AutoMapper DTO↔domain (`{EntityPlural}Mapper`)
- `Api/Configuration/` — composition root de DI (`Services.cs`)
- `Application/Services/BLL/` — services de negocio (`{Entity}Service`) que
  orquestan auth, validación, repositorios, side effects y mapeo a DTO;
  services transversales en subcarpeta especializada (ej.
  `Application/Services/Cache`)
- `Application/Domain/Entities/` — entidades de dominio (sin DTOs, sin
  detalles de persistencia)
- `Application/Domain/Interfaces/Services/` — interfaces de service
  (`I{Entity}Service`)
- `Application/Domain/Interfaces/Repository/` — interfaces de repository
  (`I{Entity}Repository`, `IItemRepository<T>`)
- `Infrastructure/Persistence/Repository/` (+ `Base/`) — repositories de
  SharePoint (`{Entity}SPRepository`, `SP{Type}Repository`)
- `Infrastructure/Persistence/Entities/` — entidades de SharePoint
  (`SP{Entity}`)
- `Infrastructure/Persistence/Mappers/` (+ `Resolvers/`) — mappers SP↔domain
  (`{Entity}SPMapper`) y resolvers de `ListItem`
- `{{PROJECT_NAMESPACE}}.API.Tests` — tests agrupados por área funcional;
  builders en `TestData`

**Data flow:**
  Controller → Application service (BLL) → repository interface →
  SharePoint repository (CSOM) → SP entity → Infrastructure mapper → Domain
  entity → API mapper → DTO → HTTP response (JSON PascalCase)

**Entry point pattern:**
  Los controllers exponen rutas `api/v{version:apiVersion}/[controller]`,
  validan `ModelState` desde DataAnnotations de los DTOs (retornando
  `BadRequest(ModelState)` si es inválido), y delegan a Application services.
  Todas las dependencias se registran en el composition root único
  `Api/Configuration/Services.cs` con lifetimes coherentes (Scoped por
  defecto).

## Rules

**MUST have:**
- Controllers sin lógica de negocio; orquestación mínima, máxima delegación a
  services.
- DTOs solo en `Api/DTO` (nunca en Domain ni Infrastructure).
- Services orquestan: autenticación, carga, validación, consultas a
  repositorios, side effects, mapeo a DTOs.
- Repositories siempre detrás de interfaces en
  `Application/Domain/Interfaces/Repository`.
- SharePoint nunca accedido directamente desde controllers; encapsulado en
  repositories/services.
- Único composition root: `Api/Configuration/Services.cs`.
- Tests en `{{PROJECT_NAMESPACE}}.API.Tests` agrupados por área funcional;
  builders en `TestData`.
- Validación de ModelState en DTOs (DataAnnotations); `Action{Result|Result<T>}`
  retorna `BadRequest(ModelState)` si corresponde.
- Rutas HTTP: `api/v{version:apiVersion}/[controller]`.
- JSON: PascalCase (`Program.cs` deshabilita camelCase automático).
- Lifetimes: Scoped para services/repositories/Context; Singleton solo para
  utilidades thread-safe compartidas.

**SHOULD follow:**
- Reusar services existentes antes de crear nuevos.
- Extender services de agregado si la nueva funcionalidad pertenece a uno
  existente.
- Usar AutoMapper Profiles (`Api/Mappers` para DTO↔Domain,
  `Infrastructure/Persistence/Mappers` para SP↔Domain).
- Usar resolvers existentes en `Infrastructure/Persistence/Mappers/Resolvers`
  para mapeo complejo de `ListItem`.
- Builders en `TestData` para evitar fixtures inline pesados.
- Documentar con comentario los endpoints no-REST que rompen la convención
  (sub-rutas especiales de POST/PUT).
- Interfaces de repository antes que la implementación concreta.

**MAY decide:**
- Helpers especializados si la lógica del service es muy pesada.
- Métodos en entidades si el patrón ya existe (`IsEstado*`, `Tiene*`, cálculos
  derivados).
- Queries encapsuladas si merecen su propia clase.
- FluentValidation si DataAnnotations no alcanza (confirmar con el equipo
  primero).

**FORBIDDEN:**
- Nuevas capas (Handlers, Features, UseCases, Contracts) sin aprobación
  explícita.
- Acceso directo a SharePoint en controllers o mezclado con lógica HTTP.
- DTOs en Infrastructure; entidades de persistencia en Api.
- Dependencias registradas fuera de `Api/Configuration/Services.cs`.
- CQRS, MediatR, FluentValidation como regla por defecto.
- camelCase en JSON; `int Id` en entidades de dominio (salvo evidencia en
  contrario).
- Asumir SQL/EF/clientes REST externos como patrón.

## Validation checklist

- ¿El controller está en `Api/Controllers` sin lógica de negocio?
- ¿Los nuevos DTOs están en `Api/DTO` con DataAnnotations?
- ¿El mapper está en `Api/Mappers` si el mapeo no es trivial?
- ¿La lógica de negocio está en un service de Application?
- ¿El repository está detrás de una interfaz en
  `Application/Domain/Interfaces/Repository`?
- ¿El acceso a SharePoint está encapsulado, no directo desde controllers?
- ¿Las nuevas dependencias están en `Api/Configuration/Services.cs` con
  lifetime coherente?
- ¿Las nuevas entidades de dominio están en `Application/Domain/Entities`?
- ¿Las nuevas entidades de SharePoint están en
  `Infrastructure/Persistence/Entities` con prefijo `SP`?
- ¿Los nombres siguen la convención (sufijos Controller, Dto, Service,
  Repository, Mapper)?
- ¿Hay tests en `{{PROJECT_NAMESPACE}}.API.Tests` si cambió lógica de
  negocio?
- ¿No se introdujeron capas arquitectónicas nuevas sin decisión explícita?

## Decision tree

- **¿Necesito una capa nueva (CQRS, Handlers, Features)?** Confirmar con el
  equipo primero; proponer con justificación.
- **¿Hay validación compleja que no encaja en DataAnnotations?** Si es
  FluentValidation, proponerlo como excepción y confirmar.
- **¿El endpoint no es REST puro?** Documentar el patrón especial con
  comentario en el controller.
- **¿La entidad está creciendo con mucha lógica?** Usar un helper
  especializado antes que métodos gigantes.
- **¿El service se está volviendo muy pesado?** Dividir por responsabilidad,
  reusar services más chicos.
- **¿Necesito persistencia nueva?** Confirmar si sigue el patrón
  especializado de SharePoint CSOM.

## Dependency matrix

| Capa | Puede depender de |
|---|---|
| `Api` | `Application`, `Shared`, paquetes de ASP.NET Core |
| `Application` | `Application/Domain`, `Shared`, AutoMapper (si aplica) |
| `Infrastructure` | `Application/Domain` (interfaces), `Shared` |
| `Tests` | proyecto principal, Moq, xUnit |
| **FORBIDDEN** | `App→Api`, `Infrastructure→{Api, Controllers, DTOs}`, cualquiera `→Context` (singleton) |

## Guidances

- **Antes de agregar una abstracción nueva**, revisar si ya existe un
  service, repository, mapper o helper equivalente; extender el service de
  agregado correspondiente antes de crear uno nuevo.
- **Nuevos endpoints** requieren: acción de controller en `Api/Controllers`
  (sin lógica de negocio), DTOs de request/response en `Api/DTO` con
  DataAnnotations, mapper de API en `Api/Mappers` si el mapeo no es trivial,
  interfaz de service en `Application/Domain/Interfaces/Services`, e
  implementación en `Application/Services/BLL`.
- **Nuevo acceso a datos de SharePoint** requiere interfaz de repository en
  `Application/Domain/Interfaces/Repository` e implementación en
  `Infrastructure/Persistence/Repository` (sufijo `SPRepository`); reusar
  repositories `Base` antes de crear un patrón de acceso nuevo.
- **Nuevas entidades de dominio** van en `Application/Domain/Entities`;
  **nuevas entidades de SharePoint** en `Infrastructure/Persistence/Entities`
  con prefijo `SP`.
- **Registrar todas las dependencias** en `Api/Configuration/Services.cs` con
  un lifetime coherente.
- **No introducir capas arquitectónicas nuevas** (CQRS, MediatR, Handlers,
  Features, UseCases) ni frameworks (FluentValidation por defecto) sin
  aprobación explícita del equipo.
- **No hardcodear** tenant URLs, site paths, list IDs ni valores específicos
  de entorno; usar configuración.
- **Paginación**: usar `{EntityPlural}PaginationFiltersDto` y una respuesta
  paginada (`PagedItemsDto<T>`) cuando encaje en la convención.
- **Endpoints no-REST**: documentar con comentario las sub-rutas especiales
  de POST/PUT que rompen la convención REST.

## Response style

- Asumir un ingeniero full stack senior; respuestas concisas, técnicas y
  orientadas a implementación.
- Ante múltiples opciones, preferir la que mejor encaje con ASP.NET Core,
  SharePoint CSOM y el resto del stack declarado en `docs/architecture.md`.
- Destacar el impacto por entorno cuando el cambio afecte {{ENTORNOS}}.
