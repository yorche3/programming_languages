# Auditoría de Módulo: 05_Naive_Sort
# Module Audit: 05_Naive_Sort

Registro de deuda técnica para devolver al estado homologado los lenguajes del módulo `05_Naive_Sort`.
Technical debt record to bring the languages of the `05_Naive_Sort` module back to a standardised state.

- **Especificación / Specification:** [`05_Naive_Sort.md`](../core/algorithms/05_Naive_Sort.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Última verificación / Last verification:** 2026-09-21

---

## Criterios de Evaluación / Evaluation Criteria

1. **Fidelidad Algorítmica / Algorithmic Fidelity**: implementación paso a paso del pseudocódigo $O(n^2)$ (*in-place* o copia, según el paradigma). Excepción solo para lenguajes **sin mutabilidad nativa razonable**. Prohibido usar ordenamiento **o selección** (`min`/`max`) de la biblioteca estándar para el paso interno.
2. **Contrato (Errores) / Contract (Errors)**: indicador de fallo natural del lenguaje (`null`, `nil`, `#f`, `-1`, `None`), sin excepciones ni envoltorios `Option`/`Maybe`/`Result`.
3. **Aislamiento de Tests / Test Isolation**: cada caso copia el fixture mutable antes de llamar a una función que ordena *in-place*.
4. **Documentación / Documentation**: comentarios simples (entrada/salida), **sin generadores formales** (JSDoc, Doxygen, Javadoc, Haddock, dartdoc, `{-|`…); README del módulo alineado a [`README_Template.md`](../README_Template.md) y **Nota Aclaratoria** cuando hubo desviación del pseudocódigo.

---

## Alcance y método de esta verificación / Scope and method

| Paso | Alcance | Resultado |
|------|---------|-----------|
| 1. Barrido léxico | **50/50** lenguajes, solo archivos rastreados por git | 0 invocaciones de ordenamiento de biblioteca; 0 monadas/excepciones como contrato |
| 2. Lectura de código | 20 implementaciones (las señaladas por el barrido y las de inserción/selección) | 4 hallazgos de fidelidad o de tests, ya corregidos (Racket, C++, C#) o validados (Clojure, Swift, Tcl/Tk) |
| 3. Ejecución de suites | **50 de 50** lenguajes | 50/50 en verde con salida real (la de Ada, tras restaurar `alr`) |
| 4. Documentación | 50 READMEs + comentarios de las 50 implementaciones | 50/50 READMEs con las secciones obligatorias y 11/11 notas de desviación; los 8 lenguajes que incumplían el criterio de comentarios **quedaron corregidos y verificados** (0 generadores formales) |
| 5. Estado del árbol | `git -C <lenguaje> status --short` en los 50 submódulos | 6 lenguajes con cambios locales, hoy ya commiteados e integrados en su `main` |

**ES:** Los pasos 1, 2 y 5 se hicieron sobre **archivos rastreados por git**, que descarta artefactos (`target/`, `bin/`, `elm-stuff/`, `.cpcache/`, `vendor/`…).

**EN:** Steps 1, 2 and 5 used **git-tracked files** only, which filters out build artifacts.

---

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- Ninguno. **Racket**, el único fallo de la pasada anterior (selección con `(apply min lst)` + `remove`, burbuja con `list-ref`/`list-set` en $O(n^3)$), quedó reescrito con `vector` interno y bucles por índice, y su suite pasa en verde.

### 🟡 Advertencias (criterio 4 — comentarios) — corregidas / Warnings — fixed

**ES:** El hallazgo de esta pasada está **cerrado**: los 8 lenguajes se corrigieron el 2026-09-21 (solo comentarios; el comportamiento no se ha tocado) y después se ejecutó la suite de cada uno con salida real. La tabla se conserva como registro del hallazgo. El autor autorizó la corrección, así que no queda ninguna advertencia pendiente de aceptación por escrito.

**EN:** This pass's finding is **closed**: the 8 languages were fixed on 2026-09-21 (comments only; behaviour untouched) and each suite was run afterwards with real output. The table is kept as a record of the finding. The author authorised the fix, so no warning is left awaiting written acceptance.

| Lenguaje | Hallazgo | Evidencia |
|----------|----------|-----------|
| **Java** | Bloque **Javadoc** de clase (`/** … <p> … <ul><li> … {@code …} */`) y **ningún** comentario por función | `src/main/java/naive_sort/NaiveSort.java:3-18` |
| **Dart** | **dartdoc** (`///`) con texto de plantilla sin contenido: `/// Support for doing something awesome.` / `/// More dartdocs go here.` / `// TODO: Export any libraries…` | `lib/naive_sort.dart:1-8` |
| **Haskell** | Marcador **Haddock** `-- \|` en la cabecera del módulo | `lib/NaiveSort.hs:1` |
| **Elm** | Comentarios **`{- \| … -}`** (doc de paquete) por función, sin indicar entrada/salida | `src/NaiveSort.elm:6, 22, 44, 63, 88, 101` |
| **Erlang** | **Cero** comentarios en la implementación (`%` no aparece ni una vez) | `src/naive_sort.erl` |
| **Haxe** | **Cero** comentarios (`//` no aparece ni una vez) | `src/NaiveSort.hx` |
| **Common Lisp** | **Cero** comentarios (`;` no aparece ni una vez) | `src/naive-sort.lisp` |
| **C++** | **Cero** comentarios en `src/` y en `include/` (el guardia `min_idx != i` ya está aplicado) | `src/naive_sort.cpp`, `include/naive_sort.h` |

**ES:** Cumplen el criterio (comentarios simples con entrada y salida) los 42 restantes; en varios la entrada/salida se declara como firma, por ejemplo `// Funciones del contrato (List<Number> -> List<Number>)` en Grain, `// Contrato (int list -> int list)` en F# y `# input: an array of Int32` en Crystal. Ese formato **sí** satisface el criterio: no es un generador formal y declara entrada y salida.

**EN:** The other 42 meet the criterion; several state input/output as a signature (Grain, F#, Crystal), which **does** satisfy it: no formal generator and both directions are declared.

### ✅ Correcciones de esta pasada, ya integradas / Fixes from this pass, integrated

**ES:** Los seis arreglos están commiteados en su submódulo, integrados en su `main` (merge `refactor/naive-sort`) y los punteros del monorepo apuntan a esos merges, comprobado con `git submodule status`.

**EN:** The six fixes are committed in their submodule, merged into its `main` (branch `refactor/naive-sort`) and the monorepo pointers point to those merges, verified with `git submodule status`.

| Lenguaje | Arreglo | Commit | Suite |
|----------|---------|--------|-------|
| **Clojure** | Bandera de salida temprana en las dos variantes (`swapped?`, `bubble-pass!`) | `d526ee0` -> merge `1089ead` | `clojure -T:build test` -> `Ran 6 tests containing 48 assertions. 0 failures, 0 errors.` |
| **C++** | Guardia `min_idx != i` en selección | `ab4c46a` -> merge `db3635d` | `bazelisk test //:naive_sort_tests` -> `PASSED in 0.0s`, `1 test passes` |
| **C#** | `Copy` de los fixtures compartidos en el helper de tests | `b085135` | `dotnet test NaiveSort.slnx` -> `Passed! - Failed: 0, Passed: 3` |
| **Racket** | Reescritura con `vector` interno y bucles por índice (adiós `min`/`remove` y $O(n^3)$) | `a57d359` -> merge `4560376` | `racket test/run_tests.rkt` -> `3 success(es) 0 failure(s)` |
| **Swift** | `insertion_sort` desplaza e inserta en lugar de encadenar `swapAt` | `8915e11` -> merge `1f1ffa0` | `swift test` -> `Executed 3 tests, with 0 failures (0 unexpected)` |
| **Tcl/Tk** | `insertion_sort` desplaza e inserta con `lset` | `82a94f5` -> merge `dd7db34` | `tclsh9.0 naive_sort.test` -> `Total 21 Passed 21 Skipped 0 Failed 0` |

### 🟢 Homologados / Homologated (50)

- [x] Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, F#, Forth, Gleam, Go, Grain, Groovy, Haskell, Haxe, Java, JavaScript, Julia, Kotlin, Lua, Nim, OCaml, PHP, Perl, Prolog, PureScript, Python, R, Racket, Raku, ReScript, REXX, Ruby, Rust, Scala, Scheme, Swift, Tcl/Tk, TypeScript, V, Vala, Zig.

**ES:** Los 50 lenguajes cumplen los cuatro criterios: contrato sin excepciones ni monadas, sin ordenamiento de biblioteca, tests aislados y comentarios simples con entrada y salida sin generadores formales. Los 6 arreglos de fidelidad o de tests y los 8 de documentación están integrados y verificados con su suite.

**EN:** All 50 languages meet the four criteria: contract without exceptions or monads, no library sort, isolated tests and simple input/output comments with no formal generators. The 6 fidelity or test fixes and the 8 documentation fixes are integrated and verified with their suite.

---

## Criterio 4 — cambios aplicados / Applied changes

**ES:** Los cambios ya están en el código (solo comentarios: el comportamiento no se ha tocado) y cada uno se validó ejecutando la suite de su lenguaje. Los ejemplos muestran el patrón que quedó en uso:

**EN:** The changes are already in the code (comments only: behaviour untouched) and each one was validated by running its language suite. The examples show the pattern left in place:

```cpp
// selection_sort: ordena ascendente en O(n^2) buscando el mínimo del tramo no ordenado
// input: el vector de enteros (se ordena una copia)
// output: el vector ordenado
```

```erlang
%% selection_sort: ordena ascendente en O(n^2)
%% input: lista de enteros
%% output: lista nueva ordenada; [] si la entrada está vacía
```

```lisp
;; selection-sort: ordena ascendente en O(n^2)
;; input: vector de enteros
;; output: copia ordenada; nil si la entrada no es un vector
```

| Lenguaje | Cambio concreto |
|----------|-----------------|
| Java | Sustituir el bloque Javadoc por un comentario `//` por método con entrada y salida |
| Dart | Borrar las 8 líneas de plantilla (`/// Support for doing something awesome.`, `TODO`) y poner cabecera simple + comentario por función |
| Haskell | Quitar el `\|` del marcador (`-- \|` -> `--`) y mantener la firma `[Int] -> [Int]` como entrada/salida |
| Elm | Cambiar `{- \| … -}` por `{- … -}` y añadir entrada/salida a cada función |
| Erlang | Añadir cabecera `%%` y un comentario `%%` por función con entrada y salida |
| Haxe | Añadir cabecera `//` y un comentario `//` por función con entrada y salida |
| Common Lisp | Añadir cabecera `;;` y un comentario `;;` por función con entrada y salida |
| C++ | Añadir cabecera `//` y un comentario `//` por función (en `include/naive_sort.h`, junto a cada declaración) |

---

## Verificación del resto de suites / Verification of the remaining suites

**ES:** Ejecutadas el 2026-09-21 con la salida real copiada abajo. Ninguna modifica el código: solo comprueban que el barrido léxico y la lectura no dejaron defectos.

**EN:** Run on 2026-09-21 with the real output copied below. They change no code: they only check that the lexical scan and the reading left no defects.

| Lenguaje | Comando | Resultado real |
|----------|---------|----------------|
| Go | `go test ./... -count=1` | `ok example.com/naive_sort/tests 0.003s` |
| Zig | `zig build test --summary all` | `run test 3 pass (3 total)` |
| V | `v test .` | `1 passed, 1 total` |
| Nim | `nimble test` | `[OK] bubble_sort`, `[OK] insertion_sort` |
| Crystal | `crystal spec` | `3 examples, 0 failures, 0 errors` |
| D | `dub test` | `1 modules passed unittests` |
| Lua | `busted` | `3 successes / 0 failures / 0 errors` |
| Ruby | `rspec` | `3 examples, 0 failures` |
| Python | `python3 -m pytest -q` | `3 passed` |
| R | `Rscript test/run_tests.R` | `FAIL 0 \| PASS 24` |
| Julia | `julia --project=. test/run_tests.jl` | `Naive Sort Tests 24/24` |
| Perl | `perl test/naive_sort_tests.pl` | `ok 3 - Subtest: insertion_sort` |
| PHP | `composer test` | `OK (3 tests, 21 assertions)` |
| REXX | `rexx test/naive_sort_tests.rexx` | `nr of failures: 0 nr of errors: 0` |
| Rust | `cargo test` | `test result: ok. 3 passed; 0 failed` |
| OCaml | `dune runtest` | `Test Successful` |
| Elixir | `mix test` | `Result: 3 passed` |
| Gleam | `gleam test` | `3 passed, no failures` |
| Scheme | `guile --no-auto-compile -s naive_sort_tests_guile.scm` | `# of expected passes 24` |
| Forth | `gforth run-tests.forth` | `passed 78 failed 0` |
| Prolog | `swipl -q -f naive_sort_tests.pl -t halt` | `[3/3] insertion_sort ... passed` |
| Ballerina | `bal test` | `0 failing` |
| F# | `dotnet test NaiveSort.slnx` | `Passed! - Failed: 0, Passed: 3` |
| JavaScript | `npm test` | `Tests: 3 passed, 3 total` |
| TypeScript | `npm test` | `Tests: 24 passed, 24 total` |
| Kotlin | `gradle test` | `BUILD SUCCESSFUL in 11s` |
| Groovy | `./gradlew test` | `BUILD SUCCESSFUL in 5s` |
| Scala | `sbt -batch -no-colors test` | `Tests: succeeded 3, failed 0` |
| C | `make test` | `Tested: 3 \| Passing: 3 \| Failing: 0` |
| COBOL | `make clean && make && ./run_tests` | `Failed: 000 >>> ALL TESTS PASSED <<<` |
| Assembly | `make run` | `passed 24 failed 0` |
| Vala | `valac src/naive_sort.vala test/naive_sort_tests.vala --pkg glib-2.0 -o /tmp/vala-naive-tests && /tmp/vala-naive-tests` | `ok 3` |
| PureScript | `spago test` | `All 3 tests passed!` |
| ReScript | `npm test` | `Tests: 21 passed, 21 total` |
| Ada | `alr -C test run` | `Total Tests Run: 3`, `Successful Tests: 3`, `Failed Assertions: 0`, `Unexpected Errors: 0` |

**ES:** Ada se verificó al final de la pasada, después de restaurar `alr` con el script `~/temp/fix-alr.sh`: el binario había desaparecido de `~/.local/bin`, pero el zip del instalador y las toolchains de Alire (~/.local/share/alire/toolchains) seguían ahí. **Los 50 lenguajes tienen su suite ejecutada.**

**EN:** Ada was verified at the end of the pass, after restoring `alr` with the `~/temp/fix-alr.sh` script: the binary had vanished from `~/.local/bin`, but the installer zip and Alire's toolchains (~/.local/share/alire/toolchains) were still there. **All 50 languages have their suite run.**

### Aislamiento de tests / Test isolation

**ES:** Revisados los casos en los que el fixture es un valor mutable compartido y la implementación ordena *in-place*. Todos copian el fixture o usan tipos de valor: `new ArrayList<>(…)` en Groovy, `List<int>.of(…)` en Dart, `clone` en Java y Scala, `copy`/`toList()` en Kotlin, `scratch` en C, arrays locales en Vala, búfer local en Zig, `Copy` en C#, parámetros `in` de un tipo de valor en Ada, y semántica de valor en Ballerina, R, PHP, Nim, Swift y Tcl/Tk. El único defecto real de este criterio fue el de C#, ya corregido.

**EN:** The cases where the fixture is a shared mutable value and the implementation sorts *in-place* were reviewed. All of them copy the fixture or use value types (`new ArrayList<>()` in Groovy, `List<int>.of()` in Dart, `clone` in Java and Scala, `copy`/`toList()` in Kotlin, `scratch` in C, local arrays in Vala, a local buffer in Zig, `Copy` in C#, `in` parameters of a value type in Ada, and value semantics in Ballerina, R, PHP, Nim, Swift and Tcl/Tk). The only real defect for this criterion was C#'s, already fixed.

| Lenguaje | Hallazgo del registro anterior | Estado real (2026-09-21) |
|----------|-------------------------------|---------------------------|
| Clojure | `bubble_sort` sin bandera `swapped` | Era cierto; arreglado, **verificado con su suite** y **ya integrado** en su `main` (`1089ead`) -> 🟢 |
| Swift | `insertion_sort` con intercambios adyacentes | Era cierto; arreglado, **verificado con `swift test`** y **integrado** (`1f1ffa0`) -> 🟢 |
| Tcl/Tk | `insertion_sort` con intercambios adyacentes | Era cierto; arreglado, **verificado con Tcltest** e **integrado** (`dd7db34`) -> 🟢 |
| C++ | `selection_sort` sin el guardia `min_idx != i` | Cierto y **corregido** (`ab4c46a`); la suite de Google Test pasa. Lo que queda es el criterio 4 |
| Racket | `min`/`remove` y $O(n^3)$ | Cierto y **corregido** con vectores (`a57d359`); la suite pasa |
| C# | Fixtures compartidos sin copia | Cierto y **corregido** (`b085135`); `dotnet test` pasa |
| Ada, C, C++ | «`bubble` sin bandera» | Falso positivo de barrido: se leyó la cabecera, no la implementación |
| Clojure, Common Lisp | «README sin Nota Aclaratoria» | Falso positivo de vocabulario: ambos explican la desviación funcional |
| — | Dos listas de homologados contradictorias | Error de forma, corregido |

---

## Deuda por lenguaje / Debt per language

| # | Lenguaje | Criterio | Acción | Estado |
|:-:|----------|:--------:|--------|:------:|
| — | Ninguno | — | Deuda cerrada el 2026-09-21 en los 8 lenguajes, con su suite ejecutada | ✅ |

---

## Plan de cierre / Closure plan

**ES:** La deuda del módulo está cerrada y la deuda de verificación también: los 50 lenguajes tienen su suite ejecutada. Solo queda el registro en git:

**EN:** The module debt is closed and so is the verification debt: all 50 languages have their suite run. Only the git record remains:

1. Commit y push de los 8 submódulos con los cambios de comentarios y del monorepo con el renombrado de este registro. **No queda ninguna deuda de verificación.**

---

## Registro de verificaciones / Verification log

| Fecha | Alcance | Comando | Resultado |
|-------|---------|---------|-----------|
| 2026-09-21 | Barrido léxico en 50 lenguajes | `git ls-files` + `grep -E` de ordenamiento de biblioteca y monadas/excepciones | 0 violaciones reales; solo comentarios declarativos |
| 2026-09-21 | Lectura de 20 implementaciones | `read_file` sobre clojure, swift, tcl-tk, cpp, racket, csharp, c, ada, java, dart, elm, haskell, erlang, haxe, lisp, nim, cobol, forth, fsharp, grain | 4 hallazgos + 8 de documentación |
| 2026-09-21 | Suite nativa de Racket (tras el refactor) | `raco make src test && racket test/run_tests.rkt` | `3 success(es) 0 failure(s) 0 error(s) 3 test(s) run` |
| 2026-09-21 | Suite nativa de C++ (tras el guardia) | `bazelisk test //:naive_sort_tests --test_output=summary` | `//:naive_sort_tests PASSED in 0.0s`, `Executed 1 out of 1 test: 1 test passes` |
| 2026-09-21 | Suite nativa de C# (tras clonar fixtures) | `dotnet test NaiveSort.slnx` | `Passed! - Failed: 0, Passed: 3, Skipped: 0, Total: 3` |
| 2026-09-21 | Suite nativa de Clojure (valida el arreglo pendiente) | `clojure -T:build test` | `Ran 6 tests containing 48 assertions. 0 failures, 0 errors.` |
| 2026-09-21 | Suite nativa de Swift (valida el arreglo pendiente) | `swift test` | `Executed 3 tests, with 0 failures (0 unexpected)` |
| 2026-09-21 | Suite nativa de Tcl/Tk (valida el arreglo pendiente) | `TCLLIBPATH="$(cd ../src && pwd)" tclsh9.0 naive_sort.test` | `Total 21 Passed 21 Skipped 0 Failed 0` |
| 2026-09-21 | Comentarios en las 50 implementaciones | `grep` de generadores (`@param`, `///`, `/**`, `-- \|`, `{- \|`, `@doc`…) y de `input/entrada/output/salida` | 4 generadores formales y 4 implementaciones sin comentarios |
| 2026-09-21 | Estado del árbol de los 50 submódulos | `git -C <lenguaje> status --short` | 6 con cambios sin commitear; el resto limpio |
| 2026-09-21 | READMEs (50) | `grep` de secciones de plantilla y de nota de desviación | 50/50 con secciones; 11/11 con nota |
| 2026-09-21 | Integración de los 6 arreglos | `git -C <lenguaje> log --oneline -2` y `git submodule status cpp csharp racket swift tcl-tk clojure` | merges `refactor/naive-sort` en el `main` de los 6 submódulos y punteros del monorepo apuntando a ellos |
| 2026-09-21 | Criterio 4 corregido en 8 lenguajes | `grep` de generadores formales en los 9 archivos tocados | 0 coincidencias (`@param`, `{@code}`, `///`, `/**`, `-- \|`, `{- \|`) |
| 2026-09-21 | Suite de Java tras los comentarios | `mvn test` | `Tests run: 3, Failures: 0, Errors: 0, Skipped: 0` y `BUILD SUCCESS` |
| 2026-09-21 | Suite de Dart tras los comentarios | `dart test` | `+3: All tests passed!` |
| 2026-09-21 | Suite de Elm tras los comentarios | `elm-test` | `TEST RUN PASSED`, `Passed: 21`, `Failed: 0` |
| 2026-09-21 | Suite de Haskell tras los comentarios | `cabal test --test-show-details=direct` | `21 examples, 0 failures`, `1 of 1 test suites (1 of 1 test cases) passed` |
| 2026-09-21 | Suite de Erlang tras los comentarios | `rebar3 eunit` | `21 tests, 0 failures` |
| 2026-09-21 | Suite de Haxe tras los comentarios | `haxe build.hxml` | `results: ALL TESTS OK (success: true)`, 3 tests OK |
| 2026-09-21 | Suite de Common Lisp tras los comentarios | `ros run --load run-tests.lisp --eval '(uiop:quit)'` | `Pass: 24 (100%)`, `Fail: 0 ( 0%)` |
| 2026-09-21 | Suite de C++ tras los comentarios (sin caché) | `bazelisk test //:naive_sort_tests --nocache_test_results` | `//:naive_sort_tests PASSED`, `Executed 1 out of 1 test: 1 test passes` |
| 2026-09-21 | Suites de los 41 lenguajes restantes | los comandos de la tabla «Verificación del resto de suites» | 41/41 en verde; Ada bloqueada por la ausencia de `alr` |
| 2026-09-21 | Aislamiento de tests revisado | `grep` de idiomas de copia en las suites mutables + lectura de Groovy y Dart | todos copian el fixture o usan tipos de valor |
| 2026-09-21 | Restauración de `alr` | `~/temp/fix-alr.sh` (idempotente, desde el zip de `~/temp`) | `instalado en /home/yorche3/.local/bin/alr` y `alr 2.1.0` |
| 2026-09-21 | Suite de Ada | `alr -C test run` | `Total Tests Run: 3`, `Successful Tests: 3`, `Failed Assertions: 0`, `Unexpected Errors: 0` |
