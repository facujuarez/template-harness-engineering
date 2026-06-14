# init-harness

**Skill para configurar Claude Code con este proyecto.**

---

## Qué hace

Ejecuta el agente `Harness Configurator` definido en
[workflow/agents/harness-configurator.md](../../workflow/agents/harness-configurator.md).

Su responsabilidad:
- Genera la capa provider-specific (`.claude/`, `.cursor/`, etc.) según el harness elegido
- Mapea 1:1 cada rol de `workflow/agents/` a la capa nativa
- Valida la configuración
- Reporta cuando está listo para `/setup-project`

---

## Cómo usar

```
/init-harness claude-code
```

O si usás otro harness:
```
/init-harness cursor
/init-harness copilot
/init-harness aider
```

---

## Antes de ejecutar

1. Clonaste el repo desde el template
2. Ejecutaste `./init.sh`
3. Completaste `AGENTS.md` (reemplazaste placeholders)
4. Completaste `feature_list.json`
5. Leíste `workflow/SETUP.md`

---

## Después de ejecutar

Una vez que `/init-harness` termina con éxito:
```
✓ Harness configurado: claude-code
✓ Carpeta generada: .claude/
✓ Roles mapeados: 8/8
✓ Listo para /setup-project
```

Luego ejecuta:
```
/setup-project
```

---

## Referencia

- **Agent:** [Harness Configurator](../../workflow/agents/harness-configurator.md)
- **Setup completo:** [workflow/SETUP.md](../../workflow/SETUP.md)
- **Harness adapters:** [workflow/docs/harness-adapters.md](../../workflow/docs/harness-adapters.md)
