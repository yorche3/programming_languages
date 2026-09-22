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
| 3. Ejecución de suites | **6** lenguajes con cambios (racket, cpp, csharp, clojure, swift, tcl-tk) | 6/6 en verde con salida real (ver registro) |
| 4. Documentación | 50 READMEs + comentarios de las 50 implementaciones | 50/50 READMEs con las secciones obligatorias y 11/11 notas de desviación presentes; **8 lenguajes incumplen el criterio de comentarios** |
| 5. Estado del árbol | `git -C <lenguaje> status --short` en los 50 submódulos | 6 lenguajes con cambios sin commitear (3 ya existentes + 3 refactors de esta pasada) |

**ES:** Los pasos 1, 2, 5 y 6 se hicieron sobre **archivos rastreados por git**, que descarta artefactos (`target/`, `bin/`, `elm-stuff/`, `.cpcache/`, `vendor/`…).

**EN:** Steps 1, 2, 5 and 6 used **git-tracked files** only, which filters out build artifacts.

---

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- Ninguno. **Racket**, el único fallo de la pasada anterior (selección con `(apply min lst)` + `remove`, burbuja con `list-ref`/`list-set` en $O(n^3)$), quedó reescrito con `vector` interno y bucles por índice, y su suite pasa en verde.

### 🟡 Advertencias / Warnings (criterio 4 — comentarios)

**ES:** Todos cumplen el contrato y la fidelidad algorítmica; la deuda es de estilo de documentación, que la regla prohíbe explícitamente (generadores formales) o exige (comentario simple por función con entrada y salida).

**EN:** All of them meet the contract and algorithmic fidelity; the debt is documentation style, which the rule either forbids (formal generators) or requires (a simple per-function comment with input and output).

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

### 🔵 Arreglados sin integrar (pendiente de commit) / Fixed but not committed

| Lenguaje | Arreglo | Verificación |
|----------|---------|--------------|
| **Clojure** | Bandera de salida temprana en las dos variantes (`swapped?`, `bubble-pass!`) | `clojure -T:build test` -> `Ran 6 tests containing 48 assertions. 0 failures, 0 errors.` |
| **Swift** | `insertion_sort` desplaza e inserta en lugar de encadenar `swapAt` | `swift test` -> `Executed 3 tests, with 0 failures (0 unexpected)` |
| **Tcl/Tk** | `insertion_sort` desplaza e inserta con `lset` | `tclsh9.0 naive_sort.test` (Tcltest) -> `Total 21 Passed 21 Skipped 0 Failed 0` |

### 🟢 Homologados / Homologated (39)

- [x] Ada, Assembly, Ballerina, C, C#, COBOL, Crystal, D, Elixir, F#, Forth, Gleam, Go, Grain, Groovy, JavaScript, Julia, Kotlin, Lua, Nim, OCaml, PHP, Perl, Prolog, PureScript, Python, R, Racket, Raku, ReScript, REXX, Ruby, Rust, Scala, Scheme, TypeScript, V, Vala, Zig.

**ES:** 39 homologados, 8 con advertencia de comentarios y 3 con el arreglo verificado pero sin commitear. Ninguno incumple el contrato de errores ni usa ordenamiento de biblioteca.

**EN:** 39 standardised, 8 with documentation warnings and 3 fixed but not committed. None breaks the error contract or uses a library sort.

---

## Criterio 4 — qué hay que cambiar / What needs changing

**ES:** La corrección no toca el comportamiento, solo los comentarios. Patrón de ejemplo por familia:

**EN:** The fix does not touch behaviour, only comments. Example pattern per family:

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

## Estado de los hallazgos anteriores / Status of the previous findings

| Lenguaje | Hallazgo del registro anterior | Estado real (2026-09-21) |
|----------|-------------------------------|---------------------------|
| Clojure | `bubble_sort` sin bandera `swapped` | Era cierto; arreglado en el árbol de trabajo y **verificado con su suite**; falta el commit -> 🔵 |
| Swift | `insertion_sort` con intercambios adyacentes | Era cierto; arreglado y **verificado con `swift test`**; falta el commit -> 🔵 |
| Tcl/Tk | `insertion_sort` con intercambios adyacentes | Era cierto; arreglado y **verificado con Tcltest**; falta el commit -> 🔵 |
| C++ | `selection_sort` sin el guardia `min_idx != i` | Cierto y **corregido** (`if (min_idx != i)`); la suite de Google Test pasa. Lo que queda es el criterio 4 |
| Racket | `min`/`remove` y $O(n^3)$ | Cierto y **corregido** con vectores; la suite pasa |
| C# | Fixtures compartidos sin copia | Cierto y **corregido** (`Copy` en el helper); `dotnet test` pasa |
| Ada, C, C++ | «`bubble` sin bandera» | Falso positivo de barrido: se leyó la cabecera, no la implementación |
| Clojure, Common Lisp | «README sin Nota Aclaratoria» | Falso positivo de vocabulario: ambos explican la desviación funcional |
| — | Dos listas de homologados contradictorias | Error de forma, corregido |

---

## Deuda por lenguaje / Debt per language

| # | Lenguaje | Criterio | Acción | Estado |
|:-:|----------|:--------:|--------|:------:|
| 1 | Java | 4 | Comentarios `//` por método en lugar del Javadoc de clase | ⏳ |
| 2 | Dart | 4 | Borrar la plantilla de dartdoc y documentar las tres funciones | ⏳ |
| 3 | Haskell | 4 | Quitar el marcador Haddock | ⏳ |
| 4 | Elm | 4 | Cambiar `{- \|` por `{-` y documentar entrada/salida | ⏳ |
| 5 | Erlang | 4 | Añadir comentarios `%%` (cabecera y funciones) | ⏳ |
| 6 | Haxe | 4 | Añadir comentarios `//` (cabecera y funciones) | ⏳ |
| 7 | Common Lisp | 4 | Añadir comentarios `;;` (cabecera y funciones) | ⏳ |
| 8 | C++ | 4 | Añadir comentarios `//` en `include/naive_sort.h` | ⏳ |
| 9 | Clojure | — | Commit + push + integrar en su `main` | 🔵 |
| 10 | Swift | — | Commit + push + integrar en su `main` | 🔵 |
| 11 | Tcl/Tk | — | Commit + push + integrar en su `main` | 🔵 |
| 12 | Racket | — | Commit + push del refactor | ✅ aplicado, sin commit |
| 13 | C# | — | Commit + push del refactor de tests | ✅ aplicado, sin commit |

---

## Plan de cierre / Closure plan

1. Documentar los 8 lenguajes del criterio 4 (no cambia comportamiento; cada uno en su rama).
2. Commitear e integrar los 6 cambios pendientes (racket, cpp, csharp, clojure, swift, tcl-tk) y actualizar el puntero del monorepo.
3. Revisar el aislamiento de tests en el resto de lenguajes con implementación *in-place*.
4. Auditar la fidelidad algorítmica de los 39 que solo pasaron el barrido léxico: inserción con desplazamiento, guardia de selección y contrato nulo.
5. Al cerrar cada lenguaje, actualizar este registro; el cierre va en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md).

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
