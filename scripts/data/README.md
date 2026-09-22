# 🗂️ Catálogo de datos / Data catalogue

**ES:** `languages.tsv` es la fuente **máquina** de los comandos e inicializadores
por lenguaje que consume `glot`: `langs` y `test`/`verify` (v0.7.0) hoy, y `new`
(v0.9.0). `commits.tsv` es la tabla de mensajes de commit que consume `save`
(v0.9.0) y `display.tsv` la de nombres de presentación que consume `close`
(v0.10.0). Una fila por lenguaje o por paso, **separada por tabuladores**, sin
cabecera, ordenada.

**EN:** `languages.tsv` is the **machine** source of the per-language commands and
initializers that `glot` consumes: `langs` and `test`/`verify` (v0.7.0) today, and
`new` (v0.9.0). `commits.tsv` is the commit-message table that `save` (v0.9.0)
consumes. One row per language or per step, **tab-separated**, no header, sorted.
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
ejecutando el inicializador** en un directorio temporal, con la entrada cerrada y
con un tiempo máximo, y comprobando qué deja en el disco. Un caso que no se pudo
verificar así **no se añade**: queda como `deferred` y lo escribe el agente. La
cobertura se informa en `doctor` como `new_commands` y `deferred: N`.

**EN:** These three columns are the **guide's legend turned into data** (✅ verified
in this repo · 🔧 ecosystem standard · ✍️ manual structure) and they are maintained
**by hand**, with one hard rule: **only what could be verified by running the
initializer** in a temporary directory, with stdin closed and a timeout, and by
checking what it leaves on disk gets added. A case that could not be verified that
way **is not added**: it stays `deferred` and the agent writes it. Coverage is
reported by `doctor` as `new_commands` and `deferred: N`.

**ES:** Reparto real de los 50 lenguajes: **22 `tool`**, **21 `manual`** y **7
`deferred`** (ada, clojure, cpp, groovy, kotlin, nim y python). Los `deferred` son
los que no se pudieron cerrar con la entrada cerrada: `alr init` pide la licencia,
`gradle init` falla, `nimble init` termina sin crear nada, `elm init` pregunta,
y `uv` no está instalado en este entorno. La lista de `deferred` es deuda visible:
si un lenguaje consigue un comando no interactivo verificado, se le cambia el tipo.

**EN:** Real split of the 50 languages: **22 `tool`**, **21 `manual`** and **7
`deferred`** (ada, clojure, cpp, groovy, kotlin, nim and python). The `deferred` ones
are those that could not be closed with stdin closed: `alr init` asks for the
licence, `gradle init` fails, `nimble init` ends up creating nothing, `elm init`
asks, and `uv` is not installed in this environment. The `deferred` list is visible
debt: if a language gets a verified non-interactive command, its kind is changed.

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

## 📝 `commits.tsv` — la tabla de commits / the commit table

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Paso del sprint | `4b` |
| 2 | Alias: el encargo que lo cubre, o `-` | `suite` |
| 3 | Ámbito del commit: `submodule` o `monorepo` | `submodule` |
| 4 | Mensaje, con los marcadores del tooling | `chore({phase}): add suite for {module}` |

**ES:** Es la tabla del sprint ([`SPRINT.md`](../docs/SPRINT.md)) puesta en datos:
`save` lee de aquí y no del script. Los marcadores (`{lang}`, `{phase}`,
`{module}`, `{Module}`) son los mismos del resto del tooling y se resuelven con el
estado del sprint. El harness comprueba **deriva en los dos sentidos**: cada mensaje
del catálogo tiene que estar en la tabla del sprint, cada alias tiene que ser un
encargo registrado en `prompts/`, y los dos pasos de ámbito `monorepo` (puntero y
roadmap) tienen que ser los que esperan a `pointer` (v0.11.0) y `close` (v0.10.0).

**EN:** It is the sprint table ([`SPRINT.md`](../docs/SPRINT.md)) turned into data:
`save` reads from here, not from the script. The placeholders (`{lang}`, `{phase}`,
`{module}`, `{Module}`) are the ones used by the rest of the tooling and are resolved
from the sprint state. The harness checks for **drift in both directions**: every
catalogue message must exist in the sprint table, every alias must be a request
registered in `prompts/`, and the two `monorepo`-scope steps (pointer and roadmap)
must be the ones waiting for `pointer` (v0.11.0) and `close` (v0.10.0).

## 🏷️ `display.tsv` — nombres de presentación / display names

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Lenguaje, como en `.gitmodules` | `tcl-tk` |
| 2 | Nombre de presentación, el que usa el roadmap | `Tcl/Tk` |

**ES:** El roadmap escribe los lenguajes con su nombre de presentación (`C#`, `C++`, `Tcl/Tk`) y **el número de línea de esta tabla es la posición** dentro de sus listas. `glot close` la usa para las dos cosas: para escribir el nombre que va a la lista y para insertarlo en su sitio, en vez de inventar un orden en el script. Se mantiene a mano, y el harness comprueba la deriva **en los dos sentidos**: los lenguajes tienen que ser los de `.gitmodules` y los nombres tienen que ser, ni más ni menos, los de una lista ya cerrada del roadmap.

**EN:** The roadmap spells languages with their display name (`C#`, `C++`, `Tcl/Tk`) and **this table's line number is the position** inside its lists. `glot close` uses it for both: to write the name that goes into the list and to insert it in place, instead of inventing an order in the script. It is maintained by hand, and the harness checks drift **in both directions**: the languages must be `.gitmodules`' and the names must be, no more and no less, those of an already closed list in the roadmap.

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
