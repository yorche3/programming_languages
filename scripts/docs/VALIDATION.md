# 🤖 Validación automática con Copilot CLI / Automated validation with Copilot CLI

**ES:** Para tareas que dependen de plantillas y de leer código fuente (que un README cumpla [`README_Template.md`](../../docs/README_Template.md), que estén las secciones obligatorias, que las salidas sean reales, que los enlaces relativos existan…), `glot` delega en el **GitHub Copilot CLI** como validador automático. Es complementario al reparto script/agente de [`ROADMAP.md`](ROADMAP.md): el agente **escribe**, el validador **comprueba**.

**EN:** For tasks that depend on templates and on reading source code (a README matching [`README_Template.md`](../../docs/README_Template.md), required sections present, outputs being real, relative links resolving…), `glot` delegates to the **GitHub Copilot CLI** as an automatic validator. It complements the script/agent split in [`ROADMAP.md`](ROADMAP.md): the agent **writes**, the validator **checks**.

**Dependencia opcional:** el validador necesita el binario `copilot` y la suscripción del autor, así que no es una dependencia del repositorio: `doctor` informa si está disponible y `validate` avisa y devuelve `1` cuando falta. Verificado el 2026-09-21 con **GitHub Copilot CLI 1.0.86** (`~/.local/bin/copilot`).

---

## 🔧 Invocación verificada / Verified invocation

```bash
COPILOT_MODEL=gpt-5-mini COPILOT_AUTO_TIER=efficiency \
copilot -C "$MODULE_DIR" -p "<instrucciones de validación>" \
        -s --output-format json \
        --reasoning-effort low --max-ai-credits 30 \
        --allow-all-tools --deny-tool 'write' \
        --share "docs/evidence/{fase}/{modulo}/{lenguaje}.validate.md"
| `--output-format json` | JSONL, un objeto por línea: `glot` lee el veredicto sin interpretar texto libre |
| `--allow-all-tools` | Obligatorio en modo no interactivo |
| `--deny-tool 'write'` | Deja el validador en solo lectura: las denegaciones tienen prioridad sobre `--allow-all-tools` |
| `--max-ai-credits 30` | Cap blando de gasto en una corrida desatendida |
| `--share <ruta>` | Guarda la sesión en markdown, que sirve como evidencia del cierre |

---

## 💰 Política de modelo y coste / Model and cost policy

| Palanca | Cómo | Nota |
|---------|------|------|
| Modelo fijo | `--model <nombre>`, `COPILOT_MODEL` o la clave `model` de `~/.copilot/settings.json` | El flag gana a la variable de entorno y esta al fichero |
| Modo auto | `--model auto` con `--auto-tier efficiency` (o `COPILOT_AUTO_TIER`) | `efficiency` es la palanca directa para «auto pero barato» |
| Esfuerzo | `--reasoning-effort low` (o `minimal` para chequeos mecánicos) | Se pasa por flag: no aparece como clave de nivel superior en `copilot help config` |
| Contexto | `--context default` | `long_context` es el tier de pago por contexto y no hace falta para validar un README |
| Coste | `/model` muestra el coste relativo por token y `copilot help billing` explica los AI credits | El gasto de una corrida se acota con `--max-ai-credits` |

**Recomendado para `validate`:** `auto` con `efficiency`, o un modelo pequeño fijo (`gpt-5-mini`, `gpt-5.4-mini`, `claude-haiku-4.5`), siempre con `--reasoning-effort low`. Los modelos grandes se reservan al trabajo interactivo. La lista de modelos la manda el CLI instalado (`copilot help config`, clave `model`), no este documento.

---

## 🧩 Proveedor propio (BYOK): fuera del alcance / Bring your own key: out of scope

**ES:** El CLI admite un proveedor propio (`copilot help providers`): se activa con `COPILOT_PROVIDER_BASE_URL` y acepta endpoints compatibles con OpenAI, Azure y Anthropic, con la clave en `COPILOT_PROVIDER_API_KEY`, en `COPILOT_PROVIDER_BEARER_TOKEN`, o impresa en cada petición por `COPILOT_PROVIDER_API_KEY_COMMAND` (la forma en la que una clave no tiene que vivir en el repositorio ni en el entorno visible). **`glot` no lo gestiona**: no lee, no guarda y no pide claves, y no elige proveedor. La configuración de modelos por encargo (L6.5, v0.11.0) se hará **solo con los modelos que ofrece Copilot**, ajustando esfuerzo y tope de créditos. Queda escrito aquí por si algún día se quiere enchufar un proveedor externo: se hace exportando esas variables antes de `glot ask` o `glot validate`, sin tocar el repositorio.

**EN:** The CLI supports a custom provider (`copilot help providers`): it is activated with `COPILOT_PROVIDER_BASE_URL` and accepts OpenAI-compatible endpoints, Azure and Anthropic, with the key in `COPILOT_PROVIDER_API_KEY`, in `COPILOT_PROVIDER_BEARER_TOKEN`, or printed per request by `COPILOT_PROVIDER_API_KEY_COMMAND` (the way a key does not have to live in the repository or in the visible environment). **`glot` does not manage it**: it neither reads, stores nor asks for keys, and it does not pick a provider. The per-request model configuration (L6.5, v0.11.0) will use **only the models Copilot offers**, tuning reasoning effort and credit caps. It stays documented here in case an external provider is ever wanted: it is done by exporting those variables before `glot ask` or `glot validate`, without touching the repository.

---

## ⚠️ Advertencias / Warnings

- **No** exportar `COPILOT_ALLOW_ALL=true` en `.bashrc`: con el valor exacto `"true"` además confía en el directorio de trabajo y carga sus skills y hooks, que pueden ejecutar shell. Mejor `--allow-all-tools` por corrida.
- `~/.copilot/config.json` guarda un token OAuth (`authTokens`): es un secreto y no debe copiarse a la documentación ni a los logs de `glot`.
- `copilot help permissions` documenta los *kinds* de permiso (`shell(...)`, `write(path)`, `url(...)`, `mcp(...)`), pero no el catálogo de nombres para `--available-tools`/`--excluded-tools`; la lista exacta se ve en `/permissions` en modo interactivo.

---

## 📜 Contrato previsto del verbo `validate` (v0.10.0, L6)

| Aspecto | Detalle |
|---------|---------|
| stdout | Hallazgos (`clave: valor` o viñetas) |
| Evidencia | `--share` con la sesión completa en markdown, en la carpeta de evidencia del sprint: `docs/evidence/{fase}/{modulo}/{lenguaje}.validate.md` |
| Códigos | `0` sin hallazgos · **`4` con hallazgos** · `1` validador ausente o entorno · `2` uso incorrecto · `3` no se pudo ejecutar |
| Entrada | El estado del sprint (`lang`, `phase`, `module`, `spec`) o una ruta explícita |
| Enchufe | La orden sale de `GLOT_VALIDATOR`, como el delegado de `ask`: el harness la prueba con un sustituto y el autor cambia de modelo o de proveedor sin tocar el script |
