# Auditoría de Módulo: 05_Naive_Sort
# Module Audit: 05_Naive_Sort

Registro de deuda técnica del módulo `05_Naive_Sort`. / Technical debt record for the `05_Naive_Sort` module.

- **Especificación / Specification:** [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** 2026-10-17

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** Los tres algoritmos (`selection_sort`, `bubble_sort`, `insertion_sort`) paso a paso sobre el pseudocódigo, **sin** invocar ordenamiento ni **selección** de la biblioteca estándar (`sort`, `sorted`, `Arrays.sort`, `std::sort`, `qsort`, `lsort`, `lists:sort`, `min`/`max` para el paso interno), con la salida temprana de la burbuja (bandera `swapped`), el indicador de fallo del lenguaje ante entrada nula o inválida —**sin** excepciones ni `Option`/`Maybe`/`Result` en esta fase—, cada caso sobre una **copia** del fixture cuando la función ordena *in-place*, separación `src/`-`test/` y README de Nivel 3. Techo: $O(n^2)$ estricto; solo un lenguaje **sin mutabilidad nativa razonable** puede usar recursión, orden superior o copias, con el mismo principio temporal.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

> **ES:** La prohibición de `min`/`max` para el paso interno se ancla al **enunciado** de la especificación («utilizando comparaciones e intercambios **paso a paso**», «sin estructuras auxiliares complejas») y no a un criterio de aceptación propio: por eso se audita como parte de la fidelidad al algoritmo (decisión del autor, 2026-10-17). El indicador de fallo sigue la regla de fase: `-1`, `null` o centinela, **sin** excepciones ni `Option`/`Maybe`/`Result`, que llegan en la Fase 4 (criterio de la especificación corregido el 2026-10-17). La tabla de implementaciones esperadas marca **las dos formas de mutación** —in-place o copia ordenada— con la misma marca `✅`, porque las dos son válidas y lo único exigible es que el README declare cuál se usa (columna corregida el 2026-10-17).
>
> **EN:** The ban on `min`/`max` for the internal step is anchored on the specification's **statement** ("using step-by-step comparisons and swaps", "no complex auxiliary structures"), not on its own acceptance criterion, so it is audited as part of the algorithm's fidelity (author's decision, 2026-10-17). The failure indicator follows the phase rule: `-1`, `null` or a sentinel, **without** exceptions or `Option`/`Maybe`/`Result`, which arrive in Phase 4 (specification criterion corrected on 2026-10-17). The expected-implementations table marks **both mutation forms** —in-place or sorted copy— with the same `✅`, because both are valid and the only requirement is that the README declares which one is used (column corrected on 2026-10-17).

## Comprobaciones por lenguaje / Per-language checks

**ES:** Con los criterios ya fijados, el paso 2 se reduce a seis comprobaciones por lenguaje. Las tres primeras son de fidelidad al módulo; la cuarta y la quinta, de forma; la sexta, de documentación.

**EN:** With the criteria settled, step 2 boils down to six checks per language: the first three cover module fidelity, the fourth and fifth cover form, and the sixth covers documentation.

| # | Comprobación / Check | Cómo se verifica / How it is verified |
|---|---|---|
| 1 | La burbuja corta de verdad cuando una pasada no cambia nada / Bubble really stops when a pass changes nothing | Bandera, valor devuelto por la pasada o pasada recursiva; lo que no vale es no mirar si hubo cambios / A flag, a value returned by the pass, or a recursive pass; not looking at whether anything changed does not count |
| 2 | Indicador de fallo sin excepciones ni `Option`/`Result` / Failure indicator without exceptions or `Option`/`Result` | Devuelto o **declarado** en el README cuando el tipo no admite ausencia / Returned, or **declared** in the README when the type admits no absence |
| 3 | Sin ordenamiento ni selección de biblioteca / No library sort or selection | `sort`, `sorted`, `qsort`, `lsort`, `lists:sort`, `Arrays.sort`, `std::sort`, `min`/`max` para el paso interno / library calls, including `min`/`max` for the internal step |
| 4 | Los 7 casos, sobre copia del fixture si ordena in-place / The 7 cases, on a copy of the fixture when sorting in-place | Conteo de aserciones por algoritmo y presencia del fixture reutilizado en cada caso / Assertions per algorithm and a fresh fixture per case |
| 5 | Separación código/pruebas / Source-test split | `src`/`test` o la disposición equivalente del lenguaje, declarada en el README / `src`/`test` or the language's equivalent layout, declared in the README |
| 6 | README de Nivel 3 / Level 3 README | Las cuatro secciones de la plantilla / The template's four sections |

**ES:** El comando de suite de cada lenguaje sale del catálogo [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) (columna `test`); los que figuran como `manual` se ejecutan con el comando que declare su README.

**EN:** Each language's suite command comes from the [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) catalog (`test` column); entries marked `manual` run with the command their README declares.

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ✅ 50/50 auditados |
| 2. Lectura de código | Los tres algoritmos, los intercambios y el aislamiento de cada caso | ✅ 6 comprobaciones por lenguaje, 1 hallazgo de biblioteca |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ⚠️ 49/50 en verde; `ocaml` no compila |
| 4. Documentación | README del módulo y comentarios del código | ⚠️ 4/4 secciones en los 50; `cobol` no declara la representación equivalente |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ✅ 50/50 limpios |

**ES:** El barrido usa **solo archivos rastreados por git**, que es lo que descarta los artefactos de build (`target/`, `bin/`, `elm-stuff/`, `.cpcache/`, `vendor/`…). El paso 3 es obligatorio antes de declarar un 🟢.

**EN:** The scan uses **only git-tracked files**, which filters out build artifacts. Step 3 is mandatory before declaring a 🟢.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- **`ocaml`** — `bin/dune` declara `(executable (public_name naive_sort) (name main))` sin `bin/main.ml`, así que `dune runtest` falla con `Error: Module "Main" doesn't exist.` y el paso 3 no puede ejecutarse. Es la **tercera aparición** del mismo caso (auditorías 03 y 04).
- **`scheme`** — `selection-sort` localiza el mínimo con `(apply min unsorted)` de la biblioteca estándar, contra el criterio anclado al enunciado («comparaciones **paso a paso**», sin selección de biblioteca). El resto de la variante está bien: `remove-first` es helper propio y la burbuja corta con su bandera.

### 🟡 Advertencias / Warnings

- **`haskell`** — `pickMin [] = error "Cannot pick minimum from an empty list"`. La rama es **inalcanzable** (`selectionSort` cubre `[]` y `[x]` antes de llamarla), pero deja un `error` en un módulo cuyo contrato dice «no lanza excepciones». Se puede totalizar sin tocar el algoritmo.
- **`cobol`** — El tipo de secuencia no admite ausencia y la especificación pide **documentar la representación equivalente**; el README describe `RETURN-CODE` y las cláusulas `OCCURS`, pero no qué ocurre con una entrada nula o inválida.

### 🔵 Aceptados por el autor / Accepted by the author

- — (ninguno / none)

### 🟢 Homologados / Homologated

- 46 lenguajes: `ada`, `assembly`, `ballerina`, `c`, `clojure`, `common-lisp`, `cpp`, `crystal`, `csharp`, `d`, `dart`, `elixir`, `elm`, `erlang`, `forth`, `fsharp`, `gleam`, `go`, `grain`, `groovy`, `haxe`, `java`, `javascript`, `julia`, `kotlin`, `lua`, `nim`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig`

## Deuda por lenguaje / Debt per language

| Lenguaje / Language | Estado / Status | Eje / Axis | Qué falta / What is missing |
|---|---|---|---|
| `ocaml` | 🔴 | `construction` | Restaurar el `bin/main.ml` de demostración para que el ejecutable de `bin/dune` exista y `dune runtest` compile |
| `scheme` | 🔴 | `construction` | Sustituir `(apply min …)` por un recorrido paso a paso que devuelva el elemento mínimo |
| `haskell` | 🟡 | `failure` | Totalizar `pickMin` (caso `[]` explícito) sin usar `error` |
| `cobol` | 🟡 | `documentation` | Declarar en el README qué ocurre con entrada inválida y con secuencia vacía |

> **ES:** Retirado en este pase: el `.github/workflows/test.yml` de `gleam` no se marca. El submódulo lo tiene en sus **cinco** módulos, así que es convención del repositorio de `gleam`, no un artefacto de este módulo.
>
> **EN:** Retracted in this pass: `gleam`'s `.github/workflows/test.yml` is not flagged. The submodule has it in **all five** modules, so it is a convention of the `gleam` repository rather than an artifact of this module.

## Plan de cierre / Closure plan

**ES:** Orden previsto: un `align` por lenguaje con hallazgo 🔴 (`ocaml`, `scheme`) y por 🟡 si el autor lo prioriza (`haskell`, `cobol`), integración en el `main` de cada submódulo y cierre cuando estén los cuatro. El bloque de 50 filas de `data/idiomaticity_state.tsv` se abre con este pase. Ver [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

**EN:** Planned order: one `align` per language with a 🔴 finding (`ocaml`, `scheme`) and per 🟡 if the author prioritises them (`haskell`, `cobol`), integration into each submodule's `main`, and closure once all four are done. The 50-row block in `data/idiomaticity_state.tsv` opens with this pass. See [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-17 | Estructura del módulo (50) | `git ls-files core/algorithms/naive_sort` | Los tres algoritmos presentes en los 50; las cuatro secciones del README, 4/4 en los 50; disposición código/pruebas declarada en los 50 |
| 2026-10-17 | Salida temprana de la burbuja (50) | Lectura de los 50 cuerpos | 50/50 con corte real: bandera, valor devuelto por la pasada o pasada recursiva |
| 2026-10-17 | Ordenamiento y selección de biblioteca (50) | `grep` de `sort`, `sorted`, `qsort`, `lsort`, `lists:sort`, `Arrays.sort`, `std::sort`, `min`/`max`, `minBy`, `minimum`, `argmin`… | 1 hallazgo: `scheme` (`apply min`) |
| 2026-10-17 | Excepciones en la fuente (50) | `grep` de `throw`, `raise`, `panic`, `error`, `abort` | 1 hallazgo: `haskell` (`error` en rama inalcanzable) |
| 2026-10-17 | Indicador de fallo y su declaración (50) | Lectura de fuentes y README | 1 hallazgo: `cobol` (no declara la representación equivalente) |
| 2026-10-17 | Los 7 casos y su aislamiento | `grep` de los valores de la tabla + lectura de los mutables | 7/7 en los 50 (`cobol` en tabla `OCCURS 7 TIMES`); fixture nuevo por caso (`crystal` `.dup`, `common-lisp` `copy-seq`, `tcl-tk` por valor, `racket` inmutable, `forth` buffer de trabajo) |
| 2026-10-17 | Suites nativas (50) | Comando del catálogo [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) | 49 rc=0; `ocaml` rc=1 (`Module "Main" doesn't exist`) |
| 2026-10-17 | Estado del árbol (50) | `git status --short` | 50/50 limpios; `ballerina` escribió `Dependencies.toml` y se revirtió |

### Resultado de las suites por lenguaje / Suite result per language

| Lenguaje | Comando / Command | Resultado / Result |
|---|---|---|
| `ada` | `alr -C tests run` | 3 tests, 0 errores |
| `assembly` | `make run` | 24 aserciones, 0 fallos |
| `ballerina` | `bal test` | 0 fallos, 0 omitidos |
| `c` | `make test` | 3 de 3 |
| `clojure` | `clojure -T:build test` | 6 tests, 48 aserciones, 0 fallos |
| `cobol` | `make test` | 78 aserciones, 0 fallos |
| `common-lisp` | `ros run --load run-tests.lisp` | 24 comprobaciones, 100% |
| `cpp` | `bazelisk test //...` | 1 test, PASSED |
| `crystal` | `crystal spec` | 3 ejemplos, 0 fallos |
| `csharp` | `dotnet test NaiveSort.slnx` | 3 tests, 0 fallos |
| `d` | `dub test` | 1 módulo, 0 fallos |
| `dart` | `dart test` | 3 tests, todos pasan |
| `elixir` | `mix test` | 3 pasan |
| `elm` | `elm-test` | 21 pasan, 0 fallan |
| `erlang` | `rebar3 eunit` | 21 tests, 0 fallos |
| `forth` | `gforth run-tests.forth` | 78 pasan, 0 fallan |
| `fsharp` | `dotnet test` | 3 tests, 0 fallos |
| `gleam` | `gleam test` | 3 pasan, sin fallos |
| `go` | `go test ./...` | ok |
| `grain` | `make test` | 21 pasan, 0 fallan |
| `groovy` | `./gradlew test` | 3 tests, 0 fallos (XML) |
| `haskell` | `cabal test` | PASS |
| `haxe` | `haxe build.hxml` | 3 OK |
| `java` | `mvn test` | 3 tests, 0 fallos (surefire) |
| `javascript` | `npm test` | 3 pasan |
| `julia` | `julia --project=. test/run_tests.jl` | 24 pasan |
| `kotlin` | `gradle test` | 3 tests, 0 fallos (XML) |
| `lua` | `busted` | 3 éxitos, 0 fallos |
| `nim` | `nimble test` | 3 OK |
| `ocaml` | `dune runtest` | **falla**: `Module "Main" doesn't exist` |
| `perl` | `prove --ext=.pl test/` | 3 tests, PASS |
| `php` | `composer test` | 3 tests, 21 aserciones |
| `prolog` | `swipl -q -f naive_sort_tests.pl -t halt` | 3 pasan |
| `purescript` | `spago test` | 3 pasan |
| `python` | `pytest` | 3 pasan |
| `r` | `make test` | 24 pasan |
| `racket` | `raco test -x .` | 24 pasan |
| `raku` | `prove6 -l t/` | 3 tests, PASS |
| `rescript` | `npm test` | 21 pasan |
| `rexx` | `rexx test/naive_sort_tests.rexx` | 24 aserciones, 0 fallos |
| `ruby` | `bundle exec rspec` | 3 ejemplos, 0 fallos |
| `rust` | `cargo test` | 3 pasan |
| `scala` | `sbt -batch test` | 3 pasan |
| `scheme` | `guile -s naive_sort_tests_guile.scm` | 24 pasan |
| `swift` | `swift test` | 3 XCTest, 0 fallos |
| `tcl-tk` | `tclsh9.0 naive_sort.test` | 21 pasan, 0 fallan |
| `typescript` | `npm test` | 24 pasan |
| `v` | `v test .` | 1 archivo, pasa |
| `vala` | `valac … && /tmp/…` | 3 ok |
| `zig` | `zig build test` | rc=0, sin fallos |
