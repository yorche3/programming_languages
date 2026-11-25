# 🗂️ Catálogo de datos / Data catalogue

**ES:** En **v2.1.0-dev**, la configuración vigente de modelos está descrita en
[`VALIDATION.md`](../docs/VALIDATION.md). `models.tsv` conserva siete columnas,
pero la clave ahora es el perfil (`profile:` en la plantilla): Flash nativo
economy, Terra 6.1 balanced (contract/build), Sonnet 5.5 deep (incluida suite).
AGY deep es `-`, sin asociación no-thinking verificada.
`delegates.tsv` separa `agy`, `copilot` nativo y `open-router`; no infiere ruta
por la barra del id. Las secciones de modelos más abajo describen el historial
hasta v2.0.3, no la política vigente.

**EN:** Current model routing is documented in
[`VALIDATION.md`](../docs/VALIDATION.md). The seven-column profile catalogue
is now keyed by `profile:`. Delegate aliases distinguish AGY, native Copilot
and OpenRouter explicitly. The later model sections are historical v2.0.3
reference, not the current policy.

### `model_options.tsv`: adaptadores autorizados / authorized adapters

**ES:** Tabla con cabecera, separada por tabuladores. Una fila por ruta/modelo,
sin credenciales ni precios. Se instala junto con los demás datos.

**EN:** Headered TSV, one row per route/model, containing no credentials or
prices; installed with the other runtime data.

| Columna / Column | Contrato / Contract |
|---|---|
| `route` | `agy`, `copilot`, `open-router` |
| `model` | Id real del catálogo de alias |
| `requests` | Lista de encargos autorizados, separada por coma |
| `efforts` | Niveles verificados separados por coma; `-` omite control y rechaza effort explícito |
| `max_prompt_tokens` | Límite de entrada BYOK; `-` en rutas no BYOK |
| `max_output_tokens` | Límite de salida BYOK; no amplía contexto |

**ES / EN:** Los ids pendientes (Argon AGY) permanecen declarados y bloquean
si el catálogo local no los ofrece; no se sustituyen. / Pending IDs remain
declared and block when absent from the local catalogue, without substitution.

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
| 2 | Tipo de inicialización (lo lee `glot new`): `tool` (hay herramienta) o `manual` (esqueleto de carpetas) | `tool` |
| 3 | Comando nativo de pruebas (lo ejecuta `glot test`) | `composer test` |
| 4 | Verificador (lo ejecuta `glot verify`): **lint idiomático** de sintaxis y formato, con la herramienta del lenguaje; `-` si el lenguaje aún no tiene. **No** comprueba la suite ni busca *hardcode*, y el análisis estático de seguridad es un no-objetivo (v1.4.0) | `php -l src/{Module}.php` |

**ES:** Este catálogo **no** guarda los datos del `ruleset`. El estado de idiomaticidad, los nombres canónicos y las características por lenguaje viven en [`docs/ruleset/data/`](../../docs/ruleset/data/) —`idiomaticity_state.tsv`, `canonical_names.tsv` y `language_characteristics.tsv`—, que es la **única copia versionada**; las copias duplicadas que había en este directorio se retiraron el 2026-10-13 porque no las consumía ninguna herramienta ni las documentaba este README.

**EN:** This catalogue does **not** hold the `ruleset` data. The idiomaticity state, the canonical names and the per-language characteristics live in [`docs/ruleset/data/`](../../docs/ruleset/data/) — `idiomaticity_state.tsv`, `canonical_names.tsv` and `language_characteristics.tsv` — which is the **single versioned copy**; the duplicate copies kept in this directory were removed on 2026-10-13 because no tool consumed them and this README did not document them.

**ES:** La columna 2 (tipo) y el comando de pruebas salen de la tabla maestra de
[`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md),
que sigue siendo el documento humano. El **esqueleto** no se duplica aquí: vive entero en
[`init_sequences.tsv`](init_sequences.tsv), que fue lo que permitió retirar de este catálogo la
secuencia v1, los manifiestos, el comando único y la normalización (v2.0.0).
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
que no lo siga necesitará revisar su fila. Prolog recoge todas las suites
`*_test.pl` y `*_tests.pl` con PlUnit. Perl usa la selección de archivos y el
harness TAP de prove, pero rechaza las ejecuciones sin casos o con todos omitidos.
Raku usa el descubrimiento y harness de prove6 con la misma protección; suma
los resultados individuales porque TAP 0.3.15 no agrega correctamente `skipped`.
Scheme ejecuta cada suite `*_guile.scm` y comprueba su runner SRFI-64.
Tcl ejecuta cada suite `.test` y comprueba los contadores de Tcltest al limpiar.
Scala conserva la tarea e informe nativos de sbt y comprueba sus resultados
estructurados; rechaza las ejecuciones sin casos aprobados.
Rust valida el resumen `libtest` de cada target Cargo y exige al menos un caso
aprobado; admite casos omitidos junto a aprobados, pero rechaza targets sin
resumen. Otros formatos requieren revisión.
Haskell selecciona las suites del paquete actual y comprueba el resumen Hspec
de cada una: rechaza resultados ausentes, vacíos o pendientes. Convierte en
error `missing-home-modules` para detectar módulos locales importados pero no
declarados en los targets compilados. Ejecuta las suites secuencialmente con
formato Hspec `progress`, sin color ni dry-run. Usa un directorio de build
temporal nuevo en cada ejecución, sin limpiar el build del proyecto o workspace;
recompilar cuesta tiempo. No modifica el manifiesto;
runners que no admitan esas opciones o no emitan el resumen esperado requieren
revisión.

**EN:** **Column 5 is maintained by hand** and only with verifiers **actually run**
in the corresponding module; coverage is reported by `doctor` as
`verify_commands` and grows as languages add their verifier. Columns 4 and 5 may
carry placeholders (`{module}`, `{Module}`, `{suite}`): `glot` resolves them against
the real module before running, and `-n` prints the result. The `nim`, `perl`, `php`
and `ruby` rows rely on the file name, so a module not following it will need its row
reviewed. Prolog collects all `*_test.pl` and `*_tests.pl` suites with PlUnit.
Perl uses prove's file discovery and TAP harness, rejecting empty or entirely
skipped runs instead of reporting them as successful.
Raku uses prove6's discovery and harness with the same protection; it sums
per-file results because TAP 0.3.15 does not aggregate `skipped` correctly.
Scheme runs every `*_guile.scm` suite and checks its SRFI-64 runner.
Tcl runs every `.test` suite and checks Tcltest counters at cleanup.
Scala retains sbt's native task and report and checks structured results;
it rejects runs without passing cases.
Rust validates each Cargo target's `libtest` summary and requires at least one
passing case; ignored cases may accompany passing cases, but targets without a
summary are rejected. Other formats require review.
Haskell selects the current package's test suites and checks each Hspec summary,
rejecting missing, empty or pending results. It promotes `missing-home-modules`
to an error to detect imported local modules missing from compiled targets.
Suites run sequentially with Hspec's progress format, no color and no dry-run.
Each run uses a fresh temporary build directory without cleaning the project's
or workspace's build; recompilation costs time. It does not edit the manifest;
runners that do not accept those options or
emit the expected summary require review.

**ES:** `haskell_sync.sh` respalda `glot sync-build`: declara un módulo interno
existente por ejecución en la biblioteca o test-suite de la plantilla Cabal
3.16.1.0 adaptada a Hspec. Acepta únicamente el layout `lib/` y `test/` y las
declaraciones de una línea que genera el propio comando; las secciones de
target y `common warnings` deben coincidir con la plantilla. Si la
configuración, lista o ruta no coincide, falla y conserva el manifiesto. No
descubre módulos, no decide exports públicos ni conecta el runner.

**EN:** `haskell_sync.sh` backs `glot sync-build`: one existing internal module
per invocation in the library or test suite of the recognized Cabal 3.16.1.0
Hspec-adapted template. It accepts only the `lib/` and `test/` layout and
single-line declarations produced by the command; the target and `common
warnings` sections must match the template. Other configurations, lists or
unsafe paths fail without editing the manifest. It does not discover modules,
decide public exports or connect the runner.

**ES:** Los esqueletos de `Makefile` compartidos por `assembly`, `c`, `cobol`,
`grain` y `r` viven en [`scaffold_templates/`](scaffold_templates/); el catálogo
los copia solo cuando el módulo aún no tiene `Makefile`. `scaffold` también
garantiza un `.gitignore` sin reemplazar el contenido existente. El encargo 4a
añade o ajusta los patrones que dependen del lenguaje y verifica un artefacto con
`git check-ignore`.

**EN:** Shared `Makefile` scaffolds for `assembly`, `c`, `cobol`, `grain` and `r`
live in [`scaffold_templates/`](scaffold_templates/); the catalogue copies one
only when the module has no `Makefile`. `scaffold` also ensures a `.gitignore`
without replacing existing contents. The 4a request adds or adjusts
language-specific patterns and verifies an artifact with `git check-ignore`.

**ES:** Assembly crea una fuente NASM mínima y un runner que anuncia que no
hay tests; también crea `.gitignore` con patrones si falta el archivo. Los
archivos existentes se conservan; el paso de suite conecta los grupos al runner.

**EN:** Assembly creates a minimal NASM source and a runner announcing that
there are no tests, plus an ignore file when absent. Existing content is preserved;
the suite step connects its groups to the runner.

**ES:** C preserva cabecera, fuente y Makefile existentes; si falta
`.gitignore`, incluye `bin/` y `obj/`. Criterion aporta el runner incluso
sin casos; la suite añade las pruebas, sin crear otro `main`.

**EN:** C preserves existing headers, sources and Makefiles, and creates a
missing `.gitignore` for `bin/` and `obj/`. Criterion supplies the runner
even without cases; the suite adds tests without creating another `main`.

**ES:** D crea `source/{module}.d` y `test/`, y un `.gitignore` si falta.
Solo retira el `app.d` idéntico a la muestra verificada y configura `test/`
en manifiestos generados o simples de biblioteca reconocidos. `d_test.sh`
comprueba las fuentes de `test/` seleccionadas por DUB y, si un manifiesto
homologado las omite, ejecuta la suite en una copia temporal configurada por
el helper de scaffold; no modifica el módulo. Manifiestos no reconocidos se
conservan y requieren adaptación explícita.

**EN:** D creates `source/{module}.d` and `test/`, and a missing `.gitignore`.
It removes only the `app.d` sample identical to the verified template and
configures `test/` for recognized generated or simple-library manifests.
`d_test.sh` checks the test sources selected by DUB and, if a homologated
manifest omits them, runs the suite in a temporary copy configured by the
scaffold helper; it does not modify the module. Unrecognized manifests are
preserved and require explicit adaptation.

**ES:** Raku crea la fuente y `.gitignore` si faltan, preserva archivos
propios y rechaza enlaces simbólicos en las rutas del scaffold.

**EN:** Raku creates a missing source and `.gitignore`, preserves authored
files and rejects symlinks at scaffold paths.

**ES:** Rexx preserva la fuente y rechaza rutas simbólicas; `rexx_test.sh`
ejecuta todas las suites y valida contadores, fallos y errores.

**EN:** Rexx preserves the source and rejects symbolic paths; `rexx_test.sh`
runs all suites and validates counters, failures and errors.

**ES:** Scheme crea un módulo Guile y excluye logs SRFI-64 si falta el ignore;
preserva archivos existentes y rechaza enlaces.

**EN:** Scheme creates a Guile module and excludes SRFI-64 logs when the ignore
file is missing; existing files are preserved and symlinks rejected.

**ES:** Scala crea solo si faltan fuente mínima, build sbt con ScalaTest,
versión sbt e ignore, basados en las dos referencias homologadas. Protege
rutas simbólicas; los archivos existentes y la adecuación del contrato requieren
revisión.

**EN:** Scala creates a missing minimal source, sbt build with ScalaTest, sbt
version and ignore file based on the two homologated references. Symbolic paths
are rejected; existing files and contract-specific source need review.

**ES:** `java_scaffold.sh` crea el paquete fuente, un POM Maven válido con
JUnit 5/Surefire y `.gitignore` para `target/`; solo escribe archivos ausentes
y rechaza rutas simbólicas o de tipo inesperado.

**EN:** `java_scaffold.sh` creates the source package, a valid Maven POM with
JUnit 5/Surefire, and a `target/` ignore file; it writes only missing files and
rejects symlinks or unexpected path types.

**ES:** Elm `init` crea `elm.json` y `src/`, pero no prepara el runner ni los
tests. El scaffold valida el manifiesto, asegura `src/` y `tests/`, y crea el
`.gitignore` específico solo si falta; `elm-test init` queda como paso manual
explícito porque declara/descarga el framework y crea una suite de ejemplo.

**EN:** Elm `init` creates `elm.json` and `src/`, but does not prepare the test
runner or tests. Scaffold validates the manifest, ensures `src/` and `tests/`,
and creates the language-specific `.gitignore` only when missing; `elm-test init`
remains an explicit manual step because it declares/downloads the framework and
creates a sample suite.

**ES:** Elixir conserva el layout Mix. `elixir_scaffold.sh` sustituye la
pareja de ejemplos de Mix 1.20.4 por un test sentinel fallido solo si el
helper también coincide y no hay otros archivos o enlaces en `lib/` y `test/`.
Conserva y anuncia las variantes para revisión. `mix test` puede devolver
éxito con cero casos o todos omitidos; `glot test` ejecuta la CLI de Mix una
vez con un callback ExUnit y exige al menos un caso aprobado. Informa omitidos
y excluidos, admite mezclas y rechaza resultados ausentes, múltiples
ejecuciones y salidas prematuras; conserva los formatters del proyecto.

**EN:** Elixir keeps the Mix layout. `elixir_scaffold.sh` replaces the Mix
1.20.4 sample pair with a failing sentinel test only when the helper also
matches and `lib/` and `test/` contain no other files or links. Other variants
are preserved for review. `mix test` can succeed with zero cases or all
cases skipped; `glot test` runs the Mix CLI once with an ExUnit callback and
requires at least one passing case. It reports skipped and excluded cases,
allows mixed results, rejects missing results, multiple runs and premature
exits, and preserves the project's formatters.

**ES:** Erlang crea `test/` y un sentinel EUnit solo para la fuente vacía
reconocida sin otros archivos. Gleam retira únicamente su pareja de ejemplos
reconocida y deja un sentinel Gleeunit, conservando variantes y archivos
propios. Los runners ejecutan la herramienta nativa una vez y rechazan
resúmenes ausentes, ambiguos, fallidos o sin casos aprobados; el de Gleam
acepta mezclas con omitidos. Los formatos verificados son los de rebar3
3.27.0 y Gleeunit 1.11.0, no cualquier reporter personalizado.

**EN:** Erlang creates `test/` and an EUnit sentinel only for the recognized
empty source with no other files. Gleam removes only its recognized sample
pair and leaves a Gleeunit sentinel, preserving authored variants and files.
The runners invoke the native tool once and reject missing, ambiguous, failed
or zero-pass summaries; the Gleam runner accepts mixtures with skips. The
verified formats are rebar3 3.27.0 and Gleeunit 1.11.0, not arbitrary custom
reporters.

**ES:** Crystal 1.20.2 deja un test de ejemplo que falla. `crystal_test.sh`
ejecuta `crystal spec` con un informe JUnit temporal y usa Python 3 para
validarlo; rechaza informes ausentes o inconsistentes y suites sin ejemplos
aprobados. Admite ejemplos pendientes cuando también hay aprobados.

**EN:** Crystal 1.20.2 leaves a failing example test. `crystal_test.sh` runs
`crystal spec` with a temporary JUnit report and validates it using Python 3;
missing or inconsistent reports and suites with no passing examples fail.
Pending examples are accepted when some examples pass.

**ES:** OCaml conserva el layout generado por Dune. `ocaml_scaffold.sh`
configura Alcotest y añade un sentinel fallido solo para la plantilla exacta
de Dune 3.24 sin otros archivos en `test/`; conserva variantes y archivos
propios. `ocaml_test.sh` fuerza `dune runtest`, ejecuta las acciones en serie
y exige un resumen Alcotest no vacío por acción `runtest` reconocida en la
salida corta de Dune 3.24.2. Rechaza acciones `runtest` etiquetadas que sean
silenciosas y ejecuciones sin etiquetas reconocidas. Una acción personalizada
que ejecuta varios programas, o un programa ejecutado como dependencia sin
etiqueta `runtest`, puede quedar oculto: revisar esas acciones y otras
versiones de Dune.

**EN:** OCaml keeps the Dune-generated layout. `ocaml_scaffold.sh` configures
Alcotest and adds a failing sentinel only for the exact Dune 3.24 template
without other files in `test/`; authored files and variants are preserved.
`ocaml_test.sh` forces `dune runtest`, runs actions sequentially and requires
one nonempty Alcotest summary per `runtest` action recognized in Dune 3.24.2's
short output. Labeled silent `runtest` actions and runs without recognized
labels are rejected. A custom action running multiple programs, or a program
run as a dependency without a `runtest` label, can still be hidden: review
such actions and other Dune versions.

**ES:** Vala conserva el layout Meson homologado. `vala_scaffold.sh` mueve
solo las muestras exactas de Meson 1.3.2 a `src/` y `test/`, actualiza las
rutas del manifiesto y sustituye el test por un sentinel GLib.Test fallido.
Conserva variantes y admite reruns con archivos propios ya en el layout;
rechaza conflictos entre raíz y destino, o enlaces. `vala_test.sh` compila
fuentes y suites separadas, exige TAP real y rechaza resúmenes ausentes,
omitidos y fallidos.

**EN:** Vala preserves the homologated Meson layout. `vala_scaffold.sh` moves
only exact Meson 1.3.2 samples into `src/` and `test/`, updates manifest paths
and replaces the test with a failing GLib.Test sentinel. It preserves variants
and allows reruns with authored files in the layout; root/destination conflicts
and symlinks are rejected. `vala_test.sh` compiles sources and separate
suites, requires real TAP and rejects missing, skipped or failed summaries.

**ES:** `purescript_test.sh` compila en una salida temporal nueva en cada
ejecución para no ocultar warnings por caché, sin borrar el `output/` del
proyecto. Exige casos aprobados y una única tabla Spago reconocida con cero
warnings; rechaza tablas ausentes o inconsistentes. Se verificó con Spago
1.0.4; otros formatos quedan sin verificar y se rechazan. La compilación
completa tiene un coste adicional. Al elegir `test-unit` 17.0.0, configura
`workspace.buildOpts.censorLibraryWarnings: all` para censurar warnings de
dependencias; `--strict` sigue rechazando warnings del proyecto. Una copia
aislada de la base pasó con cero warnings/errores y cinco casos.

**EN:** `purescript_test.sh` builds into a fresh temporary output on every run
so caching does not hide warnings, without deleting the project's `output/`.
it requires passing cases and one recognized Spago table with zero warnings;
missing or inconsistent tables are rejected. Verified with Spago 1.0.4;
other formats remain unverified and are rejected. Full recompilation costs
extra time. When choosing `test-unit` 17.0.0, set
`workspace.buildOpts.censorLibraryWarnings: all` to censor dependency warnings;
`--strict` still rejects project warnings. An isolated reference copy passed
with zero warnings/errors and five tests.

**ES:** Haxe instala `utest` y ejecuta `haxe_scaffold.sh`, que crea de forma
segura `build.hxml`, `RunTests.hx`, `.gitignore` y un test sentinel que falla
hasta que la suite lo sustituye. Los archivos existentes se conservan; el
runner conecta la clase de test generada y permanece al escribir la suite.

**EN:** Haxe installs `utest` and runs `haxe_scaffold.sh`, which safely creates
`build.hxml`, `RunTests.hx`, `.gitignore` and a failing sentinel test until the
suite replaces it. Existing files are preserved; the runner connects the
generated test class and remains when the suite is written.

**ES:** `javascript_scaffold.sh` completa `package.json` sin reemplazar
configuración propia: repara el script de test predeterminado, declara Jest y
ajusta el punto de entrada. Crea `jest.config.js` y `.gitignore` si faltan o
están vacíos, selecciona CommonJS/ESM según el paquete y no instala npm.

**EN:** `javascript_scaffold.sh` completes `package.json` without replacing
authored settings: it repairs npm's default test script, declares Jest and
sets the entry point. It creates missing or empty `jest.config.js` and
`.gitignore` files, selects CommonJS/ESM to match the package, and does not
install npm dependencies.

**ES:** `php_scaffold.sh` crea solo si faltan la fuente vacía, `composer.json`
con classmap y script `test`, `phpunit.xml` y `.gitignore`. No instala
dependencias; `composer install` sigue siendo explícito. PHPUnit falla si la
suite está vacía, para que el scaffold no dé un falso verde.

**EN:** `php_scaffold.sh` creates only missing files: an empty source,
`composer.json` with classmap and `test` script, `phpunit.xml`, and `.gitignore`.
It does not install dependencies; `composer install` remains explicit. PHPUnit
fails when the suite is empty, preventing a scaffold false green.

**ES:** `ruby_scaffold.sh` crea `Gemfile`, `.rspec` y `.gitignore` solo si
faltan; declara RSpec y no instala gems. Ejecutar `bundle install` antes de
las pruebas.

**EN:** `ruby_scaffold.sh` creates only missing `Gemfile`, `.rspec` and
`.gitignore` files; it declares RSpec but does not install gems. Run
`bundle install` before testing.

**ES:** `rescript_scaffold.sh` crea solo archivos ausentes para ReScript,
Jest y Babel, preserva `package.json` propio y deja la instalación de npm
explícita.

**EN:** `rescript_scaffold.sh` creates only missing ReScript, Jest and Babel
files, preserves an authored `package.json`, and leaves npm installation explicit.

**ES:** `typescript_scaffold.sh` completa scripts y dependencias TypeScript/Jest,
y genera `tsconfig.json`, `jest.config.cjs` y `.gitignore` no vacíos. Conserva
campos propios del paquete y no instala dependencias.

**EN:** `typescript_scaffold.sh` completes TypeScript/Jest scripts and
dependencies, and generates non-empty `tsconfig.json`, `jest.config.cjs` and
`.gitignore`. It preserves authored package fields and does not install dependencies.

**ES:** Julia conserva los runners propios; si falta `test/run_tests.jl` o está
vacío, `scaffold` lo convierte en un sentinel de error para evitar un falso
verde antes de conectar la suite.

**EN:** Julia preserves authored runners; if `test/run_tests.jl` is missing or
empty, `scaffold` creates a failing sentinel to prevent a false green before
the suite is wired in.

**ES:** Swift rechaza enlaces en las rutas del scaffold y sustituye solo la muestra
de SwiftPM 6.3.3 verificada en `scaffold_templates/swift.Test.swift`; preserva
otras suites y manifiestos. `swift_test.sh` rechaza cero casos, fallos y omisiones.

**EN:** Swift rejects symlinks in scaffold paths and replaces only the verified SwiftPM
6.3.3 test sample in `scaffold_templates/swift.Test.swift`; other suites and
manifests are preserved. `swift_test.sh` validates XCTest and Swift Testing,
rejecting zero cases, failures and skipped tests.

**ES:** Ballerina usa `tests/lib_test.bal` como la base homologada.
`ballerina_test.sh` aísla el informe JSON por ejecución y rechaza informes
ausentes, ambiguos, incompletos, cero casos o fallos.

**EN:** Ballerina uses `tests/lib_test.bal` as in the homologated base.
`ballerina_test.sh` isolates each run's JSON report and rejects missing,
ambiguous or incomplete reports, zero cases or failures.

**ES:** `lua_scaffold.sh` crea `src/`, `test/` y la configuración `.busted`
solo si faltan; esta dirige Busted a `test/` y conserva la configuración y el
`.gitignore` existentes. LuaRocks 3.13.0 no genera `.busted`; Busted 2.3.0
rechaza una ejecución sin archivos de prueba.

**EN:** `lua_scaffold.sh` creates `src/`, `test/` and `.busted` only when
missing. The config points Busted to `test/` and preserves existing config and
`.gitignore`. LuaRocks 3.13.0 does not generate `.busted`; Busted 2.3.0 rejects
a run with no test files.

**ES:** Groovy y Kotlin usan `gradle_scaffold.sh`: retira solo la pareja exacta
de ejemplos Gradle 9.6.1 cuando no hay otros archivos o enlaces en `lib/src`.
Rechaza rutas inseguras y conserva el resto; Gradle puede informar éxito sin
casos. Los layouts distintos requieren revisión.

**EN:** Groovy and Kotlin use `gradle_scaffold.sh`: it removes only the exact
Gradle 9.6.1 sample pair when there are no other files or links in `lib/src`.
It rejects unsafe paths and preserves other content; Gradle can still report
success without cases. Other layouts need review.

**ES:** `gradle_test.sh` exige informes XML legibles con casos aprobados,
rechaza ejecuciones `NO-SOURCE` vacías y no confunde una tarea auxiliar sin
fuentes con un test ejecutado.

**EN:** `gradle_test.sh` requires readable XML reports with passing cases,
rejects empty `NO-SOURCE` runs and does not mistake a source-free auxiliary task
for an empty test run.

**ES:** Go crea `src/` y `tests/` sin seguir rutas simbólicas y conserva su
contenido. `go test ./...` falla si no hay paquetes, pero puede devolver éxito
si existe un paquete sin tests o si todos los tests se omiten. `go_test_runner.go`
ejecuta `go test -count=1 -json ./...` una sola vez, muestra la salida y exige
al menos una prueba final aprobada. Cuenta subpruebas finales sin contar su
padre y anuncia las omitidas; una mezcla de aprobadas y omitidas se acepta.

**EN:** Go creates `src/` and `tests/` without following symlinked paths and
preserves their contents. `go test ./...` fails if there are no packages, but
can succeed when a package has no tests or all tests are skipped.
`go_test_runner.go` runs `go test -count=1 -json ./...` once, displays its
output and requires at least one passing leaf test. It counts leaf subtests
without counting their parent and reports skips; mixed passes and skips are
accepted.

**ES:** `dart_test.sh` conserva la salida de Dart y valida el resumen del
reporter `expanded`: exige al menos un caso aprobado y rechaza suites vacías
o solo omitidas; una mezcla de aprobados y omitidos se acepta.

**EN:** `dart_test.sh` preserves Dart's output and validates the `expanded`
reporter summary: it requires at least one passing case and rejects empty or
all-skipped suites; mixed passes and skips are accepted.

**ES:** `forth_test.sh` ejecuta Gforth desde `test/` y valida uno de los
formatos de resumen del framework homologado. Comprueba los contadores,
requiere al menos un caso aprobado y cero fallos; el código de salida nativo
por sí solo no detecta aserciones fallidas.

**EN:** `forth_test.sh` runs Gforth from `test/` and validates one of the
homologated framework's summary formats. It checks the counters, requires at
least one passing case and zero failures; the native exit status alone does
not detect failed assertions.

**ES:** Nim usa una retirada conservadora para sus muestras exactas y un runner
directo que rechaza suites ausentes o sin casos.

**EN:** Nim uses conservative removal for exact samples and a direct runner
that rejects missing suites or runs with no executed cases.

**ES:** `purescript_test.sh` rechaza runners sin `All N tests passed!`,
incluidos los runners vacíos que antes daban falso verde. Spago `--strict`
trata los warnings del proyecto como errores, pero no los de dependencias:
`test-unit` 17.0.0 produjo 15 en una compilación limpia. Al elegirlo, configura
`workspace.buildOpts.censorLibraryWarnings: all`; los warnings del proyecto
siguen fallando con `--strict`. Verificado en una copia aislada con cero
warnings/errores y cinco casos aprobados.

**EN:** `purescript_test.sh` rejects runners without `All N tests passed!`,
including empty runners that previously produced a false green. Spago `--strict`
promotes project warnings to errors, but not dependency warnings: `test-unit`
17.0.0 produced 15 in a clean build. When choosing it, set
`workspace.buildOpts.censorLibraryWarnings: all`; project warnings still fail
with `--strict`. Verified in an isolated copy with zero warnings/errors and
five passing cases.

**ES:** TypeScript elimina `--passWithNoTests`; `typescript_test.sh` exige el
informe JSON de Jest y rechaza cero casos, omitidos y fallos.

**EN:** TypeScript removes `--passWithNoTests`; `typescript_test.sh` requires the
Jest JSON report and rejects zero cases, skipped tests and failures.

**ES:** JavaScript reutiliza el runner Jest de TypeScript, con el mismo rechazo
de cero casos, omitidos y fallos.

**EN:** JavaScript reuses the TypeScript Jest runner, with the same rejection
of zero cases, skipped tests and failures.

**ES:** V puede devolver éxito con cero casos; `v_test.sh` exige un resumen con
al menos un caso aprobado.

**EN:** V can succeed with zero cases; `v_test.sh` requires a summary containing
at least one passing case.

**ES:** `tcl_scaffold.sh` crea una fuente de paquete, su índice y el ignore
si faltan, preserva archivos previos y rechaza enlaces. Deriva el nombre del
paquete de la carpeta efectiva, no del id canónico: por ejemplo,
`unit_test/calculator` produce `calculator.tcl` y `package provide calculator`.
Los archivos previos vacíos o incompatibles requieren revisión.

**EN:** `tcl_scaffold.sh` creates a missing package source, index and ignore
file, preserves existing files and rejects symlinks. It derives the package
name from the effective directory rather than the canonical id; for example,
`unit_test/calculator` produces `calculator.tcl` and
`package provide calculator`. Pre-existing empty or incompatible files require
review.

**ES:** Forth crea una fuente vacía, un framework y un runner que anuncia que
no hay tests; conserva archivos existentes. La suite conecta los grupos y el
framework devuelve código no cero ante aserciones fallidas.

**EN:** Forth creates an empty source, a framework and a runner announcing
that there are no tests, preserving existing files. The suite connects its
groups, and the framework returns a nonzero code for failed assertions.

**ES:** COBOL crea fuente, runner, Makefile y `.gitignore` cuando faltan. El
Makefile enlaza el runner antes de los helpers y comprueba su presencia incluso
si ya existe el ejecutable. La suite conecta los grupos y propaga fallos.

**EN:** COBOL creates a missing source, runner, Makefile and `.gitignore`.
The Makefile links the runner before helpers and checks that it exists even
when the executable is already present. The suite connects groups and
propagates failures.

**ES:** Grain crea fuente, runner y `test_status.gr`, Makefile y `.gitignore`
si faltan. La suite conecta los grupos y pasa el resultado del framework a
`TestStatus.finish`; el framework se adapta al dominio. Se preserva el
contenido propio y solo se actualiza el runner vacío anterior reconocido.

**EN:** Grain creates a missing source, runner, `test_status.gr`, Makefile and
`.gitignore`. The suite connects groups and passes the framework result to
`TestStatus.finish`; the framework is adapted to the domain. Authored content
is preserved and only the recognized previous empty runner is upgraded.

**ES:** R crea, si faltan, los metadatos iniciales, fuente, NAMESPACE,
runner, test vacío, Makefile y `.gitignore`. Conserva contenido propio;
el `make test` generado falla si no se ejecutó ningún caso aprobado. El
completado revisa metadatos y exports antes de la suite.

**EN:** R creates missing initial metadata, source, NAMESPACE, runner, empty
test file, Makefile and `.gitignore`. The generated `make test` fails if no
test case passes. Authored contents are preserved; completion reviews metadata
and exports before the suite.

**ES:** Prolog crea una fuente vacía compatible con `consult/1` y un
`.gitignore` si faltan, preservando el contenido existente. El comando PlUnit
ejecuta todas las suites reconocidas, distingue el scaffold vacío y falla si
hay suites pero no se ejecuta ningún caso.

**EN:** Prolog creates an empty source compatible with `consult/1` and a
missing `.gitignore`, preserving existing content. The PlUnit command runs
all recognized suites, distinguishes an empty scaffold and fails if suites
exist but no cases are executed.

**ES:** `cpp_scaffold.sh` crea la configuración Bazel con los targets de
biblioteca y Google Test, fija la versión y conserva archivos existentes.
La revisión v2.1.0 preserva los layouts comprobados de C++ (`src/include/tests`),
Crystal (`src/spec`), F# (proyectos anidados con
referencia declarada por dotnet), Go (`src/tests`), Haskell (`lib/test` y
paquete Cabal con guiones) y V (`tests/`, sin mover fuentes ajenas a sus
imports). Estas filas se prueban también con rerun, gitfile y contenido
previo. Los renombrados de fuentes F#/V requieren actualizar referencias y
permanecen como revisión explícita, no como borrado o aplanado automático.

**EN:** `cpp_scaffold.sh` creates Bazel configuration with library and Google
Test targets, pins the version, and preserves existing files. Reviewed layouts
preserve native directories and references.
Regression fixtures cover reruns, gitfiles and authored contents.
Coupled F#/V source/import changes remain explicit review tasks rather than
automatic deletion or flattening.

**ES:** **Hallazgo resuelto en 2.1.0-dev (2026-11-22):** el 2026-10-11 se midió
que `guile --no-auto-compile -s {suite}_guile.scm` podía imprimir fallos SRFI-64
y devolver `0` (10 aserciones fallidas en `data_structures_basics`). El comando
actual usa `test-runner-simple`, valida contadores, grupos y salida anticipada,
y propaga fallos o suites vacías. Se comprobó `glot test` en copias aisladas de
`naive_sort` (24 casos) y `data_structures_basics` (85 casos); no se modificaron
los submódulos.

**EN:** **Finding resolved in 2.1.0-dev (2026-11-22):** on 2026-10-11,
`guile --no-auto-compile -s {suite}_guile.scm` was measured printing SRFI-64
failures while returning `0` (10 failing assertions in `data_structures_basics`).
The current command uses `test-runner-simple`, validates counters, groups and
early exits, and propagates failures or empty suites. `glot test` passed in
isolated copies of `naive_sort` (24 cases) and `data_structures_basics`
(85 cases); submodules were not modified.

### Columnas 6 a 8: la inicialización / Columns 6 to 8: initialisation

**ES:** La columna del tipo es la **leyenda de la guía convertida en dato**
(✅ verificado en este repo · 🔧 estándar del ecosistema · ✍️ estructura manual) y se
mantienen **a mano**, con una regla dura: **solo se añade lo que se pudo verificar
ejecutando el inicializador** en un directorio temporal, con la entrada cerrada (o
conducida con `expect`, R1) y con un tiempo máximo, comprobando qué deja en el
disco. El **esqueleto** no se declara aquí: un lenguaje con varios pasos, con otro directorio de
trabajo o con un completado aparece en [`init_sequences.tsv`](init_sequences.tsv), y este
catálogo solo guarda el tipo, el comando de pruebas y el verificador, sin dos fuentes. La
cobertura se informa en `doctor` como `new_commands`.

**EN:** The type column is the **guide's legend turned into data** (✅ verified
in this repo · 🔧 ecosystem standard · ✍️ manual structure) and they are maintained
**by hand**, with one hard rule: **only what could be verified by running the
initializer** in a temporary directory, with stdin closed (or driven by `expect`,
R1) and a timeout, and by checking what it leaves on disk gets added. the **skeleton** is not declared here: a language with several steps, another working directory
or a completion appears in [`init_sequences.tsv`](init_sequences.tsv), and this catalogue only
keeps the type, the test command and the verifier, with no second source. Coverage is reported
by `doctor` as `new_commands`.

**ES:** Reparto de los 50 lenguajes tras la política R1–R6 (cerrada el 2026-09-26 y ya aplicada al dato): **32 `tool`** y **18 `manual`**. Pasan a `tool` doce lenguajes —`ada`, `groovy`, `kotlin`, `clojure`, `nim` y `python` (eran `deferred`, vocabulario retirado en la 2.0.0) más `julia`, `vala`, `perl`, `common-lisp`, `racket` y `v` (eran `manual`)—, `cpp` queda `manual` (C++ mantiene Bazel, decidido el 2026-09-26) y `java` baja a `manual` por R2 (el arquetipo `quickstart` trae `main`). `doctor` lo informa como `new_commands: 50 de / of 50`.

**EN:** Split of the 50 languages after policy R1–R6 (closed on 2026-09-26 and already applied to the data): **32 `tool`** and **18 `manual`**. Twelve languages move to `tool` —`ada`, `groovy`, `kotlin`, `clojure`, `nim` and `python` (they were `deferred`, a vocabulary retired in 2.0.0) plus `julia`, `vala`, `perl`, `common-lisp`, `racket` and `v` (they were `manual`)—, `cpp` stays `manual` (C++ keeps Bazel, decided on 2026-09-26) and `java` moves down to `manual` under R2 (the `quickstart` archetype ships `main`). `doctor` reports it as `new_commands: 50 de / of 50`.

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
| 2 | Fase: `new` o `scaffold` | `scaffold` |
| 3 | Orden del paso dentro de la fase, desde `1` | `1` |
| 4 | Directorio de trabajo: `module` o `phase` | `module` |
| 5 | Modo: `run`, `expect` o `manual` (aviso, no ejecución) | `run` |
| 6 | Comando con marcadores (`{module}`, `{Module}`, `{root}`) | `mkdir -p lib test` |
| 7 | Requisito declarado del paso | `-` |
| 8 | Respuestas de `expect`, separadas por `\|`; `-` en los otros modos | `library\|<defecto>` |
| 9 | Análisis/completado residual; `-` si no falta nada | `revisar el runner mínimo` |

**ES:** Esquema v2: cabecera y nueve columnas, con ambos pasos de los
**50 lenguajes**. `languages.tsv` tiene cuatro columnas y no duplica el
esqueleto. `new` ejecuta su fase; `scaffold` ejecuta la suya, garantiza
`.gitignore` y anuncia el análisis residual. `-n` imprime comandos sin mutar;
`GLOT_DATA_DIR` permite catálogos aislados para pruebas.

**EN:** The v2 schema has a header and nine columns, covering both phases for all
50 languages. The four-column language catalogue does not duplicate scaffolding.
Each verb executes its phase; scaffold ensures ignore files and reports residual
analysis. Dry runs do not mutate; tests can inject a data directory.

**ES:** Todo cambio conocido y repetible va en **comando**, no queda oculto
como nota del agente. Las notas son para criterio/contenido no determinado por
el catálogo. El harness comprueba nueve columnas, fases/modos válidos y órdenes
contiguos. Un paso fallido detiene la secuencia; los renombrados deben preservar
destinos existentes. La guía humana conserva las mismas adecuaciones.

**EN:** Known repeatable changes belong in commands, not hidden agent notes.
Notes describe judgment/content not determined by the catalogue. The harness
checks the nine-column schema and per-phase order; failed steps stop execution.
Renames preserve existing destinations and manual recipes mirror adaptations.

**ES:** `new` retira solo el `.git/` vacío generado por un inicializador y
preserva o bloquea Git preexistente, incluidos directorios, gitfiles y enlaces.

**EN:** `new` removes only an initializer-generated empty `.git/` and preserves
or blocks pre-existing Git, including directories, gitfiles and symlinks.

**ES:** Primer bloque v2.1.0-dev: Ballerina crea pruebas vacías, renombra con
guardas y elimina solo el ejemplo idéntico a
[`ballerina.main.bal`](scaffold_templates/ballerina.main.bal). Perl escribe
fuentes bajo `lib/` únicamente si faltan; Rust preserva `src/lib.rs`.
Los tres se comprobaron en laboratorio offline el 2026-11-02. La revisión de los
otros lenguajes sigue abierta en [`ROADMAP.md`](../docs/ROADMAP.md); las mediciones
históricas no certifican automáticamente las nuevas filas.

**EN:** The first v2.1.0-dev block adds safe Ballerina adaptations, missing-only
Perl sources under lib and preserved Rust entry points. These three were checked
offline on 2026-11-02; remaining languages still require review and historical
measurements do not certify changed rows.

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

**ES:** Este esquema es el de v2.0.3. La separación de rutas, la asignación de
Sonnet a `suite` y la migración a perfiles independientes del id de modelo se
preparan en [`ROADMAP.md`](../docs/ROADMAP.md); los TSV no cambian durante esta
preparación documental.

**EN:** This is the v2.0.3 schema. Separate routes, Sonnet for `suite` and
model-independent profiles are planned in [`ROADMAP.md`](../docs/ROADMAP.md);
TSV files remain unchanged during documentation preparation.

**ES:** Una fila por **perfil**, con el **modelo como clave**: la plantilla declara su
modelo en el frontmatter (`model:`) y esta tabla dice qué esfuerzo y qué tope de créditos
le tocan, más para qué encargos está pensado el perfil. El nombre del perfil (`economy`)
es la etiqueta legible de la fila; **no hay una clave `profile:` en la plantilla**, para
que el modelo y su presupuesto no puedan derivar el uno del otro.

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Perfil, nombre de política | `economy` |
| 2 | Modelo de Copilot: un **id real** de la lista del CLI, o uno de **OpenRouter** (`vendedor/modelo`, que se sirve por el proveedor propio) | `gpt-6.1-sol` |
| 3 | Esfuerzo de razonamiento, que `glot` pasa como `--reasoning-effort` | `low` |
| 4 | Tope de créditos, que `glot` pasa como `--max-ai-credits`; **30 es el mínimo que acepta el CLI** | `30` |
| 5 | Tier de auto (`--auto-tier`), o `-` cuando el modelo es fijo | `-` |
| 6 | Encargos que usan el perfil, separados por coma | `validate, docs-module, docs-language` |
| 7 | Modelo del delegado de **AGY**, **id real** de `agy models` | `gemini-3.8-flash-low` |

**EN:** One row per **profile**, with the **model as the key**: the template declares its
model in the frontmatter (`model:`) and this table states the effort and the credit cap it
gets, plus which requests the profile is meant for. The profile name (`economy`) is the
readable label of the row; there is **no `profile:` key in the template**, so the model and
its budget cannot drift apart.

**ES:** La lista de modelos la manda el **CLI instalado** (`copilot help config`), no este
documento: `doctor` informa de la cobertura (`model_profiles`) y de cuántos modelos del
catálogo siguen apareciendo en el CLI (`model_available`), y el harness comprueba la deriva
en los dos sentidos entre la columna 6 y las plantillas que declaran cada modelo. Un
`model:` que no esté aquí es un **dato que falta** (`1`), nunca un perfil inventado. Desde
la **v1.7.3** el perfil `economy` declara un modelo de **OpenRouter** (lleva `/`): esos no se
buscan en la lista del CLI, porque los sirve el proveedor propio, y por eso `model_available`
cuenta solo los de Copilot.

**EN:** The model list is owned by the **installed CLI** (`copilot help config`), not by
this document: `doctor` reports coverage (`model_profiles`) and how many catalogue models
are still listed by the CLI (`model_available`), and the harness checks drift in both
directions between column 6 and the templates that declare each model. A `model:` missing
here is a **missing datum** (`1`), never an invented profile. Since **v1.7.3** the `economy`
profile declares an **OpenRouter** model (it carries a `/`): those are not looked up in the
CLI list, because the custom provider serves them, and that is why `model_available` counts
only Copilot's.

| Perfil / Profile | Modelo / Model | Esfuerzo / Effort | Créditos / Credits | Encargos / Requests | Modelo AGY / AGY model |
|---|---|---|:--:|---|---|
| `economy` | `qwen/qwen3.7-plus` (OpenRouter) | `low` | 30 | `scaffold`, `correct`, `validate`, `docs-module`, `docs-language` | `gemini-3.8-flash-low` |
| `balanced` | `gpt-6.1-sol` | `low` | 60 | `contract_stub`, `suite`, `build` | `gemini-3.8-flash-low` |
| `deep` | `claude-sonnet-5.5` | `medium` | 90 | `implement`, `fix`, `refactor` | `claude-sonnet-5-5-low` |

**ES:** Los tres perfiles siguen el reparto del sprint: `balanced` escribe el **contrato**, la
**suite** y la **construcción** (estructuras ya homologadas), `deep` hace la **implementación** y
`economy` cubre el **andamiaje**, la **corrección** y la **documentación**, que va por
**OpenRouter** con esfuerzo `low`. El nombre del perfil es una política de coste: el dato del
modelo vive en la plantilla y aquí solo está su presupuesto.

**EN:** The three profiles follow the sprint split: `balanced` writes the **contract**, the
**suite** and the **build** (already homologated structures), `deep` does the **implementation**
and `economy` covers the **scaffolding**, the **correction** and the **documentation**, which
goes over **OpenRouter** at effort `low`. The profile name is a cost policy: the model datum
lives in the template and only its budget is here.

## 🔤 `delegates.tsv` — alias de modelo por delegado / per-delegate model aliases

**ES:** Una fila por **alias**, con el delegado como primera columna. Es el mapa que traduce
lo que el autor escribe en `glot set antigravity-model` (`gemini`, `sonnet`) y en
`glot set copilot-model` (`default`, `gemini`, `qwen`, `kimi`) al **id real** que espera el CLI.
Las filas de `copilot` (v1.7.3) son ids de **OpenRouter** —siempre `vendedor/modelo`—, que es la
vía de los modelos de documentación: la barra es lo que distingue ese id del que ofrece Copilot.
**No lleva nada sensible**: las credenciales de un CLI viven en su config bajo `$HOME`, fuera del
repositorio, y la orden del delegado vive en el entorno del autor.

| Columna / Column | Contenido / Content | Ejemplo / Example |
|:---:|---|---|
| 1 | Delegado, el de `--delegate` | `agy` · `copilot` |
| 2 | Alias, lo que acepta la clave de estado | `gemini` |
| 3 | Modelo, **id real** | `gemini-3.8-flash-low` |

**ES:** El **orden de las filas de cada delegado es de más barato a más caro**: es el orden
del autocompletado. `doctor` informa de la cobertura (`delegate_aliases`) y, si
`agy` está instalado, de cuántos de sus ids siguen en `agy models`
(`delegate_model_available_agy`); los ids de OpenRouter **no** se comprueban contra ningún
catálogo local, porque no lo hay.

**EN:** One row per **alias**, with the delegate as the first column. It is the map that turns
what the author writes in `glot set antigravity-model` (`gemini`, `sonnet`) and in
`glot set copilot-model` (`default`, `gemini`, `qwen`, `kimi`) into the **real id** the CLI
expects. The `copilot` rows (v1.7.3) are **OpenRouter** ids —always `vendor/model`—, the way of
the documentation models: the slash is what tells that id apart from the one Copilot offers.
It carries **nothing sensitive**: a CLI's credentials live in its config under `$HOME`, outside
the repository, and the delegate command lives in the author's environment. Each delegate's rows
are ordered **cheapest to most expensive**: that is the order of the completion.

**ES:** Cada delegado es un agente cuyo CLI se invoca desde la línea del entorno del autor; el
catálogo solo guarda los **nombres** de modelo que esa línea usa, y las credenciales de cada
CLI viven en su config bajo `$HOME`, nunca en el repositorio. En Copilot, un id con `/` hace que
`ask` y `validate` apunten el **proveedor propio** del CLI (`COPILOT_PROVIDER_BASE_URL`), que es
lo que hace usable el alias; la clave la pone el autor.

**EN:** Each delegate is an agent whose CLI is invoked from the author's environment line; the
catalogue only stores the model **names** that line uses, and each CLI's credentials live in
its config under `$HOME`, never in the repository. On Copilot, an id with a `/` makes `ask` and
`validate` point the CLI **custom provider** (`COPILOT_PROVIDER_BASE_URL`), which is what makes
the alias usable; the key belongs to the author.

| Delegado / Delegate | Alias | Modelo / Model |
|---|---|---|
| `agy` | `gemini` | `gemini-3.8-flash-low` |
| `agy` | `sonnet` | `claude-sonnet-5-5-low` |
| `copilot` | `default` | `qwen/qwen3.7-plus` (OpenRouter) |
| `copilot` | `gemini` | `google/gemini-3.8-flash` (OpenRouter) |
| `copilot` | `qwen` | `qwen/qwen3.8-max-0902` (OpenRouter) |
| `copilot` | `kimi` | `moonshotai/kimi-k3` (OpenRouter) |

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
