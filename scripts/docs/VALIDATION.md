# 🤖 Validación automática con Copilot CLI / Automated validation with Copilot CLI

**ES:** Para tareas que dependen de plantillas y de leer código fuente (que un README cumpla [`README_Template.md`](../../docs/README_Template.md), que estén las secciones obligatorias, que las salidas sean reales, que los enlaces relativos existan…), `glot` delega en el **GitHub Copilot CLI** como validador automático. Es complementario al reparto script/agente de [`ROADMAP.md`](ROADMAP.md): el agente **escribe**, el validador **comprueba**.

**EN:** For tasks that depend on templates and on reading source code (a README matching [`README_Template.md`](../../docs/README_Template.md), required sections present, outputs being real, relative links resolving…), `glot` delegates to the **GitHub Copilot CLI** as an automatic validator. It complements the script/agent split in [`ROADMAP.md`](ROADMAP.md): the agent **writes**, the validator **checks**.

**Dependencia opcional:** el validador necesita el binario `copilot` y la suscripción del autor, así que no es una dependencia del repositorio: `doctor` informa del validador configurado y de si el CLI está disponible, y `validate` avisa y devuelve `1` cuando no hay ninguno. Verificado el 2026-09-21 con **GitHub Copilot CLI 1.0.86** y el 2026-09-22 con **1.0.88**.

---

## Configuración vigente v2.1.0-dev / Current v2.1.0-dev configuration

**ES:** Esta sección reemplaza la selección de modelos y BYOK de v2.0.3
documentada más abajo como referencia histórica. No certifica inferencia ni
disponibilidad por cuenta; no se han usado cuotas o credenciales del autor.

**EN:** This section supersedes the historical v2.0.3 model/BYOK configuration
below. It does not certify inference or account availability; no author quota
or credentials have been used.

| Ruta / Route | Base / Default | Overrides autorizados / Allowed overrides |
|---|---|---|
| `antigravity` (`agy`) | Flash 3.8 para economy y contract/build | Argon solo docs; bloquea si no aparece en `agy models`. Sin Claude no-thinking verificado, deep no tiene asociación |
| `copilot` | Flash 3.8 economy; Terra 6.1 balanced; Sonnet 5.5 deep | Argon docs; Sol 6.1/Kimi K3 contract/build; Opus 5.5 suite/implement/fix/refactor |
| `open-router` | Qwen 3.7 Plus economy | Qwen Max/Kimi economy; Argon docs. Sin asociación balanced/deep |

**ES:** Las plantillas declaran `profile:`, no un id. Las fuentes de selección
son `--model` > entorno de la ruta > estado de la ruta > base. Los flags
`--effort` ganan a `GLOT_EFFORT` y al perfil. Todas las fuentes pasan la misma
autorización de [`model_options.tsv`](../data/model_options.tsv); no hay
fallback. `GLOT_MODEL_AGY`, `GLOT_MODEL_COP` (`GLOT_MODEL` como alias nativo)
y `GLOT_MODEL_OR` son independientes. Las preferencias persisten después de
`finish`. `set copilot-model` guarda el id nativo resuelto: los antiguos alias
ambiguos requieren volver a elegir ruta y ejecutar `set`; no se migran solos.

**EN:** Templates declare profiles rather than model IDs. Model precedence is
flag > route environment > route state > default; effort precedence is flag >
environment > profile. Every source goes through the same request policy.
Preferences survive `finish`; ambiguous old native/BYOK aliases block until
explicitly reset. There is no automatic migration or fallback.

```bash
export GLOT_DELEGATE_COP='copilot -C {module_dir} -p "$(cat)" --add-dir {root} --allow-all-tools {reasoning_args}'
export GLOT_DELEGATE_AGY='agy --model {model} -p "$(cat)" --add-dir {root}'
# Solo el autor ejecuta estos verbos / Only the author runs these verbs:
glot set copilot-model terra
glot set open-router-model default
glot ask --delegate copilot contract_stub ada algorithms/data_structures_basics
glot ask --delegate open-router --model argon docs-module ada algorithms/data_structures_basics
glot validate --delegate open-router --model qwen ada algorithms/data_structures_basics
```

**ES:** OpenRouter comparte `GLOT_DELEGATE_COP`, pero solo la ruta explícita
configura endpoint `https://openrouter.ai/api/v1`, tipo `openai`, wire API
`completions`, transporte `http` e identidad/wire model reales. Nunca disfraza
Qwen como GPT/Claude. Un endpoint distinto o ajustes heredados de protocolo,
identidad, tokens o archivo de proveedores bloquean: retirarlos del entorno de
esa invocación, no modificar la configuración privada. Las credenciales son
externas (`COPILOT_PROVIDER_API_KEY`, `COPILOT_PROVIDER_BEARER_TOKEN` o
`COPILOT_PROVIDER_API_KEY_COMMAND`); glot no las guarda ni imprime.

**EN:** The explicit OpenRouter route configures its endpoint, OpenAI
completion protocol, HTTP transport and real internal/wire identity.
Conflicting inherited provider settings block rather than silently changing
providers. Credentials remain external and are never stored or printed.

**ES:** Los adaptadores BYOK declaran límites conservadores de 131072 tokens
de prompt y 32768 de salida, no la ventana completa del proveedor. No aumentan
contexto ni prometen acceso a 1M mediante Copilot. Qwen Plus no tiene
`reasoning_effort` verificado: se omite con `{reasoning_args}` y cualquier
effort explícito bloquea. Qwen Max/Kimi/Argon admiten low/medium/high según
metadatos públicos. AGY ajusta el sufijo del id al esfuerzo y comprueba el
catálogo local, sin realizar inferencia. `validate` conserva `--deny-tool write`
en el adaptador por defecto; no admite AGY porque no se ha verificado una
denegación equivalente. Un `GLOT_VALIDATOR` personalizado es responsabilidad
del autor. Las órdenes no se imprimen en diagnósticos ni evidencia; el registro
identifica ruta/modelo. Dry-run muestra la orden y no debe contener secretos.

**EN:** Conservative BYOK input/output limits do not enlarge context or
guarantee 1M access through Copilot. Unsupported explicit effort blocks.
AGY effort is encoded in a locally verified model suffix. Default validation
remains read-only on Copilot/OpenRouter; AGY validation has no verified
equivalent and is blocked. Custom validators remain author-owned.
Diagnostics/evidence identify the route/model, not private commands.

**ES / EN:** Los caps de 30/60/90 AI credits solo se aplican al validador nativo.
No son límites de dinero OpenRouter ni cuotas AGY; las órdenes personalizadas
de `ask` deciden sus caps. / Credit caps apply only to default native validation,
not OpenRouter money, AGY quotas or author-owned `ask` commands.

### Precios comprobados / Verified pricing (2026-11-02)

**ES:** Comparación de tarifas públicas, no estimación de una sesión completa.
Los precios de Copilot son USD por millón de tokens en tier default.
Fuente: [GitHub, Models and pricing](https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing).
El coste final depende también de caché, escritura de caché, razonamiento,
long context y cantidad de tokens. No basta con comparar generaciones.

**EN:** Public default-tier rates in USD per million tokens, not total session
estimates. Cache, reasoning, context tiers and token counts affect actual cost;
newer models are not automatically cheaper.

| Modelo / Model | Entrada / Input | Salida / Output | Decisión / Decision |
|---|---:|---:|---|
| GPT-5.6 Terra | $2.00 | $12.00 | Retirado de la configuración activa / Removed from active configuration |
| GPT-6.1 Terra | $1.00 | $5.00 | Balanced: 50% menos entrada y 58.3% menos salida / Lower input/output rates |
| Claude Sonnet 5.5 | $2.00 | $10.00 | Deep; misma tarifa principal que 5, caché de lectura más barata / Same main rate as 5, cheaper cached input |
| Claude Opus 5.5 | $4.00 | $20.00 | Override deep; 20% menos que Opus 5 / 20% below Opus 5 |
| Gemini 3.8 Flash | $0.75 | $3.75 | Base economy conservada por decisión del autor / Author-selected economy default retained |
| Gemini 4 Argon | $2.00 | $10.00 | Override docs, no sustituto barato de Flash / Not a cheaper Flash replacement |
| Kimi K3 (Copilot) | $3.00 | $15.00 | Alternativa funcional, no escalado de ahorro / Functional alternative, not a cost-saving upgrade |
| Claude Haiku 5.5 | $0.10 | $0.50 | Más barato en default hasta 100K; no reemplaza Flash sin nueva decisión / Cheaper, but not an authorized default replacement |

**ES:** Terra 6.1 está en el catálogo oficial GA y en el selector del editor
mostrado por el autor. `copilot help config` local todavía enumera 5.6 y no
6.1: eso es una discrepancia editor/CLI, no evidencia de que 5.6 sea la mejor
opción. Se usa el id 6.1 sin fallback; doctor informa la cobertura local real.
No se ha certificado un lanzamiento/inferencia CLI con 6.1 ni actualizado
la instalación del autor. Un estado fijado al antiguo id exige elegirlo de
nuevo con `set copilot-model terra` o usar el override explícito.

**EN:** Official GA availability and the supplied editor picker include
Terra 6.1, while local CLI help does not yet list it. The configuration uses
6.1 without fallback; doctor reports the actual local catalogue coverage.
No CLI inference or author installation upgrade was performed. Old pinned
IDs require an explicit reset or override.

**ES:** OpenRouter mantiene Qwen 3.7 Plus: los
[metadatos públicos](https://openrouter.ai/api/v1/models) indican $0.32/$1.28
por millón de entrada/salida hasta 256K, frente a $2/$6 de Qwen 3.8 Max y
$2/$10 de Argon. Por tanto, actualizarlo a Max solo por ser más reciente
encarecería el default. Son rutas y tarifas distintas de Copilot; no se
extrapolan a AGY, cuya cuota pertenece al plan del autor.

**EN:** Qwen 3.7 Plus remains the OpenRouter default: its $0.32/$1.28
input/output rates below 256K are lower than Qwen 3.8 Max ($2/$6) and
Argon ($2/$10). A newer Max default would cost more. Copilot rates do not
describe OpenRouter or AGY plan quotas.

## Referencia histórica hasta v2.0.3 / Historical reference through v2.0.3

## 🔧 Invocación verificada / Verified invocation

```bash
# lo que ejecuta `glot validate` cuando no hay GLOT_VALIDATOR: el encargo (el mismo
# que imprime `glot prompt validate`) llega por stdin y entra por `-p`, y el modelo,
# el esfuerzo y el tope de créditos salen del perfil del encargo (v0.11.0)
copilot -C "$MODULE_DIR" -p "<encargo validate>" \
        -s --output-format json \
        --model "$PROFILE_MODEL" --reasoning-effort "$PROFILE_EFFORT" \
        --max-ai-credits "$PROFILE_CREDITS" \
        --add-dir "$ROOT" --allow-all-tools --deny-tool write
```

**ES:** Desde la v0.11.0 el modelo **no** lo elige la configuración del CLI para `validate`: sale del perfil del encargo (`model:` en la plantilla + [`data/models.tsv`](../data/models.tsv)), que fija modelo, esfuerzo y tope de créditos, y `glot` los pasa como flags explícitos. Además exporta `COPILOT_MODEL` (y `COPILOT_AUTO_TIER` si el perfil lo declara) para que un validador propio los lea del entorno. La configuración del CLI sigue mandando en cualquier otra invocación interactiva.

**EN:** Since v0.11.0 the model is **not** picked by the CLI configuration for `validate`: it comes from the request's profile (`model:` in the template + [`data/models.tsv`](../data/models.tsv)), which fixes model, effort and credit cap, and `glot` passes them as explicit flags. It also exports `COPILOT_MODEL` (and `COPILOT_AUTO_TIER` when the profile declares it) so a custom validator can read them from the environment. The CLI configuration still rules in any other interactive invocation.

**ES:** Un `GLOT_VALIDATOR` propio cita las rutas con los **mismos marcadores** que el delegado de `ask` —`{root}`, `{module_dir}`, `{model}` y `{effort}`—, que `glot` resuelve antes de lanzarlo (v1.6.3); así la orden no lleva ninguna ruta del autor y sigue sirviendo si el monorepo se mueve. Un marcador que no esté en esa lista detiene el verbo con `1` en vez de lanzar una orden a la que le falta algo.

**EN:** A custom `GLOT_VALIDATOR` cites paths with the **same markers** as `ask`'s delegate —`{root}`, `{module_dir}`, `{model}` and `{effort}`—, which `glot` resolves before launching it (v1.6.3); the command therefore carries no author path and keeps working if the monorepo moves. A marker outside that list stops the verb with `1` instead of launching an incomplete command.

**ES:** No se usa `--share`: el registro lo escribe `glot` en `docs/evidence/{fase}/{modulo}/{lenguaje}.validate.md` —bloque de máquina más el informe—, así que la sesión no se duplica y **también vale con un validador propio**, que no tendría por qué saber escribir sesiones.

**EN:** `--share` is not used: the record is written by `glot` into `docs/evidence/{phase}/{module}/{language}.validate.md` —machine block plus the report—, so the session is not duplicated and it **works with a custom validator too**, which would have no reason to know how to write sessions.

| Flag | Qué hace / What it does |
|------|-------------------------|
| `-C <dir>` | Ejecuta en el directorio del módulo, que es el ámbito de la revisión |
| `-p ...` | El encargo en modo no interactivo: `glot` se lo pasa por **stdin** |
| `-s` | Silencia el preámbulo, para que stdout sea solo el informe |
| `--output-format json` | JSONL, un objeto por línea: es lo que se guarda como registro |
| `--model <id>` | El modelo del perfil del encargo; `auto` es válido y entonces manda `--auto-tier` |
| `--reasoning-effort <nivel>` | `low`, `medium` o `high` según el perfil; el CLI acepta `none`, `minimal`, `low`, `medium`, `high`, `xhigh` y `max` |
| `--auto-tier <perfil>` | Solo cuando el perfil lo declara (el modelo es `auto`): `efficiency`, `balance`, `intelligence` o `fast` |
| `--max-ai-credits <n>` | Cap blando de gasto en una corrida desatendida; **el mínimo que acepta el CLI es 30** |
| `--allow-all-tools` | Obligatorio en modo no interactivo |
| `--add-dir <raíz>` | El ámbito de la revisión es el módulo, pero lo que hay que **comprobar** —la especificación, [`README_Template.md`](../../docs/README_Template.md), [`AGENT_Template.md`](../../docs/AGENT_Template.md) y el acta de evidencia— vive en el **monorepo**, fuera del submódulo (v1.6.3). Medido el 2026-10-01: sin este flag el validador de `crystal algorithms/data_structures_basics` no pudo leer la especificación ni el acta y las dejó como dos notas en vez de revisarlas |
| `--deny-tool write` | Deja el validador en solo lectura: las denegaciones tienen prioridad sobre `--allow-all-tools` |
| `--share <ruta>` | Se midió y **no se usa**: duplicaría el registro que ya escribe `glot` |

---

## 💰 Política de modelo y coste / Model and cost policy

| Palanca | Cómo | Nota |
|---------|------|------|
| Modelo fijo | `--model <nombre>`, `COPILOT_MODEL` o la clave `model` de `~/.copilot/settings.json` | El flag gana a la variable de entorno y esta al fichero |
| Modo auto | `--model auto` con `--auto-tier efficiency` (o `COPILOT_AUTO_TIER`) | `efficiency` es la palanca directa para «auto pero barato» |
| Esfuerzo | `--reasoning-effort low` (o `minimal` para chequeos mecánicos) | Se pasa por flag: no aparece como clave de nivel superior en `copilot help config` |
| Contexto | `--context default` | `long_context` es el tier de pago por contexto y no hace falta para validar un README |
| Coste | `/model` muestra el coste relativo por token y `copilot help billing` explica los AI credits | El gasto de una corrida se acota con `--max-ai-credits` |

**Recomendado para `validate`:** el perfil `economy` del catálogo (`qwen/qwen3.7-plus`, `low`, 30), que es el que ya aplica `glot` y va por **OpenRouter** desde la v1.7.3 (paso 6, `scaffold`, `correct`, `docs-module` y `docs-language`); el contrato, la suite y la construcción van con `gpt-6.1-sol` y la implementación con `claude-sonnet-5.5`. Para trabajo interactivo o para un módulo grande, `auto` con `efficiency`, o un modelo pequeño fijo (`gpt-5-mini`, `gpt-5.4-mini`, `claude-haiku-4.5`), siempre con `--reasoning-effort low`. La lista de modelos la manda el CLI instalado (`copilot help config`, clave `model`), no este documento; `doctor` avisa de cuántos modelos **de Copilot** del catálogo siguen en esa lista (los de OpenRouter los sirve el proveedor propio y no están en ella).

---

## 🧩 Proveedor propio (BYOK) y OpenRouter / Bring your own key and OpenRouter

**ES:** Lo siguiente describe la versión viva v2.0.3. La configuración detallada
de BYOK, su separación como `--delegate open-router`, el aislamiento de rutas y
las equivalencias de esfuerzo/tokens se especifican para v2.1.0 en
[`ROADMAP.md`](ROADMAP.md). Esa ampliación todavía no está implementada.

**EN:** The following describes live v2.0.3. Detailed BYOK configuration, the
separate OpenRouter delegate route, isolation and effort/token compatibility are
specified for v2.1.0 in [`ROADMAP.md`](ROADMAP.md), not implemented yet.

**ES:** El CLI admite un proveedor propio (`copilot help providers`): se activa con `COPILOT_PROVIDER_BASE_URL` y acepta endpoints compatibles con OpenAI, Azure y Anthropic, con la clave en `COPILOT_PROVIDER_API_KEY`, en `COPILOT_PROVIDER_BEARER_TOKEN`, o impresa en cada petición por `COPILOT_PROVIDER_API_KEY_COMMAND` (la forma en la que una clave no tiene que vivir en el repositorio ni en el entorno visible). **`glot` no gestiona credenciales**: no lee, no guarda y no pide claves. Desde la **v1.7.3** sí apunta el endpoint cuando el modelo del delegado es un id de **OpenRouter** (los de `copilot-model`, que siempre son `vendedor/modelo`), y eso es lo que hace usable el alias: `ask` y `validate` exportan `COPILOT_PROVIDER_BASE_URL=https://openrouter.ai/api/v1` **salvo que el autor apunte a otro proveedor**, mientras que los ids de Copilot (`gpt-6.1-sol`, `claude-sonnet-5.5`) no llevan `/` y siguen yendo a GitHub. La **clave** es del autor: `COPILOT_PROVIDER_API_KEY`, `COPILOT_PROVIDER_BEARER_TOKEN` o `COPILOT_PROVIDER_API_KEY_COMMAND` (que la imprime en cada petición); sin ninguna de las tres `ask` lo **avisa** por stderr, que es el canal del diagnóstico. En ese modo el CLI **no pide autenticación de GitHub**, y como `glot` exporta `COPILOT_MODEL` desde la clave de estado o el perfil, el id tiene que ser el de OpenRouter; si el modelo no es de una familia conocida, `COPILOT_PROVIDER_MODEL_ID` le da una para el *tool-calling* y los límites de tokens.

**EN:** The CLI supports a custom provider (`copilot help providers`): it is activated with `COPILOT_PROVIDER_BASE_URL` and accepts OpenAI-compatible endpoints, Azure and Anthropic, with the key in `COPILOT_PROVIDER_API_KEY`, in `COPILOT_PROVIDER_BEARER_TOKEN`, or printed per request by `COPILOT_PROVIDER_API_KEY_COMMAND` (the way a key does not have to live in the repository or in the visible environment). **`glot` does not manage credentials**: it neither reads, stores nor asks for keys. Since **v1.7.3** it does point the endpoint when the delegate model is an **OpenRouter** id (the `copilot-model` ones, always `vendor/model`), and that is what makes the alias usable: `ask` and `validate` export `COPILOT_PROVIDER_BASE_URL=https://openrouter.ai/api/v1` **unless the author points to another provider**, while Copilot's ids (`gpt-6.1-sol`, `claude-sonnet-5.5`) carry no `/` and keep going to GitHub. The **key** belongs to the author: `COPILOT_PROVIDER_API_KEY`, `COPILOT_PROVIDER_BEARER_TOKEN` or `COPILOT_PROVIDER_API_KEY_COMMAND` (which prints it per request); with none of the three, `ask` **warns** on stderr, the diagnostic channel. In that mode the CLI **does not ask for GitHub authentication**, and since `glot` exports `COPILOT_MODEL` from the state key or the profile, the id has to be the OpenRouter one; if the model is not from a known family, `COPILOT_PROVIDER_MODEL_ID` gives it one for tool-calling and token limits.

---

## 🤝 Los delegados de `ask` / The `ask` delegates

**ES:** `validate` usa el validador; `ask` usa un **delegado**, y desde la **v1.7.0** hay varios con nombre propio: `GLOT_DELEGATE_COP` (GitHub Copilot CLI) y `GLOT_DELEGATE_AGY` (Antigravity CLI). Además de sus modelos de siempre, el de Copilot puede llevar **modelos de OpenRouter** (`glot set copilot-model <alias>`, v1.7.3). `GLOT_DELEGATE` sigue valiendo como **alias del primero**. Se eligen con `--delegate copilot|antigravity` (cortos `cop` y `agy`); sin el argumento, con una sola variable definida se usa esa y con las dos `ask` devuelve `2` pidiendo la elección. La **v1.7.2** deja solo estos dos: `shellgpt` (v1.7.0) y `aider` (v1.7.1) se retiraron —`shellgpt` no escribe artefactos y `aider` escribe pero **no ejecuta** comandos de shell, así que ninguno cierra un paso con puerta—, y `--delegate aider` es ahora un delegado desconocido (`2`).

**EN:** `validate` uses the validator; `ask` uses a **delegate**, and since **v1.7.0** there are several with their own name: `GLOT_DELEGATE_COP` (GitHub Copilot CLI) and `GLOT_DELEGATE_AGY` (Antigravity CLI). Besides its usual models, the Copilot one can carry **OpenRouter models** (`glot set copilot-model <alias>`, v1.7.3). `GLOT_DELEGATE` still works as an **alias of the first one**. They are chosen with `--delegate copilot|antigravity` (short `cop`, `agy`); with no argument, one defined variable is used and both of them make `ask` return `2` asking for the choice. **v1.7.2** leaves only these two: `shellgpt` (v1.7.0) and `aider` (v1.7.1) were retired —`shellgpt` writes no artefacts and `aider` writes but **does not execute** shell commands, so neither closes a gated step—, and `--delegate aider` is now an unknown delegate (`2`).

```bash
export GLOT_DELEGATE_COP='copilot -C {module_dir} -p "$(cat)" --add-dir {root} --allow-all-tools --reasoning-effort {effort}'
export GLOT_DELEGATE_AGY='agy --model {model} -p "$(cat)" --add-dir {root}'
glot ask --delegate copilot contract_stub ada algorithms/data_structures_basics
```

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Marcadores / Placeholders | `{root}`, `{spec}`, `{module_dir}`, `{model}` y `{effort}` los resuelve `glot` **antes** de ejecutar la orden, y `ask` exporta además `GLOT_ROOT` y `GLOT_MODULE_DIR` para el delegado y sus hijos. Así la línea no lleva ni la ruta ni el modelo del autor y se puede pegar en cualquier clon; `{effort}` es lo que lleva el esfuerzo del perfil al CLI |
| Modelo de AGY / AGY model | `{model}` sale de la **séptima columna** de [`data/models.tsv`](../data/models.tsv) —los ids de AGY **no** son los de Copilot—: `economy` → `gemini-3.8-flash-low`, `balanced` → `gemini-3.8-flash-low` y `deep` → `claude-sonnet-5-5-low`. Gana `--model`, después `GLOT_MODEL_AGY` y después la **clave de estado `antigravity-model`** (`glot set antigravity-model <alias>`, v1.7.0), que guarda un **alias** de [`data/delegates.tsv`](../data/delegates.tsv) (`gemini`, `sonnet`) —es lo que permite cambiarlo **a mitad de módulo**: los límites de AGY (horas, cuota semanal) **no se pueden consultar** desde su CLI—; el perfil queda como último recurso. La opción del binario es **`--model`** —también acepta `-model`— y **`-m` no existe**: medido, `agy -m` responde `flags provided but not defined: -m` |
| Modelo de Copilot / Copilot model | `{model}` sale de la **columna 2** (`modelo Copilot`) de [`data/models.tsv`](../data/models.tsv) —`balanced` → `gpt-6.1-sol`, `deep` → `claude-sonnet-5.5` y el perfil de OpenRouter → `qwen/qwen3.7-plus`—, y la **clave de estado `copilot-model`** (`glot set copilot-model <alias>`, v1.7.3) la sustituye por un **alias** de [`data/delegates.tsv`](../data/delegates.tsv) (`default`, `gemini`, `qwen`, `kimi`), que son ids de **OpenRouter**. El alias **solo** entra cuando el modelo del perfil ya lleva `/`: así una asignación de documentación no cambia el modelo del contrato ni el de la implementación, y `ask`/`validate` apuntan el proveedor propio solo en ese caso. Ganan `--model` y después `GLOT_MODEL_COP`/`GLOT_MODEL` |
| `-p "$(cat)"` | El encargo llega por **stdin** (lo garantiza `ask`); `-p` a secas no lo leería. `-C` fija el directorio de trabajo y `--add-dir` abre la raíz, porque el sandbox deja fuera la especificación y el `gitdir` del submódulo |
| Permisos de COP | `--allow-all-tools` para los encargos que **escriben** (`contract_stub`, `suite`, `implement`, `scaffold`, `docs-module`); para los de solo lectura va `--deny-tool write`, que gana sobre `--allow-all-tools`. **No** se exporta `COPILOT_ALLOW_ALL=true` |
| Permisos de AGY | En modo desatendido lo que no está permitido se **auto-deniega** —no hay prompt— y el mensaje **no dice qué permiso falta**. Viven **por proyecto**, en `~/.gemini/config/projects/<id>.json`, anidados en `permissionGrants.permissionGrants.allow`, con tres clases: `command(<binario y subcomando>)`, `read_file(<ruta>)` y `write_file(<ruta>)` (`*` vale como comodín). El comando o la ruta exactos se sacan de la base de conversaciones (`~/.gemini/antigravity-cli/conversations/*.db`, tabla `steps`) o de `--log-file` |
| Guardas / Guards | Ni la orden ni su ruta viven en el repositorio: `install` las **imprime** para que el autor las pegue, y `doctor` informa `delegate_cop:` y `delegate_agy:`. Un delegado que falla devuelve `1`, no `4` |

**ES:** Documentar la línea **no** es compartir credenciales: lo que va al repositorio son marcadores y nombres de modelo; la ruta, el `MODEL` del perfil y cualquier permiso viven en el entorno del autor.

**EN:** Documenting the command is **not** sharing credentials: what goes into the repository are placeholders and model names; the path, the profile's `MODEL` and any permission live in the author's environment.

---

## ⚠️ Advertencias / Warnings

- **No** exportar `COPILOT_ALLOW_ALL=true` en `.bashrc`: con el valor exacto `"true"` además confía en el directorio de trabajo y carga sus skills y hooks, que pueden ejecutar shell. Mejor `--allow-all-tools` por corrida.
- `~/.copilot/config.json` guarda un token OAuth (`authTokens`): es un secreto y no debe copiarse a la documentación ni a los logs de `glot`.
- `copilot help permissions` documenta los *kinds* de permiso (`shell(...)`, `write(path)`, `url(...)`, `mcp(...)`), pero no el catálogo de nombres para `--available-tools`/`--excluded-tools`; la lista exacta se ve en `/permissions` en modo interactivo.

---

## 📜 Contrato del verbo `validate` (v0.10.0, L6, implementado) / `validate` contract

| Aspecto | Detalle |
|---------|---------|
| stdout | El informe del validador tal cual (con el CLI, JSONL) |
| Registro | `glot` lo escribe en `docs/evidence/{fase}/{modulo}/{lenguaje}.validate.md`: bloque de máquina (`verdict`, `findings`, `validator`, `commit`, `dirty`, `date`) más el informe |
| Veredicto | Se **lee** de la última línea del informe, que la plantilla exige: `glot:validate verdict=clean|findings findings=N`. Sin esa línea, o con otro valor, `3`: no se interpreta texto libre |
| Códigos | `0` sin hallazgos · **`4` con hallazgos** · `1` validador ausente o entorno · `2` uso incorrecto · `3` no se pudo ejecutar o no se pudo leer el veredicto |
| Entrada | El encargo `validate` del sprint (el mismo que imprime `glot prompt validate`), por **stdin** |
| Bases y agrupación / References and grouping | Incluye [`Delegation_Policy.md`](../prompts/Delegation_Policy.md): comprobar prioridad de bases, cobertura por contrato y variantes, aislamiento y agregación completa al runner. Suite única o varias son válidas si están justificadas; lo no comprobado se declara. / Includes shared policy: check reference priority, contract/variant coverage, isolation and complete runner aggregation. One or several suites are valid with rationale; declare unverified aspects. |
| Enchufe | La orden sale de `GLOT_VALIDATOR`, como el delegado de `ask`: el harness la prueba con un sustituto y el autor cambia de modelo o de proveedor sin tocar el script |
