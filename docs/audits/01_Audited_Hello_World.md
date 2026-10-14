# Auditoría de Módulo: 01_Hello_World
# Module Audit: 01_Hello_World

Registro de deuda técnica del módulo `01_Hello_World`. / Technical debt record for the `01_Hello_World` module.

- **Especificación / Specification:** [`01_Hello_World.md`](../core/foundations/01_Hello_World.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Estado / State:** [`data/idiomaticity_state.tsv`](../ruleset/data/idiomaticity_state.tsv) — bloque de 50 filas abierto en esta pasada
- **Última verificación / Last verification:** 2026-10-13

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** (a) El programa se ejecuta y muestra el **mensaje exacto** `Hello, World! from {Nombre del Lenguaje}!`, con el nombre de presentación del catálogo; (b) usa **solo** la biblioteca estándar; (c) el fichero fuente sigue la convención `hello_world.ext` o `HelloWorld.ext`. Sin coste algorítmico: no hay complejidad que auditar.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md). En este módulo, `construction`, `failure`, `access`, `encapsulation` y `complexity` son `N/A` (no hay ADT, ni entrada, ni coste); los ejes vivos son **`unsafe`** (mecanismos de depuración usados para imprimir), **`tests`** (la suite, cuando existe) y **`documentation`** (desviación declarada o no).

> **ES:** El layout `src/` + `test/` **no es una desviación**: es el que generan las herramientas de `elm`, `gleam`, `purescript` y `rescript` —cuatro lenguajes— y coincide con la convención común del repositorio (fuente y pruebas separadas). En `gleam`, además, el nombre del módulo **debe** ser `snake_case`, así que la forma válida del criterio (c) es `hello_world.ext`.
> **EN:** The `src/` + `test/` layout **is not a deviation**: it is what the tooling of `elm`, `gleam`, `purescript` and `rescript` generates —four languages— and it matches the repository's common convention (sources and tests apart). In `gleam` the module name **must** be `snake_case`, so the valid form of criterion (c) is `hello_world.ext`.

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git; los fuentes son de 5–25 líneas y se leyeron íntegros | 0 rutinas de ordenamiento o selección (no aplica); 0 `Option`/`Maybe`/`Result`; 0 excepciones; 0 generadores formales de documentación; **3 mecanismos de depuración para imprimir** (`elm` `Debug.log`, `haxe` `trace`, `zig` `std.debug.print`) |
| 2. Lectura de código | 50 fuentes + 50 `README.md` + ficheros de construcción | **22 lenguajes** no imprimen el mensaje exacto del criterio (a) y **20** no usan el nombre de fichero del criterio (c); 1 desviación de impresión en `r` y `racket`; 1 test de plantilla en `gleam`; 1 orden de ejecución documentado que no funciona (`grain`) |
| 3. Ejecución | Los 50 programas, con el comando documentado en su README y el nativo del catálogo cuando el README no lo trae | **50/50 ejecutan y terminan con código 0**; la salida real está en el registro de verificaciones, con los desajustes citados tal cual |
| 4. Documentación | Los 50 `README.md` contra [`README_Template.md`](../README_Template.md) | 50/50 presentes y bilingües; **45/50** traen las cuatro secciones que la plantilla aplica a este nivel (`Archivos y estructura`, `Enfoque y construcción`, `Compilación y ejecución`, `Notas de implementación`); faltan en `erlang` (2), `java`, `javascript`, `scheme` y `tcl-tk` (3 cada uno) |
| 5. Estado del árbol | `git -C {lang} status --short` en los 50 submódulos | **50/50 limpios**. La ejecución de `grain hello_world.gr` dejó `hello_world.gro`, `hello_world.wasm` y `target/` en su módulo: **retirados** (no eran del repositorio) |

**ES:** El barrido y la lectura usaron **solo archivos rastreados por git**. El mensaje esperado se comparó contra el nombre de presentación del catálogo ([`display.tsv`](../../scripts/data/display.tsv): `C#`, `COBOL`, `OCaml`, `REXX`, `Tcl/Tk`, `V`…), no contra una transcripción a mano.

**EN:** The sweep and the reading used **git-tracked files only**. The expected message was compared against the catalogue's display name ([`display.tsv`](../../scripts/data/display.tsv): `C#`, `COBOL`, `OCaml`, `REXX`, `Tcl/Tk`, `V`…), not against a hand transcription.

---

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

**ES:** 34 lenguajes incumplían algún criterio del módulo —**los 34 están corregidos, integrados y empujados**: ninguno queda en 🔴—. **Todos los arreglos eran de una línea** (una cadena o un `git mv`): 21 por el mensaje exacto y 20 por el nombre del fichero (7 estaban en las dos listas).

**EN:** 34 languages failed a module criterion —**all 34 are fixed, integrated and pushed**: none is left in 🔴—. **Every fix was a one-liner** (a string or a `git mv`): 21 for the exact message and 20 for the file name (7 were on both lists).

| Motivo / Reason | Lenguajes / Languages |
|-----------------|-----------------------|
| Mensaje sin el `!` final o con el nombre mal / Message missing the final `!` or with a wrong name | `assembly`, `ballerina`, `cobol`, `common-lisp`, `d`, `elm`, `erlang`, `fsharp`, `groovy`, `ocaml`, `prolog`, `purescript`, `r`, `raku`, `rexx`, `ruby`, `rescript`, `scheme`, `tcl-tk`, `v`, `zig` |
| Fichero que no sigue `hello_world.ext` / `HelloWorld.ext` | `csharp` (`Program.cs`), `fsharp` (`hello-world.fsx`), `gleam`, `groovy`, `julia`, `lua`, `nim`, `ocaml`, `perl`, `prolog`, `purescript` (`src/Main.purs`), `python`, `r`, `racket`, `ruby`, `rust`, `scala`, `swift`, `typescript`, `vala` |
| Residuos del generador dentro del módulo / Generator leftovers inside the module | `gleam`: `.github/workflows/test.yml`, presente en **sus 6 módulos**; ningún otro lenguaje lo arrastra en `hello_world` |

### 🟡 Advertencias / Warnings

**ES:** Cinco lenguajes tuvieron un hallazgo de idioma en este pase: `elm` (**aceptado**, ver la sección 🔵), `gleam`, `haxe`, `r` y `racket`. **Los cuatro corregibles están corregidos, integrados y empujados** (`haxe` con `Sys.println`, `r` con `cat()`, `racket` con `displayln`, `gleam` sin el test de plantilla); el de `elm` no es corregible porque la stdlib del lenguaje no ofrece salida por consola. Recuento final: **🔴 0 · 🟡 0 · 🔵 1 (`elm`) · 🟢 49**.

**EN:** Five languages had an idiom finding in this pass: `elm` (**accepted**, see the 🔵 section), `gleam`, `haxe`, `r` and `racket`. **The four fixable ones are fixed, integrated and pushed** (`haxe` with `Sys.println`, `r` with `cat()`, `racket` with `displayln`, `gleam` without the template test); `elm`'s is not fixable because the language's stdlib offers no console output. Final count: **🔴 0 · 🟡 0 · 🔵 1 (`elm`) · 🟢 49**.

| Lenguaje / Language | Hallazgo / Finding | Evidencia / Evidence | Estado / State |
|---|---|---|---|
| `haxe` | `trace` (utilidad de depuración) en vez de una impresión de texto | `HelloWorld.hx:3`; hoy `Hello, World! from Haxe!` por **stdout**, rc=0, sin stderr | ✅ corregido con `Sys.println` |
| `gleam` | `test/helloworld_test.gleam` era el test de plantilla del generador: comprobaba un saludo inventado (`Hello, Joe!`) y **no** el del módulo | `test/helloworld_test.gleam:9-14` | ✅ test retirado |
| `r` | `print()` añadía `[1] ` y comillas: la salida de texto idiomática es `cat()` | antes `[1] "Hello, World from R!"`; hoy `Hello, World! from R!` | ✅ corregido con `cat()` |
| `racket` | `println` imprimía el valor **con comillas**: la forma de texto es `displayln` | antes `"Hello, World! from Racket!"`; hoy sin comillas | ✅ corregido con `displayln` |
| `zig` | `std.debug.print` escribía en **stderr** | antes stdout vacío y el mensaje en stderr; hoy `Hello, World! from Zig!` por stdout | ✅ escritor sobre `Io.File.stdout()` |
| `elm` | `Debug.log` añade `: ()` y es la utilidad de depuración | `Hello, World! from Elm!: ()` | 🔵 aceptado: la stdlib no tiene `print` |

### 🔵 Aceptados por el autor / Accepted by the author

| Lenguaje / Language | Desviación aceptada / Accepted deviation | Evidencia / Evidence |
|---|---|---|
| `elm` | La salida se hace con `Debug.log` porque la stdlib de Elm **no ofrece stdout** para un `Platform.worker`: la única vía estándar es la utilidad de depuración, que antepone el tipo del valor. Severidad 🟡 `warning`, estado `active`; el **texto** del mensaje sí es el exacto | Salida real `Hello, World! from Elm!: ()`; declaración completa en [`idioms/elm.md`](../ruleset/idioms/elm.md); nivel `mostly-idiomatic` (nivel 2) por esa desviación documentada |

### 🟢 Homologados / Homologated

`ada`, `assembly`, `ballerina`, `c`, `clojure`, `cobol`, `common-lisp`, `cpp`, `crystal`, `csharp`, `d`, `dart`, `elixir`, `erlang`, `forth`, `fsharp`, `gleam`, `go`, `grain`, `groovy`, `haskell`, `haxe`, `java`, `javascript`, `julia`, `kotlin`, `lua`, `nim`, `ocaml`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `scheme`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig` — **49 lenguajes**: mensaje exacto, fichero según la convención y sin desviación de idioma. Los 34 que incumplían un criterio del módulo y `haxe` (35 en total) se corrigieron con **40 commits de `align`** más los **27 de corrección** posteriores (impresión, `.gitignore` de artefactos, READMEs y el nombre del paquete de `purescript`), todos integrados en el `main` de su submódulo y empujados. (`grain` ejecuta con `grain hello_world.gr`; su README, que documentaba `grain run hello_world.gr`, quedó corregido.)

### ✅ Alineaciones integradas / Integrated alignments

**ES:** Las 35 desviaciones (34 🔴 + `haxe` 🟡) **están integradas y empujadas**: cada submódulo tiene su `main` con los commits del `align`, y con ellos **40 commits** de alineación (21 lenguajes por el mensaje, 20 por el nombre del fichero, 7 en las dos listas) más **27 commits de corrección** en la segunda pasada (`r`, `racket`, `zig`, `elm`, `grain`, los 5 READMEs, 14 `.gitignore` de artefactos, `purescript` y `haxe`).

**EN:** All 35 deviations (34 🔴 + `haxe` 🟡) **are integrated and pushed**: each submodule's `main` carries the `align` commits —**40 alignment commits** (21 languages for the message, 20 for the file name, 7 on both lists) plus **27 correction commits** in the second pass (`r`, `racket`, `zig`, `elm`, `grain`, the 5 READMEs, 14 build-artifact `.gitignore`s, `purescript` and `haxe`).

| Cobertura / Coverage | Detalle / Detail |
|---|---|
| Mensaje exacto / Exact message | 21 lenguajes; **20 commits** (`purescript` va dentro de su commit de renombrado / inside its rename commit) |
| Nombre del fichero / File name | 20 lenguajes; **20 commits** |
| Ambos / Both | `fsharp`, `groovy`, `ocaml`, `prolog`, `purescript`, `r`, `ruby` |
| `gleam` | Además retira `.github/workflows/test.yml` y el test de plantilla, y quita `gleeunit` del manifiesto (criterio (b): solo biblioteca estándar) |
| `haxe` | Arreglo del autor: `Sys.println` en vez de `trace` |
| Formato / Format | `chore(hello-world): align {Lenguaje} {implementation\|naming conventions}` con `Causa / Cause` + `Registro / Record` |

**ES:** Re-ejecutados los 50 tras los arreglos: **rc=0 en los 50** y salida exacta del criterio (a). Los tres hallazgos que quedaban abiertos eran del eje de idioma y **también se corrigieron**: `elm` (`Debug.log` añade `: ()`, aceptado por el autor) y, en la segunda pasada, `r` (`print()` añadía `[1] "…"` → `cat()`), `zig` (escribía en **stderr** → escritor sobre `Io.File.stdout()`) y `racket` (`println` entrecomillaba → `displayln`).

**EN:** All 50 re-run after the fixes: **rc=0 in all 50** and the exact criterion-(a) output. The three findings still open belonged to the language axis and **were fixed too**: `elm` (`Debug.log` appends `: ()`, accepted by the author) and, in the second pass, `r` (`print()` appended `[1] "…"` → `cat()`), `zig` (wrote to **stderr** → writer over `Io.File.stdout()`) and `racket` (`println` added quotes → `displayln`).

**ES:** La revisión de los 50 `README.md` encontró **14** que citaban el mensaje viejo (sin el `!` final, o con `Hello, World from R!`, `VLang`, `TCL/TK`, `Rexx`, `world` en minúscula): corregidos y **consolidados en el commit de alineación de cada lenguaje** (`--amend`), no en un commit aparte.

**EN:** The review of the 50 `README.md` found **14** quoting the old message (missing final `!`, or `Hello, World from R!`, `VLang`, `TCL/TK`, `Rexx`, lowercase `world`): fixed and **folded into each language's alignment commit** (`--amend`), not a separate commit.

---

## Deuda por lenguaje / Debt per language

| # | Alcance / Scope | Acción / Action | Lenguajes / Languages | Estado / State |
|:-:|-----------------|-----------------|-----------------------|:--------------:|
| 1 | Mensaje exacto | Añadir el `!` final, la coma que falta o corregir el nombre de presentación (en `zig`, además, imprimir por **stdout**: `std.debug.print` escribe en stderr) | Los 21 de la tabla 🔴 | ✅ corregida (20 commits de `align`) |
| 2 | Nombre del fichero | `git mv` a `hello_world.ext`/`HelloWorld.ext` y actualizar lo que lo cite (README, manifiestos, `Makefile`) | Los 20 de la tabla 🔴 | ✅ corregida (20 commits de `align`) |
| 3 | Impresión idiomática | `Sys.println` en `haxe`, `displayln` en `racket`, `cat()` en `r` | 3 | ✅ corregida |
| 4 | Test de plantilla | Sustituir el test de `gleam` por uno del mensaje del módulo, o retirarlo | 1 | ✅ retirado |
| 5 | README del módulo | Completar las secciones que faltan de la plantilla | `erlang`, `java`, `javascript`, `scheme`, `tcl-tk` | ✅ completadas (4/4 cada uno) |
| 6 | README: comando que falla | Corregir el comando de ejecución documentado (`grain run` → `grain hello_world.gr`) | `grain` | ✅ corregido |
| 7 | Nombre de la carpeta | La carpeta del módulo es `helloworld` en 49 lenguajes y `hello_world` en `ada`. **Decisión del autor: no es desviación**; cualquiera de las dos formas vale y solo aplica a los dos primeros módulos | 50 | ✅ cerrada (no es desviación) |
| 8 | Estado de `06` | Cuatro filas del bloque de `data_structures_basics` traen un `commit` que no es el del submódulo (`swift`, `ruby`, `rescript`, `rexx`) | 4 | ⏳ abierta |
| 9 | Residuo del generador | `.github/workflows/test.yml` en los **6 módulos** de `gleam` | `gleam` | 🚫 fuera de este audit (retirado en `hello_world`, decisión del autor) |
| 10 | Catálogo del tooling | La fila `scaffold` de `gleam` en [`init_sequences.tsv`](../../scripts/data/init_sequences.tsv) solo hace `rm -rf .git && touch .gitignore`: no retira `.github/`, no renombra a `hello_world.gleam` ni sustituye el test de plantilla, y su columna de completado es `-` | 1 fila | 🚫 fuera de este audit (decisión del autor) |
| 11 | Desviación declarada | `purescript` usaba `name: helloworld` en `spago.yaml`; Spago **no admite** `_` en `package.name`, así que se usa `hello-world`, la forma válida más cercana | 1 | ✅ cerrada (`name: hello-world`) |
| 12 | Artefactos de compilación | Ignorar los ficheros que deja la compilación para que el árbol quede limpio | 16: los 14 medidos (`c`, `cpp`, `cobol`, `erlang`, `haxe`, `java`, `kotlin`, `nim`, `ocaml`, `rust`, `swift`, `typescript`, `vala`, `zig`) más `elm` y `grain` | ✅ cerrada (14 + 2 commits) |

---

## Plan de cierre / Closure plan

**ES:** El pase **no toca código**: los arreglos son de la rama `align` y los decide el autor.

1. **Decidir por lenguaje**: `align` (los arreglos de una línea) o 🔵 aceptación por escrito en la ficha del lenguaje.
2. **`align` en lote por tipo de arreglo — hecho**, no por lenguaje: 20 commits de mensaje y 20 de renombrado en 34 submódulos, cada uno en su rama `align/foundations/hello-world`, con su ejecución verificada y su acta.
3. **Re-verificar — hecho**: los pasos 3 y 5 del método se repitieron tras los arreglos (rc=0 en los 50 y árboles limpios).
4. **Cerrar el registro — hecho**: los 50 quedan en 🟢 (49) o 🔵 (1, `elm`), con el estado, el índice de [`README.md`](README.md) y este registro al día, y los punteros del monorepo sincronizados en `1f31638`. El contador del sprint (`50/50`) **no se toca**.

**EN:** The pass at first **touched no code**: the fixes belonged to the `align` branch and the author decided them. The `align` work was batched by fix type —**done**: 20 message commits and 20 rename commits across 34 submodules—, re-verified with the same pass —**done**— and, in a second pass, the remaining findings were corrected (printing, build-artifact `.gitignore`s, READMEs, `purescript`'s package name). **Closing the record is done**: all 50 are 🟢 (49) or 🔵 (1, `elm`), with the state, the [`README.md`](README.md) index and this record up to date, and the monorepo pointers synced in `1f31638`. The sprint counter (`50/50`) is **not** touched.

---

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-13 | Inventario del módulo en los 50 | `git -C {lang} ls-files core/foundations/hello_world core/foundations/helloworld` | 49 lenguajes con `helloworld/` y `ada` con `hello_world/` |
| 2026-10-13 | Lectura de los 50 fuentes | `sed -n '1,22p'` sobre cada fuente rastreada | 22 mensajes que no coinciden con el criterio, 20 nombres de fichero fuera de convención |
| 2026-10-13 | Ejecución, lote 1 (17) | `alr exec -- gprbuild -P hello_world.gpr -q && ./bin/hello_world`, `make -s run`, `bal run`, `gcc`+run, `clojure -M`, `cobc -x -free`, `sh hello_world.lisp`, `g++`, `crystal run`, `dotnet run`, `dmd -run`, `dart run`, `elixir`, `elm make`+`node run.js`, `erlc`+`erl -noshell`, `gforth`, `dotnet fsi` | 17/17 con código 0; desajustes: `assembly`, `ballerina`, `cobol`, `common-lisp`, `d`, `elm` (`from Elm: ()`), `erlang`, `fsharp` |
| 2026-10-13 | Ejecución, lote 2 (17) | `gleam run`, `go run`, `grain hello_world.gr`, `groovy`, `runghc`, `haxe --main … --interp`, `java HelloWorld.java`, `node`, `julia`, `kotlinc -d /tmp/hw-kotlin.jar`+`java -jar`, `lua`, `nim r`, `ocaml`, `perl`, `php`, `swipl -g hello -t halt`, `spago run` | 17/17 con código 0; desajustes: `groovy`, `ocaml`, `prolog`, `purescript`; `kotlin` ✓ |
| 2026-10-13 | Ejecución, lote 3 (16) | `python3`, `Rscript`, `racket`, `raku`, `npx rescript build`+`node src/hello_world.res.js`, `rexx`, `ruby`, `rustc`+run, `scala`, `guile`, `swift`, `tclsh9.0`, `node --experimental-strip-types`, `v run`, `valac`+run, `zig run` | 16/16 con código 0; desajustes: `raku`, `rexx`, `ruby`, `rescript`, `scheme`, `tcl-tk`, `v`; `zig` imprime **en stderr** y con `world` en minúscula; `racket` y `r` con comillas o `[1]` |
| 2026-10-13 | READMEs contra la plantilla | `grep -F` de las cuatro secciones aplicables en los 50 `README.md` | 45/50 completos; faltan en `erlang`, `java`, `javascript`, `scheme`, `tcl-tk` |
| 2026-10-13 | Estado del árbol | `git -C {lang} status --short` en los 50 submódulos | 50/50 limpios tras retirar los artefactos de mi ejecución de `grain` |
| 2026-10-13 | Commits verificados | `git submodule status` | El `commit` de cada fila del estado es el del submódulo verificado; detectadas 4 discrepancias en el bloque de `data_structures_basics` (deuda 8) |
| 2026-10-13 | **`align` de `haxe`, re-verificado** | `haxe -cp . --run HelloWorld` | rc=0; salida exacta `Hello, World! from Haxe!` por **stdout** y sin stderr (antes: `trace`, con prefijo de posición) |
| 2026-10-13 | README del módulo de `haxe` | `grep -n 'trace\|Sys\.println' README.md` | El fragmento de código y la tabla de elementos ya citan `Sys.println`; el README queda alineado con el código |
| 2026-10-13 | **Homologación de `gleam`, probada en `/tmp`** | Copia del módulo + `mv src/helloworld.gleam src/hello_world.gleam`, `name = "hello_world"` en `gleam.toml`, `rm -rf .github` y retirada del test de plantilla; después `gleam run` | rc=0; `Running hello_world.main` → `Hello, World! from Gleam!`. El layout `src/` + `test/` se mantiene: es el del generador y la convención del repositorio |
| 2026-10-13 | Barrido de residuos del generador en los 50 | `git -C {lang} ls-files 'core/foundations/hello*'` + `grep -E 'template\|\.github\|LICENSE\|CHANGELOG\|\.editorconfig'` | Solo `gleam` arrastra `.github/workflows/test.yml`, y en **sus 6 módulos** |
| 2026-10-13 | **Integración y empuje de las 35** | `merge` del `align` en el `main` de cada submódulo y `git push` (autor); barrido posterior de los 50 | 50/50 en `main`, árboles limpios y `main == origin/main`; sin ramas `align/*` pendientes |
| 2026-10-13 | **Segunda pasada de correcciones** | `Rscript`, `racket`, `zig run`, `spago run`, `haxe --interp`/`--run`, `grain hello_world.gr`, `grain compile`+`grain run`, `javac`, `make`, `g++`, `erlc`, `cobc`, `kotlinc`, `nim c`, `valac`, `zig build-exe` | 10 correcciones de código verificadas con salida exacta; `elm make`+`node run.js` sigue dando `Hello, World! from Elm!: ()` (aceptado) |
| 2026-10-13 | **READMEs y artefactos** | `grep -E` de las 4 secciones de plantilla en los 50 y `git check-ignore -v` de cada patrón nuevo | 5 READMEs completados (`erlang`, `java`, `javascript`, `scheme`, `tcl-tk`); 14 `.gitignore` nuevos con patrón verificado, más `elm` y `grain` |
| 2026-10-13 | **Cierre y sincronización** | `git show --name-status HEAD` y `git submodule status` en el monorepo | Commit `1f31638 chore(repo): sync the hello_world submodule pointers` con **41 rutas** (solo punteros) y **0** punteros stale; estado final 🔴 0 · 🟡 0 · 🔵 1 · 🟢 49 |
| 2026-10-13 | **`align` en lote: 40 commits** | `git -C {lang} log --oneline -1` en los 34 submódulos con rama `align/foundations/hello-world` | 20 commits `align {Lang} implementation` + 20 `align {Lang} naming conventions`, cada uno con `Causa / Cause` + `Registro / Record`; el `main` de cada submódulo sigue en `origin/main` |
| 2026-10-13 | Re-ejecución de los 50 tras los arreglos | El comando documentado en cada README (o el nativo del catálogo) | 50/50 rc=0; salida exacta del criterio (a) salvo `elm` (`: ()`), `r` (`[1] "…"`) y `zig` (**stderr**) |
| 2026-10-13 | Citas del mensaje en los 50 `README.md` | `grep -nE 'from [A-Za-z0-9 +#./-]+["`]'` sobre cada README | 14 READMEs citaban el mensaje viejo: corregidos y consolidados con `git commit --amend` en el commit de su lenguaje |
| 2026-10-13 | **`gleam`, aplicado en el submódulo** | `git mv src/helloworld.gleam src/hello_world.gleam`; `gleam.toml` (`name = "hello_world"`, sin `gleeunit`); `rm -rf .github`; `git rm test/helloworld_test.gleam`; `gleam run` | rc=0: `Running hello_world.main` → `Hello, World! from Gleam!`. Commit `dee1b1a` |
| 2026-10-13 | **`purescript`, aplicado en el submódulo** | `git mv src/Main.purs src/HelloWorld.purs`, `module HelloWorld`, `run.main: HelloWorld`; `spago run` | rc=0: `✓ Build succeeded.` → `Hello, World! from PureScript!`. `name: hello_world` **no es válido** en Spago: se conserva `helloworld` y se declara (deuda 11) |
| 2026-10-13 | Rama de los commits | `git -C {lang} branch --show-current` + `git rev-parse origin/main` | `rexx`, `scheme`, `tcl-tk`, `v`, `zig` y `rescript` tenían el commit en `main`: movidos a `align/foundations/hello-world` con `git branch` + `git reset --hard origin/main`; los 34 `main` verificados contra `origin/main` |
