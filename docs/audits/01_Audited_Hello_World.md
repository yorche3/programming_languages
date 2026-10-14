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

**ES:** 34 lenguajes incumplen algún criterio del módulo. **Todos los arreglos son de una línea** (una cadena o un `git mv`): 22 por el mensaje exacto y 20 por el nombre del fichero (8 están en las dos listas).

**EN:** 34 languages fail a module criterion. **Every fix is a one-liner** (a string or a `git mv`): 22 for the exact message and 20 for the file name (8 are on both lists).

| Motivo / Reason | Lenguajes / Languages |
|-----------------|-----------------------|
| Mensaje sin el `!` final o con el nombre mal / Message missing the final `!` or with a wrong name | `assembly`, `ballerina`, `cobol`, `common-lisp`, `d`, `elm`, `erlang`, `fsharp`, `groovy`, `ocaml`, `prolog`, `purescript`, `r`, `racket`, `raku`, `rexx`, `ruby`, `rescript`, `scheme`, `tcl-tk`, `v`, `zig` |
| Fichero que no sigue `hello_world.ext` / `HelloWorld.ext` | `csharp` (`Program.cs`), `fsharp` (`hello-world.fsx`), `gleam`, `groovy`, `julia`, `lua`, `nim`, `ocaml`, `perl`, `prolog`, `purescript` (`src/Main.purs`), `python`, `r`, `racket`, `ruby`, `rust`, `scala`, `swift`, `typescript`, `vala` |

### 🟡 Advertencias / Warnings

**ES:** Cuatro lenguajes tienen un hallazgo de idioma; tres de ellos (`gleam`, `r`, `racket`) aparecen además en la tabla 🔴 porque también incumplen un criterio del módulo. El recuento del índice cuenta cada lenguaje **una vez**, por su estado más grave: 🔴 34 · 🟡 1 (`haxe`) · 🟢 15.

**EN:** Four languages have an idiom finding; three of them (`gleam`, `r`, `racket`) also appear in the 🔴 table because they fail a module criterion too. The index counts every language **once**, by its worst state: 🔴 34 · 🟡 1 (`haxe`) · 🟢 15.

| Lenguaje / Language | Hallazgo / Finding | Evidencia / Evidence |
|---|---|---|
| `haxe` | Imprime con `trace` (mecanismo de depuración) en vez de `Sys.println`, y la desviación no está declarada. La salida **sí** es exacta en esta versión | `HelloWorld.hx:3`, salida real en el registro |
| `gleam` | `test/helloworld_test.gleam` es el test de plantilla del generador: comprueba un saludo inventado (`Hello, Joe!`) y **no** el del módulo | `test/helloworld_test.gleam:9-14` |
| `r` | `print()` añade `[1] ` y comillas: la salida de texto idiomática es `cat()`; además el mensaje pierde la coma | salida real `[1] "Hello, World from R!"` |
| `racket` | `println` imprime el valor **con comillas**: la forma de texto es `displayln` | salida real `"Hello, World! from Racket!"` |

### 🔵 Aceptados por el autor / Accepted by the author

- — (ninguno todavía / none yet)

### 🟢 Homologados / Homologated

`ada`, `c`, `clojure`, `cpp`, `crystal`, `dart`, `elixir`, `forth`, `go`, `grain`, `haskell`, `java`, `javascript`, `kotlin`, `php` — **15 lenguajes**: mensaje exacto, fichero según la convención y sin desviación de idioma. (`grain` ejecuta con `grain hello_world.gr`; el comando que documenta su README, `grain run hello_world.gr`, **falla**, y eso se anota como deuda de documentación.)

---

## Deuda por lenguaje / Debt per language

| # | Alcance / Scope | Acción / Action | Lenguajes / Languages | Estado / State |
|:-:|-----------------|-----------------|-----------------------|:--------------:|
| 1 | Mensaje exacto | Añadir el `!` final, la coma que falta o corregir el nombre de presentación (en `zig`, además, imprimir por **stdout**: `std.debug.print` escribe en stderr) | Los 22 de la tabla 🔴 | ⏳ abierta |
| 2 | Nombre del fichero | `git mv` a `hello_world.ext`/`HelloWorld.ext` y actualizar lo que lo cite (README, manifiestos, `Makefile`) | Los 20 de la tabla 🔴 | ⏳ abierta |
| 3 | Impresión idiomática | `Sys.println` en `haxe`, `displayln` en `racket`, `cat()` en `r` | 3 | ⏳ abierta |
| 4 | Test de plantilla | Sustituir el test de `gleam` por uno del mensaje del módulo, o retirarlo | 1 | ⏳ abierta |
| 5 | README del módulo | Completar las secciones que faltan de la plantilla | `erlang`, `java`, `javascript`, `scheme`, `tcl-tk` | ⏳ abierta |
| 6 | README: comando que falla | Corregir el comando de ejecución documentado (`grain run` → `grain hello_world.gr`) | `grain` | ⏳ abierta |
| 7 | Nombre de la carpeta | La carpeta del módulo es `helloworld` en 49 lenguajes y `hello_world` en `ada`; la especificación pide `hello_world`. **Decisión del autor**: ajustar la especificación o renombrar | 50 | ⏳ decisión |
| 8 | Estado de `06` | Cuatro filas del bloque de `data_structures_basics` traen un `commit` que no es el del submódulo (`swift`, `ruby`, `rescript`, `rexx`) | 4 | ⏳ abierta |

---

## Plan de cierre / Closure plan

**ES:** El pase **no toca código**: los arreglos son de la rama `align` y los decide el autor.

1. **Decidir por lenguaje**: `align` (los arreglos de una línea) o 🔵 aceptación por escrito en la ficha del lenguaje.
2. **`align` en lote por tipo de arreglo**, no por lenguaje: los 22 mensajes primero, los 20 renombrados después —cada uno en su submódulo, con su rama `align/foundations/hello-world`, su suite/ejecución y su acta—.
3. **Re-verificar** con este mismo pase: los pasos 3 y 5 bastan para los arreglos de la deuda 1 y 2.
4. **Cerrar el registro** cuando los 50 estén en 🟢 o 🔵, con su sección en el registro de verificaciones, el índice de [`README.md`](README.md) y la nota en `docs/ROADMAP.md`. El contador del sprint (`50/50`) **no se toca**.

**EN:** The pass **touches no code**: the fixes belong to the `align` branch and the author decides them. Decide per language (`align` or a written 🔵 acceptance), batch the `align` work by fix type (the 22 messages first, the 20 renames after), re-verify with the same pass, and close the record once all 50 are 🟢 or 🔵 —the sprint counter is **not** touched.

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
