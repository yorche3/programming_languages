# 📜 Contrato de `glot` / `glot` contract

**ES:** Reglas que cumplen **todos** los verbos, más el contrato del almacén de estado. Es lo que hace que `glot` se pueda encadenar: la salida de un verbo se puede capturar sin parsear texto humano.

**EN:** Rules **every** verb obeys, plus the state store contract. This is what makes `glot` scriptable: a verb's output can be captured without parsing human text.

---

## 🧱 Contrato de todos los verbos / Every-verb contract

| Regla | Detalle |
|-------|---------|
| stdout | Solo el dato (así `$(glot get lang)` es utilizable) |
| stderr | Diagnóstico, avisos y errores; `set`/`unset` confirman aquí |
| Códigos de salida | `0` correcto · `1` error de entorno o dato ausente · `2` uso incorrecto · `3` estado ilegible o no escribible |
| Flags | `-h/--help` (general y por verbo), `--version`, `-q/--quiet`; desde v0.4.0, `-n/--dry-run` en los verbos que mutan y, desde v0.7.0, también en `test`/`verify`, donde imprime el comando sin ejecutarlo |
| Interacción | Un verbo nunca pregunta: el dato llega por argumento o por stdin |
| Idempotencia | Repetir el mismo efecto no cambia el resultado ni el código de salida |
| Testabilidad | La raíz del repo y la ruta del estado son inyectables por variable (`GLOT_ROOT`, `GLOT_STATE_DIR`/`GLOT_STATE_FILE`) |
| Bilingüismo | `help`, `doctor` y los errores van en ES/EN; los datos de salida (`Hello, Ada!`) no se traducen |

---

## 🔢 Códigos de salida / Exit codes

| Código | Significado | Cuándo |
|:------:|-------------|--------|
| `0` | Correcto | El verbo hizo lo que promete |
| `1` | Entorno o dato ausente | Falta bash 4+, git, la raíz del monorepo, un lenguaje de `.gitmodules`, la especificación, o el árbol tiene cambios sin confirmar |
| `2` | Uso incorrecto | Verbo desconocido, opción desconocida, argumentos de menos, valor inválido |
| `3` | Estado ilegible o no escribible | No se pudo leer, crear o escribir el almacén |
| `4` | Verificación fallida | `test` o `verify` se ejecutaron y **fallaron**: la suite en rojo o hallazgos del analizador |

> **ES:** `3` no se confunde con `1`: quien llama debe poder distinguir «me falta un dato» de «no puedo guardar». `4` tampoco se confunde con `1`: un CI necesita distinguir «no pude ejecutar la suite» de «la ejecuté y está en rojo».
> **EN:** `3` is not confused with `1`: callers must be able to tell "I am missing a datum" from "I cannot save". `4` is not confused with `1` either: a CI needs to tell "I could not run the suite" from "I ran it and it is red".

---

## 🧰 Verbos de la versión viva (v1.0.0) / Verbs in the live version

| Verbo | Comportamiento | Código |
|-------|----------------|:------:|
| `version`, `--version` | `glot 1.0.0` | 0 |
| `help`, `-h`, `--help`, `help <verbo>` | Ayuda general o de un verbo | 0 |
| `doctor` | Diagnóstico: bash, git, raíz del monorepo, directorio y fichero de estado, y número de claves | 0 / 1 |
| `greet [nombre]` | `Hello, <nombre>!` con el nombre por argumento o por stdin | 0 / 2 |
| `set <clave> <valor>` | Guarda la clave; confirma por stderr; con `-n`, imprime `clave=valor` y no escribe | 0 / 2 / 3 |
| `get <clave>` | Imprime el valor en stdout | 0 / 1 / 2 |
| `unset <clave>` | Borra la clave; repetirlo no es error | 0 / 2 / 3 |
| `list` | Todas las entradas `clave=valor`, ordenadas por clave en `LC_ALL=C` | 0 / 3 |
| `path` | Ruta del fichero de estado | 0 |
| `use <lenguaje> <fase>/<módulo> [tipo]` | Sitúa el trabajo según los cuatro estados del sprint (nuevo, en curso, reanudar y cerrado): valida, activa o crea la rama desde `main`, la publica con `-u` y crea la carpeta del módulo si falta; con trabajo sin confirmar no toca nada. Guarda el estado del sprint e imprime la ruta | 0 / 1 / 2 / 3 |
| `langs` | Catálogo de lenguajes: uno por línea con su **comando nativo de pruebas** | 0 / 1 |
| `modules [fase]` | Catálogo de módulos del roadmap con su especificación resuelta (`-` si aún no existe) | 0 / 1 / 2 |
| `progress [fase]` | Estado del roadmap: sin fase, contadores globales en `clave=valor`; con fase, una línea por módulo | 0 / 1 / 2 |
| `completion [bash\|zsh]` | Imprime el guion de autocompletado en stdout; **no** lo instala | 0 / 1 / 2 |
| `test [lenguaje] [fase/módulo]` | Ejecuta la suite del módulo asignado en su directorio, con el comando nativo del lenguaje; la salida del runner va a stdout | 0 / 1 / 2 / 3 / **4** |
| `verify [lenguaje] [fase/módulo]` | Ejecuta el verificador (sintaxis/formato) del lenguaje; imprime `skipped` si aún no tiene uno | 0 / 1 / 2 / 3 / **4** |
| `prompt [encargo] [lenguaje] [fase/módulo]` | Sin encargo, lista el registro —`nombre<TAB>paso<TAB>modelo<TAB>descripción`—; con encargo, imprime el encargo armado (estado del sprint + plantilla expandida) | 0 / 1 / 2 / 3 |
| `ask <encargo> [lenguaje] [fase/módulo]` | Arma el encargo y lo envía a `GLOT_DELEGATE` por stdin; su salida va a stdout. El modelo del perfil del encargo viaja por entorno (`COPILOT_MODEL`, y el tier de auto si el perfil lo declara) | 0 / 1 / 2 / 3 |
| `new [lenguaje] [fase/módulo]` | Inicializa el lenguaje y crea el esqueleto mecánico del módulo: con `tool` ejecuta el comando del catálogo; con `manual` crea las carpetas; con `deferred` informa e imprime `skipped`. Normaliza lo que deja el inicializador. No escribe la suite | 0 / 1 / 2 / **4** |
| `save <paso\|alias> [lenguaje] [fase/módulo]` | Confirma con el mensaje de la tabla del sprint (que vive en datos) e imprime el SHA corto; `nothing` si no hay nada. Los pasos del submódulo añaden el submódulo; los del monorepo (`9`, `10`) añaden **solo las rutas del paso**. Sin push | 0 / 1 / 2 / 3 / **4** |
| `evidence [lenguaje] [fase/módulo]` | Ejecuta la suite y el verificador y deja el acta con la salida real en `docs/evidence/`; la escribe también cuando algo está en rojo | 0 / 1 / 2 / 3 / **4** |
| `close [lenguaje] [fase/módulo]` | Cierra el módulo: exige la evidencia en verde y los README, registra la entrada del checklist y sube el contador y la lista del roadmap; idempotente. Imprime la línea nueva | 0 / 1 / 2 / 3 / **4** |
| `validate [lenguaje] [fase/módulo]` | Pasa el encargo `validate` al validador automático (opcional) y guarda su informe como registro del sprint. Sin validador, avisa y devuelve `1` | 0 / 1 / 2 / 3 / **4** |
| `status [lenguaje]` | **Solo lectura**: una línea por lenguaje registrado —`lang<TAB>branch<TAB>pointer<TAB>worktree`— con el puntero en `ok`, `differs`, `uninitialised` o `unknown` | 0 / 1 / 2 |
| `pointer [lenguaje] [fase/módulo]` | Deja el puntero del submódulo **preparado y sin confirmar**: exige que el submódulo esté en su `main` y que ese commit sea el de `origin/main`, prepara y publica la rama `chore/{fase}/{módulo}-pointer` y añade el gitlink. Imprime el SHA corto o `nothing` | 0 / 1 / 2 / 3 |
| `clean [lenguaje] [fase/módulo]` | Borra lo que el propio `.gitignore` del lenguaje declara como artefacto, **solo dentro del directorio del módulo**, y sincroniza el submódulo. Imprime las rutas borradas o `nothing` | 0 / 1 / 2 |
| `install` | Deja la **copia estable** (`~/.local/share/glot/`), el enlace `~/.local/bin/glot`, el completado de cada shell presente y el bloque del rc entre marcas. Idempotente; imprime el directorio de instalación | 0 / 1 / 2 / 3 |
| `uninstall` | Deshace lo de `install`: quita el bloque del rc, borra los completados, retira el enlace **solo si es el suyo** y la copia. Idempotente: sin nada instalado imprime `nothing` | 0 / 1 / 2 / 3 |
| Verbo desconocido | Error en stderr con sugerencia de `greet`/`help`; un nombre suelto ya no vale. Desde la **v1.1.0**, si el nombre es un **encargo registrado** (`scaffold`, `contract`, `suite`, `implement`, `validate`, `docs-module`, `docs-language`), la sugerencia es el verbo que lo arma: `glot suite` → `quizá buscabas / maybe you meant: glot prompt suite` | 2 |

---

## 💾 Almacén de estado / State store

| Regla | Detalle |
|-------|---------|
| Ubicación | `GLOT_STATE_DIR` → `$XDG_STATE_HOME/glot` → `~/.local/state/glot`. Desde la **v1.0.0** el fichero es **por raíz de monorepo**: `<dir>/state.<clave>-<nombre de la raíz>`, para que dos repositorios no compartan `lang/phase/module`; fuera de un repositorio se usa el `<dir>/state` global de antes, y `GLOT_STATE_FILE` sigue mandando sobre todo lo demás (es lo que usa el harness para aislarse) |
| Estado global anterior | El `<dir>/state` de las versiones previas **no se migra**: se avisa una vez y se deja quieto. `doctor` lo nombra como `state_legacy:` y `path` imprime el fichero resuelto |
| Formato | Texto plano, una línea `clave=valor` por entrada; clave `[A-Za-z0-9_.-]+`, valor sin `\n` ni `\r` |
| Validación | Clave y valor se validan **antes** de tocar el disco; lo que no cumple falla con `2` |
| Escritura | Atómica: temporal con `mktemp` en el mismo directorio, `chmod 600`, `mv -f`; el directorio se crea con `chmod 700` |
| Concurrencia | `flock` sobre `<fichero>.lock` rodeando el ciclo leer-modificar-escribir |
| Lectura | `list` ordena con `LC_ALL=C sort -t= -k1,1`; `get` distingue «no encontrada» (`1`) de «valor vacío» (`0` con línea vacía) |
| Errores | No poder crear o escribir devuelve `3` |
| `-n/--dry-run` | Los verbos que mutan imprimen el efecto en stdout y no escriben; validan igual que la ejecución real |

### Claves reservadas / Reserved keys

| Clave | Significado | La escribe |
|-------|-------------|:----------:|
| `lang` | Lenguaje del sprint (carpeta del submódulo) | `use` (v0.5.0) |
| `phase` | Fase bajo `{lenguaje}/core/` (`foundations`, `algorithms`, …) | `use` (v0.5.0) |
| `module` | Módulo en `snake_case` (`naive_sort`) | `use` (v0.5.0) |
| `branch` | Rama de trabajo (`feat/algorithms/naive-sort`) | `use` (v0.5.0) |
| `spec` | Ruta de la especificación (`docs/core/algorithms/05_Naive_Sort.md`) | `use` (v0.5.0) |
| `repo` | Nombre del submódulo en la raíz del monorepo (`php`) | `use` (v0.5.0) |

**ES:** Hasta la v0.4.0 el almacén solo guardaba y devolvía texto: no interpretaba ninguna clave. Desde la v0.5.0 las escribe `use`.

**EN:** Up to v0.4.0 the store only saved and returned text: it interpreted no key. Since v0.5.0, `use` writes them.

---

## 📐 Reglas de diseño / Design rules

### Desde v0.3.0

1. **stdout solo dato, stderr solo diagnóstico**, para que la salida se pueda canalizar y capturar.
2. **Códigos de salida estables** (`0`/`1`/`2`/`3`).
3. **Nunca preguntar** en un verbo: el dato llega por argumento o stdin.
4. **Idempotencia** cuando se repite el mismo efecto.
5. **Inyectable para test**: raíz del repo y ruta del estado sobreescribibles por variable.
6. **Mensajes bilingües ES/EN**; los datos de salida no se traducen.
7. **Namespace**: funciones y variables internas con prefijo `_glot_`; públicas solo `GLOT_VERSION`, `GLOT_ROOT`, `GLOT_STATE_DIR`, `GLOT_STATE_FILE`, `GLOT_INSTALL_DIR`, `GLOT_INSTALL_BIN`, `BASH_COMPLETION_DIR`, `ZSH_COMPLETION_DIR` y `GLOT_TOOLCHAINS_FILE` (esta última, como `GLOT_STATE_FILE`, es para pruebas y herramientas: apunta a otro catálogo de toolchains) y `GLOT_DATA_DIR` (apunta a otro directorio de datos, para pruebas y laboratorio). `GLOT_LOADED` no se declara: la capa cargable la pone al delegar en el programa, para que `doctor` sepa que hay función

### Desde v0.4.0 — el almacén

8. **Texto plano y validado antes de escribir**; lo que no cumpla falla con `2` sin tocar el disco.
9. **Escritura atómica y bloqueada**: temporal en el mismo directorio + `mv -f`, todo bajo `flock`.
10. **Permisos restrictivos**: `600` el fichero y `700` el directorio.
11. **`3` para el estado**, nunca para el uso ni para el entorno.
12. **Ensayo antes de mutar**: todo verbo que escribe admite `-n/--dry-run`.

### Desde v1.0.0 — cuando sea cargable con `source`

13. **Sin `exit`, sin tocar opciones globales del shell** (`set -e`, `IFS`) ni el directorio actual fuera de un verbo que lo pida explícitamente; todo sale con `return`. La única excepción es el subshell del almacén (`( … )` en `_glot_state_rewrite`), donde `exit` termina ese subshell y no el shell que haya cargado `glot`.
14. **Raíz del monorepo**: `GLOT_ROOT` → superproyecto → raíz git, para que funcione también desde dentro de un submódulo.
15. **Un solo archivo, dos modos**: la guarda `"${BASH_SOURCE[0]}" == "$0"` ejecuta el dispatcher solo cuando se invoca como programa; cargado con `source`, el archivo define la función y no ejecuta nada.

### Desde v1.0.0 — la instalación

16. **Copia estable, no puntero**: lo instalado es una copia de `glot.sh` con sus datos, no un enlace al clon. Mover o borrar el repositorio no rompe la instalación; `doctor` es quien avisa de que la copia quedó vieja.
17. **Quirúrgico en el rc**: el bloque va entre `# >>> glot (install) >>>` y `# <<< glot (install) <<<`, y `install`/`uninstall` **solo** tocan lo que hay entre esas marcas. Nunca reescriben el rc entero ni lo crean si ya existe.
18. **Lo ajeno no se pisa**: si en la ruta del enlace hay un fichero, o un enlace que no apunta a la copia instalada, `install` falla con `1` y no toca nada; `uninstall` deja ese fichero donde está y avisa.
19. **Idempotencia y ensayo**: `install` repetido deja exactamente lo mismo (un solo bloque); `uninstall` sin nada instalado devuelve `0` con `nothing`. Los dos admiten `-n/--dry-run`.
20. **Cargar no ejecuta**: `source glot.sh` define la función y no ejecuta el dispatcher; el `cd` de `use` ocurre solo cuando el verbo se invoca **a través** de la función.

---

## 🧭 Catálogo (L2.5, v0.6.0) / Catalogue

**ES:** El catálogo **no adivina nombres: los convierte**. Cada módulo tiene un **id canónico** —el del roadmap— y todas sus formas se derivan de él. Las divergencias legacy se resuelven con excepciones mínimas y sondeo del disco, nunca con una tabla completa que haya que mantener a mano.

**EN:** The catalogue **does not guess names: it converts them**. Every module has a **canonical id** —the roadmap's— and all its forms derive from it. Legacy divergences are solved with minimal exceptions and probing the disk, never with a full table to maintain by hand.

### De un id a todas sus formas / From one id to all its forms

| Forma / Form | `data_structures_basics` | Cómo se obtiene / How |
|--------------|-------------------|------------------------|
| `name` (legible) | `Data Structures` | palabras capitalizadas, separadas por espacio |
| `project_name` (id) | `data_structures_basics` o `data_structures_advanced` | el id canónico del roadmap; no se deriva, se declara |
| `branch` | `data-structures` | `_glot_kebab`: `_` → `-` |
| documento | `NN_Data_Structures.md` | stem en `Title_Case` con `_`; el prefijo `NN` se **lee** de `docs/core/{fase}/` |
| commit | `data structures` | minúsculas y espacios |

**ES:** Excepciones declaradas (todo lo demás sigue la convención): `unit_test` → documento `03_Unit_Test_Calculator.md`; carpetas `helloworld`/`hellouser` (49 lenguajes; Ada usa el id tal cual) y `unit_test/calculator`, que el sondeo resuelve prefiriendo la forma más específica. La comparación del nombre del documento no distingue mayúsculas, así que `etl_basico` encuentra `14_ETL_Basico.md`.

**EN:** Declared exceptions (everything else follows the convention): `unit_test` → document `03_Unit_Test_Calculator.md`; folders `helloworld`/`hellouser` (49 languages; Ada uses the id as is) and `unit_test/calculator`, which the probe resolves preferring the most specific form. Document name matching is case-insensitive, so `etl_basico` finds `14_ETL_Basico.md`.

### Fuentes de datos / Data sources

| Dato / Datum | Fuente / Source |
|--------------|-----------------|
| Lenguajes registrados | `.gitmodules` (el denominador, 50) |
| Módulos y su estado | el bloque de contadores de `docs/ROADMAP.md` (fuente de verdad) |
| Especificación de cada módulo | `docs/core/{fase}/{NN}_{Nombre}.md`, con el prefijo leído del disco |
| Comandos nativos por lenguaje | [`data/languages.tsv`](../data/languages.tsv), con cabecera documentada en [`data/README.md`](../data/README.md) |
| Texto del autocompletado | [`completions/glot.bash`](../completions/glot.bash) y [`completions/glot.zsh`](../completions/glot.zsh) |

### Formatos de salida / Output formats

| Verbo | stdout |
|-------|--------|
| `langs` | `lenguaje<TAB>prueba nativa`, uno por línea, ordenado en `LC_ALL=C` |
| `modules [fase]` | `id<TAB>fase<TAB>módulo<TAB>especificación` (`-` si el documento aún no existe) |
| `progress` | `registrados=` · `homologados=` · `modulos=` · `pares_hechos=` · `pares_total=`, uno por línea |
| `progress <fase>` | `modulo<TAB>estado<TAB>hechos<TAB>total` |

**ES:** El **estado** se traduce de la marca del roadmap a una palabra en ASCII (`done`, `in_progress`, `planned`, `pending`) para que la salida sea parseable y no dependa de un emoji que un editor pueda corromper. El parser reconoce las marcas **por bytes**; una línea de `core.*` que no entienda es un error `1`, nunca un recuento inventado. Además, `progress` avisa si el contador `X/N` contradice la lista de lenguajes que el propio roadmap escribe entre paréntesis, o si su denominador no coincide con los lenguajes registrados.

**EN:** The **status** is translated from the roadmap mark into an ASCII word (`done`, `in_progress`, `planned`, `pending`) so the output is parseable and does not depend on an emoji an editor could corrupt. The parser recognises marks **by bytes**; a `core.*` line it does not understand is a `1` error, never an invented count. `progress` also warns when the `X/N` counter contradicts the language list the roadmap writes in parentheses, or when its denominator differs from the registered languages.

**ES:** **Definición / Definition:** `registrados` = lenguajes de `.gitmodules`; `homologados` = módulos con su contador completo; `pares_*` = suma de `X` y de `módulos × registrados`.

---

## ▶️ Ejecución (L3, v0.7.0) / Execution

**ES:** `test` y `verify` son la capa que **ejecuta** el trabajo: leen el catálogo, resuelven el objetivo y corren el comando del lenguaje en el directorio del módulo. La salida del runner va a **stdout tal cual** (es el dato y la evidencia del sprint); los avisos y el comando elegido van a stderr.

**EN:** `test` and `verify` are the layer that **executes** the work: they read the catalogue, resolve the target and run the language command in the module directory. The runner output goes to **stdout as is** (it is the datum and the sprint evidence); warnings and the chosen command go to stderr.

**ES:** El objetivo se resuelve en este orden: **argumentos** → **estado del sprint** → **directorio actual**. Lo último es lo que hace que `cd php && glot test algorithms/naive_sort` funcione sin pasar por `use`: dentro de un submódulo el lenguaje es evidente. El estado manda sobre el directorio a propósito: el sprint en curso es el que decide, y desde cualquier directorio `glot test` sigue apuntando a él.

**EN:** The target is resolved in this order: **arguments** → **sprint state** → **current directory**. The last one is what makes `cd php && glot test algorithms/naive_sort` work without going through `use`: inside a submodule the language is obvious. The state wins over the directory on purpose: the sprint in progress is what decides, and from any directory `glot test` keeps pointing at it.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Objetivo / Target | `glot <verbo> [lenguaje] [fase/módulo]`; lo que no llegue por argumento se completa con el **estado del sprint** (`lang`, `phase`, `module`) |
| Directorio / Directory | `{lenguaje}/core/{fase}/{módulo}`; si el comando empieza por `cd X &&`, ese `cd` se respeta |
| Comando / Command | Columna 4 (`test`) o 5 (`verify`) de [`data/languages.tsv`](../data/languages.tsv) |
| Marcadores / Placeholders | `{module}` → id (`naive_sort`), `{Module}` → PascalCase (`NaiveSort`), `{suite}` → archivo de suite |

**ES:** El vocabulario de marcadores es **uno solo** para el catálogo y para las plantillas de encargo, anclado a las claves del estado: `{lang}`, `{phase}`, `{module}`, `{repo}`, `{branch}`, `{spec}`, más `{Module}` (PascalCase), `{suite}` (catálogo) y `{module_dir}` (ruta absoluta del módulo).

**EN:** The placeholder vocabulary is **a single one** for both the catalogue and the request templates, anchored to the state keys: `{lang}`, `{phase}`, `{module}`, `{repo}`, `{branch}`, `{spec}`, plus `{Module}` (PascalCase), `{suite}` (catalogue) and `{module_dir}` (absolute module path).

**ES:** `{suite}` **no** se adivina: se deduce del propio patrón. Del token que lo contiene se toman el prefijo y el sufijo (`test/{suite}.vala` → `test/*.vala`; `{suite}_guile.scm` → `*_guile.scm`), se busca en el directorio efectivo del comando y se exige **una única** coincidencia; cero o varias son un error en vez de una elección silenciosa.

**EN:** `{suite}` is **not** guessed: it is derived from the pattern itself. The prefix and suffix are taken from the token containing it (`test/{suite}.vala` → `test/*.vala`; `{suite}_guile.scm` → `*_guile.scm`), it is searched for in the command's effective directory, and **exactly one** match is required; zero or several is an error instead of a silent choice.

| Resultado / Outcome | Código / Code |
|---------------------|:-------------:|
| Suite o verificador en verde | `0` |
| La suite o el verificador fallaron | `4` |
| El lenguaje aún no tiene verificador (imprime `skipped`) | `0` |
| No se pudo preparar (sin estado, módulo o fase inexistentes, suite ambigua) | `1` |

**ES:** La tabla de comandos es **superficie de ejecución**: por eso se versiona, `glot doctor` informa de su ruta y de su cobertura, `-n` imprime el comando exacto antes de correrlo y el harness comprueba su forma. Los comandos salen de la ejecución real de los módulos: **tres lenguajes ya homologados** (V, Rust y Crystal) tienen hallazgos de formato preexistentes, así que `verify` informa de ellos con `4`; no es un fallo de `glot` ni una regresión.

**EN:** The command table is an **execution surface**: that is why it is versioned, `glot doctor` reports its path and coverage, `-n` prints the exact command before running it, and the harness checks its shape. The commands come from real module runs: **three already-homologated languages** (V, Rust and Crystal) have pre-existing formatting findings, so `verify` reports them with `4`; it is not a `glot` failure nor a regression.

---

## 🤝 Delegación (L4, v0.8.0) / Delegation

**ES:** `prompt` **arma** el encargo para el agente y `ask` lo **envía**. Ninguno de los dos ejecuta el trabajo ni escribe en el repositorio: `prompt` imprime texto y `ask` lo entrega al delegado. Las plantillas viven **versionadas** en [`prompts/`](../prompts/), junto al tooling.

**EN:** `prompt` **builds** the request for the agent and `ask` **sends** it. Neither runs the work nor writes to the repository: `prompt` prints text and `ask` hands it to the delegate. Templates live **versioned** in [`prompts/`](../prompts/), next to the tooling.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Registro / Registry | `prompts/*.prompt.md`; el `name`, el `step`, el `model` y la `description` salen de su frontmatter, así que añadir un encargo es añadir un archivo. El **modelo es la clave del perfil** que fija esfuerzo y tope de créditos en [`data/models.tsv`](../data/models.tsv) (v0.11.0) |
| Salida de `prompt` / `prompt` output | Cabecera con el estado del sprint (`lang`, `phase`, `module`, `branch`, `spec`, `repo`, `root`, `module_dir`) + la plantilla sin frontmatter y con los marcadores resueltos. `root` es la raíz del monorepo, y es desde donde se leen las rutas de las fuentes |
| Fuentes del encargo / Request sources | La plantilla declara en su frontmatter las fuentes del monorepo que necesita (`sources:`, rutas relativas a `root`, ordenadas y separadas por coma). `prompt` y `ask` **avisan** por stderr de cada una que falte y el encargo se imprime igual: el código no cambia, porque el aviso es para el autor. Las plantillas ya **no** nombran el monorepo en prosa: sus rutas son relativas a `root` |
| `-n/--dry-run` | `prompt` no lo necesita (imprimir es su función); `ask -n` imprime el plan sin enviar nada |
| Delegado / Delegate | `GLOT_DELEGATE`: el encargo va por **stdin** y su salida va a **stdout**. Sin la variable, `ask` devuelve `1` |
| Plantilla local / Local template | Si solo existe en `.github/prompts/` (banco local del autor, no versionado), `prompt` la usa **avisando** |
| Marcador desconocido | Error `1` con el marcador y la lista de los válidos: nunca texto literal silencioso |

**ES:** `ask` es una **superficie de ejecución** como la tabla de comandos: la orden sale de una variable de entorno, se anuncia por stderr y `-n` la muestra antes de lanzarla. Un delegado que falla devuelve `1`, no `4`: no es una verificación.

**EN:** `ask` is an **execution surface** like the command table: the command comes from an environment variable, it is announced on stderr and `-n` shows it before running it. A failing delegate returns `1`, not `4`: it is not a verification.

---

## 🛠️ Creación y registro (L5, v0.9.0) / Creation and recording

**ES:** `new` **construye** el esqueleto del módulo y `save` **confirma** con la convención del repositorio. Son los dos verbos que hasta la v0.8.0 se hacían a mano.

**EN:** `new` **builds** the module skeleton and `save` **commits** with the repository convention. They are the two steps that were done by hand until v0.8.0.

### `new` — el esqueleto / the skeleton

**ES:** La parte mecánica sale del catálogo de datos, no del script. La columna 6 de [`data/languages.tsv`](../data/languages.tsv) decide qué hace:

| Tipo / Kind | Qué hace `new` / what `new` does |
|-------------|-----------------------------------|
| `tool` | Ejecuta el comando de la columna 7 **en el directorio del módulo** y después aplica la normalización de la columna 8 |
| `manual` | Ejecuta la creación de carpetas de la columna 7 (el esqueleto manual del lenguaje) |
| `deferred` | **No ejecuta nada**: informa, remite al encargo `scaffold` y imprime `skipped` |

**EN:** The mechanical part comes from the data catalogue, not from the script. Column 6 of [`data/languages.tsv`](../data/languages.tsv) decides what it does: `tool` runs column 7 in the module directory and then applies column 8; `manual` runs the folder creation of column 7; `deferred` **runs nothing**, points at the `scaffold` request and prints `skipped`.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Directorio / Directory | El del módulo, que prepara `use`. Si no existe, `new` **no lo inventa**: error `1` con la sugerencia de `use` |
| Normalización / Normalisation | `flat:<sub>` sube el contenido de `<sub>` y lo borra; `rm:<ruta>` elimina (tolerante). Separadas por `;` y en orden |
| Nido / Nesting | Los inicializadores que crean un proyecto hijo se ejecutan en el directorio del módulo y se aplanan: sin `flat` el módulo quedaría anidado dos veces |
| Repositorios anidados / Nested repositories | `crystal` y `gleam` crean un `.git` propio; `new` lo borra antes de aplanar, porque un repositorio dentro de un submódulo no es válido |
| Contenido previo / Existing content | Con el directorio no vacío **no se pisa nada**: aviso por stderr, imprime la ruta y devuelve `0` |
| Alcance / Scope | **No** escribe la suite (encargo `suite`), **no** implementa, **no** añade al índice y **no** confirma nada |
| `-n/--dry-run` | Imprime `cd <dir> && <comando>`, la normalización ya expandida y la ruta; no toca el disco |

**ES:** La normalización **no adivina**: si un lenguaje no tiene operación declarada en el catálogo, no se toca nada. Lo que el inicializador deja y el módulo no usa —runners de ejemplo, nombres predefinidos— lo ajusta el encargo `scaffold`, que sí puede leer la especificación.

**EN:** Normalisation **does not guess**: if a language has no declared operation in the catalogue, nothing is touched. What the initializer leaves and the module does not use —sample runners, predefined names— is adjusted by the `scaffold` request, which can read the specification.

### `save` — el registro / the recording

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Mensaje / Message | Sale de [`data/commits.tsv`](../data/commits.tsv) por **paso** (`4a`, `4b`, `4c`, `5`, `7`, `8`) o por **alias del encargo** (`scaffold`, `contract`, `suite`, `implement`, `docs-module`, `docs-language`). Nunca se escribe a mano |
| Marcadores / Placeholders | `{lang}`, `{phase}`, `{module}`, `{Module}`: los mismos del resto del tooling, resueltos con el estado del sprint |
| Índice / Index | `git add -A` del **submódulo** completo. Si hay cambios fuera del módulo, se nombran por stderr antes de confirmar |
| Rama / Branch | Si la rama activa no es la del estado del sprint, se avisa (no se bloquea) |
| Ámbito / Scope | Solo los pasos con ámbito `submodule`. Los del monorepo (puntero y roadmap) se rechazan con `1` y remiten a `close` (v0.10.0) y `pointer` (v0.12.0) |
| Salida / Output | El **SHA corto** del commit; `nothing` si el árbol ya estaba limpio |
| Push | **Nunca**. La rama la publica `use`; subir el trabajo es del autor |
| `-n/--dry-run` | Imprime el `git add` y el `git commit -m` con el mensaje ya resuelto. Con el árbol ya limpio no hay plan que enseñar: imprime `nothing`, igual que la ejecución real |

**ES:** `save` no inventa convenciones: si el paso no está en el catálogo, no hay commit. La tabla del sprint ([`SPRINT.md`](SPRINT.md)) es la fuente y el catálogo es la copia que lee el verbo; el harness comprueba la **deriva** entre las dos, y que cada alias sea un encargo registrado.

**EN:** `save` does not invent conventions: if the step is not in the catalogue, there is no commit. The sprint table ([`SPRINT.md`](SPRINT.md)) is the source and the catalogue is the copy the verb reads; the harness checks the **drift** between the two, and that every alias is a registered request.

---

## 🧾 Evidencia, cierre y validación (L6, v0.10.0) / Evidence, closure and validation

**ES:** `evidence` **deja el acta** de lo que pasó de verdad y `close` (más adelante en esta misma versión) comprueba los requisitos del cierre y registra el cambio en el checklist y en el roadmap. La evidencia es del **monorepo** —`docs/evidence/{fase}/{módulo}/{lenguaje}.md`— y apunta al commit del submódulo que la respalda: el acta es el registro del cierre, no un artefacto del lenguaje.

**EN:** `evidence` **writes the record** of what actually happened and `close` (later in this same version) checks the closure requirements and registers the change in the checklist and the roadmap. The evidence belongs to the **monorepo** —`docs/evidence/{phase}/{module}/{language}.md`— and points at the submodule commit backing it: the record is the closure's log, not a language artefact.

### `evidence` — el acta / the record

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Qué ejecuta / What it runs | La suite (columna 4 del catálogo) y el verificador (columna 5), en el directorio del módulo, con **stdout y stderr juntos** |
| Qué escribe / What it writes | El acta en `docs/evidence/{fase}/{módulo}/{lenguaje}.md`: fecha, rama, commit del submódulo, si el árbol está sucio, el comando de cada uno, su salida tal cual y su código de salida |
| Bloque de máquina / Machine block | Un comentario HTML `<!-- glot:evidence … -->` con `lang`, `phase`, `module`, `branch`, `commit`, `dirty`, `date`, `test_exit`, `verify_exit` y `verdict`: invisible al renderizar y legible con una línea de grep, para que `close` no tenga que interpretar markdown |
| Salida / Output | La **ruta del acta** por stdout; el veredicto y los avisos por stderr |
| Códigos / Codes | `0` verde · `1` entorno · `2` uso · `3` no se pudo escribir el acta · **`4` en rojo** |
| En rojo / When red | **Escribe el acta igual**: la evidencia es lo que pasó, no lo que se desea. Devuelve `4` para que un CI lo note |
| Árbol sucio / Dirty tree | Se marca (`dirty=yes`) y se avisa: la evidencia apunta al commit, así que lo que no está confirmado no queda respaldado |
| Sin verificador / No verifier | Con la columna 5 en `-` solo se ejecuta la suite, y el acta lo dice (`verify_exit=-`) |
| `-n/--dry-run` | Enseña los comandos y dónde queda el acta, sin ejecutar ni escribir |
| Qué **no** hace / What it does **not** | No confirma (el commit es del autor), no toca el submódulo ni el roadmap, y no resume ni interpreta la salida |

### `close` — el cierre / the closure

**ES:** `close` registra el cierre de **un módulo en un lenguaje**. Comprueba lo que el script puede comprobar y no finge el resto: la revisión cualitativa (pseudocódigo, divergencias idiomáticas) sigue siendo de una persona.

**EN:** `close` records the closure of **one module in one language**. It checks what the script can check and does not fake the rest: the qualitative review (pseudocode, idiomatic divergences) is still a person's job.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Comprueba / It checks | El acta de evidencia **en verde** (`verdict=green`), el README del módulo y el README de la fase. Sin acta, `1` con la orden que la genera; con el acta en rojo o un README ausente, `4` |
| Registra / It records | Una entrada en `docs/ROADMAP_UPDATE_CHECKLIST.md` con la plantilla del repositorio: fecha, fase, módulo, lenguaje, evidencia, comandos y sus códigos (leídos del acta), READMEs y el cambio del roadmap |
| Actualiza / It updates | La línea del módulo en `docs/ROADMAP.md`: contador `X/50`, marca (`🔄` en curso, `✅` al llegar al total) y lista entre paréntesis, con el **nombre de presentación** (`php` → `PHP`, `tcl-tk` → `Tcl/Tk`) y el orden canónico de [`data/display.tsv`](../data/display.tsv) |
| No adivina / It does not guess | Conserva el formato que ya tiene la línea; si no entiende el contador, usa el número de lenguajes registrados como total. Una línea que no se encuentra es `1` |
| Idempotente / Idempotent | Si el lenguaje ya está en la lista, avisa, imprime la línea y devuelve `0` sin tocar nada ni volver a pedir la evidencia |
| Salida / Output | La **línea nueva del roadmap** por stdout |
| `-n/--dry-run` | Imprime el **diff exacto** que aplicaría (`-` línea vieja, `+` línea nueva) y no escribe nada |
| Qué **no** hace / What it does **not** | **No confirma**: el commit es del autor, como el resto de los cambios del monorepo. Tampoco cuenta el cierre en la cabecera de la fase, cuyo formato aún no es único entre fases |

### `validate` — la validación / validation

**ES:** `validate` **encarga** la validación automática del módulo. No valida él: pasa el encargo al validador y traduce lo que responde. Es **opcional** —el validador necesita el CLI de Copilot y la suscripción del autor, que no son dependencias del repositorio—, así que el cierre no lo exige.

**EN:** `validate` **requests** the module's automatic validation. It does not validate itself: it hands the request to the validator and translates the answer. It is **optional** —the validator needs the Copilot CLI and the author's subscription, which are not repository dependencies—, so the closure does not require it.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Encargo / Request | **El mismo que imprime `glot prompt validate`** (paso 6): una sola verdad entre lo que se lee y lo que se envía. Va por **stdin** |
| Orden / Command | `GLOT_VALIDATOR`, con `ask` como precedente. Sin la variable, la invocación verificada de Copilot CLI en **solo lectura** (`--deny-tool write`), con el modelo, el esfuerzo y el tope de créditos del **perfil del encargo** (v0.11.0) |
| Registro / Record | `docs/evidence/{fase}/{módulo}/{lenguaje}.validate.md`: bloque de máquina (`verdict`, `findings`, `validator`, `commit`, `dirty`, `date`) más el informe del validador tal cual. Lo escribe `glot`, así que vale también para un validador propio |
| Veredicto / Verdict | Se **lee**, no se adivina: la plantilla exige una última línea `glot:validate verdict=clean\|findings findings=N`. Sin ella, o con un valor que no sea `clean` ni `findings`, devuelve `3` |
| Salida / Output | El informe del validador por stdout (JSONL con el CLI), y el veredicto y la ruta del registro por stderr |
| Códigos / Codes | `0` sin hallazgos · `1` sin validador o entorno · `2` uso · `3` no se pudo ejecutar o no se pudo leer el veredicto · **`4` con hallazgos** |
| `-n/--dry-run` | Enseña el comando que se lanzaría —con el encargo en lugar del prompt— y la ruta del registro, sin ejecutar ni escribir |
| Qué **no** hace / What it does **not** | No corrige nada, no confirma, y no sustituye a la revisión humana: el validador puede equivocarse en las dos direcciones |

---

## 🤖 Perfiles de modelo (L6.5, v0.11.0) / Model profiles

**ES:** Cada encargo declara **su modelo** en el frontmatter de su plantilla (`model:`, con el id real que ofrece Copilot) y el catálogo [`data/models.tsv`](../data/models.tsv) fija el esfuerzo, el tope de créditos y el tier de auto de ese modelo. El **modelo es la clave del perfil**: no hay una clave `profile:` que pueda derivar del modelo declarado.

**EN:** Every request declares **its model** in its template frontmatter (`model:`, with the real id Copilot offers) and the [`data/models.tsv`](../data/models.tsv) catalogue fixes the effort, the credit cap and the auto tier for that model. The **model is the profile key**: there is no `profile:` key that could drift from the declared model.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Dónde se declara / Where | `model:` en el frontmatter de la plantilla, que `glot prompt` (sin encargo) enseña como **tercera columna** del registro |
| Qué añade el catálogo | Esfuerzo (`--reasoning-effort`), tope de créditos (`--max-ai-credits`) y tier de auto (`--auto-tier`, solo si el modelo es `auto`). El mínimo de créditos que acepta el CLI es **30** |
| `ask` | Exporta `COPILOT_MODEL` —y `COPILOT_AUTO_TIER` si el perfil lo declara— antes del `eval` del delegado: a un delegado cualquiera se le da entorno, no flags |
| `validate` | Compone además su invocación por defecto con `--model`, `--reasoning-effort` y `--max-ai-credits` del perfil |
| Dato que falta / Missing datum | `model:` ausente en la plantilla, o un modelo que el catálogo no reconoce: **`1`**, como un marcador sin resolver. Nunca se inventan esfuerzo ni créditos |
| Anti-envejecimiento | `doctor` informa de `model_profiles` (encargos con perfil reconocido) y de `model_available` (modelos del catálogo que siguen en la lista del CLI instalado) |
| Qué **no** hace / What it does **not** | No gestiona proveedores ni claves (BYOK fuera de alcance) y no tiene override por corrida: manda el `model:` de la plantilla, que es el dato versionado |

---

## 🧹 Higiene y punteros (L7, v0.12.0) / Hygiene and pointers

**ES:** La capa de ops diaria: `status` para mirar, `pointer` para dejar el puntero listo y `clean` para quitar artefactos. Ninguno confirma nada: el commit del monorepo lo hace `save 9` o `save 10`.

**EN:** The daily-ops layer: `status` to look, `pointer` to get the pointer ready and `clean` to drop artefacts. None of them commits: the monorepo commit is made by `save 9` or `save 10`.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| `pointer` no confirma | **Prepara**: verifica, deja el submódulo en el commit integrado, prepara la rama `chore/{fase}/{módulo}-pointer`, la publica con upstream y hace `git add <lenguaje>`. El commit lo hace `save 9`, que es el mismo verbo que confirma el resto del sprint |
| La regla, como comprobación | `pointer` hace `fetch` explícito de `origin/main` del submódulo y exige que su HEAD **sea** ese commit: nunca se apunta a una rama de trabajo sin integrar. Con el ref local, la comprobación podría mentir |
| Idempotencia | Si el monorepo ya apunta a ese commit, imprime `nothing` y no toca ramas |
| `status` sin resumen | Cuatro columnas y un lenguaje por línea: el resumen de contadores es de `progress`, y `status` no muta nada, así que no necesita `-n` |
| Alcance de `clean` | `git clean -Xfd` en el **directorio del módulo** (lo que el `.gitignore` del lenguaje declara como artefacto) más `git submodule sync` del lenguaje. Nunca `-x`: lo no rastreado y no ignorado es trabajo del autor. Nunca el monorepo ni `docs/` |
| Lo del propio sprint no bloquea | `pointer` no se detiene por el **gitlink del lenguaje** (es el cambio que el verbo viene a preparar) ni por la **evidencia del sprint**, que confirma `save 10` *después* del puntero; cualquier otra ruta sin confirmar sí lo detiene y se nombra |
| Qué **no** hace / What it does **not** | No hace `push` del monorepo (`pointer` solo publica su rama), no confirma, y no borra nada que el lenguaje no haya declarado ignorado |

---

## 📦 Instalación y capa cargable (L8, v1.0.0) / Installation and the loadable layer

**ES:** `install` es el único verbo que toca el `HOME` del usuario, y lo hace de forma declarada y reversible: copia el script con sus datos, deja el enlace en el `PATH`, el completado donde cada shell lo busca y un bloque del rc entre marcas. El bloque carga la **copia**, y esa copia es la que define la función `glot`: la única forma de que `use` haga el `cd` real, porque un proceso hijo no puede cambiar el directorio de su padre.

**EN:** `install` is the only verb that touches the user's `HOME`, and it does so explicitly and reversibly: it copies the script along with its data, leaves the symlink in `PATH`, the completion where each shell looks for it and an rc block between markers. The block loads the **copy**, and that copy defines the `glot` function: the only way `use` can perform the real `cd`, because a child process cannot change its parent's directory.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Rutas por defecto | Copia `~/.local/share/glot/`, enlace `~/.local/bin/glot`, completado `~/.local/share/bash-completion/completions/glot` y `~/.zsh/completions/_glot`. Todas cambiables por variable: `GLOT_INSTALL_DIR`, `GLOT_INSTALL_BIN`, `BASH_COMPLETION_DIR`, `ZSH_COMPLETION_DIR` |
| Bloque del rc | Bash: `if [ -r "DIR/glot.sh" ]; then . "DIR/glot.sh"; fi`. Zsh: `fpath+=("DIR")`, que añade la carpeta del completado (el guion de bash no se puede cargar en zsh) |
| Metadatos | `install.meta` junto a la copia, con `version`, `source`, `date` y `sha` (checksum del `glot.sh` copiado). Sin él, `doctor` no puede decir si la copia quedó vieja, así que no escribirlo es `3` |
| `-n/--dry-run` | Imprime el plan (`mkdir`, `cp`, `ln`, bloque del rc) y **no** crea nada; la última línea es el directorio de instalación |
| Idempotencia | Repetido deja lo mismo y un solo bloque por rc. Sirve también de actualización: reinstalar refresca la copia y el `sha` |
| Enlace ajeno | Fichero o enlace que no apunta a la copia instalada: `1`, con el motivo por stderr, sin tocar nada |
| `uninstall` | Quita el bloque, borra el completado (y la carpeta vacía que lo contenía), retira el enlace **solo si es el suyo** y la copia. Idempotente: `nothing` y `0` si no había nada |
| Qué **no** hace / What it does **not** | No instala dependencias ni toolchains (L9), no toca el `PATH` de ningún rc, no modifica `.bashrc`/`.zshrc` fuera de sus marcas ni los crea si ya existen, y no confirma nada en git |

**ES:** `doctor` da el estado de esta capa con estas líneas: `install:` (sí/no y ruta), `install_version:` e `install_source:` (de los metadatos), `install_stale:` (la copia o el clon cambiaron respecto al `sha` guardado), `install_data:` (desde la **v1.1.0**: si `data/`, `prompts/` y `completions/` siguen siendo los instalados; `(sin metadatos)` en una instalación anterior), `install_rc:` (el bloque sigue en el rc de cada shell: `bash:yes zsh:no`), `install_path:` (la carpeta del enlace está en el `PATH`), `shell:` (bash y zsh presentes con su versión) y `shell_loaded:` (si esa shell cargó la función, que lo sabe porque la capa exporta `GLOT_LOADED` al delegar). Desde la **v1.1.0** `install.meta` guarda tres huellas —`sha` de todo lo que viaja con la copia, `script_sha` y `data_sha`—, así que una copia con el catálogo viejo deja de pasar por buena.

**EN:** `doctor` reports this layer with these lines: `install:` (yes/no and path), `install_version:` and `install_source:` (from the metadata), `install_stale:` (copy or clone changed against the stored `sha`), `install_data:` (since **v1.1.0**: whether `data/`, `prompts/` and `completions/` are still the installed ones; `(sin metadatos)` on an older installation), `install_rc:` (the block is still in each shell's rc: `bash:yes zsh:no`), `install_path:` (the symlink directory is in `PATH`), `shell:` (bash and zsh present, with their version) and `shell_loaded:` (whether that shell loaded the function, known because the layer exports `GLOT_LOADED` when delegating). Since **v1.1.0** `install.meta` stores three fingerprints —`sha` for everything that travels with the copy, `script_sha` and `data_sha`— so a copy with a stale catalogue no longer passes as good.

---

## 🧰 Toolchains: el dato y la comprobación (v1.0.0) / Toolchains: the datum and the check

**ES:** La L9 es **instalar** versiones; lo que entra en la v1.0.0 es el **dato** y su comprobación. El dato vive en [`data/toolchains.tsv`](../data/toolchains.tsv) (`lenguaje`, `comando`, `serie verificada`) y crece **solo con versiones verificadas en este entorno**, así que hay lenguajes sin fila: es un fichero que crece, no una lista que hay que completar.

**EN:** L9 is about **installing** versions; what lands in v1.0.0 is the **datum** and its check. The datum lives in [`data/toolchains.tsv`](../data/toolchains.tsv) (`language`, `command`, `verified series`) and only grows **with versions verified in this environment**, so some languages have no row: it is a file that grows, not a list to be completed.

| Aspecto / Aspect | Detalle / Detail |
|------------------|------------------|
| Qué informa `doctor` | `toolchains_file:`, la **cobertura** (`toolchains: N de / of M`) y la **presencia** de las filas declaradas (`toolchains_present:`). Cobertura y presencia son un `command -v` por fila |
| Qué comprueba además | La **serie** del lenguaje del sprint en curso: `toolchain_<lenguaje>: ok (3.4.3 = 3.4)` |
| Comparación | Por **prefijo** contra la primera versión que aparece en la salida del comando: `3.4` acepta `3.4.3`; un salto de serie es `differs` |
| Códigos | `missing` (la herramienta no está) y `unknown` (fila fuera de `.gitmodules` o sin versión legible) dan `1`. `differs` **no** cambia el código: que una versión avance es información, no un fallo del entorno |
| Por qué no se comprueban todas | Arrancar las 45 toolchains declaradas cuesta unos 5 segundos medidos, y `doctor` se ejecuta a menudo; el lenguaje del sprint es el que se va a usar |
| Inyectable | `GLOT_TOOLCHAINS_FILE` apunta a otro catálogo, como `GLOT_STATE_FILE` con el estado |
| Qué **no** hace / What it does **not** | No instala ni actualiza versiones (eso es L9), no escribe el catálogo y no adivina una serie que no esté declarada: sin fila, `toolchain_<lenguaje>: - (sin serie declarada)` |

---

## 🧾 Especificación de `use` (v0.5.0, implementado) / `use` specification

```bash
glot use <lenguaje> <fase>/<módulo> [tipo]     # tipo por defecto: feat
glot use <fase>/<módulo> [tipo]                # dentro del submódulo, deduce el lenguaje
```

**ES:** `use` **sitúa el trabajo**: dice dónde vas a trabajar y lo deja preparado. Lee el estado, nunca lo fuerza: **con trabajo sin confirmar no crea ni cambia ramas**. No implementa, no genera esqueleto (solo crea la carpeta vacía del módulo) y no toca el monorepo.

**EN:** `use` **locates the work**: it tells you where you will be working and gets it ready. It reads the state, never forces it: **with uncommitted work it creates and switches nothing**. It does not implement, does not scaffold (it only creates the empty module folder) and does not touch the monorepo.

| Paso | Efecto |
|:----:|--------|
| 1 | Valida lenguaje, fase, módulo, `tipo` y estado del árbol **sin tocar nada** |
| 2 | Resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` |
| 3 | Clasifica el estado: ¿existe la carpeta del módulo? ¿existe la rama `{tipo}/{fase}/{módulo}`? ¿hay trabajo sin confirmar? |
| 4 | **Árbol limpio**: activa la rama si ya existe, o la crea **desde `main`** si no, y la publica con `push -u origin {rama}`. Crea `{lenguaje}/core/{fase}/{módulo}` (**vacía**: sin `src/` ni `test/`) solo si falta |
| 5 | **Trabajo sin confirmar** (estado normal de reanudar): no crea ni cambia ramas. Si ya estás en la rama objetivo, la republica; si no, informa de dónde estás y de la rama que falta |
| 6 | Escribe el estado (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) |
| 7 | Imprime la **ruta absoluta** del módulo en stdout |

### Estados del sprint / Sprint states

**ES:** Los cuatro estados que `use` reconoce. El directorio del módulo **no** cuenta como suciedad ajena: dentro de él, un árbol sucio es el estado normal de un sprint a medias (fin de jornada, corte de luz, implementación incompleta), no una anomalía.

**EN:** The four states `use` recognises. The module directory does **not** count as foreign dirt: inside it, a dirty tree is the normal state of an unfinished sprint (end of the day, power cut, incomplete implementation), not an anomaly.

| Estado | Árbol | Rama `{tipo}/{fase}/{módulo}` | Qué hace `use` |
|--------|-------|-------------------------------|----------------|
| **Nuevo** | — | no existe | crea la rama desde `main`, la publica, crea la carpeta vacía y guarda el estado |
| **En curso, limpio** | limpio | existe | la activa (aunque estés en `main`), la publica y guarda el estado |
| **Reanudar** | con trabajo sin confirmar | exista o no | **no crea ni cambia nada**: republica si ya estás en la rama; si no, informa de dónde estás |
| **Cerrado** | limpio sobre `main` | no existe | con `tipo` explícito abre la rama de mantenimiento (`test`, `fix`, `refactor`…) desde `main` y la publica; sin `tipo`, avisa y sugiere uno |

**ES:** El `tipo` por defecto (`feat`) es el de la rama propia del módulo: por eso, con el módulo **ya cerrado**, `use` exige indicarlo para no resucitar una rama `feat` fantasma. Con el módulo **nuevo** el valor por defecto se aplica sin preguntar.

**EN:** The default `tipo` (`feat`) is the module's own branch type: that is why, with an **already closed** module, `use` requires it to be given so a phantom `feat` branch is not resurrected. With a **new** module the default applies without asking.

| Comprobación | Falla con |
|--------------|:---------:|
| Faltan argumentos, `tipo` fuera de `feat\|fix\|docs\|chore\|refactor\|test`, opción desconocida | `2` |
| Lenguaje fuera de `.gitmodules` · especificación ausente · submódulo sin inicializar · cambios sin confirmar **fuera** del directorio del módulo · la ruta del módulo existe y no es un directorio · rama no creable o no publicable | `1` |
| Estado no escribible (el módulo y la rama ya estarían preparados: se avisa por stderr) | `3` |

**ES:** **No hace:** commits, `git add`, correr el inicializador, generar esqueleto (`src/`, `test/` y el contrato de pruebas son de `new` y del encargo `suite`, v0.9.0), tocar la rama del monorepo ni el puntero del submódulo. **Con trabajo sin confirmar nunca crea ni cambia de rama**: reanudar es su caso principal, no un error. **El `cd` real existe desde la v1.0.0**, pero solo con la capa cargable (`install`): ejecutado como programa, `use` imprime la ruta y hay que hacer `cd "$(glot use …)"`.

**EN:** **It does not:** commit, `git add`, run the initializer, scaffold (`src/`, `test/` and the test contract belong to `new` and the `suite` request, v0.9.0), touch the monorepo branch or the submodule pointer. **With uncommitted work it never creates or switches branches**: resuming is its main case, not an error. **The real `cd` exists since v1.0.0**, but only with the loadable layer (`install`): run as a program, `use` prints the path and you have to do `cd "$(glot use …)"`.
