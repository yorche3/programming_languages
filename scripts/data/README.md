# 🗂️ Catálogo de datos / Data catalogue

**ES:** `languages.tsv` es la fuente **máquina** de los comandos e inicializadores
por lenguaje que consume `glot`: `langs` y `test`/`verify` (v0.7.0) hoy, y `new`
(v0.9.0). `commits.tsv` es la tabla de mensajes de commit que consume `save`
(v0.9.0), `display.tsv` la de nombres de presentación que consume `close`
(v0.10.0) y `toolchains.tsv` la de series verificadas que comprueba `doctor`
(v1.0.0). Una fila por lenguaje o por paso, **separada por tabuladores**, sin
cabecera, ordenada.

**EN:** `languages.tsv` is the **machine** source of the per-language commands and
initializers that `glot` consumes: `langs` and `test`/`verify` (v0.7.0) today, and
`new` (v0.9.0). `commits.tsv` is the commit-message table that `save` (v0.9.0)
consumes, `display.tsv` the display-name table that `close` (v0.10.0) uses and
`toolchains.tsv` the verified-series table that `doctor` checks (v1.0.0). One row per
language or per step, **tab-separated**, no header, sorted.
| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, tal como aparece en `.gitmodules` | `php` |
| 2 | Comando de inicialización del ecosistema | `mkdir -p src test + composer require --dev phpunit/phpunit` |
| 3 | Manifiestos y archivos clave | `composer.json, phpunit.xml, .gitignore` |
| 4 | Comando nativo de pruebas (lo ejecuta `glot test`) | `composer test` |
| 5 | Verificador de sintaxis o formato (lo ejecuta `glot verify`); `-` si el lenguaje aún no tiene | `php -l src/{Module}.php` |
| 6 | Tipo de inicialización (lo lee `glot new`): `tool` (hay herramienta), `manual` (esqueleto de carpetas) o `deferred` (lo escribe el agente) | `tool` |
| 7 | Comando que ejecuta `glot new` **en el directorio del módulo**; `-` cuando el tipo es `deferred` | `mkdir -p src test && composer require --dev phpunit/phpunit` |
| 8 | Normalización posterior (la aplica `glot new`), separada por `;`; `-` si no hace falta | `rm:{module}/.git;flat:{module}` |

**ES:** Las columnas 2 a 4 salen de la tabla maestra de
[`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md),
que sigue siendo el documento humano: aquí solo está lo que el tooling necesita.
El harness comprueba que **los dos no se separan** (mismos lenguajes y mismos
comandos de pruebas), así que si actualizas la guía hay que actualizar el TSV, y
al revés. El número de filas tiene que ser igual a los lenguajes de `.gitmodules`;
`glot doctor` lo informa como `native_commands`.

**EN:** Columns 2 to 4 come from the master table in
[`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md),
which remains the human document: only what the tooling needs lives here. The
harness checks that **the two do not drift apart** (same languages and same test
commands), so updating the guide means updating the TSV, and vice versa. The row
count must equal the languages in `.gitmodules`; `glot doctor` reports it as
`native_commands`.

**ES:** La **columna 5 se mantiene a mano** y solo con verificadores **ejecutados
de verdad** en el módulo correspondiente; la cobertura se informa en `doctor` como
`verify_commands` y crece cuando un lenguaje suma su verificador. Las columnas 4 y
5 pueden llevar marcadores (`{module}`, `{Module}`, `{suite}`): `glot` los resuelve
contra el módulo real antes de ejecutar, y `-n` imprime el resultado. El régimen de
`nim`, `perl`, `php` y `ruby` se apoya en el nombre del archivo, así que un módulo
que no lo siga necesitará revisar su fila.

**EN:** **Column 5 is maintained by hand** and only with verifiers **actually run**
in the corresponding module; coverage is reported by `doctor` as
`verify_commands` and grows as languages add their verifier. Columns 4 and 5 may
carry placeholders (`{module}`, `{Module}`, `{suite}`): `glot` resolves them against
the real module before running, and `-n` prints the result. The `nim`, `perl`, `php`
and `ruby` rows rely on the file name, so a module not following it will need its row
reviewed.

### Columnas 6 a 8: la inicialización / Columns 6 to 8: initialisation

**ES:** Estas tres columnas son la **leyenda de la guía convertida en dato**
(✅ verificado en este repo · 🔧 estándar del ecosistema · ✍️ estructura manual) y se
mantienen **a mano**, con una regla dura: **solo se añade lo que se pudo verificar
ejecutando el inicializador** en un directorio temporal, con la entrada cerrada (o
conducida con `expect`, R1) y con un tiempo máximo, comprobando qué deja en el
disco. La columna 7 es el **comando único**: un lenguaje que necesita varios pasos,
otro directorio de trabajo o un completado aparece en `init_sequences.tsv` con la
columna 7 en `-`, para no tener dos fuentes. `deferred` sigue en el vocabulario (un
lenguaje que no se pueda cerrar vuelve ahí), pero hoy no lo usa ninguno. La
cobertura se informa en `doctor` como `new_commands` y `deferred: N`.

**EN:** These three columns are the **guide's legend turned into data** (✅ verified
in this repo · 🔧 ecosystem standard · ✍️ manual structure) and they are maintained
**by hand**, with one hard rule: **only what could be verified by running the
initializer** in a temporary directory, with stdin closed (or driven by `expect`,
R1) and a timeout, and by checking what it leaves on disk gets added. Column 7 is
the **single command**: a language needing several steps, another working directory
or a completion appears in `init_sequences.tsv` with column 7 set to `-`, so there
is only one source. `deferred` stays in the vocabulary (a language that cannot be
closed goes back there), but no language uses it today. Coverage is reported by
`doctor` as `new_commands` and `deferred: N`.

**ES:** Reparto de los 50 lenguajes tras la política R1–R6 (cerrada el 2026-09-26 y ya aplicada al dato): **33 `tool`**, **17 `manual`** y **0 `deferred`**. Pasan a `tool` doce lenguajes —`ada`, `groovy`, `kotlin`, `clojure`, `nim` y `python` (eran `deferred`) más `julia`, `vala`, `perl`, `common-lisp`, `racket` y `v` (eran `manual`)—, `cpp` queda `manual` (C++ mantiene Bazel, decidido el 2026-09-26) y `java` baja a `manual` por R2 (el arquetipo `quickstart` trae `main`). `doctor` lo informa como `new_commands: 50 de / of 50 (deferred: 0)`.

**EN:** Split of the 50 languages after policy R1–R6 (closed on 2026-09-26 and already applied to the data): **33 `tool`**, **17 `manual`** and **0 `deferred`**. Twelve languages move to `tool` —`ada`, `groovy`, `kotlin`, `clojure`, `nim` and `python` (were `deferred`) plus `julia`, `vala`, `perl`, `common-lisp`, `racket` and `v` (were `manual`)—, `cpp` stays `manual` (C++ keeps Bazel, decided on 2026-09-26) and `java` moves down to `manual` under R2 (the `quickstart` archetype ships `main`). `doctor` reports it as `new_commands: 50 de / of 50 (deferred: 0)`.

**ES:** Normalización declarada: `flat:<sub>` sube al directorio del módulo el
contenido de `<sub>` (incluidos los archivos ocultos) y borra `<sub>`; `rm:<ruta>`
elimina y es tolerante, porque es limpieza y no una comprobación de existencia. Se
aplican en orden, y ese orden importa: `crystal` y `gleam` crean un `.git` propio en
el proyecto hijo, así que la fila declara `rm:{module}/.git` **antes** de
`flat:{module}`, porque después del aplanado esa ruta ya no existe. Un lenguaje sin
operación declarada no se toca: es decisión de datos, no del script.

**EN:** Declared normalisation: `flat:<sub>` moves the contents of `<sub>` up into
the module directory (hidden files included) and deletes `<sub>`; `rm:<path>` removes
and is tolerant, because it is cleanup, not an existence check. They are applied in
order, and that order matters: `crystal` and `gleam` create a `.git` of their own in
the child project, so the row declares `rm:{module}/.git` **before**
`flat:{module}`, because after flattening that path no longer exists. A language with
no declared operation is untouched: it is a data decision, not the script's.

## 🧩 `init_sequences.tsv` — secuencias de inicialización / initialisation sequences

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, tal como aparece en `.gitmodules` | `ada` |
| 2 | Orden del paso, desde `1` | `1` |
| 3 | Directorio de trabajo del paso: `module` (la carpeta del módulo que crea `use`) o `phase` (cuando el generador crea la carpeta él mismo) | `module` |
| 4 | Modo: `run` (se ejecuta) o `expect` (se conduce con `expect`) | `run` |
| 5 | Comando con los marcadores del tooling (`{module}`, `{Module}`) | `alr -n init --lib --in-place {module}` |
| 6 | Requisito del paso: `-`, `expect`, `network`, `env:PERL5LIB+PATH` o `tool:uv` | `-` |
| 7 | Respuestas de `expect`, separadas por `|`; `-` en los demás modos | `library|<defecto>|<defecto>|<defecto>|<defecto>` |
| 8 | Lo que hay que **completar a mano** después (el generador no lo crea); `-` si no falta nada | `borrar el .git que crea uv` |

**ES:** Un lenguaje aparece aquí **solo** si su inicialización necesita **más de un paso**, **otro directorio de trabajo**, `expect` o un **completado posterior**; los que se resuelven con un único comando siguen en la columna 7 de `languages.tsv` y **no se duplican**. La consume `new` (v1.1.0): construye el plan con estos pasos, lo imprime con `-n` (`cd <directorio> && <comando>` por paso, más `# completar / complete:`), lo ejecuta en orden y, si el paso declara `phase`, **retira la carpeta vacía** que dejó `use`, porque ese generador crea la carpeta él mismo (los tres que lo hacen —`julia`, `clojure` y `racket`— fallan si ya existe). Está pensada también como **consulta humana**: es la lista que dice, lenguaje a lenguaje, qué se ejecuta y qué falta. `GLOT_DATA_DIR` redirige el directorio del dato, para pruebas y laboratorio.

**EN:** A language appears here **only** when its initialisation needs **more than one step**, **another working directory**, `expect` or a later **completion**; single-command languages stay in column 7 of `languages.tsv` and are **not duplicated**. It is consumed by `new` (v1.1.0): it builds the plan from these steps, prints it with `-n` (`cd <dir> && <command>` per step, plus `# completar / complete:`), runs it in order and, when a step declares `phase`, **removes the empty folder** left by `use`, because that generator creates the folder itself (the three that do —`julia`, `clojure` and `racket`— fail if it already exists). It is also meant as a **human reference**: the per-language list of what runs and what is missing. `GLOT_DATA_DIR` redirects the data directory, for tests and the lab.

**ES:** Las filas están medidas ejecutando cada generador en el laboratorio el 2026-09-26 (ver la tabla de medición de [`ROADMAP.md`](../docs/ROADMAP.md)). La regla de la columna 3 se comprobó una a una: `uv init --lib .`, `module-starter --dir=.` y `quickproject` con nombre trabajan **en el sitio**, mientras que `Pkg.generate`, `deps-new` con destino, `raco pkg new` y `alr init` **crean la carpeta** — con `alr` se resuelve con `--in-place` y se queda en `module`.

**EN:** Rows were measured by running each generator in the lab on 2026-09-26 (see the measurement table in [`ROADMAP.md`](../docs/ROADMAP.md)). The column 3 rule was checked one by one: `uv init --lib .`, `module-starter --dir=.` and `quickproject` with a name work **in place**, whereas `Pkg.generate`, `deps-new` with a target, `raco pkg new` and `alr init` **create the folder** — `alr` is solved with `--in-place`, staying in `module`.

## 📝 `commits.tsv` — la tabla de commits / the commit table

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Paso del sprint | `4c` |
| 2 | Alias: el encargo que lo cubre, o `-` | `suite` |
| 3 | Ámbito del commit: `submodule` o `monorepo` | `submodule` |
| 4 | Mensaje, con los marcadores del tooling | `chore({phase}): add suite for {module}` |

**ES:** Es la tabla del sprint ([`SPRINT.md`](../docs/SPRINT.md)) puesta en datos:
`save` lee de aquí y no del script. Los marcadores (`{lang}`, `{phase}`,
`{module}`, `{Module}`) son los mismos del resto del tooling y se resuelven con el
estado del sprint. El harness comprueba **deriva en los dos sentidos**: cada mensaje
del catálogo tiene que estar en la tabla del sprint, cada alias tiene que ser un
encargo registrado en `prompts/`, y los dos pasos de ámbito `monorepo` (puntero y
roadmap) tienen que ser los que esperan a `pointer` (v0.12.0) y `close` (v0.10.0).

**ES:** **Numeración de pasos:** cuando un paso entra **en medio**, toma el ordinal libre y **los siguientes se recorren** (v1.1.0: el contrato entra como `4b` y la suite pasa a `4c`). El ordinal es el mismo en esta tabla, en la tabla del sprint y en el `step:` de la plantilla del encargo, y se cambia en los tres sitios a la vez.

**EN:** **Step numbering:** when a step goes **in the middle**, it takes the free ordinal and **the following ones shift** (v1.1.0: the contract comes in as `4b` and the suite moves to `4c`). The ordinal is the same in this table, in the sprint table and in the request template's `step:`, and the three change at once.

**EN:** It is the sprint table ([`SPRINT.md`](../docs/SPRINT.md)) turned into data:
`save` reads from here, not from the script. The placeholders (`{lang}`, `{phase}`,
`{module}`, `{Module}`) are the ones used by the rest of the tooling and are resolved
from the sprint state. The harness checks for **drift in both directions**: every
catalogue message must exist in the sprint table, every alias must be a request
registered in `prompts/`, and the two `monorepo`-scope steps (pointer and roadmap)
must be the ones waiting for `pointer` (v0.12.0) and `close` (v0.10.0).

## 🏷️ `display.tsv` — nombres de presentación / display names
| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, como en `.gitmodules` | `tcl-tk` |
| 2 | Nombre de presentación, el que usa el roadmap | `Tcl/Tk` |

**ES:** El roadmap escribe los lenguajes con su nombre de presentación (`C#`, `C++`, `Tcl/Tk`) y **el número de línea de esta tabla es la posición** dentro de sus listas. `glot close` la usa para las dos cosas: para escribir el nombre que va a la lista y para insertarlo en su sitio, en vez de inventar un orden en el script. Se mantiene a mano, y el harness comprueba la deriva **en los dos sentidos**: los lenguajes tienen que ser los de `.gitmodules` y los nombres tienen que ser, ni más ni menos, los de una lista ya cerrada del roadmap.

**EN:** The roadmap spells languages with their display name (`C#`, `C++`, `Tcl/Tk`) and **this table's line number is the position** inside its lists. `glot close` uses it for both: to write the name that goes into the list and to insert it in place, instead of inventing an order in the script. It is maintained by hand, and the harness checks drift **in both directions**: the languages must be `.gitmodules`' and the names must be, no more and no less, those of an already closed list in the roadmap.

## 🤖 `models.tsv` — perfiles de modelo por encargo / per-request model profiles

**ES:** Una fila por **perfil**, con el **modelo como clave**: la plantilla declara su
modelo en el frontmatter (`model:`) y esta tabla dice qué esfuerzo y qué tope de créditos
le tocan, más para qué encargos está pensado el perfil. El nombre del perfil (`economy`)
es la etiqueta legible de la fila; **no hay una clave `profile:` en la plantilla**, para
que el modelo y su presupuesto no puedan derivar el uno del otro.

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Perfil, nombre de política | `economy` |
| 2 | Modelo de Copilot, **id real** de la lista del CLI instalado | `gemini-3.8-flash` |
| 3 | Esfuerzo de razonamiento, que `glot` pasa como `--reasoning-effort` | `low` |
| 4 | Tope de créditos, que `glot` pasa como `--max-ai-credits`; **30 es el mínimo que acepta el CLI** | `30` |
| 5 | Tier de auto (`--auto-tier`), o `-` cuando el modelo es fijo | `-` |
| 6 | Encargos que usan el perfil, separados por coma | `validate, docs-module, docs-language` |

**EN:** One row per **profile**, with the **model as the key**: the template declares its
model in the frontmatter (`model:`) and this table states the effort and the credit cap it
gets, plus which requests the profile is meant for. The profile name (`economy`) is the
readable label of the row; there is **no `profile:` key in the template**, so the model and
its budget cannot drift apart.

**ES:** La lista de modelos la manda el **CLI instalado** (`copilot help config`), no este
documento: `doctor` informa de la cobertura (`model_profiles`) y de cuántos modelos del
catálogo siguen apareciendo en el CLI (`model_available`), y el harness comprueba la deriva
en los dos sentidos entre la columna 6 y las plantillas que declaran cada modelo. Un
`model:` que no esté aquí es un **dato que falta** (`1`), nunca un perfil inventado.

**EN:** The model list is owned by the **installed CLI** (`copilot help config`), not by
this document: `doctor` reports coverage (`model_profiles`) and how many catalogue models
are still listed by the CLI (`model_available`), and the harness checks drift in both
directions between column 6 and the templates that declare each model. A `model:` missing
here is a **missing datum** (`1`), never an invented profile.

| Perfil / Profile | Modelo / Model | Esfuerzo / Effort | Créditos / Credits | Encargos / Requests |
|---|---|---|:--:|---|
| `economy` | `gemini-3.8-flash` | `low` | 30 | `validate`, `docs-module`, `docs-language` |
| `balanced` | `gpt-5.6-terra` | `medium` | 90 | `scaffold`, `suite` |
| `deep` | `claude-sonnet-5` | `high` | 120 | `implement` |

## 🧰 `toolchains.tsv` — series verificadas / verified series

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, como en `.gitmodules` | `ruby` |
| 2 | Comando que imprime su versión, como orden de shell | `ruby --version` |
| 3 | Serie verificada **en este entorno**, que se compara por prefijo | `3.4` |

**ES:** Es el dato de la L9 puesto en un fichero, del que la v1.0.0 solo usa la
**comprobación**: `doctor` informa de la cobertura (`toolchains:`) y de cuántas de las
declaradas están presentes (`toolchains_present:`), y comprueba la **serie** del lenguaje
del sprint en curso (`toolchain_<lenguaje>: ok`, `differs`, `missing` o `unknown`). Crece
**solo con versiones verificadas aquí**: una fila entra cuando el comando se ha ejecutado y
su salida se ha leído. Por eso hay lenguajes sin fila: Ada no tiene `gnat` en este entorno,
Common Lisp no tiene `sbcl`, ReScript no está instalado, `rexx` no tiene comando de versión
y el `scala` instalado solo informa de la versión de su runner.

**EN:** It is the L9 datum in a file, of which v1.0.0 only uses the **check**: `doctor`
reports the coverage (`toolchains:`) and how many declared rows are present
(`toolchains_present:`), and checks the **series** of the sprint's language
(`toolchain_<language>: ok`, `differs`, `missing` or `unknown`). It only grows **with
versions verified here**: a row goes in once the command has been run and its output read.
That is why some languages have no row: Ada has no `gnat` in this environment, Common Lisp
has no `sbcl`, ReScript is not installed, `rexx` has no version command, and the installed
`scala` only reports its runner's version.

**ES:** El comando puede ser cualquier orden de shell que imprima la versión
(`elixir -e 'IO.puts System.version()'`, `echo 'puts $tcl_version' | tclsh`) y la
columna 3 admite un número o una serie: se compara **por prefijo** contra la primera
versión que aparezca en la salida, así que `3.4` acepta `3.4.3` y un salto de serie se
informa como `differs` **sin** cambiar el código, porque que una versión avance es
información y no un fallo del entorno. Lo que sí falla es que la herramienta no esté
(`missing`) o que la fila no sea de un lenguaje registrado (`unknown`). Comprobar la
serie de las 45 filas cuesta unos 5 segundos medidos (kotlin 1,3 s, ballerina 0,5 s,
groovy 0,4 s): por eso `doctor` comprueba la del sprint y deja la cobertura y la
presencia, que son un `command -v` por fila. `GLOT_TOOLCHAINS_FILE` apunta a otro
catálogo, como `GLOT_STATE_FILE` con el estado.

**EN:** The command can be any shell command printing the version (`elixir -e 'IO.puts
System.version()'`, `echo 'puts $tcl_version' | tclsh`) and column 3 accepts a number or
a series: it is compared **by prefix** against the first version in the output, so `3.4`
accepts `3.4.3` and a series jump is reported as `differs` **without** changing the exit
code, because a version moving forward is information and not an environment failure.
What does fail is the tool being absent (`missing`) or the row not being a registered
language (`unknown`). Checking the series of all 45 rows costs around 5 measured seconds
(kotlin 1.3 s, ballerina 0.5 s, groovy 0.4 s): that is why `doctor` checks the sprint's
one and keeps coverage and presence, which are one `command -v` per row.
`GLOT_TOOLCHAINS_FILE` points at another catalogue, as `GLOT_STATE_FILE` does for the
state.

## 🔁 Regeneración / Regeneration

**ES:** La guía manda. Este comando rehace las **columnas 1 a 4** desde su tabla
maestra, quitando las marcas de estado y los backticks; las columnas 5 a 8 se
**mantienen a mano** y se recuperan por lenguaje desde el propio fichero, porque
regenerarlas las borraría. Si un lenguaje entra o sale, la línea final avisa.

**EN:** The guide is the source of truth. This command rebuilds **columns 1 to 4**
from its master table, stripping the status marks and the backticks; columns 5 to 8
are **maintained by hand** and are recovered per language from the file itself,
because regenerating them would wipe them. If a language comes or goes, the last
line warns.

```bash
clean() {
    LC_ALL=C sed 's/\xef\xb8\x8f//g; s/\xe2\x9c\x85//g; s/\xf0\x9f\x94\xa7//g;
                   s/\xe2\x9c\x8d//g; s/`//g; s/  */ /g; s/^ //; s/ $//'
}

# 1. Las columnas a mano, a salvo / the hand-maintained columns, kept safe
cp scripts/data/languages.tsv /tmp/languages.tsv.bak

# 2. Columnas 1 a 4 desde la tabla maestra / columns 1 to 4 from the master table
awk -F'|' '/^\| \*\*[a-z]/ {print $2 "\t" $3 "\t" $4 "\t" $5}' \
    docs/core/00_Project_Initialization_Guide.md |
while IFS=$'\t' read -r a b c d; do
    printf '%s\t%s\t%s\t%s\n' \
        "$(printf '%s' "$a" | clean | tr -d '*')" \
        "$(printf '%s' "$b" | clean)" \
        "$(printf '%s' "$c" | clean)" \
        "$(printf '%s' "$d" | clean)"
done >/tmp/languages.new

# 3. Se reenganchan las columnas 5 a 8 por lenguaje / columns 5 to 8 rejoined by language
awk -F'\t' 'NR == FNR {
        tail = ""
        for (i = 5; i <= NF; i++) tail = tail "\t" $i
        keep[$1] = tail
        next
    }
    { print $0 keep[$1] }' /tmp/languages.tsv.bak /tmp/languages.new >scripts/data/languages.tsv

# 4. Nadie se quedó sin columnas / nobody lost their columns
awk -F'\t' 'NF != 8 {print "revisar / check: " $1}' scripts/data/languages.tsv
```

**ES:** Después, verifica con el harness: incluye la comprobación de deriva entre
la guía y este catálogo.

**EN:** Then verify with the harness: it includes the drift check between the
guide and this catalogue.
