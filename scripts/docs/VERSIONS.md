# 🧾 Log de versiones / Version log

**ES:** Historial de versiones cerradas y de la versión viva. Las versiones **futuras** y la capa que cubre cada una están en [`ROADMAP.md`](ROADMAP.md).

**EN:** History of closed versions and of the live version. **Future** versions and the layer each one covers are in [`ROADMAP.md`](ROADMAP.md).

**ES:** El cierre de v2.1.0 sigue en curso. No se marcará como cerrada hasta
resolver los seguimientos de scaffold y runner de su alcance; 50 filas de
catálogo no equivalen a 50 comprobaciones nativas. La sincronización general
de helpers de build figura como criterio de la siguiente versión.

**EN:** v2.1.0 closure is still in progress. It will not be marked closed until
the in-scope scaffold and runner follow-ups are resolved; 50 catalog rows do
not imply 50 native checks. General build-helper synchronization is listed as
a next-version criterion.

| Versión | Fecha | Archivo | Añade | Estado |
|---------|-------|---------|-------|:------:|
| 0.1.0 | 2026-09-20 | [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh) | Hello World en Bash (`echo "Hello World! from Bash!"`) | ✅ cerrada |
| 0.2.0 | 2026-09-20 | [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh) | Nombre por argumento o por entrada estándar y saludo `Hello, <nombre>!` (equivalente a `hellouser`) | ✅ cerrada |
| 0.3.0 | 2026-09-20 | [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh) | **Contrato y dispatcher** (L0): `version`, `help`, `doctor`, `greet`, `hello`, sin rutas del usuario, más harness de pruebas propio | ✅ cerrada |
| 0.4.0 | 2026-09-21 | [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh) | **Almacén clave/valor** (L1): `set`, `get`, `unset`, `list`, `path`, en XDG, atómico bajo `flock` y con `-n/--dry-run` | ✅ cerrada |
| 0.5.0 | 2026-09-22 | [`versions/glot_0.5.0.sh`](../versions/glot_0.5.0.sh) | **Asignación** (L2): `use <lenguaje> <fase>/<módulo> [tipo]`, que sitúa el trabajo según los cuatro estados del sprint (nuevo, en curso, reanudar y cerrado) | ✅ cerrada |
| 0.6.0 | 2026-09-22 | [`versions/glot_0.6.0.sh`](../versions/glot_0.6.0.sh) | **Catálogo** (L2.5): `langs`, `modules`, `progress` y `completion`, con el conversor de nombres y los comandos nativos por lenguaje | ✅ cerrada |
| 0.7.0 | 2026-09-22 | [`versions/glot_0.7.0.sh`](../versions/glot_0.7.0.sh) | **Ejecución** (L3): `test` y `verify`, con el código `4` de verificación fallida, los marcadores de la tabla de comandos y la cobertura de verificadores | ✅ cerrada |
| 0.8.0 | 2026-09-22 | [`versions/glot_0.8.0.sh`](../versions/glot_0.8.0.sh) | **Delegación** (L4): `prompt` y `ask`, con las cuatro plantillas versionadas de `scripts/prompts/` y un solo vocabulario de marcadores | ✅ cerrada |
| 0.9.0 | 2026-09-22 | [`versions/glot_0.9.0.sh`](../versions/glot_0.9.0.sh) | **Creación y registro** (L5): `new` (inicializador del lenguaje, esqueleto y normalización) y `save` (commit guiado desde el catálogo `data/commits.tsv`), con la tabla de inicialización ampliada | ✅ cerrada |
| 0.10.0 | 2026-09-22 | [`versions/glot_0.10.0.sh`](../versions/glot_0.10.0.sh) | **Evidencia y cierre** (L6): `evidence`, `close` y `validate` con validador enchufable, más la retirada de `hello` y el objetivo resuelto por directorio | ✅ cerrada |
| 0.11.0 | 2026-09-22 | [`versions/glot_0.11.0.sh`](../versions/glot_0.11.0.sh) | **Perfiles de modelo por encargo** (L6.5): `model:` en el frontmatter de las seis plantillas y `data/models.tsv` fijando esfuerzo y tope de créditos por encargo, con los modelos que ofrece Copilot | ✅ cerrada |
| 0.12.0 | 2026-09-23 | [`versions/glot_0.12.0.sh`](../versions/glot_0.12.0.sh) | **Higiene y punteros** (L7): `status` (submódulos, ramas y punteros), `pointer` (deja el puntero del submódulo listo y publicado en el monorepo) y `clean` (artefactos del módulo y `submodule sync`), con el commit del monorepo en manos de `save` | ✅ cerrada |
| 1.0.0 | 2026-09-23 | [`versions/glot_1.0.0.sh`](../versions/glot_1.0.0.sh) | **Instalación y capa cargable** (L8): `install`/`uninstall` con copia estable, bloque del rc y completado; `glot` como función de bash que hace el `cd` real de `use`; estado **por raíz** de monorepo, `doctor` completo (instalación, shells, estado y toolchains) y encargos con sus fuentes declaradas | ✅ cerrada |
| 1.1.0 | 2026-09-26 | [`versions/glot_1.1.0.sh`](../versions/glot_1.1.0.sh) | **Secuencia de inicialización, contrato propio y deriva de datos**: `new` ejecuta los pasos de cada lenguaje (18 lenguajes y 28 pasos, con `expect` y completado posterior) y el catálogo declara un único comando por lenguaje; el **contrato** es el paso `4b` con encargo versionado y la suite se desplaza a `4c`; `install.meta` guarda la huella de `data/`, `prompts/` y `completions/` y `doctor` informa `install_data`; el verbo desconocido sugiere `glot prompt <encargo>` | ✅ cerrada |
| 1.2.0 | 2026-09-27 | [`versions/glot_1.2.0.sh`](../versions/glot_1.2.0.sh) | **Los dos delegados de `ask`** (`GLOT_DELEGATE_COP` y `GLOT_DELEGATE_AGY`, elegibles con `--delegate`), los marcadores `{root}`/`{module_dir}` dentro de la orden y `GLOT_ROOT`/`GLOT_MODULE_DIR` exportados al delegado; `install` imprime las líneas que el autor pega en su rc, con los marcadores sin resolver | ✅ cerrada |
| 1.3.0 | 2026-09-27 | [`versions/glot_1.3.0.sh`](../versions/glot_1.3.0.sh) | **Las correcciones del paso 4 y el resto del bloque B**: el **runner** es del `4a` y la suite no lo crea, el **completado** se imprime en un bloque final y el dato se valida, los **flags globales** valen en cualquier posición, el **paso de corrección** `4d` exige la causa en el commit, `pointer` prepara el gitlink **en la rama activa** y `close` deja de pegar la marca al id | ✅ cerrada |
| 1.4.0 | 2026-09-27 | [`versions/glot_1.4.0.sh`](../versions/glot_1.4.0.sh) | **El cierre del bloque B**: el alcance real de `verify` (*lint* idiomático, con el SAST fuera), las **dos orillas** de la deriva de la copia en `doctor`, la nota del `cd` en tubería, la **política de CI** por submódulo, las filas **medibles** de `toolchains.tsv` (`ada`, `common-lisp`, `rexx`, `scala`), la tabla de módulos como **vista manual sin contador** y la **`suite` sin falso positivo** cuando el lenguaje necesita el cuerpo para enlazar | ✅ cerrada |
| 1.4.1 | 2026-09-27 | [`versions/glot_1.4.1.sh`](../versions/glot_1.4.1.sh) | **El remedio del delegado en `ask`**: sin delegado imprime las **dos líneas de invocación verificada** (y con `--delegate`, solo la que falta), en vez de dejar al autor con el nombre de la variable; `help ask` las trae. Fix sobre la v1.4.0, rama `fix/repo/glot-v1.4.0` | ✅ cerrada |
| 1.4.2 | 2026-09-27 | [`versions/glot_1.4.2.sh`](../versions/glot_1.4.2.sh) | **El delegado en el autocompletado**: `glot ask <TAB>` ofrece `--delegate` además de los encargos, tras la opción ofrece `copilot` y `antigravity` (y con `--delegate=` el valor pegado), y el posicional sigue completándose aunque la opción vaya delante. Fix sobre la v1.4.1, rama `fix/repo/glot-v1.4.1` | ✅ cerrada |
| 1.5.0 | 2026-09-28 | [`versions/glot_1.5.0.sh`](../versions/glot_1.5.0.sh) | **El contrato pasa a `contract_stub`** —el paso `4b` entrega el contrato **y los esqueletos** de todas sus operaciones, para que la suite compile y enlace aunque el cuerpo sea del paso 5—, el **paso de corrección** se alinea con el resto del CLI (`--cause`, con `--causa` como alias) y **el ciclo dice lo que le toca al autor**: el bloque de integración del submódulo al confirmar el paso 7 u 8, `pointer` que frena si la rama del sprint tiene commits que el `main` del submódulo no tiene y `close` que exige el gitlink al commit integrado | ✅ cerrada |
| 1.6.0 | 2026-09-30 | [`versions/glot_1.6.0.sh`](../versions/glot_1.6.0.sh) | **El retrabajo se reparte por momento** (`4d correct`, `5b fix` y `5c refactor`, los tres con la causa obligatoria en el commit), **el modelo se elige por rol** y viaja también al delegado de AGY (séptima columna de `data/models.tsv`), el cierre tiene su verbo (`finish`) y las **plantillas solo mandan versionadas** | ✅ cerrada |
| 1.6.1 | 2026-09-30 | [`versions/glot_1.6.1.sh`](../versions/glot_1.6.1.sh) | **La línea del delegado de AGY usa `--model`** —el binario no define `-m`— y lleva el marcador `{model}`, la **secuencia de `common-lisp` pasa a `cl-project`** con su homologación declarada y la **regla de rama/versión** queda escrita: la rama `fix/…-vX.Y.Z` ya lleva el número de la entrega que cierra | ✅ cerrada |
| 1.6.2 | 2026-09-30 | [`versions/glot_1.6.2.sh`](../versions/glot_1.6.2.sh) | **El ciclo te lleva donde toca** —`use` a la carpeta de la fase, `new` a la del módulo y `save 7`/`8` a la raíz del lenguaje— con el listado de `save` ofreciendo los **once** pasos, **`glot finish` limpia el estado del sprint** al terminar (salvo `model`), el **modelo de AGY se fija por sprint** con `glot set model <id>` y el **autocompletado y la ayuda cubren las nueve claves** reservadas; `install` avisa en vez de copiarse sobre sí mismo | ✅ cerrada |
| 1.7.0 | 2026-10-04 | [`versions/glot_1.7.0.sh`](../versions/glot_1.7.0.sh) | **Un tercer delegado y el modelo por alias**: `shellgpt` (ShellGPT, con la clave de OpenRouter en el entorno del autor y nunca en el repositorio) entra en `ask` con `GLOT_DELEGATE_SGPT`; el modelo de **AGY** y de **shellgpt** se fija por sprint con un **alias** de `data/delegates.tsv` (`glot set antigravity-model\|shell-gpt-model`), que publica el verbo nuevo **`glot delegates`** y completa el autocompletado, incluido **`glot finish`**; los ids de AGY se actualizan y `finish` conserva las **dos** claves de modelo. **Recoge el trabajo de la 1.6.3/1.6.4** que estaba en `main` sin cerrar | ✅ cerrada |
| 1.7.1 | 2026-10-04 | [`versions/glot_1.7.1.sh`](../versions/glot_1.7.1.sh) | **Se retira `shellgpt` y entra `aider`**: ShellGPT no es un agente y no puede escribir artefactos, así que el tercer delegado pasa a **Aider** (agéntico y compatible con OpenRouter), con `GLOT_DELEGATE_AIDER`, la clave `aider-model` y el marcador nuevo **`{spec}`** (que la línea publicada usa para dar a Aider las fuentes por `--read`) | ✅ cerrada |
| 1.7.2 | 2026-10-05 | [`versions/glot_1.7.2.sh`](../versions/glot_1.7.2.sh) | **Se retira `aider`**: escribe artefactos pero **no ejecuta** comandos de shell, así que no cierra los pasos con puerta; quedan `GLOT_DELEGATE_COP` y `GLOT_DELEGATE_AGY`, desaparecen `GLOT_DELEGATE_AIDER`, la clave `aider-model` y el modelo `-` (alias `default`), y el marcador `{spec}` (v1.7.1) se conserva para cualquier delegado | ✅ cerrada |
| 1.7.3 | 2026-10-05 | [`versions/glot_1.7.3.sh`](../versions/glot_1.7.3.sh) | **El reparto por encargo y Copilot con OpenRouter**: `gpt-5.6-terra` para el contrato y la suite, `claude-sonnet-5` para la implementación y el perfil de **OpenRouter** (`qwen/qwen3.7-plus`, esfuerzo `low`) para el andamiaje, la corrección y la documentación; la clave `copilot-model` cambia de modelo **solo** dentro de OpenRouter (nunca toca `terra` ni `sonnet`) y el esfuerzo del perfil **viaja en la orden** (`--reasoning-effort {effort}`) | ✅ cerrada |
| 1.7.4 | 2026-10-07 | [`versions/glot_1.7.4.sh`](../versions/glot_1.7.4.sh) | **El generador de OCaml se ejecuta desde la fase**: `dune init proj` **crea** la carpeta del proyecto, así que la fila de `data/init_sequences.tsv` pasa de `module` a `phase` y deja de anidar `{module}/{module}/`; la guía de inicialización nombra los **cinco** generadores que crean la carpeta, la columna de artefactos del catálogo pasa a `lib/dune` y el arnés fija ese conjunto. Cierra el módulo `algorithms/data_structures_basics` de OCaml con el layout generado (`lib/`, `bin/`, `test/`, `.opam`) y homologa calculator, numbers y naive_sort a él | ✅ cerrada |
| 1.7.5 | 2026-10-07 | [`versions/glot_1.7.5.sh`](../versions/glot_1.7.5.sh) | **El verificador de Perl apunta al layout real**: la fila del catálogo compilaba `src/{module}.pl`, ruta que desapareció al homologar los cuatro módulos de Perl a `lib/` + `test/`, así que el acta de `evidence` salía en rojo (`Can't open perl script`) con la suite en verde; ahora compila todos los fuentes bajo `lib/` —`.pl` y `.pm`, con `-Ilib`— y la guía de inicialización queda al día | ✅ cerrada |
| 1.7.6 | 2026-10-07 | [`versions/glot_1.7.6.sh`](../versions/glot_1.7.6.sh) | **El andamiaje de Perl pasa a `manual`**: `module-starter` generaba `Makefile.PL`, `lib/{module}.pm` y `t/`, que no es el layout homologado, así que la fila del catálogo queda con `mkdir -p lib test`, el paso único sale de `init_sequences.tsv` y la guía lo lee de la tabla maestra; cierra la corrección de Perl que abrió la v1.7.5 | ✅ cerrada |
| 1.7.7 | 2026-10-07 | [`versions/glot_1.7.7.sh`](../versions/glot_1.7.7.sh) | **El layout de R es el de un paquete**: la fila del catálogo apuntaba a `src/` y a `Rscript test/run_tests.R`, rutas que desaparecieron al homologar los cuatro módulos de R a `DESCRIPTION` + `NAMESPACE` + `R/` + `tests/testthat/`, así que el andamiaje pasa a `mkdir -p R tests/testthat`, el runner a `make test` (`testthat::test_local()`, que carga el paquete sin instalarlo) y el verificador a los fuentes de `R/`; la guía de inicialización lo documenta | ✅ cerrada |
| 1.7.8 | 2026-10-08 | [`versions/glot_1.7.8.sh`](../versions/glot_1.7.8.sh) | **El estándar de Racket es `raco new library {module}`** —el layout lib/test/doc de la comunidad— con las tres adecuaciones que su plantilla no resuelve aquí: render portátil (`mv` + `sed -i` de GNU, porque su `render-template.sh` es interactivo y de BSD y dejaba los marcadores `<project>`/`<username>` en los cuatro `info.rkt`), borrado de `.github/`, `pull_request_template.md`, `render-template.sh` y `profile/`, y suites que requieren la librería **por ruta relativa** para correr sin enlazar paquetes. El runner pasa a **`raco test -x .`**: `racket test/run_tests.rkt` no existía en los dos módulos de un solo archivo y, en los tres que sí lo tienen, **salía con código 0 aunque un test fallara** (falso verde en `test`/`evidence`), mientras `raco test` sale con 1, cuenta los casos y no contamina la salida | ✅ cerrada |
| 2.0.0 | 2026-10-12 | [`versions/glot_2.0.0.sh`](../versions/glot_2.0.0.sh) | **El esqueleto se parte en dos pasos y dos commits** (paso `4`, la carpeta del módulo, y paso `4a`, la estructura idiomática) y entra el **paso `4d build`**, con `4d correct` recorrido a `4e`; `languages.tsv` se queda con cuatro columnas (lenguaje, tipo, pruebas y verificador) y `init_sequences.tsv` con todo el esqueleto en nueve, así que se retira el vocabulario `deferred` y el camino v1 del script (`_glot_init_run`, `_glot_init_fix`, `_glot_init_normalise`, `_glot_init_flat`); los perfiles de modelo pasan a `gpt-6.1-sol` (low, 60) y `claude-sonnet-5.5` (medium, 90) | ✅ cerrada |
| 2.0.1 | 2026-10-23 (archivo) | [`versions/glot_2.0.1.sh`](../versions/glot_2.0.1.sh) | Base previa al hotfix, archivada como copia exacta del script vivo antes de editarlo; conserva sus cambios anteriores de andamiaje y encargos / Pre-hotfix baseline, archived as an exact copy before editing | ✅ cerrada |
| 2.0.2 | 2026-10-23 (archivo) | [`versions/glot_2.0.2.sh`](../versions/glot_2.0.2.sh) | Snapshot exacto previo al hotfix 2.0.3 / Exact pre-2.0.3 hotfix snapshot | ✅ cerrada |
| 2.0.3 | 2026-10-26 | [`versions/glot_2.0.3.sh`](../versions/glot_2.0.3.sh) | `scaffold` automatiza `.gitignore` y Makefiles declarados, avisa si queda análisis delegado; `build` queda excepcional y conserva la suite / `scaffold` automates `.gitignore` and declared Makefiles, announces remaining delegated analysis; `build` is exceptional and preserves the suite | ✅ cerrada como línea base; snapshot exacto archivado el 2026-11-02, publicación del autor pendiente / Baseline closed; exact snapshot archived, author publication pending |
| 2.1.0 | 2026-11-24 | [`glot.sh`](../glot.sh) | Rutas BYOK, overrides por categoría y avances verificados de scaffolds/runners; quedan seguimientos nativos de scaffold/runner por cerrar / BYOK routes, category overrides and verified scaffold/runner progress; native scaffold/runner follow-ups remain | ⏳ cierre en curso / closure in progress |

---

## 2.1.0 — Scaffold y runner Rust / Rust scaffold and runner

**ES:** Cargo 1.98.1 devuelve éxito para su ejemplo generado, cero casos o
solo casos omitidos. El scaffold conserva el punto de entrada y retira solo
la muestra exacta sin otros fuentes ni tests. El runner comprueba el resumen
`libtest` de cada target y exige al menos un caso aprobado; acepta omitidos
junto a aprobados y rechaza targets silenciosos. Otros formatos quedan sin
verificar.

**EN:** Cargo 1.98.1 succeeds for its generated example, zero cases or only
ignored cases. Scaffold preserves the entry point and removes only the exact
sample without other sources or tests. The runner checks each target's
`libtest` summary and requires at least one passing case; ignored cases may
accompany passing cases, while silent targets are rejected. Other formats
remain unverified.

```text
Rust native: empty, ignored-only and silent harness rejected; mixed passed
Rust references: data_structures_basics 22, numbers 10 cases
glot Rust: dry-run preserved sample; empty rejected; passing test accepted
Rust focused assertions: 10 passed, 0 failed
```

## 2.1.0 — Corrección del scaffold D / D scaffold fix

**ES:** `dub describe --data=source-files` no demostraba que `dub test`
incluyera `test/`: en una copia de la base homologada, un sentinel fallido
devolvía éxito antes de configurar el manifiesto. El scaffold reconoce ahora
el manifiesto generado y el layout simple de biblioteca homologado, incluidas
líneas vacías; configura `test/` solo en `unittest`, preserva manifiestos no
reconocidos y es idempotente. En un root aislado el sentinel pasó de falso
verde a fallo detectado. `d_test.sh` valida las fuentes que selecciona DUB y
usa una copia temporal configurada por el helper para manifiestos reconocidos
que omiten `test/`; la base homologada pasó y un fallo inyectado se propagó.
El manifiesto del submódulo permanece sin cambios.

**EN:** `dub describe --data=source-files` did not prove that `dub test`
included `test/`: in a copied homologated base, a failing sentinel returned
success before the manifest was configured. Scaffold now recognizes both the
generated manifest and the homologated simple-library layout, including blank
lines; it configures `test/` only for `unittest`, preserves unrecognized
manifests and is idempotent. `d_test.sh` validates DUB's selected sources and
uses a temporary copy configured by the helper for recognized manifests that
omit `test/`; the homologated base passed and an injected failure propagated.
The submodule manifest remains unchanged.

```text
D scaffold: generated and homologated manifests configured; custom manifest preserved
D base copy: false-green sentinel rejected after scaffold; rerun stable
D runner: recognized omitted-test manifest runs in temporary copy; source tree unchanged
```

## 2.1.0 — Corrección del rerun de Vala / Vala rerun fix

**ES:** El helper rechazaba su propia salida en una segunda ejecución.
Ahora conserva los archivos ya adaptados o propios y rechaza conflictos entre
la raíz y el destino. Con Meson 1.3.2 y Vala 0.56.16, una generación aislada
se adaptó, el rerun conservó fuente, test y manifiesto, y el sentinel falló
como se esperaba. Las aserciones focalizadas también cubren conflictos; no se
ejecutó el harness completo.

**EN:** The helper rejected its own output on a second run. It now preserves
adapted or authored files and rejects root/destination conflicts. With Meson
1.3.2 and Vala 0.56.16, an isolated generated project was adapted, the rerun
preserved source, test and manifest, and the sentinel failed as expected.
Focused assertions also cover conflicts; the full harness was not run.

## 2.1.0 — Corrección de runners PureScript y Haskell / PureScript and Haskell runner fixes

**ES:** PureScript acepta el resumen de warnings censurados por Spago si los
contadores visibles son cero; rechaza warnings visibles, resúmenes ausentes o
inconsistentes. Cada prueba recompila en
una salida temporal. Se confirmó que `workspace.buildOpts.censorLibraryWarnings: all`
censura los 15 warnings de `test-unit` sin ocultar warnings de proyecto:
Spago 1.0.4 terminó con cero warnings/errores y cinco casos aprobados en una
copia aislada. Otros formatos de resumen no están verificados. Haskell ya no ejecuta
`cabal clean`, que eliminaba el build compartido en un workspace aislado:
recompila en un `--builddir` temporal. En una copia nativa pasó, rechazó un
fallo y volvió a pasar; en un workspace de dos paquetes conservó el build
compartido. El incidente original de marcas de tiempo no está explicado.
`sync-build` sigue explícito y limitado a plantillas reconocidas.

**EN:** PureScript accepts Spago's censored-warning summary only when visible
counts are zero; visible warnings, missing summaries and inconsistent totals
are rejected. Each test rebuilds into a temporary output.
`workspace.buildOpts.censorLibraryWarnings: all` was verified to censor the
15 `test-unit` dependency warnings without hiding project warnings: Spago 1.0.4
reported zero warnings/errors and five passing cases in an isolated copy.
Other summary formats are unverified. Haskell no longer runs
`cabal clean`, which removed the shared build in an isolated workspace; it
rebuilds in a temporary `--builddir`. In a native copy it passed, rejected a
failure and passed again; in a two-package workspace it preserved the shared
build. The original timestamp incident remains unexplained. `sync-build` remains
explicit and limited to recognized templates.

```text
PureScript native: dependency warnings 1 twice; warning-free smoke test 0
Haskell native (offline): 51 passing, deliberate failure rejected, 51 passing
Haskell native workspace (offline): current package only, shared build preserved
```

## 2.1.0-dev — scaffold y runner OCaml / OCaml scaffold and runner

**ES:** La plantilla exacta de Dune 3.24 se adapta a Alcotest con un sentinel
fallido; se conservan variantes y archivos propios. El runner fuerza Dune y
exige un resumen Alcotest no vacío por acción `runtest` en salida corta. Con
Dune 3.24.2 rechazó una acción silenciosa junto a una suite aprobada y aceptó
dos suites aprobadas. Una acción personalizada con varios programas o una
dependencia sin etiqueta `runtest` aún puede ocultar un ejecutable silencioso;
revisar estos casos y otras versiones.

**EN:** The exact Dune 3.24 template is adapted to Alcotest with a failing
sentinel; authored files and variants are preserved. The runner forces Dune
and requires one nonempty Alcotest summary per `runtest` action in short
output. With Dune 3.24.2 it rejected a silent action alongside a passing suite
and accepted two passing suites. A custom action running multiple programs or
a dependency without a `runtest` label can still hide a silent executable;
review those cases and other versions.

```text
OCaml scaffold and runner focused assertions: 21 passed, 0 failed
OCaml references: 3, 4 and 15 cases, 0 failures
OCaml runner: silent action rejected; two passing actions accepted
```

## 2.1.0-dev — runner Crystal / Crystal runner

**ES:** Crystal 1.20.2 devuelve éxito sin specs y con todos los ejemplos
pendientes. `glot test` valida el informe JUnit temporal con Python 3 y
exige un ejemplo aprobado; acepta pendientes junto con aprobados y rechaza
informes ausentes o inconsistentes. El ejemplo generado ya falla sin cambios.

**EN:** Crystal 1.20.2 succeeds without specs and with all examples pending.
`glot test` validates a temporary JUnit report using Python 3 and requires a
passing example; it accepts pending examples alongside passing ones and
rejects missing or inconsistent reports. The generated example already fails.

```text
Crystal focused assertions: 10 passed, 0 failed
Crystal references: 4 and 10 examples, 0 failures
```

## 2.1.0-dev — Erlang y Gleam

**ES:** EUnit y Gleeunit devolvieron éxito sin casos. Erlang ahora crea un
sentinel para el scaffold generado reconocido; Gleam sustituye su pareja
exacta de ejemplos por otro sentinel. Ambos conservan contenido propio y
rechazan rutas simbólicas. Los runners comprueban los resúmenes nativos y
rechazan cero casos y resúmenes ausentes o ambiguos. Gleam admite omitidos
si también hay casos aprobados. Otros reporters y versiones siguen pendientes.

**EN:** EUnit and Gleeunit succeeded with no cases. Erlang now creates a
sentinel for the recognized generated scaffold; Gleam replaces its exact
sample pair with another sentinel. Both preserve authored content and reject
symlinked paths. Their runners validate native summaries and reject zero
cases and missing or ambiguous reports. Gleam accepts skipped cases when
some pass. Other reporters and versions remain unverified.

```text
Erlang focused assertions: 16 passed, 0 failed
Gleam focused assertions: 19 passed, 0 failed
EUnit references: 23 and 10 tests, 0 failures
Gleeunit references: 4 and 10 passed
Gleam JavaScript target: 1 passed
```

## 2.1.0-dev — runner ExUnit / ExUnit runner

**ES:** `mix test` puede devolver éxito sin pruebas o con todas omitidas.
`glot test` ejecuta la CLI de Mix una vez, conserva los formatters configurados
y comprueba los contadores del callback `ExUnit.after_suite/1`. Exige un caso
aprobado, informa omitidos y excluidos, acepta mezclas y rechaza resultados
ausentes, ejecuciones múltiples y terminaciones prematuras. La protección se
verificó con Mix 1.20.4; otras versiones permanecen pendientes.

**EN:** `mix test` can succeed with no tests or all tests skipped. `glot test`
runs the Mix CLI once, preserves configured formatters and checks the
`ExUnit.after_suite/1` counters. It requires a passing case, reports skipped
and excluded tests, accepts mixed results and rejects missing results,
multiple runs and premature exits. This was verified with Mix 1.20.4; other
versions remain unverified.

```text
Elixir runner assertions: 18 passed, 0 failed
data_structures_basics: 4 passed
numbers: 10 passed
glot test (empty Elixir suite): exit 4
glot test (data_structures_basics, path with spaces): 4 passed
```

## 2.1.0-dev — scaffold Elixir / Elixir scaffold

**ES:** Mix 1.20.4 generó una fuente `hello/0` y dos casos de muestra.
El scaffold sustituye solo esa pareja reconocida, con el helper original y
sin otros archivos o enlaces en `lib/` y `test/`, por un test sentinel que
falla hasta escribir la suite. Conserva variantes y rechaza rutas simbólicas.
En un proyecto aislado, `glot test` rechazó el sentinel con código 4.
La brecha del runner se resolvió en la sección de validación ExUnit anterior:
ahora rechaza suites vacías y suites sin casos aprobados.

**EN:** Mix 1.20.4 generated a `hello/0` source and two example cases.
Scaffold replaces only that recognized pair, with the original helper and
no other files or links in `lib/` and `test/`, with a failing sentinel until
the suite is written. Other variants are preserved and symlinked paths are
rejected. In an isolated project, `glot test` rejected the sentinel with
exit code 4. General runner protection was resolved in the preceding ExUnit
validation entry: empty suites and suites without passing cases are now
rejected.

```text
mix test (generated sample): 2 passed (1 doctest, 1 test)
mix test (empty): 0 tests, exit 0
mix test (skipped): 0 tests, 1 skipped, exit 0
glot test (scaffold sentinel): exit 4
Elixir focused assertions: 14 passed, 0 failed
```

## 2.1.0-dev — 2026-11-23 (runners y scaffolds PHP, R y C++ / PHP, R and C++ runners and scaffolds)

**ES:** PHPUnit 13.3.4 devolvía código 0 sin ejecutar pruebas en el scaffold
PHP. La plantilla ahora exige `failOnEmptyTestSuite`, y una prueba real sigue
pasando. El runner R también daba código 0 con `PASS 0`; ahora `make test`
falla si testthat no informa casos aprobados, y pasa con una prueba real.
C++ reemplaza los archivos Bazel vacíos por `MODULE.bazel`, `WORKSPACE` y
targets de biblioteca/Google Test basados en la base homologada; fija Bazel
7.1.1 y conserva configuraciones existentes. En una copia aislada, Bazelisk
compiló y ejecutó la suite C++ homologada. El harness comprueba generación,
rerun, contenido propio y rechazo de `BUILD` simbólico. La revisión de los
demás scaffolds sigue abierta.

**EN:** PHPUnit 13.3.4 previously returned zero without running tests in the
PHP scaffold. Its template now sets `failOnEmptyTestSuite`; a real smoke test
still passes. The R runner also returned zero with `PASS 0`; `make test` now
fails unless testthat reports passing cases and succeeds with a real test.
C++ replaces empty Bazel files with `MODULE.bazel`, `WORKSPACE` and
library/Google Test targets based on the homologated project, pins Bazel
7.1.1 and preserves existing configuration. Bazelisk built and ran the
homologated C++ suite in an isolated copy. The harness covers generation,
reruns, authored content and rejection of a symlinked `BUILD`. The remaining
scaffold review is still open.

```text
bazelisk test //... --noshow_progress --color=no: 1 test passed
glot tests: 1943 passed, 0 failed
docs checks: 32 passed, 0 failed
bash -n scripts/data/cpp_scaffold.sh
bash -n scripts/tests/glot_test.sh
git diff --check
```

## 2.1.0-dev — 2026-11-23 (revisión de Vala / Vala review)

**ES:** La fila de Vala solo creaba `src/` y `test/`, aunque Meson 1.3.2
genera `meson.build` y ambas fuentes en la raíz; además, su archivo de test es
una demo, no una suite GLib.Test. El nuevo helper mueve solo la pareja exacta,
actualiza las rutas Meson y sustituye el test por un sentinel GLib.Test fallido.
`vala_test.sh` compila todas las suites y exige TAP con casos aprobados, sin
omitidos ni fallos. Las bases homologadas pasaron en copias aisladas.
No se modificaron submódulos.

**EN:** Vala's row only created `src/` and `test/`, while Meson 1.3.2 generates
`meson.build` and both source files at the root; its test file is a demo, not a
GLib.Test suite. The helper moves only the exact pair, updates Meson paths and
replaces the test with a failing GLib.Test sentinel. `vala_test.sh` compiles all
suites and requires TAP with passing cases and no skips or failures. The
homologated references passed in isolated copies. No submodules were modified.

```text
meson 1.3.2 / Vala 0.56.16: generated pair adapted, sentinel rejected
Vala references: data_structures_basics 4, numbers 10 cases
Vala native TAP: passing case accepted; empty and mixed skipped cases rejected
docs checks: 32 passed, 0 failed
git diff --check
```

## 2.1.0-dev — 2026-11-23 (revisión de Dart / Dart review)

**ES:** `dart create --no-pub -t package` genera el layout `lib/src/`, `test/`
y `example/` ya alineado con las bases, pero deja muestras `Awesome` en la
fuente, el test y el ejemplo. La secuencia de scaffold y la guía ahora indican
explícitamente conservar la estructura y configuración del paquete y adaptar
las tres muestras al contrato; el test inicial no cuenta como suite
homologada. Se inspeccionó la salida de Dart 3.12.2 en un directorio temporal,
sin descargar dependencias ni modificar submódulos.

**EN:** `dart create --no-pub -t package` generates `lib/src/`, `test/` and
`example/`, already aligned with the homologated layout, but leaves `Awesome`
samples in the source, test and example. The scaffold sequence and guide now
explicitly preserve the package structure/configuration and adapt all three
samples to the contract; the generated test is not a homologated suite. Dart
3.12.2 output was inspected in a temporary directory without fetching
dependencies or modifying submodules.

```text
dart --version: 3.12.2
dart create --no-pub -t package: expected package files generated in temporary directory
```

## 2.1.0-dev — 2026-11-24 (runner Dart / Dart runner)

**ES:** Dart 3.12.2 y `package:test` 1.32.0 (versión del lockfile homologado)
devuelven éxito si todos los casos están omitidos (`+0 ~1: All tests passed!`);
una suite sin casos sí devuelve 79. `dart_test.sh` conserva la salida de
`dart test --reporter expanded --no-color`, propaga errores del proceso y
exige un resumen único con al menos un caso aprobado. La mezcla de aprobados y
omitidos se acepta. El módulo homologado aprobó sus tres casos y una copia
aislada confirmó el comportamiento vacío/omitido; no se modificó el submódulo.

**EN:** Dart 3.12.2 and `package:test` 1.32.0 (the homologated module's lockfile)
exit successfully when all cases are skipped (`+0 ~1: All tests passed!`);
an empty suite exits 79.
`dart_test.sh` preserves `dart test --reporter expanded --no-color` output,
propagates process failures and requires one summary with at least one passing
case. Mixed passes and skips are accepted. The homologated module passed its
three cases; an isolated copy confirmed the empty/skipped behavior. The
submodule was not modified.

```text
dart --version: 3.12.2
package:test: 1.32.0 (homologated module lockfile)
homologated Dart tests: 3 passed
isolated module copy: empty suite exit 79; skipped-only exit 0
dart runner assertions: pass, mixed pass/skip accepted; empty summary and skipped-only rejected
```

## 2.1.0-dev — 2026-11-23 (revisión de Elm / Elm review)

**ES:** `elm init` deja `elm.json` y `src/`, pero no `tests/`, `.gitignore`
ni las dependencias de `elm-test`. El scaffold ahora valida el manifiesto,
crea `src/` y `tests/` con protección de rutas y añade el ignore específico
solo si falta. La nota de completado y la guía hacen explícito `elm-test init`,
que declara `elm-explorations/test` y crea una suite de ejemplo; no se ejecuta
ni instala durante `glot scaffold`. Se verificó `elm init` temporalmente y el
harness cubre scaffold, rerun, preservación del ignore y rechazo de symlinks.

**EN:** `elm init` leaves `elm.json` and `src/`, but not `tests/`, `.gitignore`
or `elm-test` dependencies. Scaffold now validates the manifest, creates `src/`
and `tests/` with path protection, and adds the language-specific ignore file
only when missing. The completion note and guide make `elm-test init` explicit;
it declares `elm-explorations/test` and creates a sample suite, and is not run
or installed by `glot scaffold`. `elm init` was verified temporarily, and the
harness covers scaffolding, reruns, ignore preservation and symlink rejection.

```text
elm init (temporary project): elm.json and src/ created; tests/ and .gitignore absent
glot tests: 1959 passed, 0 failed
docs checks: 32 passed, 0 failed
git diff --check
```

## 2.1.0-dev — 2026-11-23 (runner mínimo de Haxe / Haxe minimal runner)

**ES:** El workflow requiere que el runner exista antes de escribir la suite,
pero el scaffold de Haxe solo creaba directorios e instalaba `utest`. Ahora
`haxe_scaffold.sh` crea de forma idempotente `build.hxml`, `RunTests.hx`, un
test sentinel fallido y `.gitignore`, preservando archivos propios y rechazando
rutas simbólicas. Haxe 4.3.7 con utest 1.13.2 ejecutó el sentinel y devolvió
código 1. El harness cubre la instalación simulada, rerun, preservación y
rechazo de symlink; la auditoría global sigue abierta.

**EN:** The workflow requires a runner before the suite is written, but Haxe's
scaffold only created directories and installed `utest`. `haxe_scaffold.sh` now
idempotently creates `build.hxml`, `RunTests.hx`, a failing sentinel test and
`.gitignore`, preserving authored files and rejecting symlinked paths. Haxe
4.3.7 with utest 1.13.2 ran the sentinel and returned exit code 1. The harness
covers simulated installation, reruns, preservation and symlink rejection;
the global audit remains open.

```text
haxe build.hxml (temporary scaffold): 1 failure, "No tests configured", exit 1
glot tests: 1972 passed, 0 failed
docs checks: 32 passed, 0 failed
bash -n scripts/data/haxe_scaffold.sh scripts/tests/glot_test.sh
git diff --check
```

## 2.1.0-dev — 2026-11-23 (verificación nativa de scaffold Swift / native Swift scaffold check)

**ES:** En un checkout temporal con espacios en la ruta y sin `.build`,
`swift package init` produjo la muestra exacta de SwiftPM 6.3.3; `glot
scaffold` la sustituyó por los imports vacíos. `glot test` compiló desde cero
y rechazó que XCTest y Swift Testing no ejecutaran casos (código 4), aunque
`swift test` presenta ambos resúmenes vacíos como éxito. No se modificó el
submódulo Swift.

**EN:** In a temporary checkout with spaces in its path and no `.build`,
`swift package init` produced the exact SwiftPM 6.3.3 sample; `glot scaffold`
replaced it with empty imports. `glot test` built from scratch and rejected
the zero XCTest and Swift Testing cases (exit code 4), although `swift test`
reports both empty summaries as successful. The Swift submodule was untouched.

```text
SwiftPM 6.3.3: sample matched and was replaced
glot test: zero cases rejected, exit code 4
Swift native scaffold check: passed
```

## 2.1.0-dev — 2026-11-23 (paso manual de PureScript / PureScript manual step)

**ES:** La guía y el completado de scaffold nombran ahora `spago install
--test-deps test-unit` como paso manual opcional. No se automatiza: con Spago
1.0.4 y test-unit 17.0.0, la prueba estricta produjo 15 warnings de
dependencia, aunque no hubo warnings del código del proyecto. El bloqueo de
4a sigue abierto.

**EN:** The guide and scaffold completion note now name
`spago install --test-deps test-unit` as an optional manual step. It is not
automated: with Spago 1.0.4 and test-unit 17.0.0, the strict test produced 15
dependency warnings, though there were no project-code warnings. The 4a gate
remains open.

**ES — Confirmación (2026-11-24):** una compilación limpia aislada reprodujo
los 15 warnings de dependencia con código 0; al añadir una declaración de
proyecto sin firma de tipo, `--strict` devolvió código 1. El aviso del scaffold
conserva también la advertencia del runner vacío y ambas notas tienen regresión.

**EN — Confirmation (2026-11-24):** an isolated clean build reproduced the 15
dependency warnings with exit 0; adding a project declaration without a type
signature made `--strict` exit 1. The scaffold notice also retains the empty
runner warning, and both handoffs have regression coverage.

```text
spago test --offline --strict: Src 0 warnings, Lib 15 warnings, exit 0
strict project warning probe: MissingTypeDeclaration, exit 1
PureScript targeted tests: 23 passed, 0 failed
docs checks: 32 passed, 0 failed
git diff --check
```

## 2.1.0-dev — 2026-11-24 (revisión del scaffold Go / Go scaffold review)

**ES:** El scaffold crea `src/` y `tests/` sin seguir enlaces ni aceptar
archivos en lugar de directorios, y conserva contenido propio. Go 1.26.5
rechazó el scaffold sin paquetes, pero devolvió éxito tanto con una fuente sin
tests como con un solo test omitido. La guía y el completado advierten que
esto no valida una suite; sigue pendiente un runner que detecte esos casos.

**EN:** Scaffold creates `src/` and `tests/` without following symlinks or
accepting files in place of directories, preserving authored contents. Go
1.26.5 rejected the scaffold without packages, but succeeded both with a
source file and no tests and with a single skipped test. The guide and
completion notice warn that this does not validate a suite; a runner detecting
these cases remains pending.

```text
go test ./...: no packages, exit 1
go test ./...: source without tests, exit 0
go test -count=1 -json ./...: skipped-only test, exit 0
go test -count=1 -run '^TestPass$' ./...: passed
go test -count=1 -run '^TestFail$' ./...: exit 1
Go targeted tests: 14 passed, 0 failed
docs checks: 32 passed, 0 failed
git diff --check
```

## 2.1.0-dev — 2026-11-24 (runner Go / Go runner)

**ES:** `glot test` para Go ejecuta ahora `go_test_runner.go`, que invoca
`go test -count=1 -json ./...` una sola vez, muestra la salida nativa y
requiere al menos una prueba final aprobada. Rechaza resultados incompletos,
fallos, JSON inválido y suites vacías o totalmente omitidas; informa
omisiones y permite combinarlas con pruebas aprobadas. No cuenta como caso
aprobado un padre cuyas subpruebas fueron omitidas. Se probaron ambos
proyectos homologados en copias aisladas y el flujo de `glot test` con
espacios en la ruta.

**EN:** `glot test` for Go now runs `go_test_runner.go`, invoking
`go test -count=1 -json ./...` once, displaying native output and requiring
at least one passing leaf test. It rejects incomplete results, failures,
invalid JSON, empty and entirely skipped suites; it reports skips and permits
them alongside passes. A parent with skipped subtests does not count as a
passing case. Both homologated projects were tested in isolated copies, as was
`glot test` under a path containing spaces.

```text
Go runner regressions: 15 passed, 0 failed
Go native edge cases: empty, skipped-only and failing rejected; mixed passed
Go compilation failure: error displayed and rejected
data_structures_basics: 15 passing leaf tests
numbers: 10 passing leaf tests
glot test go algorithms/data_structures_basics (isolated copy): passed
glot test with no test files (isolated copy): exit 4
go vet scripts/data/go_test_runner.go
docs checks: 32 passed, 0 failed
git diff --check
```

---

## 2.1.0-dev — 2026-11-22 (fix de scaffold en curso / scaffold fix in progress)

**ES:** Se inicia el fix sin cerrar la versión. `new` inspecciona el `.git/`
recién generado en un módulo inicialmente vacío y solo lo retira si es seguro;
el estado se resuelve desde Git anidado y se eliminan del catálogo los borrados
incondicionales de `.git`. `scaffold` también retira un Git anidado vacío
reconocible dejado por un generador anterior; las regresiones cubren invocación
desde el módulo, `--dry-run`, limpieza real, rerun y bloqueo de configuración
propia.
En D se retira únicamente el ejemplo nativo verificado; D y PureScript anuncian
el análisis pendiente. Siguen abiertas la revisión de los scaffolds, los helpers
de build y las demás condiciones del [`ROADMAP.md`](ROADMAP.md).

**EN:** The fix has started; the release remains open. `new` checks and removes
freshly generated Git only when safe, nested Git resolves the superproject
state, and unconditional catalog cleanup is removed. `scaffold` also removes
recognizable empty nested Git left by an earlier generator; regressions cover
module-local invocation, non-mutating dry-run, cleanup, rerun and blocking
authored configuration. D removes only the verified native sample; D and
PureScript announce pending analysis. The remaining scaffold review, build
helpers and roadmap conditions are open.

**ES:** Continuación: PureScript conserva sus layouts Spago, crea el módulo
PascalCase y un runner vacío, y retira o sustituye únicamente las muestras
exactas de Spago 1.0.4. En un proyecto aislado, `spago test --offline --strict`
compiló con 0 warnings y 0 errores y ejecutó el runner. Los warnings de
`test-unit` se resuelven con el censor soportado por Spago; otras versiones
del generador siguen por comprobar.

**EN:** Continued with a PureScript module and empty runner, replacing only
exact Spago 1.0.4 samples. In an isolated project, `spago test --offline --strict`
compiled with zero warnings and errors and ran the runner. `test-unit` warnings
are handled with Spago's supported library-warning censor setting. The runner
accepts Spago's `0/15` censored-warning summary only when visible warning
counts remain zero; other generator versions remain to be checked.

**ES:** Assembly incorpora un runner NASM mínimo que informa de la ausencia
de tests, una fuente ensamblable y patrones para objetos/ejecutable; preserva
archivos existentes y completa el antiguo runner vacío. Verificado en un
directorio aislado con `make run`, NASM y `ld`; la suite debe conectar sus
grupos y propagar los fallos.

**EN:** Assembly now provides an executable empty NASM runner, an assemblable
source and ignore patterns, preserving existing contents. Verified in an
isolated directory with `make run`, NASM and `ld`; the suite must connect its
groups and propagate failures.

**ES:** JavaScript corrige el andamiaje npm/Jest: deja de forzar ESM sobre la
base CommonJS, completa el script de test y los archivos de configuración,
conserva scripts propios y no instala dependencias. Se añade cobertura de
generación e idempotencia; la auditoría global sigue abierta.

**EN:** JavaScript's npm/Jest scaffold no longer forces ESM on the CommonJS
base; it completes the test script and configuration, preserves authored
scripts, and does not install dependencies. Generation and idempotence are
covered; the full audit remains open.

**ES:** TypeScript reemplaza los archivos vacíos que dejaba el scaffold por
configuración strict/NodeNext, Jest/ts-jest y `.gitignore`; completa los scripts
predeterminados sin sobrescribir los propios ni instalar dependencias. La
auditoría global sigue abierta.

**EN:** TypeScript replaces the scaffold's empty files with strict/NodeNext,
Jest/ts-jest and ignore configuration; it completes npm defaults without
overwriting authored scripts or installing dependencies. The full audit remains open.

**ES:** Julia configura `Test` y el target de pruebas en el manifiesto generado
reconocido, adapta la muestra exacta a `src/{Module}.jl` cuando no hay otras
fuentes y crea un sentinel que falla en `test/run_tests.jl`. Añade
`test/runtests.jl` como adaptador porque `Pkg.test()` requiere ese entrypoint;
la suite conectada pasó por ambos runners. Conserva manifiestos y fuentes
propias. La auditoría global sigue abierta.

**EN:** Julia configures `Test` and the test target in the recognized generated
manifest, adapts the exact sample to `src/{Module}.jl` when no other sources
exist, and creates a failing sentinel in `test/run_tests.jl`. It adds
`test/runtests.jl` as an adapter because `Pkg.test()` requires that entrypoint;
the connected suite passed through both runners. Authored manifests and sources
are preserved. The full audit remains open.

**ES:** C conserva archivos y Makefile existentes, rechaza rutas simbólicas
y crea `.gitignore` cuando falta. En un laboratorio aislado, Criterion 2.4.1
ejecutó el runner sin casos y devolvió fallo al introducir un caso fallido.

**EN:** C preserves existing files and Makefiles, rejects symlinked paths and
creates a missing `.gitignore`. In an isolated lab, Criterion 2.4.1 ran the
empty runner and returned failure for an intentionally failing test.

**ES:** D crea `source/{module}.d` y `test/`, y configura la inclusión de
`test/` en manifiestos reconocidos. DUB 1.41.0 confirmó que el build normal
no incluye esos tests. La base homologada, cuyo manifiesto omite `test/`, se
valida ahora con `d_test.sh` en una copia temporal. Los manifiestos propios se
conservan y requieren adaptación explícita si omiten la suite.

**EN:** D creates `source/{module}.d` and `test/`, configuring `test/` in
recognized manifests. DUB 1.41.0 confirmed that normal builds exclude these
tests. The homologated base, whose manifest omits `test/`, is now validated
with `d_test.sh` in a temporary copy. Authored manifests are preserved and
require explicit adaptation if they omit the suite.

**ES:** Forth crea una fuente vacía, un framework y un runner que anuncia la
ausencia de tests, sin sobrescribir archivos propios. Aunque el sentinel de
scaffold falla, Gforth 0.7.3 devuelve 0 para las aserciones fallidas de las
bases: el contador `failed` solo se imprime. `forth_test.sh` valida los dos
formatos de resumen homologados, sus contadores y un mínimo de un caso
aprobado, sin modificar los submódulos.

**EN:** Forth creates an empty source, a framework and a runner announcing no
tests without overwriting authored files. Although the scaffold sentinel
fails, Gforth 0.7.3 exits 0 for failed assertions in the homologated bases:
the `failed` counter is only printed. `forth_test.sh` validates both
homologated summary formats, their counters and at least one passing case,
without modifying the submodules.

```text
Gforth 0.7.3 references through glot: calculator 5, numbers 22, naive_sort 78,
  data_structures_basics 114, data_structures_advanced 180 cases passed
Injected failed assertions: native exit 0 in both summary formats; wrapper exit 1
Forth summary parser: valid formats, failures, empty/incomplete/malformed,
  ambiguous, inconsistent and process-failure cases rejected or accepted as expected
```

**ES:** COBOL crea una fuente y un runner mínimos, Makefile y `.gitignore`
sin sobrescribir los existentes. Con GnuCOBOL 3.2.0 se verificaron el punto de
entrada con helpers, la propagación de un fallo y la ausencia del runner aunque
exista un ejecutable anterior.

**EN:** COBOL creates a minimal source and runner, Makefile and `.gitignore`
without overwriting existing files. With GnuCOBOL 3.2.0, tests verified the
entry point with helpers, failure propagation and a missing runner even when
an earlier executable exists.

**ES:** Grain crea fuente y runner mínimos, Makefile y `.gitignore` sin
sobrescribir archivos. Grain 0.7.2 compiló el runner e informó el fallo de una
fuente inválida. El framework sigue pendiente: una prueba negativa de la base
homologada reportó el fallo pero devolvió código 0.

**EN:** Grain creates a minimal source, runner, Makefile and `.gitignore`
without overwriting files. Grain 0.7.2 compiled the runner and rejected an
invalid source. The framework remains pending: a negative test of the
homologated base reported failure but returned exit code 0.

**ES:** Grain incorpora `TestStatus.finish` y actualiza solo el runner vacío
anterior reconocido. Con el framework de la base, una prueba verde devolvió
0 y una fallida devolvió 1. La suite debe conectar el resultado; los módulos
existentes y la adaptación del framework siguen pendientes.

**EN:** Grain now provides `TestStatus.finish` and upgrades only the
recognized previous empty runner. With the base framework, a passing test
returned 0 and a failing one returned 1. The suite must connect the result;
existing modules and framework adaptation remain pending.

**ES:** R prepara un paquete mínimo con `testthat` sin reemplazar archivos
existentes. En un laboratorio aislado, testthat 3.2.1 arrancó con cero casos
y devolvió fallo al introducir una aserción fallida.

**EN:** R prepares a minimal package with `testthat` without replacing
existing files. In an isolated lab, testthat 3.2.1 ran with zero cases and
returned failure for an intentionally failing assertion.

**ES:** Prolog preserva fuentes y crea, si falta, una fuente vacía compatible
con `consult/1` y patrones para QLF. SWI-Prolog 10.0.2 la consultó sin errores;
esa comprobación inicial no ejecutó suites; la selección múltiple y la
validación del resultado se resolvieron en el seguimiento documentado abajo.

**EN:** Prolog preserves existing sources and creates a missing empty source
compatible with `consult/1` plus QLF ignore patterns. SWI-Prolog 10.0.2
consulted it without errors; that initial check did not run suites. Multiple
suite selection and result validation were resolved in the follow-up below.

**ES:** El comando Prolog ahora ejecuta todas las suites `*_test.pl` y
`*_tests.pl`, informa scaffold vacío y falla cuando no se ejecuta ningún caso,
una aserción falla o hay errores. Se verificaron 15 casos de las tres suites
de `numbers` y los cinco de `calculator` con SWI-Prolog 10.0.2.

**EN:** The Prolog command now runs all `*_test.pl` and `*_tests.pl` suites,
reports an empty scaffold and fails when no case runs, an assertion fails, or
errors occur. SWI-Prolog 10.0.2 verified all 15 cases from the three `numbers`
suites and all five `calculator` cases.

**ES:** En Perl, el comando de pruebas conserva la selección de prove y su
harness TAP, pero rechaza la ausencia de suites o de casos no omitidos. Un
scaffold vacío necesita su suite antes de validar.

**EN:** Perl test execution retains prove's selection and TAP harness but
rejects runs without suites or non-skipped cases. An empty scaffold needs its
suite before validation.

**ES:** Raku preserva la fuente y el ignore existentes, protege rutas
simbólicas y crea patrones de precompilación si falta el ignore. Verificado
con el compilador, una suite de prueba y `numbers`. La salida exitosa de
`prove6` sin casos se aborda en el cambio siguiente.

**EN:** Raku preserves existing source and ignore files, protects symbolic
paths and creates missing precompilation ignore patterns. Verified with the
compiler, a test suite and `numbers`. `prove6` succeeding with no cases was
addressed in the following change.

**ES:** El comando Raku conserva el descubrimiento y harness de `prove6` y
rechaza la ausencia de suites, ejecuciones incompletas y casos todos omitidos.
Las suites homologadas de `numbers` y `data_structures_basics` pasan.

**EN:** Raku's test command retains prove6's discovery and harness and rejects
missing suites, incomplete runs and entirely skipped cases. The homologated
`numbers` and `data_structures_basics` suites pass.

**ES:** Rexx preserva la fuente, protege rutas simbólicas y ejecuta todas las
suites con `rexx_test.sh`, que valida contadores y rechaza fallos, errores y
ejecuciones vacías.

**EN:** Rexx preserves the source, protects symbolic paths and runs all suites
with `rexx_test.sh`, which validates counters and rejects failures, errors and
empty runs.

**ES:** Scheme crea una fuente Guile cargable sin sobrescribir archivos y
excluye logs SRFI-64 cuando falta el ignore. La selección de varias suites y
la propagación de fallos se abordan en el cambio siguiente.

**EN:** Scheme creates a loadable Guile source without overwriting files and
excludes SRFI-64 logs when the ignore file is absent. Multiple-suite selection
and runner failure propagation are addressed in the following change.

**ES:** El comando Scheme ejecuta todas las suites Guile y consulta sus
resultados SRFI-64. Rechaza ausencia de casos, grupos incompletos, salidas
anticipadas y fallos; se verificaron las tres suites de `numbers`.

**EN:** Scheme's command runs every Guile suite and checks SRFI-64 results.
It rejects empty runs, incomplete groups, early exits and failures; verified
with all three `numbers` suites.

**ES:** Tcl crea una fuente de paquete y su índice funcionales si faltan,
conserva archivos existentes y anuncia la revisión pendiente del runner y
de scaffolds anteriores. Rexx cargó el cuerpo de la suite al crear un
`.Package`, por lo que volver a ejecutar sus clases duplicaría las pruebas.

**EN:** Tcl creates a working package source and index if missing, preserves
existing files and announces pending runner and old-scaffold review. Rexx
executed the suite body when creating a `.Package`, so running its classes
again would duplicate tests.

**ES:** El runner Tcl ejecuta todas las suites `.test` y comprueba los
contadores de Tcltest para detectar fallos y ejecuciones vacías o incompletas.
Se verificaron `numbers` y `data_structures_basics`.

**EN:** The Tcl runner executes all `.test` suites and checks Tcltest counters
for failures and empty or incomplete runs. Verified against `numbers` and
`data_structures_basics`.

**ES:** `new` y `scaffold` bloquean también un `.git` anidado en formato
gitfile, sin modificarlo. Git preexistente queda protegido por el fix cerrado.

**EN:** `new` and `scaffold` also block a nested `.git` gitfile without
modifying it. Pre-existing Git is protected by the closed fix.

**ES:** Scala preserva archivos existentes, rechaza enlaces y crea un build
sbt/ScalaTest basado en las referencias. `sbt test` compiló el scaffold aislado
sin casos y propagó casos sintéticos aprobado y fallido. La fuente y el build
previos requieren revisión; el cambio siguiente aborda ejecuciones sin tests.

**EN:** Scala preserves existing files, rejects symlinks and creates an
sbt/ScalaTest build based on the references. `sbt test` compiled the isolated
scaffold with no cases, and propagated passing and failing synthetic tests.
Existing source and build files need review; the following change addresses
empty test runs.

**ES:** El comando Scala comprueba los resultados estructurados de sbt sin
repetir las pruebas; rechaza ejecuciones vacías o con todos los casos omitidos.
Verificadas las dos bases homologadas en copias aisladas.

**EN:** Scala's command checks sbt's structured results without rerunning tests;
it rejects empty and entirely ignored runs. Both homologated bases were verified
in isolated copies.

**ES:** Swift conserva suites y manifiestos existentes, protege rutas y
sustituye solo el ejemplo SwiftPM 6.3.3 comprobado. `swift_test.sh` valida
XCTest y Swift Testing y rechaza cero casos, fallos y omisiones.

**EN:** Swift preserves existing suites and manifests, protects paths and
replaces only the verified SwiftPM 6.3.3 example. `swift_test.sh` validates
XCTest and Swift Testing and rejects zero cases, failures and skips.

**ES:** PureScript usa `purescript_test.sh` para contar los resúmenes
`All N tests passed!` y rechazar runners vacíos o fallidos.

**EN:** PureScript uses `purescript_test.sh` to count `All N tests passed!`
summaries and reject empty or failing runners.

**ES:** Haskell rechaza durante `glot test` los módulos locales importados y
no declarados en targets Cabal compilados; no modifica el manifiesto.

**EN:** Haskell `glot test` rejects imported local modules missing from compiled
Cabal targets; it does not edit the manifest.

**ES:** El selector Haskell rechaza paquetes sin suites declaradas; por sí
solo no garantiza que una suite existente contenga casos.

**EN:** The Haskell selector rejects packages without declared suites; alone,
it does not guarantee that an existing suite contains cases.

**ES:** La investigación inicial encontró selección ambigua y códigos de
salida poco fiables en ooRexxUnit. El runner integrado `rexx_test.sh` ejecuta
cada suite una vez, valida los contadores e impide esos falsos verdes.

**EN:** Initial investigation found ambiguous selection and unreliable
ooRexxUnit exit codes. The integrated `rexx_test.sh` runs each suite once,
validates counters and prevents those false greens.

**ES:** Ballerina aísla el informe JSON de cada ejecución para no aceptar
resultados antiguos y rechaza cero casos y fallos; el workspace probado agrega
los resultados de sus paquetes.

**EN:** Ballerina isolates each run's JSON report to prevent stale results and
rejects zero cases and failures; the tested workspace aggregates package results.

**ES:** Groovy conserva archivos propios y retira solo la pareja de ejemplos
Gradle 9.6.1 verificada. `gradle_test.sh` rechaza NO-SOURCE y exige informes XML.

**EN:** Groovy preserves authored files and removes only the verified Gradle
9.6.1 sample pair. `gradle_test.sh` rejects NO-SOURCE and requires XML reports.

**ES:** Kotlin comparte la protección y el runner de Gradle con Groovy;
conserva archivos propios y rechaza NO-SOURCE.

**EN:** Kotlin shares Groovy's Gradle sample protection and runner, preserves
authored files and rejects NO-SOURCE.

**ES:** Nim retira solo las muestras exactas de Nimble y ejecuta las suites
directamente para rechazar casos vacíos o fallidos.

**EN:** Nim removes only exact Nimble samples and executes suites directly to
reject empty or failing runs.

**ES:** V conserva su layout generado y rechaza ejecuciones cuyo resumen tenga
cero casos.

**EN:** V preserves its generated layout and rejects runs whose summary reports
zero cases.

**ES:** TypeScript exige el informe JSON de Jest y rechaza cero casos,
omitidos y fallos.

**EN:** TypeScript requires the Jest JSON report and rejects zero cases,
skipped tests and failures.

**ES:** JavaScript reutiliza el runner JSON de Jest y rechaza ejecuciones vacías,
omitidas o fallidas.

**EN:** JavaScript reuses the Jest JSON runner and rejects empty, skipped or
failing runs.

## 2.1.0-dev — 2026-11-02 (tarifas vigentes / current rates)

**ES:** El perfil balanced, el alias `terra` y su adaptador pasan de
`gpt-5.6-terra` a `gpt-6.1-terra`, que figura en el catálogo oficial y en el
selector del editor mostrado por el autor. Tarifa default: entrada $1 y salida
$5 por millón, frente a $2/$12 de 5.6. Sonnet/Opus 5.5 ya estaban vigentes.
Flash se conserva por decisión previa; Qwen Plus sigue siendo más barato que
Max en OpenRouter. Comparación y fuentes en
[`VALIDATION.md`](VALIDATION.md).

**EN:** Balanced now selects Terra 6.1 instead of 5.6 across default, alias
and adapter. Current public pricing confirms lower input/output rates;
the existing Claude versions and author-selected Flash remain unchanged.
Qwen Plus remains cheaper than Max on OpenRouter.

**ES / EN:** La ayuda del CLI local aún no enumera Terra 6.1; doctor informa
la cobertura real, sin confundirla con el editor ni sustituir el modelo.
No se ejecutó inferencia ni se actualizó la instalación del autor. /
Local CLI help still omits 6.1; doctor reports actual coverage without
fallback. No inference or author installation upgrade was performed.

```text
glot tests: 1316 passed, 0 failed
docs checks: 25 passed, 0 failed
```

## 2.1.0-dev — 2026-11-02 (layouts nativos / native layouts)

**ES:** Segundo bloque de scaffold: C++ usa `tests/`; Crystal conserva
`src/spec`; F# conserva proyectos anidados y declara su `ProjectReference`
con `dotnet add reference`; Go usa `src/tests`; Haskell genera nombre Cabal
con guiones, `hs-source-dirs: lib` y el módulo exportado, y crea su declaración
solo si falta; V conserva `tests/`, gitfile y fuente generado sin mover código
cuyos imports aún apuntan a la raíz. Se corrigió también la tabla manual de
Perl para que declare `lib/`, no `src/`.

**EN:** The next scaffold block corrects C++, Crystal, F#, Go, Haskell and V
layouts without flattening native projects, deleting Git metadata or moving
authored sources independently of their references. The manual Perl table
now matches its library layout.

**ES:** Comprobaciones nativas en laboratorio temporal aislado: generadores
Crystal, F#, Haskell y V, aplicación de las filas reales de scaffold,
inicialización Go y `ghc -fno-code lib/NaiveSort.hs`. F# se generó con
`--no-restore` y se comprobó su referencia con `dotnet sln list`; no se
certifica la suite xUnit ni se descargaron paquetes. Se conserva la distinción
entre comprobar un layout y homologar código/tests académicos.

**EN:** Isolated native checks covered generators, actual scaffold rows,
Go initialization and a no-code Haskell compilation. F# used no-restore
templates and solution/reference inspection, not xUnit certification.
No academic code or module completion counters changed.

```text
crystal scaffold: passed
fsharp scaffold: passed
haskell scaffold: passed
v scaffold: passed
glot tests: 1316 passed, 0 failed
docs checks: 25 passed, 0 failed
```

**ES / EN:** No cierra v2.1.0: nueve lenguajes tienen correcciones verificadas
en estos bloques; queda la revisión/corrección de los otros 41, incluidos
renombrados acoplados a referencias y artefactos de configuración faltantes.
/ v2.1.0 remains open pending the other 41 languages and their coupled
reference/configuration corrections.

## 2.1.0-dev — 2026-11-23 (preservación de Racket / Racket preservation)

**ES:** Racket deja de borrar recursivamente `.github/`, `profile/` y archivos
auxiliares de `raco new`; la guía y el encargo scaffold ahora exigen preservar
extras que no bloquean el módulo. El harness verifica esos artefactos con un
generador simulado, y `glot new` se probó con `raco-new` 9.1 real.

**EN:** Racket no longer recursively deletes `.github/`, `profile/` or other
`raco new` files. The guide and scaffold request now preserve extras that do
not block module use. The harness checks these artifacts with a fake generator;
`glot new` was also exercised with real `raco-new` 9.1.

```text
bash -n scripts/tests/glot_test.sh
Integrated scaffold: 184 passed, 0 failed
glot new racket algorithms/naive_sort: generated auxiliary files preserved
git diff --check
```

**ES / EN:** `docs/tests/docs_check.sh` aún presenta dos fallos previos a este
bloque: deriva general entre comandos documentados y `languages.tsv`, y dos
líneas de comandos indentadas que ya estaban en la guía en `HEAD`. / The docs
checker still reports two pre-existing issues: general command drift between
the guide and `languages.tsv`, and two indented command lines already present
in the committed guide.

## 2.1.0-dev — 2026-11-23 (test-suite de Haskell / Haskell test suite)

**ES:** `cabal init` recibe `--tests` para generar también el test-suite y
`test/Main.hs`; la guía distingue ese runner nativo vacío de los casos que
añadirá el sprint. En un laboratorio aislado, Cabal 3.16.1.0 compiló y ejecutó
el runner con `cabal test .:tests --offline
--ghc-options=-Werror=missing-home-modules`. La sincronización de helpers en
Cabal es explícita y parcial; la revisión de los demás scaffolds permanece
pendiente.

**EN:** `cabal init` now receives `--tests` to generate the test suite and
`test/Main.hs`; the guide distinguishes this empty native runner from sprint
test cases. In an isolated lab, Cabal 3.16.1.0 compiled and ran the runner with
`cabal test .:tests --offline
--ghc-options=-Werror=missing-home-modules`. Helper synchronization in Cabal
remains explicit and partial; the remaining scaffold review is still pending.

**ES:** Las bases usan Hspec, pero el runner generado no lo conecta. La guía
y el encargo explican la adaptación del test-suite y `main-is`. El helper adapta
solo la pareja generada reconocida y conserva los manifiestos y runners propios.
En un laboratorio aislado, Hspec arrancó con cero ejemplos,
aprobó un caso y devolvió fallo con una aserción fallida.

**EN:** The references use Hspec, but the generated runner does not connect it.
The guide and scaffold request explain the test-suite and `main-is` adaptation;
the helper adapts only the recognized generated pair and preserves authored
manifests and runners. In an isolated lab, Hspec ran with zero examples, passed
one case, and returned failure for a failing assertion.

**ES:** `glot test` comprueba cada resumen Hspec, rechaza suites vacías,
pendientes o no reconocidas y conserva la comprobación de módulos declarados.
Las dos bases homologadas pasaron en copias aisladas; también se verificó un
proyecto con dos suites. No sincroniza manifiestos automáticamente.

**EN:** `glot test` checks each Hspec summary, rejects empty, pending or
unrecognized suites, and retains the declared-module check. Both homologated
references passed in isolated copies; a two-suite project was also verified.
It does not synchronize manifests automatically.

**ES:** `glot sync-build library|test Nombre.Modulo` permite declarar un
helper interno por ejecución en la plantilla Cabal reconocida, con plan `-n`
y reruns idempotentes. No infiere targets, exports ni conexiones al runner;
las configuraciones distintas se conservan y requieren revisión. La
sincronización para otros manifiestos y lenguajes sigue pendiente.

**EN:** `glot sync-build library|test Module.Name` declares one internal
helper per invocation in the recognized Cabal template, with `-n` preview and
idempotent reruns. It does not infer targets, exports or runner connections;
other configurations are preserved for review. Synchronization for other
manifests and languages remains pending.

**ES:** El runner Swift ejecuta ahora `swift test` sin `--skip-build`. La
regresión parte de un paquete nuevo sin `.build`, para comprobar compilación y
ejecución en un checkout limpio.

**EN:** The Swift runner now uses `swift test` without `--skip-build`. Its
regression starts from a new package with no `.build` directory, verifying
compilation and execution from a clean checkout.

```text
glot tests: 1804 passed, 0 failed
cabal test .:tests --offline --ghc-options=-Werror=missing-home-modules: passed
Haskell native scaffold/sync-build lab: passed
Integrated scaffold lab (clean Swift + Haskell sync): 230 passed, 0 failed
docs checks: 30 passed, 2 failed (known command drift and indented blocks)
git diff --check
```

## 2.1.0-dev — 2026-11-23 (andamiaje C# / C# scaffold)

**ES:** `scaffold` copia la plantilla `.gitignore` de C# solo si falta y
conserva archivos existentes. La plantilla excluye artefactos .NET medidos en
las bases homologadas, incluidos `bin/` y `obj/`. El harness verifica dry-run,
rerun, preservación y `git check-ignore`. `scaffold` también retira `Class1.cs`
y `UnitTest1.cs` solo si coinciden con las muestras medidas de .NET 10 tras
normalizar BOM/CRLF; preserva archivos editados y bloquea symlinks. En un
proyecto temporal con .NET 10.0.115, la secuencia del catálogo agregó la
referencia del test a producción; un test que importó un tipo de producción
pasó. `glot -n new` y `glot -n scaffold` mostraron los pasos esperados.

**EN:** `scaffold` copies the C# `.gitignore` template only when missing and
preserves existing files. The template excludes .NET artifacts measured in
the homologated modules, including `bin/` and `obj/`. The harness checks
dry-run, rerun, preservation and `git check-ignore`. `scaffold` also removes
`Class1.cs` and `UnitTest1.cs` only when they match the measured .NET 10
samples after BOM/CRLF normalization; edited files are preserved and symlinks
are blocked. In a temporary .NET 10.0.115 project, the catalogue sequence
added the test-to-production reference; a test importing a production type
passed. `glot -n new` and `glot -n scaffold` showed the expected steps.

```text
Integrated scaffold lab: 238 passed, 0 failed
Focused C# scaffold regressions: 14 passed, 0 failed
dotnet test Sample.slnx: 1 passed, 0 failed
git diff --check
```

## 2.1.0-dev — 2026-11-23 (scaffold Zig / Zig scaffold)

**ES:** `zig init` 0.17.1 genera `src/main.zig`, que también es la raíz del
test target en su `build.zig`: retirarlo antes de adaptar el target hace fallar
`zig build test` (`unable to load "main.zig"`). `scaffold` deja de borrarlo,
añade `.gitignore` con las cachés y salidas Zig, y avisa que `build.zig` y la
suite deben adaptarse antes de retirar el `main`. El laboratorio integrado
ejecutó `zig build test --summary all` (3/3 tests) y `zig build` después del
scaffold.

**EN:** `zig init` 0.17.1 generates `src/main.zig`, which is also the test
target's root in its `build.zig`; removing it before adapting that target makes
`zig build test` fail (`unable to load "main.zig"`). `scaffold` no longer
deletes it, adds `.gitignore` for Zig caches and outputs, and warns that
`build.zig` and the suite must be adapted before removing `main`. The isolated
lab ran `zig build test --summary all` (3/3 tests) and `zig build` after
scaffolding.

```text
Focused C# + Zig scaffold regressions: 24 passed, 0 failed
Zig 0.17.1 scaffold integration: 3/3 tests passed; build passed
```

## 2.1.0-dev — 2026-11-23 (renombrado Common Lisp / Common Lisp rename)

**ES:** `cl-project` genera `src/main.lisp` y `tests/main.lisp`. El scaffold
ahora los mueve a los nombres del módulo solo cuando los destinos están libres;
si ya existen los destinos, conserva ambos archivos y falla explícitamente.
Los reruns conservan fuentes renombradas y `run-tests.lisp` propio. Medido con
Roswell 19.08.10, Quicklisp y `cl-project` ya disponibles localmente.

**EN:** `cl-project` generates `src/main.lisp` and `tests/main.lisp`. Scaffold
now moves them to module-named files only when destinations are free; if a
destination already exists, it preserves both files and fails explicitly.
Reruns preserve renamed sources and an authored `run-tests.lisp`. Measured
with Roswell 19.08.10, Quicklisp and `cl-project` already available locally.

```text
Focused C# + Zig + Common Lisp scaffold regressions: 35 passed, 0 failed
Common Lisp scaffold integration: rename, rerun and conflict preservation passed
```

## 2.1.0-dev — 2026-11-02 (rutas y perfiles / routes and profiles)

**ES:** Tres rutas explícitas, perfiles independientes del modelo, Sonnet para
suite e implementación, Terra 5.6 para contrato/build, Flash conservado en AGY
y como base nativa. OpenRouter conserva Qwen y sustituye su alternativa Flash
por Argon. Overrides autorizados por ruta/encargo y esfuerzos verificados;
Qwen Plus omite effort y rechaza su selección explícita. AGY deep no tiene
modelo no-thinking verificado y Argon pendiente permanece declarado.

**EN:** Explicit AGY/native Copilot/OpenRouter routes, profile metadata and
request-restricted adapters. Defaults and overrides match the agreed model
split; unavailable AGY bindings block instead of silently falling back.

**ES / EN:** `ask` y `validate` comparten resolutor, preferencias independientes
y aislamiento del entorno. El validador por defecto conserva solo lectura;
AI credits no se aplican a BYOK. Ayuda, completado bash/zsh, instalación,
catálogos y doctor acompañan el cambio. / Shared resolution, independent
preferences, provider isolation and read-only default validation are wired
through CLI surfaces.

Validación ejecutada / Executed validation:

```text
bash -n scripts/glot.sh scripts/completions/glot.bash scripts/tests/glot_test.sh
zsh -n scripts/completions/glot.zsh
env GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all ./scripts/tests/glot_test.sh
glot tests: 1282 passed, 0 failed
bash docs/tests/docs_check.sh
docs checks: 25 passed, 0 failed
git diff --check
```

**ES:** También se ejecutó el completado zsh con funciones de presentación de
prueba: validate ofrece lenguaje, ask cuenta correctamente los valores de
opción y OpenRouter ofrece sus cuatro alias. No se ejecutó inferencia, no se
consultaron credenciales ni se modificaron submódulos. **No cierra la versión**:
la revisión y corrección restante de los 47 scaffolds sigue pendiente.

**EN:** Zsh completion was also exercised with presentation stubs. No paid
inference, credential access or submodule changes occurred. **The release
remains open** pending the remaining 47-language scaffold review/corrections.

## 2.1.0-dev — 2026-11-02 (primer bloque / first block)

**ES:** Commit documental de preparación: `2469c90`. Antes de editar código
se archivó v2.0.3 y se comprobó su igualdad con la fuente de ese commit.
Se implementó el primer bloque de scaffold:

- Ballerina: renombrado protegido, retirada solo del ejemplo idéntico a la
  plantilla verificada y archivo vacío `tests/lib_test.bal`.
- Perl: fuente bajo `lib/`, coherente con el verificador, sin truncar contenido.
- Rust: conservación de `src/lib.rs`, el punto de entrada predeterminado de Cargo.
- Protección de `.gitignore` frente a symlinks/directorios y creación sin
  truncamiento; no se modifica una instancia regular existente en el paso final.

**EN:** Preparation documentation was committed as `2469c90`; v2.0.3 was
archived and equality checked before code edits. The first scaffold block adds
safe Ballerina adaptations, missing-only Perl sources under lib, preserved Rust
crate entry points and protected ignore-file creation.

**ES:** Verificación real del bloque:

```text
bash -n scripts/glot.sh scripts/tests/glot_test.sh scripts/versions/glot_2.0.3.sh
# sin salida, código 0 / no output, exit 0

env GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all ./scripts/tests/glot_test.sh
glot tests: 1255 passed, 0 failed

bash docs/tests/docs_check.sh
docs checks: 25 passed, 0 failed

git diff --check
# sin salida, código 0 / no output, exit 0
```

**ES:** Se verificaron también los tres scaffolds en un laboratorio temporal
aislado y offline: Ballerina 2201.13.4 compila el fuente vacío y anuncia
`No tests found`; Cargo 1.98.1 ejecuta el test de su plantilla sin romper la
entrada de biblioteca; Perl devuelve `syntax OK` al comprobar la fuente creada.
El laboratorio se retiró y no se tocaron submódulos. El harness prueba
reruns, dry-run, contenido propio, renombrados conflictivos, fuentes ausentes,
symlinks, directorios y rutas con espacios.

**EN:** Isolated offline native checks passed for all three scaffolds; the
temporary lab was removed and no submodules changed. Harness cases cover reruns,
dry runs, authored contents, rename conflicts, missing sources, invalid paths and
spaces. Native template/empty tests do not certify academic contract coverage.

**ES:** **No cierra v2.1.0:** rutas/modelos/overrides y los otros 47 lenguajes
siguen pendientes según [`ROADMAP.md`](ROADMAP.md).

**EN:** **This does not close v2.1.0:** routes/models/overrides and the remaining
47 languages are still pending.

---

## 2.0.3 — 2026-10-26 (verificada / verified)

**ES:** Hotfix de la secuencia 4a/4c/4d: `glot scaffold` prepara los artefactos
repetibles conocidos, garantiza `.gitignore` sin truncar contenido, copia los
Makefiles compartidos declarados solo si faltan y muestra `glot prompt scaffold`
cuando queda análisis idiomático. Assembly, C y COBOL reciben además una nota para
completar el runner vacío y los patrones del ignore; Grain y R automatizan sus
Makefiles. El delegate de suite conecta casos al runner ya preparado; `build`
solo atiende bloqueos no previstos, conserva la suite y exige reejecutar `glot test`.

**EN:** Hotfix for steps 4a/4c/4d: `glot scaffold` prepares known repeatable
artifacts, ensures `.gitignore` without truncating contents, copies declared
shared Makefiles only when missing, and prints `glot prompt scaffold` when
idiomatic analysis remains. Assembly, C and COBOL also flag the empty runner and
ignore patterns for delegate completion; Grain and R automate their Makefiles.
The suite delegate connects cases to the prepared runner; `build` handles only
unpredicted blockers, preserves the suite, and calls for rerunning `glot test`.

**ES:** Verificación real con repositorios y estado aislados:

**EN:** Actual verification with isolated repositories and state:

```text
bash -n scripts/glot.sh scripts/tests/glot_test.sh scripts/versions/glot_2.0.2.sh
# sin salida, código 0 / no output, exit 0

env GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all ./scripts/tests/glot_test.sh
glot tests: 1209 passed, 0 failed

bash docs/tests/docs_check.sh
docs checks: 25 passed, 0 failed

git diff --check
# sin salida, código 0 / no output, exit 0
```

**ES:** El harness comprueba la copia de las cinco plantillas, la creación y
conservación de `.gitignore`, el ensayo sin mutaciones y una raíz con espacios.
No certifica los cinco toolchains nativos ni ejecuta scaffold sobre los módulos
reales del autor.

**EN:** The harness checks copying all five templates, creating and preserving
`.gitignore`, non-mutating dry runs, and a root containing spaces. It does not
certify all five native toolchains or run scaffold on the author's real modules.

---

## 2.0.2 — 2026-10-23 (verificada; lista para cierre / verified; ready for closure)

**ES:** Los once encargos reciben una sola copia de
[`Delegation_Policy.md`](../prompts/Delegation_Policy.md): bases del mismo lenguaje
en orden persistente `data_structures_basics` → `numbers`, con selección de
patrones por tema y aspecto, nunca como moldes ni sustitutos del contrato.
Se distingue agrupación lógica de archivos físicos: suite agregada o separada
según framework, casos por operación/contrato y variantes aplicables, escenarios
con sus pasos, aislamiento y runner que agrega todos los grupos. No se trasladan
las carpetas o el runner de Ada a otros lenguajes.

**EN:** All eleven requests receive shared policy once: persistent same-language
reference priority, with topic- and aspect-aware patterns rather than templates
or contract replacements. Logical groups are distinct from physical files:
aggregate or split suites according to the framework, operation/contract and
variant-specific cases, scenario steps, isolation and complete runner aggregation.
Ada directories and runner are not imposed on other languages.

**ES:** El constructor entrega también las fuentes declaradas para lectura.
Política ausente, vacía o ilegible bloquea con `1` sin encargo parcial; sus
marcadores se comprueban como los del cuerpo. Se conserva en la instalación y
su huella detecta cambios. `4c` integra el runner; `4d` configura construcción y
enlace sin reescribirlo; `4e` corrige el artefacto indicado, incluido runner o
construcción. `save 4e` retira la causa después del commit; `save 4d` no consume
una causa pendiente. Modelos, esfuerzos, créditos y proveedores no cambian.

**EN:** The builder also delivers declared sources for reading. Missing, empty
or unreadable policy fails with `1` without a partial request; its placeholders
are checked alongside the body. Installation preserves it and fingerprints detect
changes. Suite authoring integrates the runner; build configures construction and
linking without rewriting it; correction repairs the selected artefact, including
runner or build. Correction consumes the cause after committing; build leaves a
pending cause intact. Models, effort, credits and providers remain unchanged.

**ES:** Verificación real, con estado, repositorios y delegados simulados aislados:

**EN:** Actual verification with isolated state, repositories and fake delegates:

```text
bash -n scripts/glot.sh scripts/tests/glot_test.sh scripts/versions/glot_2.0.1.sh
# sin salida, código 0 / no output, exit 0

env GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all ./scripts/tests/glot_test.sh
glot tests: 1179 passed, 0 failed

bash docs/tests/docs_check.sh
docs checks: 25 passed, 0 failed

git diff --check
# sin salida, código 0 / no output, exit 0
```

**ES:** La configuración de Git solo permite al proceso de pruebas usar sus
remotos bare temporales; no modifica la configuración del autor. El harness
comprueba los once encargos y su entrega íntegra a delegados simulados, el
validador, rutas desde submódulo y copia instalada, ausencia y vaciado de política,
marcadores inválidos, agrupación declarada y limpieza de causa. La lectura
comparativa de AUnit (Ada), descubrimiento automático (Go) y runner procedural
(COBOL) comprobó que la política admite sus agrupaciones; no certifica sus
implementaciones ni sustituye una evaluación futura del agente. No se ejecutaron
delegados reales ni se alteraron submódulos o el roadmap del monorepo.

**EN:** Git configuration only permits the test process to use its temporary
bare remotes; author configuration is unchanged. The harness covers requests and
complete delivery to fake delegates, validation, submodule and installed paths,
missing/empty policy, invalid placeholders, stated grouping and cause cleanup.
Read-only comparison of AUnit, automatic discovery and a procedural runner checked
that policy allows their grouping; this neither certifies their implementations
nor replaces future agent evaluation. No real delegates ran; submodules and the
monorepo roadmap were untouched.

**ES:** La base `2.0.1` se archivó antes de editar; el plan temporal se retiró.
Esta entrega queda verificada para revisión y cierre del autor, sin commit ni push
del agente. No se declara cerrado ningún módulo del monorepo.

**EN:** The previous baseline was archived before editing and the temporary plan
removed. This release is verified for author review and closure, without agent
commit or push. No monorepo module is declared closed.

---

## 0.1.0 — 2026-09-20 (cerrada)

- **Añade:** `echo "Hello World! from Bash!"`, el equivalente del `helloworld` de los lenguajes aplicado al tooling del repositorio.
- **Cómo se usaba:** `./scripts/glot.sh`.
- **Snapshot:** [`versions/glot_0.1.0.sh`](../versions/glot_0.1.0.sh), archivado al abrir la v0.2.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real → `Hello World! from Bash!`, código de salida `0`.

## 0.2.0 — 2026-09-20 (cerrada)

- **Añade:** el nombre llega como argumento (`./scripts/glot.sh Ada`) o por la entrada estándar; si no llega por ninguna de las dos vías, el script pregunta `Enter your name: ` y lee con `read -r`.
- **Equivalencia:** es el `hellouser` del tooling (especificación `02_Hello_User`): pide el nombre, lo guarda en una variable y saluda.
- **Snapshot:** [`versions/glot_0.2.0.sh`](../versions/glot_0.2.0.sh), archivado al abrir la v0.3.0.
- **Verificación:** `bash -n scripts/glot.sh` (sin salida) y ejecución real de las tres vías → `Hello, Ada!` (`rc=0`), `Enter your name: Hello, Ada!` (`rc=0`) y `Hello, Grace Hopper!` con entrada `printf 'Grace Hopper\r\n'`.
- **Notas:** `read -r` evita que se interpreten las barras invertidas; `${name%$'\r'}` descarta el terminador CRLF, igual que los módulos `hellouser` de los lenguajes; con entrada vacía (EOF) imprime `Enter your name: Hello, !` y devuelve `0`, sin abortar pese a `set -e`.

## 0.3.0 — 2026-09-20 (cerrada)

- **Añade:** el contrato L0 y el dispatcher de verbos: `version`, `help [verbo]`, `doctor` y `greet [nombre]`, con `stdout` = datos, `stderr` = diagnóstico y códigos `0/1/2`; y el harness [`tests/glot_test.sh`](../tests/glot_test.sh) (39 comprobaciones, sin dependencias).
- **Sin rutas del usuario:** el script se localiza con `BASH_SOURCE` y resuelve la raíz con `GLOT_ROOT` → superproyecto → raíz git; la documentación usa variables en lugar de rutas fijas.
- **Cambios respecto a v0.2.0:** se retira el prompt interactivo (los verbos nunca preguntan: el dato llega por argumento o stdin) y un primer argumento que no es verbo ya no se interpreta como nombre: devuelve `2` con la sugerencia `glot greet <nombre>`. El saludo de v0.2.0 se conserva como verbo `hello`, que se retira en v1.0.0.
- **Verificación:** `bash -n` limpio en `glot.sh`, el harness y el snapshot; `./scripts/tests/glot_test.sh` → `glot tests: 39 passed, 0 failed` (rc `0`); `doctor` dentro del monorepo rc `0` y fuera rc `1` con `root: (no detectado / not detected)`.
- **Documentación:** recorrido interno del script, con la lectura de argumentos, la tabla de despacho, qué lee y decide cada verbo y los detalles no evidentes (`-t 0`, `read -r`, CRLF, resolución de la raíz).
- **Snapshot:** [`versions/glot_0.3.0.sh`](../versions/glot_0.3.0.sh), archivado al abrir la v0.4.0.
- **Notas:** al pasar a v0.4.0 se ajustó un detalle del contrato: las confirmaciones de `set`/`unset` van a `stderr` (antes se mezclaban con el dato en stdout de los verbos de estado) y se estrenó el código `3` para el estado ilegible.

## 0.4.0 — 2026-09-21 (cerrada)

- **Añade:** el **almacén de estado** (L1) con `set`, `get`, `unset`, `list` y `path`; escritura atómica (`mktemp` + `mv -f`) bajo `flock`, permisos `600` del fichero y `700` del directorio, `-n/--dry-run` en los verbos que mutan, y `doctor` ampliado con `state_dir`, `state_file` y `state_file_ok`.
- **Contrato:** se estrena el código `3` (estado ilegible o no escribible) y se documenta el formato `clave=valor` con clave `[A-Za-z0-9_.-]` y valor sin saltos de línea.
- **Sin rutas del usuario:** el estado se resuelve con `GLOT_STATE_DIR` → `XDG_STATE_HOME` → `~/.local/state/glot`, y `GLOT_STATE_FILE` gana a todo; el harness se aísla con esa variable.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 71 passed, 0 failed` (rc `0`); `get` de clave ausente → `1`; clave inválida y valor con salto de línea → `2`; `unset` repetido → `0`; `-n set lang lua` imprime `lang=lua` y no escribe; `stat -c '%a'` → `600` el fichero y `700` el directorio.
- **Snapshot:** [`versions/glot_0.4.0.sh`](../versions/glot_0.4.0.sh), archivado al abrir la v0.5.0.

## 0.5.0 — 2026-09-22 (cerrada)

- **Añade:** la **asignación** (L2) con `use <lenguaje> <fase>/<módulo> [tipo]`, que **sitúa el trabajo**: valida lenguaje, fase, módulo, tipo y árbol **sin tocar nada**, resuelve la especificación `docs/core/{fase}/{NN}_{Nombre}.md` y después **lee el estado y nunca lo fuerza**. Reconoce cuatro estados: **nuevo** (no existe la carpeta) → crea la rama desde `main`, la publica con `push -u origin` y crea la carpeta vacía; **en curso y limpio** (la rama ya existe) → la activa y la publica; **reanudar** (trabajo sin confirmar dentro del módulo) → no crea ni cambia nada y solo informa, republicando si ya estás en la rama; **cerrado** (limpio sobre `main` y sin rama) → con `tipo` explícito abre la rama de mantenimiento desde `main`; sin él avisa y sugiere. En todos los casos escribe las seis claves del sprint (`lang`, `phase`, `module`, `branch`, `spec`, `repo`) e imprime la ruta absoluta del módulo en stdout.
- **Contrato:** `2` para uso incorrecto (argumentos, tipo no permitido, opción desconocida), `1` para entorno o dato ausente (lenguaje fuera de `.gitmodules`, especificación ausente, submódulo sin inicializar, cambios sin confirmar **fuera** del directorio del módulo, rama no creable o no publicable) y `3` si el estado no se puede escribir (avisando de que el módulo y la rama ya quedaron preparados). No hace commits, ni `git add`, ni esqueleto, ni toca el monorepo.
- **Estados del sprint:** el directorio del módulo **no** cuenta como suciedad ajena; dentro de él, un árbol sucio es el estado normal de un sprint a medias (fin de jornada, corte de luz, implementación incompleta). Por eso **con trabajo sin confirmar `use` nunca crea ni cambia de rama**: reanudar es su caso principal, no un error. Reanudar sobre la rama del módulo republica con `-u` lo que quedó local (el `push` no toca el árbol de trabajo).
- **`tipo`:** por defecto `feat`, que es el de la rama propia del módulo. Por eso, con el módulo **ya cerrado**, hay que indicarlo: así no se resucita una rama `feat` fantasma. Con el módulo **nuevo** el valor por defecto se aplica sin preguntar.
- **`-n/--dry-run`:** imprime el plan completo sin tocar el repositorio ni el estado: la rama desde `main`, el `push -u` y la creación de la carpeta para un módulo nuevo; la activación y el `push -u` para un módulo en curso; nada para un reanudar; y la rama de mantenimiento para un módulo cerrado con `tipo`.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 158 passed, 0 failed` (rc `0`), con un sandbox de git propio (monorepo falso con `.gitmodules`, especificación y un submódulo `php` con remoto desnudo) para que `use` cree la rama desde `main`, la publique con upstream y genere la carpeta en un módulo nuevo, active una rama existente, abra una de mantenimiento en un módulo cerrado y respete el trabajo sin confirmar, sin salir del directorio temporal ni tocar la red. Ensayo real sobre el monorepo: `./scripts/glot.sh -n use php algorithms/naive_sort` → aviso de módulo existente, activación de `feat/algorithms/naive-sort` y estado intacto; `./scripts/glot.sh -n use php algorithms/naive_sort test` → plan de la rama de mantenimiento `test/algorithms/naive-sort` desde `main`.
- **Snapshot:** [`versions/glot_0.5.0.sh`](../versions/glot_0.5.0.sh), archivado al abrir la v0.6.0; su contenido es el que tenía `main` en el cierre de la versión.

## 0.6.0 — 2026-09-22 (cerrada)

- **Añade:** el **catálogo** (L2.5) con `langs`, `modules`, `progress` y `completion`, más el **conversor de nombres**: de un id canónico (`data_structures`) salen el nombre legible, el del documento, la rama, el nombre del commit y la carpeta.
- **Fuentes:** `.gitmodules` (lenguajes, el denominador), el bloque de contadores de `docs/ROADMAP.md` (módulos y estado, la fuente de verdad), `docs/core/{fase}/` (especificaciones, con el prefijo `NN` leído del disco) y [`data/languages.tsv`](../data/languages.tsv) (comandos nativos por lenguaje, con test de deriva contra la guía de inicialización).
- **Nombres legacy:** `hello_world` → carpeta `helloworld` (en 49 lenguajes; Ada usa el id tal cual) y `hello_user` → `hellouser`; `unit_test` → carpeta `unit_test/calculator` y documento `03_Unit_Test_Calculator.md`. Se resuelven sondeando el disco, no con una tabla completa, y la comparación del documento no distingue mayúsculas (`etl_basico` encuentra `14_ETL_Basico.md`).
- **Corrige:** `use` ya no falla con los módulos cuyo nombre de carpeta o de documento no sigue el id del roadmap (`foundations/helloworld` y `foundations/unit_test` devolvían `1` con 158 comprobaciones en verde). El fixture del harness incluye ahora una fase con nombres divergentes, que es justo por lo que el fallo no se veía.
- **Robustez:** `doctor` comprueba `flock`, `mktemp`, `sort`, `awk` y `cat`, la cobertura del catálogo de datos, los dos guiones de autocompletado y la lectura del roadmap; el estado ya no se inventa una ruta si no hay `HOME` ni `XDG_STATE_HOME` (mensaje propio en vez de abortar por `set -u`).
- **Autocompletado:** `completions/glot.bash` y `completions/glot.zsh`, con completado **dinámico** de lenguajes, fases y módulos preguntando al catálogo. Se imprimen con `glot completion <shell>`; **no** se instalan (eso es `install`, v1.0.0).
- **Contrato:** `langs` devuelve `lenguaje<TAB>prueba nativa`; `modules` devuelve `id<TAB>fase<TAB>módulo<TAB>especificación`; `progress` devuelve `clave=valor` sin fase y TSV con fase. Los estados del roadmap se traducen a `done`/`in_progress`/`planned`/`pending`: ASCII, sin emoji en la salida.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 227 passed, 0 failed` (rc `0`); incluye la deriva guía ↔ `data/languages.tsv`, la resolución de los nombres divergentes en el sandbox, el autocompletado de bash de punta a punta y, cuando `zsh` está instalado, su sintaxis y su `compdef` (verificado con `zsh 5.9.2`).
- **Snapshot:** [`versions/glot_0.6.0.sh`](../versions/glot_0.6.0.sh), archivado al abrir la v0.7.0; su contenido es el que tenía `main` en el cierre de la versión.

## 0.7.0 — 2026-09-22 (cerrada)

- **Añade:** la **ejecución** (L3) con `test` (suite del módulo asignado, con el comando nativo del lenguaje) y `verify` (sintaxis/formato), los dos desde cualquier directorio: el objetivo se resuelve con los argumentos y, lo que falte, con el estado del sprint (`lang`, `phase`, `module`).
- **Contrato:** se estrena el código `4` (**verificación fallida**), para que un CI distinga «no pude ejecutar» (`1`) de «ejecuté y está en rojo» (`4`). `-n/--dry-run` imprime el plan (`cd <módulo> && <comando>`) sin ejecutar nada, también aquí.
- **Marcadores de la tabla de comandos:** `{modulo}` → id (`naive_sort`), `{Modulo}` → PascalCase (`NaiveSort`) y `{suite}` → archivo de suite, que se deduce del propio patrón (prefijo y sufijo del token, buscados en el directorio efectivo del comando) y exige una única coincidencia: cero o varias son un error, nunca una elección silenciosa.
- **Corrige la tabla de comandos:** nueve filas no eran ejecutables como estaban. `ada` apuntaba a `tests` (el directorio real es `test`), `kotlin` usaba un envoltorio que no existe, `scala` necesita `-batch -no-colors` para no quedarse esperando, `prolog` y `tcl-tk` requieren `cd test` (tcl-tk además `TCLLIBPATH`), `vala` necesita `--pkg glib-2.0` y ejecutar el binario, `scheme` usa `--no-auto-compile` con la suite de Guile, `common-lisp` necesita el `--eval '(uiop:quit)'` y `nim` va con `nimble test`. Se corrigen en la guía de inicialización y en el catálogo, con lo que documentan y ejecutan los módulos.
- **Columna nueva `verify`:** 14 de los 50 lenguajes tienen verificador **verificado** (crystal, dart, elixir, go, julia, nim, perl, php, python, r, ruby, rust, v, zig). El resto imprime `skipped` y `doctor` informa de la cobertura: `verify_commands: 14 de / of 50`.
- **Hallazgo declarado:** el verificador encuentra hallazgos de formato **preexistentes** en tres módulos ya homologados (V, Rust y Crystal). No se tocan en esta versión: quedan visibles como deuda.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 258 passed, 0 failed` (rc `0`). Ejecuciones reales sobre el monorepo: `test` en `php` (`OK (3 tests, 21 assertions)`), `prolog` (3 subtests passed), `vala` (`ok 1..3`) y `tcl-tk` (`Total 21 Passed 21 Failed 0`) → rc `0`; `verify php` → `No syntax errors detected` rc `0`; `verify v` y `verify rust` → rc `4` con los hallazgos preexistentes; `verify ada` → `skipped` rc `0`.
- **Snapshot:** [`versions/glot_0.7.0.sh`](../versions/glot_0.7.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.8.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

## 0.8.0 — 2026-09-22 (cerrada)

- **Añade:** la **delegación** (L4) con `prompt` (sin argumentos lista el registro; con encargo imprime la cabecera del estado del sprint y la plantilla expandida) y `ask` (el mismo encargo, enviado a `GLOT_DELEGATE` por stdin). Ninguno de los dos ejecuta el trabajo ni escribe en el repositorio.
- **Plantillas versionadas:** cuatro encargos en `scripts/prompts/` — `scaffold` (paso 4), `implement` (5), `docs-module` (7) y `docs-language` (8) — normalizados y versionados junto al tooling. El registro no está codificado: `glot prompt` recorre `*.prompt.md` y lee `name`, `step` y `description` del frontmatter, así que añadir un encargo es añadir un archivo.
- **Un solo vocabulario de marcadores**, anclado a las claves del estado: `{lang}`, `{phase}`, `{module}`, `{Module}`, `{repo}`, `{branch}`, `{spec}`, `{suite}` y `{module_dir}`. Se renombran en la guía de inicialización y en el catálogo de datos (`{modulo}`/`{Modulo}` → `{module}`/`{Module}`, 110 ocurrencias).
- **Contrato:** un marcador sin resolver es un error `1` que lo nombra, nunca texto literal; `prompt` no necesita `-n` (imprimir es su función) y `ask -n` imprime el plan; sin `GLOT_DELEGATE`, `ask` devuelve `1`; un delegado que falla devuelve `1`, no `4`.
- **`doctor`:** informa de la carpeta de plantillas, del número de encargos y de si hay delegado configurado.
- **Corrige:** la clave reservada `repo` se documentaba como «ruta del submódulo dentro del monorepo» cuando `use` guarda el **nombre** del submódulo; la tabla del contrato ya dice lo que hace el código.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 286 passed, 0 failed` (rc `0`). Reproducción real: `glot prompt` → 4 encargos con su paso; `glot prompt scaffold php algorithms/naive_sort` → cabecera con `spec` y `module_dir` y plantilla sin frontmatter y sin marcadores; `GLOT_DELEGATE='wc -l' glot ask implement php algorithms/naive_sort` → el encargo completo (115 líneas) por stdin, rc `0`; sin delegado → rc `1`; delegado que falla → rc `1`.
- **Snapshot:** [`versions/glot_0.8.0.sh`](../versions/glot_0.8.0.sh), archivado **antes** de fusionar la rama en `main` y antes de abrir la v0.9.0, para que la puerta de entrada no bloquee el arranque de la siguiente versión.

## 0.9.0 — 2026-09-22 (cerrada)

- **Añade:** la **creación y el registro** (L5) con `new` (inicializador del lenguaje y esqueleto mecánico del módulo) y `save` (commit guiado con la convención del repositorio), los dos verbos que hasta la v0.8.0 se hacían a mano.
- **`new` tiene dos modos, decididos por dato:** con `tool` ejecuta el inicializador del lenguaje en el directorio del módulo; con `manual` crea las carpetas del esqueleto; con `deferred` no ejecuta nada, informa, remite al encargo `scaffold` e imprime `skipped` (como `verify` sin verificador). No escribe la suite: eso es el encargo `suite` (paso 4b).
- **Tabla de inicialización ampliada** en [`data/languages.tsv`](../data/languages.tsv): de 5 a 8 columnas, con el **tipo** (columna 6, la leyenda ✅/🔧/✍️ de la guía recuperada como dato), el **comando** (7) y la **normalización** (8). Resultado: **22 lenguajes con herramienta**, **21 de estructura manual** y **7 aplazados** al agente.
- **Normalización declarada, no adivinada:** `flat:<sub>` sube el contenido del proyecto hijo (los inicializadores que anidan, como `crystal init lib` o `dart create`) y `rm:<ruta>` limpia. `crystal` y `gleam` crean además un `.git` propio: se borra **antes** de aplanar, porque un repositorio dentro de un submódulo no es válido. Un lenguaje sin operación declarada no se toca.
- **Tabla paso → mensaje, en datos:** [`data/commits.tsv`](../data/commits.tsv) (`paso`, `alias`, `ámbito`, `mensaje`). `save` acepta el paso (`4a`, `4b`, `5`, `7`, `8`) o el nombre del encargo (`scaffold`, `suite`, `implement`, `docs-module`, `docs-language`). Los pasos del monorepo (puntero y roadmap) se rechazan con `1` y remiten a `close` (v0.10.0) y `pointer` (v0.12.0).
- **Encargo nuevo:** `suite` (paso 4b) con el contrato de pruebas unitarias, que estaba dentro de `scaffold`. El paso 4 del sprint se parte en **4a** (esqueleto, `glot new` + `glot prompt scaffold`) y **4b** (suite, `glot prompt suite`), con dos commits: `chore({phase}): add scaffold for {module}` y `chore({phase}): add suite for {module}`.
- **Contrato:** `new` devuelve `4` si el inicializador falla y `0` con `skipped` si el esqueleto está aplazado; `save` devuelve el **SHA corto** por stdout o `nothing` si no hay nada que confirmar, **nunca hace push** y solo confirma en el submódulo. Los dos respetan `-n/--dry-run`, obligatorio por mutar.
- **Hallazgos que no bloquean, nombrados antes de confirmar:** cambios fuera del módulo (que entran igual, porque `add -A` es del submódulo) y una rama activa que no es la del estado del sprint.
- **`doctor`:** informa de la cobertura de inicializadores (`new_commands: 43 de / of 50 (deferred: 7)`) y del catálogo de commits (`commit_steps: 7 de / of which 5 son del submódulo`).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 361 passed, 0 failed` (rc `0`), con la **deriva** entre `data/commits.tsv` y la tabla del sprint, la coherencia del catálogo de inicialización (tipos válidos, comando obligatorio salvo en `deferred`, operaciones conocidas), el ciclo completo `use` → `new` → `save` en el sandbox sobre `ruby` (manual) y `python` (deferred), y la **genericidad de las plantillas** (ninguna lleva casos ni nombres de un módulo concreto).
- **Snapshot:** [`versions/glot_0.9.0.sh`](../versions/glot_0.9.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

## 0.10.0 — 2026-09-22 (cerrada)

- **Añade:** la **evidencia y el cierre** (L6) completos: `evidence`, `close` y `validate`.
- **En detalle:**
  - **`validate`:** pasa el encargo `validate` (paso 6, **versionado** en `prompts/validate.prompt.md`) al validador automático y guarda su informe en `docs/evidence/{fase}/{módulo}/{lenguaje}.validate.md`. La orden sale de `GLOT_VALIDATOR` y, sin ella, de la invocación verificada de Copilot CLI en solo lectura; el **veredicto se lee** de la línea que la plantilla exige (`glot:validate verdict=clean|findings findings=N`) y no se adivina. Es **opcional**: sin validador avisa y devuelve `1`.
  - **`close`:** registra el cierre de un módulo en un lenguaje. Exige el acta de `evidence` **en verde** y los README del módulo y de la fase; escribe la entrada del checklist con los comandos y sus códigos leídos del acta, y sube el contador y la lista del roadmap con el nombre de presentación (`data/display.tsv` fija el nombre y el orden). Es idempotente, enseña el diff exacto con `-n` y **no confirma**.
  - **`evidence`:** ejecuta la suite y el verificador del módulo y deja el **acta** con la salida real en `docs/evidence/{fase}/{módulo}/{lenguaje}.md` —fecha, rama, commit del submódulo, árbol sucio o limpio, los comandos, su salida tal cual y sus códigos—, más un bloque de máquina que `close` leerá sin interpretar markdown. La escribe **también cuando algo está en rojo**, y entonces devuelve `4`.
  - **Retira** el verbo `hello` (alias de compatibilidad de la v0.2.0), que el contrato situaba en la v1.0.0: devuelve `2` como cualquier verbo desconocido. El aviso de verbo desconocido ya solo sugiere `glot help`.
  - **El objetivo se resuelve por directorio:** `test`, `verify`, `new` y `save` deducen el lenguaje del directorio cuando no lo traen ni los argumentos ni el estado del sprint, así que `cd php && glot test algorithms/naive_sort` funciona sin `use` previo. El estado manda sobre el directorio a propósito.
  - **El harness cierra el círculo del archivado:** toda versión marcada como cerrada en este log tiene que tener su snapshot, y ningún snapshot puede sobrar.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 477 passed, 0 failed` (rc `0`), incluida la **puerta de entrada del archivado** en las dos direcciones: 10 versiones cerradas en el log y 10 snapshots en `versions/`.
- **Snapshot:** [`versions/glot_0.10.0.sh`](../versions/glot_0.10.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.
- **Lo que deja abierto:** `pointer` y `status` llegan con L7 (0.12.0) y el reparto de modelos por encargo con L6.5 (0.11.0), **solo con los modelos que ofrece Copilot**; la cabecera de fase del roadmap y su contador siguen esperando un formato único entre fases.

---

## 0.11.0 — 2026-09-22 (cerrada)

- **Añade:** los **perfiles de modelo por encargo** (L6.5): `model:` en el frontmatter de las seis plantillas —con el **id real** del modelo, que es clave nativa de los `.prompt.md` de VS Code— y el catálogo [`data/models.tsv`](../data/models.tsv), que fija el esfuerzo y el tope de créditos de cada perfil.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md). El modelo es la **clave del perfil** (no hay `profile:` que pueda derivar), el delegado recibe el modelo por entorno (`COPILOT_MODEL` y `COPILOT_AUTO_TIER`, que el CLI sí reconoce) y el tope de créditos del perfil económico es el **mínimo que acepta el CLI** (30).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 503 passed, 0 failed` (rc `0`), con 26 comprobaciones nuevas del catálogo, las plantillas y los códigos. Los límites del CLI (1.0.88) se midieron de verdad: `--reasoning-effort bogus` → `error: invalid value 'bogus' for '--reasoning-effort <level>' [possible values: none, minimal, low, medium, high, xhigh, max]` y `--max-ai-credits 20` → `error: Invalid value for --max-ai-credits: "20". Use at least 30 AI credits.`, que es de dónde sale el suelo de 30 del perfil económico. Los **tres perfiles se probaron contra la API real** —`copilot -C <dir temporal> -p 'Responde solo con la palabra OK.' -s --model <modelo> --reasoning-effort <esfuerzo> --max-ai-credits <créditos> --allow-all-tools --deny-tool write`— y los tres respondieron `OK` con código `0`: `gemini-3.8-flash`/`low`/30, `gpt-5.6-terra`/`medium`/90 y `claude-sonnet-5`/`high`/120.
- **Snapshot:** [`versions/glot_0.11.0.sh`](../versions/glot_0.11.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

## 0.12.0 — 2026-09-23 (cerrada)

- **Añade:** la **higiene y los punteros** (L7): `status`, `pointer` y `clean`, con el commit del monorepo en manos de `save`.
- **El puntero deja de ser manual:** `pointer` comprueba con `fetch` explícito de `origin/main` que el commit del submódulo está **integrado** —la regla de [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md) pasa de prosa a comprobación—, prepara y publica la rama `chore/{fase}/{módulo}-pointer` y deja el gitlink añadido; el commit lo hace `save 9`. Es idempotente: si el monorepo ya apunta a ese commit, imprime `nothing` y no toca ramas.
- **`status`, solo lectura:** `lang<TAB>branch<TAB>pointer<TAB>worktree`, con `pointer` en `ok`, `differs`, `uninitialised` o `unknown`. Sin resumen a propósito (los contadores son de `progress`) y filtrable por lenguaje.
- **`clean` declara su alcance:** `git clean -Xfd` en el directorio del módulo —lo que el propio `.gitignore` del lenguaje declara como artefacto, aunque parezca útil: `php` ignora `composer.lock`— más `submodule sync` del lenguaje. Nunca `-x`, nunca el monorepo y nunca `docs/`. Se declara **apoyo a los pasos 5–6**, porque no es un paso por sí mismo.
- **`save` confirma el monorepo:** los pasos `9` y `10` añaden solo sus rutas (el submódulo del puntero; roadmap, checklist y evidencia del cierre), y siguen sin hacer push.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 551 passed, 0 failed` (rc `0`), con 48 comprobaciones nuevas sobre una fixture con **submódulos reales** (gitlink, remoto y rama `main`), porque el sandbox anterior no tenía punteros que mover. Las últimas siete guardan la **ayuda por verbo** de los tres verbos nuevos, que se había quedado sin escribir.
- **Snapshot:** [`versions/glot_0.12.0.sh`](../versions/glot_0.12.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

---

## 1.0.0 — 2026-09-23 (cerrada)

- **Añade:** la **instalación y la capa cargable** (L8): `install`/`uninstall`, `glot` como función de bash y el `doctor` completo. Es la versión que cierra el objetivo original: `use` deja de necesitar `cd "$(glot use …)"`.
- **Añade además:** el **catálogo de toolchains** ([`data/toolchains.tsv`](../data/toolchains.tsv), con la serie verificada de 45 de los 50 lenguajes) que `doctor` comprueba, y los **encargos con fuentes**: cada plantilla declara sus `sources:` en el frontmatter, la cabecera del encargo lleva `root` y `glot prompt` avisa de las fuentes que falten.
- **Paga dos deudas declaradas:** el **estado por raíz** de monorepo (dos repos ya no comparten sprint) y los **encargos sin el nombre del monorepo**, con sus fuentes declaradas en el frontmatter y aviso si falta alguna.
- **Decisiones cerradas antes de codificar:** en [`ROADMAP.md`](ROADMAP.md) (copia estable, bloque del rc, bash para la capa cargable, `-n` sin `cd`, nombre y ruta del fichero de estado, `doctor`, toolchains y el ajuste de L9).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 666 passed, 0 failed` (rc `0`), 91 comprobaciones más que la v0.12.0: el estado por raíz, la instalación con `HOME` desechable, el catálogo de toolchains (con catálogo inyectado para probar `ok`, `differs`, `missing` y `unknown`), las fuentes de los encargos y las dos direcciones de `pointer`. En el **laboratorio**, con repos y remotos reales: ciclo completo del sprint en `ruby2` (4a→10, con puntero y cierre), hasta evidencia verde en `python2` (`pytest`, 24 pasados) y `php2` (`composer test`, 27 aserciones, con `new` en modo `tool`), y el **camino de fallo** en `ada2` (sin `gnat`: `test` en `4`, acta roja y `close` en `4` sin cerrar). Esa prueba encontró tres cosas, corregidas en la misma versión: `pointer` se detenía por la evidencia del propio sprint (que confirma `save 10`, después), el harness no era hermético (heredaba `GLOT_ROOT` del autor) y las plantillas nombraban el monorepo en prosa.
- **Snapshot:** [`versions/glot_1.0.0.sh`](../versions/glot_1.0.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su contenido es el que tenía `glot.sh` en el cierre, y no se edita.

---

## 1.1.0 — 2026-09-26 (cerrada)

- **Añade:** la **secuencia de inicialización como dato** ([`data/init_sequences.tsv`](../data/init_sequences.tsv), 18 lenguajes y 28 pasos): `new` ejecuta los pasos en su directorio de trabajo (`module` o `phase`), conduce los interactivos con `expect`, aplanó los que crean la carpeta y deja por escrito lo que falta por completar. La columna 7 del catálogo queda como **comando único**: un lenguaje con secuencia la deja en `-`, para no tener dos fuentes.
- **Añade además:** el **contrato con paso propio** (`4b`) y su encargo versionado [`contract_stub.prompt.md`](../prompts/contract_stub.prompt.md) (entonces `contract.prompt.md`); la suite pasa a `4c` y **consume** el contrato en vez de declararlo. Al insertar un paso **en medio**, los siguientes se recorren, y el ordinal se cambia a la vez en la tabla del sprint, el catálogo de commits y el `step:` de cada plantilla (43 comprobaciones nuevas en el harness: 666 → 709).
- **Paga deuda declarada del bloque A:** `install.meta` guarda la huella de **todo lo que viaja con la copia** (`data/`, `prompts/` y `completions/`, no solo `glot.sh`), `doctor` informa `install_data` y una copia con el catálogo viejo deja de pasar por buena; el harness se aísla de `GLOT_STATE_DIR` y `GLOT_DATA_DIR`; la sección «Secuencias de varios pasos» de la guía se compara con el dato en los dos sentidos; y `glot suite` sugiere `glot prompt suite` en vez de morir en la pista general.
- **Corrige de paso:** la guía decía que son **tres** los generadores que crean la carpeta y el dato declara **cuatro** (faltaba `common-lisp`, medido con `quickproject:make-project`), y los tres fallos que el harness arrastraba desde el split del módulo 06 (dos casos usaban el nombre antiguo `algorithms/data_structures`).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 709 passed, 0 failed` (rc `0`); `doctor` informa `new_commands: 50 de / of 50 (deferred: 0)`, `commit_steps: 8 de / of which 6 son del submódulo`, `prompts_ok: 7 encargos` y `model_profiles: 7 de / of 7`. La puerta de archivado se probó **en negativo**: moviendo el snapshot, el harness da dos fallos que nombran la versión.
- **Ciclo real medido el 2026-09-26** en un sandbox de laboratorio con remoto local (Ada, sin tocar ningún repositorio del autor): `use` (rama `feat/algorithms/data-structures-basics` creada y publicada), `new` (los dos pasos de la secuencia más la nota de completado), `prompt contract` (encargo armado, avisando de las fuentes que no existen en el sandbox), `-n save 4a` (plan del commit) y `test` → `test: alr -C tests run` … `test: en verde / green` (rc `0`). El **diff normalizado** del esqueleto contra el módulo homologado `ada/core/algorithms/naive_sort` da **nueve archivos idénticos** (`.gitignore`, `naive_sort.gpr`, `config/*` y `tests/tests.gpr` + `tests/config/*`); difieren la licencia y el `tests/alire.toml` que declara la columna de completado, más el contrato y el runner, que son contenido del sprint.
- **Snapshot:** [`versions/glot_1.1.0.sh`](../versions/glot_1.1.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.2.0 — 2026-09-27 (cerrada)

- **Añade:** los **dos delegados** de `ask` con nombre propio: `GLOT_DELEGATE_COP` (GitHub Copilot CLI) y `GLOT_DELEGATE_AGY` (Antigravity CLI), elegibles con `--delegate copilot|antigravity` (cortos `cop` y `agy`). `GLOT_DELEGATE` sigue valiendo como **alias del primero**, que es lo ya documentado. Sin argumento, con una sola variable definida se elige sola y con las dos `ask` devuelve `2` pidiendo elegir: no se adivina.
- **La orden del delegado usa los marcadores del tooling:** `{root}` y `{module_dir}` se resuelven **antes** de ejecutarla —con el módulo del **encargo**, resuelto como su cabecera, argumentos → estado—, y `ask` exporta además `GLOT_ROOT` y `GLOT_MODULE_DIR`, junto a `COPILOT_MODEL` y `COPILOT_AUTO_TIER`, para que la línea cite las rutas por variable. Un marcador sin resolver es `1` que lo nombra; los `${VAR}` del shell son legítimos y no se confunden con marcadores.
- **Lo que el autor pega, no lo que el repositorio versiona:** `install` **no** escribe la orden en el rc —lleva su ruta, su modelo y a veces un permiso—, sino que imprime al terminar las dos líneas de `export` listas para pegar, con los marcadores sin resolver (también en `-n`); `doctor` informa `delegate_cop:` y `delegate_agy:` y avisa de que `GLOT_DELEGATE` es el alias antiguo. En `scripts/` no queda ninguna ruta del `HOME` ni credencial.
- **Paga deuda declarada del bloque B (2 de las 15 entradas):** el **delegado de referencia documentado** —comando, permisos y guardas, con la medición de cada CLI en [`VALIDATION.md`](VALIDATION.md)— y **`glot` exporta `GLOT_ROOT`**, que era lo que obligaba a escribir la ruta a mano en la orden. El resto del bloque B pasa a la v1.3.0, con las correcciones del paso 4 (`4a`/`4c`) **como prioridad**.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 728 passed, 0 failed` (rc `0`), 19 comprobaciones más que la v1.1.0: la elección de delegado (una sola configurada, las dos, `--delegate` desconocido), el alias antiguo, la expansión de `{root}`/`{module_dir}` —comparada con la cabecera del propio encargo, no con una ruta escrita en el caso—, `GLOT_ROOT`/`GLOT_MODULE_DIR` vistos por el delegado, el marcador sin resolver y las dos líneas que imprime `install`. El harness se ejecutó además con las variables del laboratorio exportadas (`GLOT_ROOT`, `GLOT_STATE_DIR` y los dos delegados) y sigue en verde: el aislamiento no depende del entorno del autor.
- **Snapshot:** [`versions/glot_1.2.0.sh`](../versions/glot_1.2.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.3.0 — 2026-09-27 (cerrada)

- **Añade las correcciones del paso 4:**
  - El **runner de pruebas** es del paso **`4a`**: el esqueleto lo deja **arrancando sin casos** y lo escribe si el framework no lo trae; la **suite no lo crea** (si falta o no arranca, se detiene). Estaba en los dos sitios a la vez, y así se quedó sin escribir en `assembly` (`make build` se paró en el enlace).
  - El **completado** de la secuencia se imprime **en un bloque al final** —antes lo tapaba la salida de los comandos—, numerado por su paso, y el dato se valida: **8 columnas** por fila, **órdenes contiguos** por lenguaje y la **columna 8 nunca vacía**. La regla de completitud queda escrita en [`data/README.md`](../data/README.md): todo paso necesario para que el runner arranque va como **comando**, no como nota.
  - Los **flags globales** (`-q`, `-n`) valen en **cualquier posición**: el dispatcher los retira de los argumentos del verbo, así que `glot new -n …` y `glot save -n 4a …` funcionan, y la opción desconocida sigue devolviendo `2`.
- **Añade el paso de corrección:** **`4d`** (alias `fix`) con encargo versionado ([`fix.prompt.md`](../prompts/fix.prompt.md)) y `save --causa "<texto>"`, **obligatoria** en ese paso, que viaja como **segundo `-m`** del commit: el registro del retrabajo —qué se corrigió y por qué—, que era lo que faltaba cuando hubo que retocar el contrato y la suite ya confirmados.
- **Cambia el modelo de ramas de `pointer`:** prepara el gitlink **en la rama activa**, **sin crear ni publicar rama propia** ni tocar el estado del sprint, y como no cambia de rama ya **no bloquea por trabajo sin confirmar**. El gitlink pertenece al cierre en curso; abrir rama a mitad del cierre era lo que estorbaba.
- **Corrige el bug que hacía desaparecer un módulo:** `close` escribía la línea del contador con `printf '%-38s%s'`, así que con un id de **38 caracteres o más** la marca quedaba pegada (`…data_structures_basics🔄 3/50`) y el catálogo descartaba la línea **en silencio**: `data_structures_basics` dejó de ofrecerse en `modules`, `use`, `progress` y `doctor`. El separador va ahora **dentro** del relleno y el catálogo **avisa** de la línea que no entiende.
- **Paga deuda declarada del bloque B (ocho entradas).** Las **siete restantes** pasan al plan de la **v1.4.0**, con su orden de trabajo, en [`ROADMAP.md`](ROADMAP.md).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 763 passed, 0 failed` (rc `0`), **54 más** que la v1.2.0 (728): la frontera del runner en las dos mitades, el completado con dato inyectado, la validación del dato de secuencias, los flags detrás del verbo, el paso de corrección (causa obligatoria, plan con los dos `-m`, alias `fix`) y el roadmap ilegible (aviso, módulo que no se cuela y módulo que entra).
- **Snapshot:** [`versions/glot_1.3.0.sh`](../versions/glot_1.3.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.4.0 — 2026-09-27 (cerrada)

- **Escribe el alcance real de `verify`:** es *lint* idiomático (sintaxis y formato) y nada más —la **suite entera** es de `test`, los **valores codificados para aprobar los casos** (*hardcode*) son de `validate` y el **análisis estático de seguridad es un no-objetivo explícito**—. Aplicado a la ayuda del verbo, [`CONTRACT.md`](CONTRACT.md) (tabla *Alcance de la capa*), el paso 6 de [`SPRINT.md`](SPRINT.md), [`validate.prompt.md`](../prompts/validate.prompt.md), la columna 5 de [`data/README.md`](../data/README.md) y el harness.
- **Mide la deriva de la copia en sus dos orillas:** `doctor` separa `install_copy` (`ok`/`tweaked`, la copia frente a lo instalado) de `install_source_state` (`ok`/`stale`/`moved`, la fuente frente a lo instalado), así que un clon que se movió **no** convierte en vieja a una copia intacta; el remedio (`glot install`) va por stderr y el harness monta una **fuente desechable** para medir cada orilla. Al medirlo se supo que la comparación con la fuente ya existía desde la v1.1.0: lo que faltaba era **distinguirlas**.
- **Anota el `cd` en tubería:** la ayuda de `use` avisa de que la capa cargada solo hace el `cd` si el verbo corre en tu shell —en una tubería corre en un subshell y el `cd` se queda ahí, limitación de bash y no del verbo— y recuerda la salida sin capa (`cd "$(glot use …)"`).
- **Escribe la política de CI por submódulo:** la CI del ciclo vive en el monorepo, llama a los verbos del catálogo (`glot test`, `glot verify`) en vez de **copiar** el comando, **comprueba y no firma** —el acta de `docs/evidence/` la firma el autor— y su disparador es el **puntero** del submódulo; el SAST del repositorio no es el verbo `verify`, y el workflow de `ada` que copia sus comandos queda como excepción declarada.
- **Añade las filas medibles de `toolchains.tsv`:** `ada` (`alr --version` → `2.1`), `common-lisp` (`ros run -- --version` → `2.6`), `rexx` (`rexx -v` → `5.2`) y `scala` (`scalac -version` → `3.9`, y no `scala -version`, cuya primera versión es la del *runner*). `rescript` queda como **excepción declarada**: su toolchain no está instalada aquí.
- **Declara la tabla de módulos del roadmap vista manual:** se le quita la columna de lenguajes para que ningún número pueda quedarse atrás en silencio; el recuento vive en el **bloque de contadores**, que es el que lee `glot progress`.
- **Quita el falso positivo de la `suite`:** el contrato **inválido** detiene el paso y «aún no enlaza» **no**; mientras falte el cuerpo, la verificación es la **compilación sin enlace** (`gprbuild -c -cargs -gnatc` en Ada) y la ejecución y su contra-verificación se trasladan al **acta del paso 6**.
- **Cierra el bloque B de la deuda: 17 de 17 entradas.** No queda ninguna abierta —dos pagadas por la v1.2.0, ocho por la v1.3.0 y **siete** por esta—; el detalle está en [`ROADMAP.md`](ROADMAP.md).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 818 passed, 0 failed` (rc `0`), **55 más** que la v1.3.0 (763).
- **Snapshot:** [`versions/glot_1.4.0.sh`](../versions/glot_1.4.0.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.4.1 — 2026-09-27 (cerrada)

- **`ask` trae el remedio cuando le falta el delegado:** en vez de nombrar solo la variable que falta, imprime por stderr las **dos líneas de invocación verificada** —Copilot y Antigravity— listas para el rc; con `--delegate` imprime **solo la que falta** y la ayuda del verbo las trae. Nació de usar el verbo sin tenerlas configuradas y encontrarse con que el error no daba el comando.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 833 passed, 0 failed` (rc `0`), **15 más** que la v1.4.0 (818).
- **Snapshot:** [`versions/glot_1.4.1.sh`](../versions/glot_1.4.1.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.
- **Rama del fix:** `fix/repo/glot-v1.4.0` —nombraba la versión **arreglada**— y aun así la versión que genera es la **1.4.1**: era la regla de `fix` y `refactor` desde esta versión. **Desde la v1.6.1** la rama ya lleva el número de la entrega (`fix/repo/glot-v1.6.1` cierra como **1.6.1**), como dice la convención de abajo.

---

## 1.4.2 — 2026-09-27 (cerrada)

- **El delegado, en el autocompletado:** `ask` tiene una opción propia —`--delegate copilot|antigravity`— y el completado no la ofrecía, así que había que recordarla de memoria. Ahora `glot ask <TAB>` la ofrece junto a los encargos, tras la opción se completan sus dos valores (y `--delegate=<letra>` filtra el pegado) y el **posicional no se desplaza**: con la opción delante, el encargo, el lenguaje y la fase/módulo siguen completándose. El guion de zsh deja de compartir rama con `prompt`, que es de donde venía la carencia.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 847 passed, 0 failed` (rc `0`), **14 más** que la v1.4.1 (833). Los casos nuevos **ejecutan** el completado —cargan el guion y llaman a `_glot_complete`— en vez de mirar el texto: qué ofrece para `glot ask `, para `--delegate `, para `--delegate=c`, para `--delegate copilot ` y que `prompt` no lo ofrece.
- **Snapshot:** [`versions/glot_1.4.2.sh`](../versions/glot_1.4.2.sh), archivado al cerrar la versión y **antes** de fusionar la rama en `main`; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.5.0 — 2026-09-28 (cerrada)

- **El contrato se encarga como `contract_stub`:** el encargo del paso `4b` entregaba el contrato **sin cuerpos**, así que el `4c` se bloqueaba al compilar —en Ada un `.ads` sin su `.adb` no construye— y el delegado del sprint de `c` se detuvo con ese bloqueo. La v1.4.0 lo mitigó admitiendo la **compilación sin enlace**; la causa de raíz era el `4b`. Ahora el encargo —[`contract_stub.prompt.md`](../prompts/contract_stub.prompt.md), `name: contract_stub`— entrega el contrato **y el esqueleto de cada operación** con el retorno del indicador natural, con una tabla de formas por familia de lenguaje (Ada, C/C++, OO, funcionales y scripting), y la verificación exige **compilación y enlace**. El nombre se propaga a `data/models.tsv`, al **alias** de [`data/commits.tsv`](../data/commits.tsv) (`4b contract_stub`, con `4b` como forma estable), a [`SPRINT.md`](SPRINT.md), [`CONTRACT.md`](CONTRACT.md), [`VALIDATION.md`](VALIDATION.md), [`README.md`](../README.md) y los encargos `scaffold`, `suite` y `fix`.
- **La suite (`4c`) consume los esqueletos:** el encargo de la suite ya no describe el enlace roto como algo esperado —lo era mientras faltaba el cuerpo— sino como **defecto del `4b`**; la **compilación sin enlace** queda solo como mitigación y la ejecución se traslada al acta del paso 6.
- **La opción del paso de corrección, en inglés:** `--causa` pasa a **`--cause`**, con `--causa` **aceptado como alias** mientras se documenta el cambio. Al día la ayuda larga, la del listado (`glot help save` —que además no enumeraba el `4d`—), el mensaje de error, el encargo [`fix.prompt.md`](../prompts/fix.prompt.md), [`SPRINT.md`](SPRINT.md) y [`CONTRACT.md`](CONTRACT.md).
- **De paso, la ayuda de `pointer`:** el listado seguía anunciando que el verbo «prepara y publica la rama `chore/{fase}/{módulo}-pointer`», que la **v1.3.0** retiró; ahora dice que el gitlink va **en la rama activa** y lo comprueba el harness.
- **El ciclo dice lo que le toca al autor.** Medido recorriendo el **ciclo entero** en el laboratorio (`~/glot-lab/cycle`, un monorepo de pruebas con remotos **locales**, sin red ni cuentas) el 2026-09-28: tras el paso 7 nadie avisaba de que el trabajo vive en `feat/{fase}/{módulo}` hasta que se fusiona en el `main` del submódulo, y `pointer` solo frenaba con un mensaje incompleto —`git -C {lang} switch main`— que, seguido al pie de la letra, dejaba los seis commits del módulo **fuera** del puntero: `main` seguía siendo el de `origin/main` y `pointer` respondía `nothing`, con salida `0`. Tres correcciones: (1) `save` imprime el **bloque de integración** —`switch main`, `merge --no-ff`, `push origin main` y el verbo siguiente— al confirmar el paso **7** o el **8** con la rama del sprint sin integrar; (2) `pointer` **frena** si esa rama tiene commits que el `main` del submódulo no tiene, y lo comprueba **antes** de su atajo de idempotencia, dando los comandos en vez de pedir un `switch` a secas; (3) `close` exige que el **gitlink** del monorepo apunte al `HEAD` del submódulo, porque el paso 8 se confirma **dentro** del submódulo y puede ir después del `pointer` (medido: `status` decía `differs` y `close` cerraba igual, con el módulo «cerrado» apuntando a un commit anterior).
- **Orden del ciclo corregido** en [`SPRINT.md`](SPRINT.md): el paso **8** (`docs-language`) es del **submódulo** y va **antes** de la integración; se añade la sección de la **integración** (solo el autor), la del **paso a paso de cada verbo** y la de lo que **solo puede hacer el autor**.
- **Normalización del índice de fuentes:** un lenguaje cuyo *autoloader* indexa `src/` (Composer, PSR-4…) tiene que **regenerarlo** después de crear los ficheros —medido en el laboratorio: el `composer require` de `new` deja el mapa del `src/` **vacío** y la suite falla con «Class not found» hasta un `composer dump-autoload`—; queda dicho en [`scaffold.prompt.md`](../prompts/scaffold.prompt.md).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 878 passed, 0 failed` (rc `0`), **31 más** que la v1.4.2 (847): el registro `contract_stub`, su alias en el catálogo y el ordinal `4b`, el alias viejo rechazado, el contenido del encargo (esqueleto, compilación y enlace, «no resuelve ningún caso»), el contrato consumido por la suite, `--cause` en sus cuatro formas (larga, pegada `--cause=`, alias `--causa` y texto ausente), la ayuda de `save` y de `pointer`, el `pointer` que frena con la rama del sprint sin integrar y da sus comandos, el `close` que frena con el puntero obsoleto y su remedio, el aviso de integración del paso 7 y la normalización del índice de fuentes del andamiaje.
- **Snapshot:** [`versions/glot_1.5.0.sh`](../versions/glot_1.5.0.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.6.0 — 2026-09-30 (cerrada)

- **El retrabajo se reparte por momento.** El catálogo de commits gana tres pasos, cada uno con su causa: **`4d correct`** corrige un artefacto `4a`/`4b`/`4c` ya confirmado —**antes** de implementar—, **`5b fix`** un defecto de comportamiento de la implementación del paso 5 y **`5c refactor`** una reelaboración de la forma sin cambio observable. Los tres **exigen la causa** —`--cause`, con `--causa` como alias desde la v1.5.0— o la toman de la **clave de estado `cause`** que deja el propio encargo, y `save` la **borra** al confirmar: el registro del retrabajo vive en el cuerpo del commit y no deja ningún fichero en el módulo. Plantillas: [`correct.prompt.md`](../prompts/correct.prompt.md) (renombrada desde la vieja `fix`), [`fix.prompt.md`](../prompts/fix.prompt.md) y [`refactor.prompt.md`](../prompts/refactor.prompt.md).
- **El modelo se elige por rol y viaja también al delegado de AGY.** [`data/models.tsv`](../data/models.tsv) gana una **séptima columna** con el modelo del delegado de Antigravity —los ids **no** son los mismos que los de Copilot— (`economy` → `gemini-3.8-flash-low`, `balanced` → `gemini-3.8-flash-medium`, `deep` → `claude-sonnet-4-6`), `balanced` pasa al esfuerzo `low` con `gpt-5.6-terra` y el marcador `{model}` de la orden del delegado lo resuelve `ask`; `--model`/`GLOT_MODEL` (`_COP`/`_AGY`) y `--effort`/`GLOT_EFFORT` cambian modelo y esfuerzo **para una corrida** sin tocar el dato. `doctor` informa `model_profiles` (10 de 10) y comprueba los tres perfiles contra el CLI (`model_available`, `model_available_agy`).
- **El cierre tiene su verbo: `finish`.** Prepara y confirma el **puntero** (`pointer` + `save 9`) y registra el **cierre** (`close` + `save 10`) desde el monorepo, en la **rama activa** y **sin abrir rama propia**: son **dos commits** y el `push` es del autor. `use` deja `target=submodule` y `finish`, `target=monorepo`.
- **El alcance de los encargos documentales queda repartido:** [`docs-module.prompt.md`](../prompts/docs-module.prompt.md) (paso 7) entrega **solo el README de Nivel 3** del módulo y [`docs-language.prompt.md`](../prompts/docs-language.prompt.md) (paso 8) **solo los índices de Nivel 1 y 2** del lenguaje; el roadmap y el checklist son de `glot close`, en el monorepo.
- **Las plantillas solo mandan versionadas:** se retira el respaldo al banco local de encargos —y todas sus menciones en la documentación y en el `CHANGELOG`—, así que la **fuente única** es `scripts/prompts/` (10 encargos). Los ficheros locales y su línea de `.gitignore` **no** se borran: son del autor.
- **La capa de roles se documenta:** [`docs/AGENT_ROLES.md`](../../docs/AGENT_ROLES.md) —11 roles, con qué decide cada uno, qué **no** le corresponde y con qué perfil de modelo trabaja— queda referenciada desde [`AGENTS.md`](../../AGENTS.md), [`docs/AGENT_Template.md`](../../docs/AGENT_Template.md) y las 10 plantillas (`## Rol` + `sources:`).
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 880 passed, 0 failed` (rc `0`), **2 más** que la v1.5.0 (878).
- **Snapshot:** [`versions/glot_1.6.0.sh`](../versions/glot_1.6.0.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.6.1 — 2026-09-30 (cerrada)

- **La línea del delegado de AGY, corregida con la medición delante.** El repositorio publicaba `agy -m {model}` —y, en tres sitios, `agy -m claude-sonnet-4-6`, un id **fijo** que dejaba al perfil sin llegar—; medido el 2026-09-30, el binario **no define `-m`** (`flags provided but not defined: -m`) y sí `--model` (también `-model`). Al día los **cinco** sitios (`_glot_delegates_hint`, [`README.md`](../README.md), [`VALIDATION.md`](VALIDATION.md), [`ROADMAP.md`](ROADMAP.md) y el arnés, que afirmaba el texto en vez del comportamiento) y remedidas las versiones: `copilot` 1.0.89 y `agy` 1.2.14.
- **La deuda de `common-lisp`, pagada:** la secuencia de [`data/init_sequences.tsv`](../data/init_sequences.tsv) pasa a **`cl-project`** —el generador de la comunidad, con `#p"{module}"` obligatorio y `phase` como directorio de trabajo—, la fila de manifiestos de [`data/languages.tsv`](../data/languages.tsv) nombra el andamiaje homologado (con guion, no subrayado) y la guía [`docs/core/00_Project_Initialization_Guide.md`](../../docs/core/00_Project_Initialization_Guide.md) describe las **seis correcciones** de homologación, con `data_structures_basics` como referencia. Falta la comprobación de ciclo completo (generar un módulo con `glot new` y pasar su `4a`).
- **La regla de rama y versión, escrita:** la rama `fix/…-vX.Y.Z` **ya lleva el número de la entrega** que cierra —`fix/repo/glot-v1.6.1` cierra como **1.6.1**—; el número del parche se nombra, no se deduce. En [`VERSIONS.md`](VERSIONS.md) § *Convención*, [`CONTRIBUTING.md`](../../docs/CONTRIBUTING.md) (ES/EN) y el comentario del arnés.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 882 passed, 0 failed` (rc `0`), **2 más** que la v1.6.0 (880): la línea de AGY con `--model` y su `{model}`, y los dos casos de la secuencia de `common-lisp` (sin `quickproject` y con `cl-project` + `#p`).
- **Snapshot:** [`versions/glot_1.6.1.sh`](../versions/glot_1.6.1.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.6.2 — 2026-09-30 (cerrada)

- **El ciclo te lleva donde toca.** `use` deja al autor en la **carpeta de la fase**, `new` en la del **módulo** y `save 7`/`save 8` en la **raíz del lenguaje**: la carpeta del módulo no existe en el `main` del submódulo, así que integrar desde ahí dejaba un directorio sin contenido (medido en el laboratorio). En modo **programa** el verbo imprime el recordatorio del `cd`; en la **capa cargable** el `cd` es real. Tres `cd` y trece casos en el arnés.
- **El listado de `save` ofrece los once pasos** —también los del monorepo (9 y 10)—, que es lo que alimenta su autocompletado: antes iba filtrado por alcance y los pasos del monorepo no aparecían.
- **`glot finish` limpia el estado del sprint** al terminar, salvo `model`: se van `lang`, `phase`, `module`, `branch`, `spec`, `repo`, `target` y `cause`, así que el siguiente sprint empieza por `glot use` y nadie sigue trabajando sobre una rama y un directorio finalizados. En ensayo (`-n`) solo lo anuncia.
- **El modelo del delegado de AGY se puede fijar por sprint** con `glot set model <id>` (clave de estado `model`), porque su CLI no expone los límites de horas o de cuota: gana al perfil y pierde con `--model`/`GLOT_MODEL_AGY`, y `doctor` lo informa (`model_state:`). El de Copilot no se ve afectado.
- **El autocompletado y la ayuda ofrecen las nueve claves reservadas** —`target`, `cause` y `model` se habían quedado fuera— y `install` avisa, en vez de copiarse sobre sí mismo, cuando se lanza desde la **copia instalada**.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 915 passed, 0 failed` (rc `0`), **33 más** que la v1.6.1 (882).
- **Snapshot:** [`versions/glot_1.6.2.sh`](../versions/glot_1.6.2.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.7.0 — 2026-10-04 (cerrada)

- **Un tercer delegado, `shellgpt`.** `ask` elige entre `copilot`, `antigravity` y `shellgpt` (`--delegate`; cortos `cop`, `agy` y `sgpt`), y la orden vive en el entorno del autor —`GLOT_DELEGATE_SGPT`—, nunca en el repositorio: la clave de OpenRouter de ShellGPT se queda en `~/.config/shell_gpt/.sgptrc`. La línea que `glot` publica —en `install` y en `help ask`— desactiva el renderizado markdown (`--no-md`) y las llamadas a función (`--no-functions`), y deja la caché activada. ShellGPT 1.5.1 **no expone** esfuerzo de razonamiento: el único ajuste contra el «sobrepensar» es su `.sgptrc` (`--temperature`/`--top-p`) y elegir un modelo barato.
- **El modelo por alias, por delegado.** Las claves de estado `antigravity-model` (`gemini`, `sonnet`) y `shell-gpt-model` (`default`, `qwen`, `gemini`, `kimi`) guardan un **alias** del catálogo nuevo [`data/delegates.tsv`](../data/delegates.tsv), ordenado de más barato a más caro: es el orden del autocompletado y el del escalado cuando AGY agota su límite semanal. El alias `default` de shellgpt deja el modelo vacío a propósito (manda su `DEFAULT_MODEL`) y `set` valida el alias antes de escribir, con la lista de válidos.
- **`glot delegates [delegado]`** publica el catálogo para el autocompletado, y **`glot finish` entra en el autocompletado** (verbos de bash y zsh), que era lo que faltaba.
- **Los ids de AGY, remedidos.** La 7ª columna de `models.tsv` y los alias usan los nombres nuevos, con el esfuerzo en el nombre: `gemini-3.8-flash-low` y `claude-sonnet-5-5-low`; `doctor` comprueba los ids de AGY contra `agy models` (`delegate_model_available_agy`) además de la cobertura (`delegate_aliases`).
- **`finish` conserva las dos claves de modelo** al limpiar el sprint, y `doctor` informa `delegates_file:`, `delegate_aliases:`, `antigravity_model_state:`, `shell_gpt_model_state:` y `delegate_sgpt:`.
- **Recoge el trabajo de la 1.6.3/1.6.4**, que ya estaba en `main` sin cerrar: las rutas absolutas del encargo, el verbo `models`, el autocompletado de `set` y el validador que lee fuera del submódulo.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 984 passed, 0 failed` (rc `0`).
- **Snapshot:** [`versions/glot_1.7.0.sh`](../versions/glot_1.7.0.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.7.1 — 2026-10-04 (cerrada)

- **Se retira `shellgpt`.** ShellGPT no es un agente: solo imprime texto y no puede crear ni editar ficheros, así que no sirve para los pasos que escriben artefactos (4a–8). Desaparecen el delegado, `GLOT_DELEGATE_SGPT`, la clave `shell-gpt-model`, sus filas del catálogo, su ayuda y sus casos del arnés.
- **Entra `aider` (Aider).** Es agéntico y compatible con OpenRouter: `GLOT_DELEGATE_AIDER`, `--delegate aider` (corto `aid`), la clave de estado `aider-model` (alias `default`, `qwen`, `gemini`, `kimi`) y cuatro filas nuevas en [`data/delegates.tsv`](../data/delegates.tsv). La línea que `glot` publica le pasa el encargo por `--message "$(cat)"`, le prohíbe commitear (`--no-auto-commits`, el commit es de `glot save`) y le da las fuentes por `--read`.
- **Marcador `{spec}` (nuevo).** La orden del delegado aprende `{spec}` —la especificación del sprint, relativa a la raíz— y `ask` la exporta como `GLOT_DELEGATE_SPEC`; es lo que permite a la línea de aider leer la especificación sin copiar ninguna ruta.
- **La clave de OpenRouter, fuera del repo.** Vive en `OPENROUTER_API_KEY` o en un fichero de Aider bajo `$HOME`; el repositorio solo guarda nombres de modelo. Como Aider auto-carga `.env`/`.aider.conf.yml` del directorio actual y `glot` delega dentro del submódulo, la documentación avisa de no dejar esos ficheros en el árbol del módulo.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 988 passed, 0 failed` (rc `0`).
- **Snapshot:** [`versions/glot_1.7.1.sh`](../versions/glot_1.7.1.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.7.2 — 2026-10-05 (cerrada)

- **Se retira `aider`.** Aider **escribe** artefactos pero **no ejecuta** comandos de shell: con `--yes-always` responde que **no** a los comandos que le propone el modelo (en su `io.py`, `confirm_ask(..., explicit_yes_required=True)` solo auto-acepta con permiso explícito), así que no puede cerrar los pasos que ejecutan algo (la suite del `4c`, el verificador del `6`, el andamiaje del `4a`). Un delegado que no cierra un paso con puerta no se queda: `ask` vuelve a tener **dos**, `GLOT_DELEGATE_COP` y `GLOT_DELEGATE_AGY`.
- **Lo que desaparece.** `GLOT_DELEGATE_AIDER` y su línea en `install` y `help ask`, la clave de estado `aider-model` (vuelve a ser una clave del autor, como cualquier otra: `set` ya no la valida contra el catálogo), las cuatro filas de Aider en [`data/delegates.tsv`](../data/delegates.tsv), el alias corto `aid` y las filas de Aider de la documentación.
- **El modelo `-` se va con él.** El alias `default` (modelo `-`) existía solo para que Aider omitiera `--model` y usara el de su config; Copilot y AGY **exigen** modelo (su id no tiene valor por defecto), así que el caso `-` desaparece del código, del catálogo y de la ayuda.
- **`{spec}` se queda** (v1.7.1): es un marcador de la orden del delegado, no de Aider, así que cualquier línea puede citar la especificación del sprint sin copiar una ruta.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 976 passed, 0 failed` (rc `0`); los casos de Aider se convierten en casos de su retirada (`--delegate aider` → `2` con la lista de válidos, `GLOT_DELEGATE_AIDER` ignorado por `doctor`, `set aider-model` sin validación, y el catálogo y los completados con las dos únicas filas de AGY).
- **Snapshot:** [`versions/glot_1.7.2.sh`](../versions/glot_1.7.2.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 1.7.3 — 2026-10-05 (cerrada)

- **El reparto por encargo.** El delegado de Copilot gana la clave de estado `copilot-model` y cuatro filas nuevas en [`data/delegates.tsv`](../data/delegates.tsv) —`default` → `qwen/qwen3.7-plus`, `gemini` → `google/gemini-3.8-flash`, `qwen` → `qwen/qwen3.8-max-0902` y `kimi` → `moonshotai/kimi-k3`—, que son ids de **OpenRouter**, y [`data/models.tsv`](../data/models.tsv) reparte los perfiles por tipo de encargo: `balanced` se queda con **`gpt-5.6-terra`** para `contract_stub` y `suite`, `deep` con **`claude-sonnet-5`** para `implement`/`fix`/`refactor`, y el perfil de **OpenRouter** (`economy`, `qwen/qwen3.7-plus`, esfuerzo `low`) cubre `scaffold`, `correct`, `validate`, `docs-module` y `docs-language`. Los **tres modelos de siempre no cambian** y las cinco plantillas que pasan a OpenRouter declaran el id nuevo en su `model:`.
- **El alias solo cambia modelos de OpenRouter.** `glot set copilot-model <alias>` sustituye el modelo del perfil **solo cuando ese modelo ya lleva `/`**: una asignación de documentación no puede cambiar el modelo de un contrato, de una suite ni de una implementación. `--model`, `GLOT_MODEL_COP` y `GLOT_MODEL` sí pueden con todo: son la puerta explícita.
- **El proveedor propio se apunta solo cuando toca.** `_glot_delegate_provider` exporta `COPILOT_PROVIDER_BASE_URL=https://openrouter.ai/api/v1` **solo** si el modelo resuelto lleva `/` —los ids de OpenRouter son siempre `vendedor/modelo`— y **nunca** pisa un endpoint que el autor ya tenga configurado: BYOK queda **por modelo**, no por entorno. La **clave** no pasa por glot (`COPILOT_PROVIDER_API_KEY`, `COPILOT_PROVIDER_BEARER_TOKEN` o `COPILOT_PROVIDER_API_KEY_COMMAND`, que la imprime por petición); sin ninguna de las tres `ask` lo **avisa** por stderr.
- **El esfuerzo viaja de verdad.** La línea de Copilot que `glot` publica cita `{effort}` (`--reasoning-effort {effort}`), así que el esfuerzo del perfil llega al CLI: `low` en los encargos de OpenRouter y en el contrato, `high` en la implementación. Antes solo lo aplicaba la invocación por defecto de `validate`.
- **`validate` entra por la misma vía** (el validador usa el delegado de Copilot, así que su modelo sale de la misma cadena) y **`doctor`** informa `copilot_model_state:`, cuenta la cobertura como `delegate_aliases: 6 alias / aliases (2 de AGY, 4 de Copilot)` y mide `model_available` **solo** con los modelos de Copilot: los de OpenRouter los sirve el proveedor propio y no están en el catálogo del CLI.
- **La línea de perfil aclara las asignaciones**: imprime el modelo del perfil **del delegado elegido** (columna 2 para Copilot, 7 para AGY) y añade `→ <modelo>` solo cuando el efectivo no coincide.
- **Verificación:** `./scripts/tests/glot_test.sh` → `glot tests: 1002 passed, 0 failed` (rc `0`); los casos cubren el reparto por encargo, la resolución del alias, el alcance del alias (contrato y suite con `terra`, implementación con `sonnet`), el proveedor que solo aparece con `/`, el endpoint del autor que manda, el aviso sin clave, el esfuerzo en la orden, el alias inválido, los completados y las dos limpiezas del sprint.
- **Snapshot:** [`versions/glot_1.7.3.sh`](../versions/glot_1.7.3.sh), archivado al cerrar la versión; su cabecera solo cambia el bloque de archivado y la primera línea de uso.

---

## 2.0.0 — 2026-10-12 (cerrada)

**ES:** El esqueleto se parte en **dos pasos y dos commits** (`4` la carpeta, `4a` la
estructura idiomática) y entra el paso **`4d build`**, con `4d correct` recorrido a `4e`.
`languages.tsv` se queda con cuatro columnas y `init_sequences.tsv` con todo el esqueleto en
nueve; se retira el vocabulario `deferred` y el camino v1 del script. Perfiles de modelo al
día (`gpt-6.1-sol` / `claude-sonnet-5.5`).

**EN:** The skeleton is split into **two steps and two commits** (`4` the folder, `4a` the
idiomatic structure) and step **`4d build`** comes in, with `4d correct` shifted to `4e`.
`languages.tsv` keeps four columns and `init_sequences.tsv` holds the whole skeleton in nine;
the `deferred` vocabulary and the script's v1 path are removed. Model profiles up to date
(`gpt-6.1-sol` / `claude-sonnet-5.5`).

---

## 🔖 Convención de archivado / Archiving convention
- **SemVer** `MAJOR.MINOR.PATCH`; el número vive en el encabezado de [`glot.sh`](../glot.sh) y en la tabla de este documento (desde v0.3.0 también en `glot version`).
- **Puerta de entrada:** ninguna versión se empieza a implementar sin el snapshot de la anterior en `versions/`. Si falta, se copia `glot.sh` con el sufijo de su versión y solo después se reanuda la implementación de la nueva.
- **Cierre de versión:** copiar `glot.sh` a `versions/glot_<versión>.sh`, marcar la fila del log como `✅` y empezar la versión siguiente en `glot.sh`.
- **Fix y refactor: la rama ya lleva el número de la entrega.** Un cambio que corrige o reestructura algo ya cerrado se trabaja en una rama `fix/…-vX.Y.Z` que **ya nombra la versión que cierra** —`fix/repo/glot-v1.6.1` cierra como **1.6.1**—: se sube el parche en `glot.sh`, se archiva `versions/glot_X.Y.Z.sh` y se añade su fila al log. La rama dice a qué versión se le está haciendo el fix y el número del parche **se nombra, no se deduce**. Un `feat`, en cambio, abre la versión siguiente completa (`X.(Y+1).0`).
- **EN:** the same rule in English: a `fix` or a `refactor` branch already names the version it closes (`fix/repo/glot-v1.6.1` → **1.6.1**); the patch number is named, not derived. A `feat` opens the next full minor instead.
- Los snapshots de `versions/` **no se editan**: son la foto de cómo estaba el script en esa versión y permiten ver la progresión.
- `versions/` contiene [`glot_0.1.0.sh`](../versions/glot_0.1.0.sh), [`glot_0.2.0.sh`](../versions/glot_0.2.0.sh), [`glot_0.3.0.sh`](../versions/glot_0.3.0.sh), [`glot_0.4.0.sh`](../versions/glot_0.4.0.sh), [`glot_0.5.0.sh`](../versions/glot_0.5.0.sh), [`glot_0.6.0.sh`](../versions/glot_0.6.0.sh), [`glot_0.7.0.sh`](../versions/glot_0.7.0.sh), [`glot_0.8.0.sh`](../versions/glot_0.8.0.sh), [`glot_0.9.0.sh`](../versions/glot_0.9.0.sh), [`glot_0.10.0.sh`](../versions/glot_0.10.0.sh), [`glot_0.11.0.sh`](../versions/glot_0.11.0.sh), [`glot_0.12.0.sh`](../versions/glot_0.12.0.sh), [`glot_1.0.0.sh`](../versions/glot_1.0.0.sh), [`glot_1.1.0.sh`](../versions/glot_1.1.0.sh), [`glot_1.2.0.sh`](../versions/glot_1.2.0.sh), [`glot_1.3.0.sh`](../versions/glot_1.3.0.sh), [`glot_1.4.0.sh`](../versions/glot_1.4.0.sh), [`glot_1.4.1.sh`](../versions/glot_1.4.1.sh), [`glot_1.4.2.sh`](../versions/glot_1.4.2.sh), [`glot_1.5.0.sh`](../versions/glot_1.5.0.sh), [`glot_1.6.0.sh`](../versions/glot_1.6.0.sh), [`glot_1.6.1.sh`](../versions/glot_1.6.1.sh), [`glot_1.6.2.sh`](../versions/glot_1.6.2.sh), [`glot_1.7.0.sh`](../versions/glot_1.7.0.sh), [`glot_1.7.1.sh`](../versions/glot_1.7.1.sh), [`glot_1.7.2.sh`](../versions/glot_1.7.2.sh) y [`glot_1.7.3.sh`](../versions/glot_1.7.3.sh).
- El harness **comprueba la puerta de entrada**: exige el snapshot de la versión anterior a la viva, así que no se puede empezar una versión nueva sin haber archivado la anterior.
- Cada versión se cierra en su propia rama `chore/repo/glot-v0.X` antes de fusionarla en `main` (ver [`README.md`](../README.md)). Un **fix** o un **refactor** usan `fix/repo/glot-vX.Y.Z` —la **entrega** que cierran, ya nombrada en la rama— y se archivan como ese mismo parche.

---

## ✅ Definition of Done de una versión / Per-version Definition of Done

- [ ] `bash -n scripts/glot.sh scripts/tests/glot_test.sh` sin salida.
- [ ] Harness en verde (`glot tests: N passed, 0 failed`, rc `0`).
- [ ] Salidas reales capturadas y documentadas (sin editar).
- [ ] `scripts/README.md` y los documentos de `scripts/docs/` al día.
- [ ] Snapshot copiado a `versions/glot_<versión>.sh` y fila del log marcada `✅`.
- [ ] El harness pasa, incluida la comprobación de la **puerta de entrada**: el snapshot de la versión anterior a la viva existe.
- [ ] Rama `chore/repo/glot-v0.X` fusionada en `main`.
- [ ] `git diff --check` sin errores y sin `push` ni `commit` hechos por el agente.

---

## ✅ Requisitos / Requirements

| Herramienta | Uso | Verificación |
|-------------|-----|--------------|
| Bash 5.2 | Ejecutar `glot.sh` y, desde v1.0.0, cargarlo con `source`. Desde v0.6.0 el conversor de nombres usa `${var,,}`, `${var^}` y `${1//_/-}` (bash 4+) | `bash --version` |
| Git 2.43 | Desde v0.3.0: `doctor` resuelve la raíz con `git rev-parse --show-superproject-working-tree`; desde v0.5.0, `use` prepara y publica ramas; desde v0.6.0, `langs` lee `.gitmodules` y el catálogo resuelve el lenguaje desde la raíz de git | `git --version` |
| coreutils y util-linux | Desde v0.4.0: el almacén usa `mktemp`, `mv`, `chmod` y `flock`; `doctor` lo comprueba desde v0.6.0 | `mktemp --version`, `flock --version` |
| GNU coreutils (`stat -c`) | Solo para el harness: comprueba los permisos `600`/`700` | `stat --version` |
| zsh 5.9 (opcional) | Solo para verificar el autocompletado de `completions/glot.zsh`; el harness se salta sus dos comprobaciones si no está | `zsh --version` |
| Toolchains de cada lenguaje | Desde v0.7.0, `test` y `verify` ejecutan el comando nativo del lenguaje: la toolchain que falte se detecta al ejecutar (código `1`), y `doctor` informa de la cobertura del catálogo de verificadores | p. ej. `composer --version`, `swipl --version` |
| GitHub Copilot CLI 1.0.88 (opcional) | Validador automático de `validate` (v0.10.0) | `copilot --version` |

---

## 🧪 Cómo verificar / How to verify

```bash
bash -n scripts/glot.sh              # sintaxis
./scripts/tests/glot_test.sh        # contrato, verbos, estado, catálogo, ejecución, delegación, creación, evidencia, cierre, validación, perfiles de modelo, higiene y punteros, plantillas, archivado y códigos (878 comprobaciones)
./scripts/glot.sh doctor            # diagnóstico del entorno, del catálogo y del roadmap
./scripts/glot.sh langs             # catálogo de lenguajes y su comando de pruebas
./scripts/glot.sh modules           # catálogo de módulos con su especificación
./scripts/glot.sh progress          # contadores del roadmap
./scripts/glot.sh completion bash   # autocompletado en stdout
./scripts/glot.sh -n test php algorithms/naive_sort   # plan: cd al módulo y comando nativo
./scripts/glot.sh test php algorithms/naive_sort     # ejecuta la suite (salida real)
./scripts/glot.sh verify php algorithms/naive_sort   # verificador del lenguaje
./scripts/glot.sh prompt                             # registro de encargos
./scripts/glot.sh prompt scaffold php algorithms/naive_sort   # encargo armado
GLOT_DELEGATE='cat' ./scripts/glot.sh ask implement php algorithms/naive_sort
./scripts/glot.sh -n new php algorithms/naive_sort          # esqueleto: comando y normalización
./scripts/glot.sh new python algorithms/naive_sort          # aplazado al agente: skipped
./scripts/glot.sh -n save 4a php algorithms/naive_sort      # commit guiado: git add + mensaje
./scripts/glot.sh -n use php algorithms/naive_sort   # ensayo de `use`: plan sin tocar nada

# Estado en un directorio propio, sin tocar el del usuario / state in its own dir
export GLOT_STATE_DIR=$(mktemp -d)
./scripts/glot.sh set lang php      # set: lang (stderr)
./scripts/glot.sh get lang          # php
./scripts/glot.sh list              # lang=php
```

`shellcheck` no está instalado en este entorno; conviene añadirlo a la verificación cuando exista CI.
