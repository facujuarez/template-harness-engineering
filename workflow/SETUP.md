# Harness Engineering Workflow — Init (`/init-harness`)

> Esta guía cubre **únicamente** la configuración del harness (Fase 0 - INIT).
> ¿Es la primera vez que usás esta plantilla? Empezá por el
> [`README.md`](../README.md) del repo — clonar, verificar entorno y
> completar `AGENTS.md` / `feature_list.json` van ahí. Volvé a esta guía
> cuando estés listo para ejecutar `/init-harness`.

---

## Qué hace `/init-harness`

Configura la capa **provider-specific** del harness elegido (`.claude/`,
`.cursor/`, `.copilot/`, etc.), mapeando 1:1 cada rol de `workflow/agents/*.md`
a la capa nativa del harness. Lo ejecuta el
[harness-configurator](agents/harness-configurator.md) — ver ese archivo
para la definición completa del rol.

Se ejecuta **una sola vez** por harness elegido. Es **idempotente**: podés
re-ejecutarlo cuantas veces quieras sin riesgo.

---

## Cómo ejecutarlo

Abrí el harness que vas a usar en este directorio — lee `AGENTS.md`
automáticamente. Luego ejecutá:

```
/init-harness claude-code
```

(Reemplazá `claude-code` por tu harness: `cursor`, `copilot`, `aider`,
`continue`, `openhands`, o cualquier otro compatible con el estándar
`AGENTS.md`.)

**Qué sucede internamente:**

1. Detecta el harness elegido.
2. Lee `workflow/docs/harness-adapters.md` para conocer la estructura esperada.
3. Genera la carpeta provider-specific.
4. Mapea 1:1 cada rol de `workflow/agents/*.md` a la capa nativa (nunca
   duplica contenido, solo referencia).
5. Genera skills/configuración nativa si el harness las soporta.
6. Valida que todos los roles estén mapeados correctamente.
7. Reporta: `✓ Harness configurado: [harness-name] → podés usar /setup-project`.

Si hay errores, los reporta con la causa y los pasos de resolución, y no
marca la configuración como completada.

---

## Qué se genera por harness

### Claude Code (ya configurado)

```
.claude/
├── agents/         → 8 referencias 1:1 a workflow/agents/*.md
├── skills/         → init-harness, setup-project, start-issue, enrich-issue,
│                     design, implement, verify, commit, create-pr,
│                     new-issue, move-issue
└── settings.json   → hooks, permisos, MCP servers (opcional)
```

### Cursor

```
.cursor/
├── rules/          → 8 reglas nativas, una por rol
└── .cursorignore
```

### GitHub Copilot

```
.copilot/
├── rules/rules.md  → reglas consolidadas (menos granular que Claude Code/Cursor)
└── README.md
```

### Otros (Continue, Aider, OpenHands, etc.)

Se adapta según las capacidades nativas del harness: carpeta `agents/` si
soporta roles, `rules/` o `prompts/` si soporta reglas, `config.json` si usa
configuración declarativa.

Detalle técnico completo (contenido exacto de cada archivo, reglas de
mapeo, validación): [`workflow/docs/harness-adapters.md`](docs/harness-adapters.md).

---

## Troubleshooting

**❌ `/init-harness` no reconoce mi harness**
→ Usá uno de los soportados explícitamente, o indicale al harness-configurator
  que adapte la estructura según las capacidades nativas (ver sección "Otros"
  en `harness-adapters.md`).

**❌ Faltan archivos después de correr `/init-harness`**
→ Volvé a ejecutarlo: es idempotente y recrea la capa completa.

**❌ Quiero cambiar de harness**
→ Ejecutá `/init-harness [otro-harness]`. Genera la nueva capa sin borrar la
  anterior (si ya no la necesitás, eliminala manualmente).

**❌ `/setup-project` no existe después de `/init-harness`**
→ Verificá que la carpeta provider-specific (`.claude/skills/`, etc.) se
  generó correctamente. Volvé a correr `/init-harness`.

---

## FAQ

**¿`.claude/` (o `.cursor/`, etc.) se commitea?**
Sí. Es configuración del proyecto y se versiona junto con `workflow/` y `docs/`.

**¿Qué pasa si un rol en `workflow/agents/` cambia más adelante?**
Volvé a ejecutar `/init-harness` para sincronizar las referencias. Es idempotente, sin riesgo.

---

## Próximo paso

Con el harness configurado, seguí con la Fase 0 - SETUP:

```
/setup-project
```

Detalle completo: [`workflow/WORKFLOW-REFERENCE.md`](WORKFLOW-REFERENCE.md#fase-0--setup-completo-del-proyecto).

---

## Referencias

- [`README.md`](../README.md) — Punto de partida: clonar, verificar entorno, Quickstart completo.
- [`AGENTS.md`](../AGENTS.md) — Contrato del harness y definición de roles.
- [`workflow/agents/harness-configurator.md`](agents/harness-configurator.md) — Definición completa del rol.
- [`workflow/docs/harness-adapters.md`](docs/harness-adapters.md) — Referencia técnica por harness.
- [`workflow/WORKFLOW-REFERENCE.md`](WORKFLOW-REFERENCE.md) — Referencia completa del flujo.
