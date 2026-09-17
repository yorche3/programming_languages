# Roadmap Update Checklist / Registro de cierre

Este archivo registra los cierres que autorizan una actualización de
`docs/ROADMAP.md`. Es parte del flujo de documentación: una delegación no está
finalizada hasta que el registro y el roadmap reflejan el mismo estado.

## Regla de cierre / Completion rule

Para cerrar un módulo, comprobar código, tests y README. Para cerrar una fase,
comprobar además todos sus módulos requeridos. Solo después se cambia el estado
en `ROADMAP.md`.

Cada entrada debe incluir la fecha, la fase, el módulo o conjunto de módulos,
los lenguajes verificados, los comandos ejecutados y el cambio de estado
realizado en el roadmap. No se deben inventar resultados.

## Plantilla de registro / Entry template

```text
Fecha / Date: YYYY-MM-DD
Fase / Phase: core.<phase>
Módulo(s) / Module(s): core.<phase>.<module>
Lenguaje(s) / Language(s): language-a, language-b
Código verificado / Code verified: yes/no
Tests y comandos / Tests and commands:
- `command` -> result
README(s) verificado(s) / README(s) verified: yes/no
Cambio en ROADMAP.md / ROADMAP.md change: old status -> new status
Observaciones / Notes:
```

## Pendientes / Pending closures

Añadir aquí una entrada cuando una delegación termina la implementación y la
generación de documentación, antes de actualizar el estado correspondiente en
`ROADMAP.md`.

## Historial / History

<!-- Las entradas cerradas se conservan debajo con su fecha y evidencia. -->

Fecha / Date: 2026-09-11
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): ada
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `alr -C test run` en `ada/core/algorithms/naive_sort` -> 3 tests ejecutados, 3 exitosos, 0 aserciones fallidas, 0 errores inesperados
README(s) verificado(s) / README(s) verified: yes (`ada/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 📋 -> 🔄 (1/49)
Observaciones / Notes: Primera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. En Ada no existe representación de array nulo, por lo que el escenario inválido de la especificación queda documentado como no representable.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): assembly
Código verificado / Code verified: yes (bugs corregidos: sintaxis GAS en vez de NASM, `rsi`/`esi` reutilizado para la bandera `swapped` en bubble_sort, límite fuera de uno en el bucle interno de bubble_sort, `rbx` sin preservar, `rax` sin fijar en los casos vacío/un elemento)
Tests y comandos / Tests and commands:
- `make run` en `assembly/core/algorithms/naive_sort` -> 24 tests ejecutados, 24 exitosos, 0 fallidos
README(s) verificado(s) / README(s) verified: yes (`assembly/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 1/49 (Ada) -> 2/49 (Ada, Assembly)
Observaciones / Notes: Segunda implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. A diferencia de Ada, en Assembly el array es un puntero crudo, por lo que `null` sí es representable; se añadió un octavo caso de prueba (puntero nulo) además de los 7 del enunciado.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): ballerina
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `bal test` en `ballerina/core/algorithms/naive_sort` -> 3 tests ejecutados, 3 exitosos, 0 fallidos (24 aserciones)
- Prueba negativa: con `insertionSort` invertido -> 2 passing, 1 failing, confirmando que la suite detecta fallos
README(s) verificado(s) / README(s) verified: yes (`ballerina/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 2/49 (Ada, Assembly) -> 3/49 (Ada, Assembly, Ballerina)
Observaciones / Notes: Tercera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Ballerina no admite `int[]` nulo, pero sí el tipo nillable `int[]?`, que se usa como indicador de fallo; se añadió el octavo caso (`()`). El clonado es responsabilidad de la implementación, por lo que los fixtures compartidos se pasan como entradas de solo lectura sin clonar en el test.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): c
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `make test` en `c/core/algorithms/naive_sort` (compilación limpia, sin warnings con `-Wall -Wextra -std=c99`) -> `Tested: 3 | Passing: 3 | Failing: 0 | Crashing: 0` (24 aserciones)
- Prueba negativa: con la comparación de `insertion_sort` invertida -> `Passing: 2 | Failing: 1`, confirmando que la suite detecta fallos
README(s) verificado(s) / README(s) verified: yes (`c/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 3/49 (Ada, Assembly, Ballerina) -> 4/49 (Ada, Assembly, Ballerina, C)
Observaciones / Notes: Cuarta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. En C el ordenamiento es in-place (paradigma del lenguaje, permitido por la especificación); el indicador de fallo es `NULL` y se añadió el octavo caso (`arr = NULL`). Las pruebas copian cada fixture a un buffer `scratch` con `memcpy` porque los fixtures son `const` y compartidos entre los tres algoritmos.

Fecha / Date: 2026-09-12
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): clojure
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `clojure -T:build test` en `clojure/core/algorithms/naive_sort` -> `Ran 3 tests containing 24 assertions. 0 failures, 0 errors.`
- Verificación previa en copia desechable fuera del repositorio, para no tocar `src/` durante la generación de tests: implementación funcional correcta -> 0 failures; implementación rota a propósito -> 3 failures con mensajes como `insertion-sort should sort negative values`
README(s) verificado(s) / README(s) verified: yes (`clojure/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 4/49 (Ada, Assembly, Ballerina, C) -> 5/49 (Ada, Assembly, Ballerina, C, Clojure)
Observaciones / Notes: Quinta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. La realización difiere de la establecida en la especificación: Clojure es funcional y su idioma evita la mutación, así que las tres funciones devuelven siempre una colección nueva en lugar de ordenar in-place; el concepto algorítmico es el mismo. El indicador de fallo es `nil` (valor válido en Clojure) y se añadió el octavo caso. El runner nativo ya existía (`build.clj` -> `cognitect.test-runner`), por lo que no se generó un archivo de ejecución aparte.

Fecha / Date: 2026-09-13
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): cobol
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `make clean && make && ./run_tests` en `cobol/core/algorithms/naive_sort` -> 78 tests ejecutados, 78 exitosos, 0 fallidos
README(s) verificado(s) / README(s) verified: yes (`cobol/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 5/49 (Ada, Assembly, Ballerina, C, Clojure) -> 6/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL)
Observaciones / Notes: Sexta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. COBOL es un lenguaje orientado a procedimientos que no soporta recursión de forma natural. Todos los algoritmos se implementaron de manera iterativa. El manejo de arrays se realiza mediante estructuras con cláusulas OCCURS. La implementación sigue el patrón de devolver un código de retorno (RETURN-CODE) para indicar éxito o fracaso.

Fecha / Date: 2026-09-13
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): common-lisp
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `ros run --load run-tests.lisp --eval '(uiop:quit)'` en `common-lisp/core/algorithms/naive_sort` -> `Running test suite NAIVE-SORT-SUITE ... Did 24 checks. Pass: 24 (100%) Skip: 0 (0%) Fail: 0 (0%)`
- `(asdf:test-system :naive-sort)` (vía ASDF) -> mismos resultados, 24 checks
- Prueba negativa: con la comparación de la suite devolviendo siempre `nil` -> 24 fallos, confirmando que la suite detecta fallos
README(s) verificado(s) / README(s) verified: yes (`common-lisp/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 6/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL) -> 7/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp)
Observaciones / Notes: Séptima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. La realización difiere del pseudocódigo por convención del lenguaje: Common Lisp es funcional y su idioma evita la mutación, así que las tres funciones devuelven una copia ordenada en lugar de ordenar in-place (la especificación permite ambas variantes). El indicador de fallo es `nil` (valor válido en Common Lisp) y se añadió el octavo caso controlado (`nil` -> `nil`), ya que el lenguaje puede representarlo. El sistema base no tiene dependencias externas; se eliminó `alexandria`, que estaba declarada pero sin usar, y `fiveam` se usa solo en el sistema de pruebas. Las aserciones usan `equalp` en vez de `equal`, porque `equal` no compara vectores generales elemento a elemento. El runner nativo funciona con `(asdf:test-system :naive-sort)` gracias al `test-op` declarado en `naive-sort.asd`.

Fecha / Date: 2026-09-13
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): cpp
Código verificado / Code verified: yes (mitigación aplicada: `bubble_sort` no incluía la salida temprana con bandera `swapped` exigida por los criterios de aceptación; se añadió y se re-verificó)
Tests y comandos / Tests and commands:
- `bazelisk test //...` en `cpp/core/algorithms/naive_sort` -> `[==========] 3 tests from 1 test suite ran. [  PASSED  ] 3 tests.` (21 aserciones: 7 casos × 3 algoritmos)
- `g++ -std=c++17 -Wall -Wextra -Wpedantic -Iinclude -c src/naive_sort.cpp` -> sin warnings
README(s) verificado(s) / README(s) verified: yes (`cpp/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 7/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp) -> 8/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp, C++)
Observaciones / Notes: Octava implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Verificación previa al README: se comparó la implementación con el pseudocódigo y se detectó que `bubble_sort` omitía la salida temprana con bandera `swapped` (criterio de aceptación de `05_Naive_Sort.md`), lo que degradaba el mejor caso a O(n²); se notificó al desarrollador y se mitigó antes de generar el README. Las demás divergencias no son funcionales: las funciones reciben el vector por valor y devuelven una copia ordenada (la especificación permite in-place o copia), y `selection_sort` siempre intercambia, lo que equivale al guardas `if (min_idx != i)` del pseudocódigo. El caso nulo no es representable con `std::vector<int>` por valor; se documenta como no representable y se conservan los 7 casos canónicos. La implementación compila sin warnings con `-Wall -Wextra -Wpedantic`.

Fecha / Date: 2026-09-13
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): crystal
Código verificado / Code verified: yes (corrección aplicada: eliminado `return nil if arr.nil?` de los tres algoritmos y corregida la sintaxis de lambda en tests)
Tests y comandos / Tests and commands:
- `crystal spec` en `crystal/core/algorithms/naive_sort` -> 3 tests ejecutados, 3 exitosos, 0 fallidos (21 aserciones: 7 casos × 3 algoritmos)
- `crystal build src/naive_sort.cr` -> sin warnings ni errores
README(s) verificado(s) / README(s) verified: yes (`crystal/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 8/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp, C++) -> 9/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp, C++, Crystal)
Observaciones / Notes: Novena implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Crystal es un lenguaje orientado a objetos con tipado estático inferido. Los tres algoritmos operan in-place sobre el array recibido (paradigma imperativo del lenguaje, permitido por la especificación). El tipo `Array(Int32)` no permite `nil`, por lo que el caso de entrada nula no es representable y se documenta como tal. Todos los algoritmos usan iteración (bucles `each`, `loop`, `while`) siguiendo el estilo idiomático de Crystal, que no garantiza TCO. Las pruebas usan el framework estándar `spec` de Crystal y clonan los fixtures con `.dup` para evitar efectos secundarios al ordenar in-place.

Fecha / Date: 2026-09-14
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): csharp
Código verificado / Code verified: yes (mitigación aplicada: las firmas de `SelectionSort`, `BubbleSort` e `InsertionSort` declaraban `int[]` no anulable pese a comprobar `arr == null`, lo que producía `CS8603` en `src/` y `CS8622` al pasar los métodos a `Func<int[]?, int[]?>` en los tests; se cambiaron parámetro y retorno a `int[]?` y se re-verificó)
Tests y comandos / Tests and commands:
- `dotnet build NaiveSort.slnx` en `csharp/core/algorithms/naive_sort` -> build correcto, 0 warnings, 0 errores
- `dotnet test NaiveSort.slnx` -> `Test summary: total: 3, failed: 0, succeeded: 3, skipped: 0, duration: 0.7s` (24 aserciones: 8 casos × 3 algoritmos)
README(s) verificado(s) / README(s) verified: yes (`csharp/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 9/49 (Ada, Assembly, Ballerina, C, Clojure, COBOL, Common Lisp, C++, Crystal) -> 10/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal)
Observaciones / Notes: Décima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. C# tiene los *nullable reference types* habilitados (`<Nullable>enable</Nullable>`), por lo que el indicador de fallo `null` exige declarar parámetro y retorno como `int[]?`; se añadió el octavo caso controlado (`null` -> `null`). Los tres algoritmos ordenan in-place (paradigma imperativo, permitido por la especificación). La clase se llama `NaiveSortImpl` para no chocar con el namespace `NaiveSort`. El runner es `dotnet test` sobre la solución `.slnx`; no se generó un archivo de ejecución aparte porque .NET descubre automáticamente los `[Fact]`. Se añadió `.gitignore` del módulo, pero permanecen 25 archivos `bin/`/`obj/` ya rastreados en el índice anteriores a su creación.

Fecha / Date: 2026-09-14
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): d
Código verificado / Code verified: yes
Tests y comandos / Tests and commands:
- `dub test` en `d/core/algorithms/naive_sort` -> `1 modules passed unittests` (3 bloques `unittest`, 24 aserciones: 8 casos × 3 algoritmos)
- `dmd -c -o- -w -wi source/naive_sort.d` -> sin salida, exit 0 (compila sin warnings)
README(s) verificado(s) / README(s) verified: yes (`d/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 10/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal) -> 11/49 (…, C++, Crystal, D)
Observaciones / Notes: Undécima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Los arrays de D son *slices* (puntero + longitud), por lo que `null` es representable y se añadió el octavo caso (`null` -> `null`). Los tres algoritmos ordenan in-place sobre el slice recibido (idiomático en D). `insertionSort` usa `size_t` y la variante de desplazamiento `while (j > 0 && arr[j - 1] > key)`, equivalente al pseudocódigo sin índice con signo. El paquete se configuró como `targetType "library"` y se eliminó el `source/app.d` generado por `dub init` porque su `void main()` choca con el runner de `dub test` (`only one entry point 'main' is allowed`). Los fixtures del test son `static immutable` y cada caso ordena una copia con `.dup`.

Fecha / Date: 2026-09-14
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): dart
Código verificado / Code verified: yes (mitigación aplicada: el scaffold de `dart create` en `example/naive_sort_example.dart` seguía referenciando la clase `Awesome`, eliminada al implementar `NaiveSort`, y hacía fallar `dart analyze` con `undefined_function`; se actualizó el ejemplo a una llamada real a `NaiveSort.selectionSort`)
Tests y comandos / Tests and commands:
- `dart test` en `dart/core/algorithms/naive_sort` -> `00:00 +3: All tests passed!` (3 tests, 8 casos × 3 algoritmos = 24 aserciones)
- `dart analyze` -> `No issues found!` (exit 0)
README(s) verificado(s) / README(s) verified: yes (`dart/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 11/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D) -> 12/49 (…, D, Dart)
Observaciones / Notes: Duodécima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. El parámetro y el retorno son `List<int>?` porque `null` es el indicador de fallo del lenguaje, y se añadió el octavo caso (`null` -> `null`). Los tres algoritmos ordenan in-place sobre la lista recibida (idiomático en Dart). La clase `NaiveSort` agrupa métodos `static`, siguiendo la convención de `Numbers` en `numbers/`. Los fixtures del test son `const` y cada caso ordena una copia con `List<int>.of`, evitando que la mutación in-place contamine los demás casos o falle contra una lista inmutable. `dart analyze` usa `package:lints/recommended.yaml` vía `analysis_options.yaml`.

Fecha / Date: 2026-09-14
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): elixir
Código verificado / Code verified: yes (mitigaciones aplicadas: en `lib/naive_sort.ex:38`, `{swapped, rest} = bubble_pass([a | tail])` declaraba una variable `swapped` sin usar, que hacía fallar `mix compile --warnings-as-errors`; se renombró a `_swapped`. Además `lib/naive_sort.ex` no cumplía `mix format --check-formatted` por líneas en blanco sobrantes; se aplicó `mix format`)
Tests y comandos / Tests and commands:
- `mix compile --force --warnings-as-errors` en `elixir/core/algorithms/naive_sort` -> `Compiling 1 file (.ex)` y `Generated naive_sort app` (exit 0, 0 warnings)
- `mix format --check-formatted` -> sin archivos pendientes (exit 0)
- `mix test` -> `Finished in 0.01 seconds (0.00s async, 0.01s sync)` y `Result: 3 passed` (3 tests, 8 casos × 3 algoritmos = 24 aserciones)
README(s) verificado(s) / README(s) verified: yes (`elixir/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 12/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart) -> 13/49 (…, D, Dart, Elixir)
Observaciones / Notes: Decimotercera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Elixir no tiene bucles imperativos ni listas mutables, así que los tres algoritmos son recursivos y devuelven una lista nueva: el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` de `bubble_sort` se conserva como el valor de retorno de `bubble_pass/1`, que empaqueta `{swapped, lista}`, manteniendo la salida temprana. `nil` es el indicador de fallo y se retorna como valor, con el octavo caso `assert sort_function.(nil) == nil`. Los casos base `[]` y `[a]` se resuelven por cláusulas en lugar de un `if n <= 1`. Ubicación desviada de la especificación: el código va en `lib/` (convención de Mix) y no hay `run_tests.exs` porque ExUnit incorpora su propio runner vía `mix test`. El índice de fase `elixir/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): elm
Código verificado / Code verified: yes (mitigación aplicada: el listado `exposing` de `src/NaiveSort.elm` estaba sin cerrar, lo que producía `UNFINISHED EXPOSING` y hacía fallar `elm make` y `elm-test` con exit 1; se añadió el paréntesis de cierre)
Tests y comandos / Tests and commands:
- `elm make src/NaiveSort.elm --output=/dev/null` en `elm/core/algorithms/naive_sort` -> `Success! Compiled 1 module.` (exit 0)
- `elm-test` -> `TEST RUN PASSED`, `Duration: 117 ms`, `Passed: 21`, `Failed: 0` (3 algoritmos × 7 casos)
README(s) verificado(s) / README(s) verified: yes (`elm/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 13/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir) -> 14/49 (…, Elixir, Elm)
Observaciones / Notes: Decimocuarta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Elm no tiene bucles imperativos ni listas mutables, así que los tres algoritmos son recursivos y devuelven una lista nueva: el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` se devuelve como parte de un par (`bubblePass : List Int -> (List Int, Bool)`), conservando la salida temprana. `pickMin` reconstruye la lista restante en un orden distinto al original, sin efecto observable porque se vuelve a ordenar de inmediato. Caso nulo omitido: Elm no tiene `null`/`nil` y `List Int` no admite entradas inválidas; el criterio «sin lanzar excepciones» se cumple porque Elm no tiene excepciones. Ubicación desviada de la especificación: el archivo debe llamarse `NaiveSort.elm` (PascalCase, igual que el módulo), el directorio de pruebas es `tests/` en plural y no hay `run_tests.elm` porque `elm-test` descubre las suites automáticamente. `elm.json` declara `elm-explorations/test` en `test-dependencies`, no en `dependencies`. El índice de fase `elm/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): erlang
Código verificado / Code verified: yes (sin mitigaciones: `rebar3 compile` sin warnings y `rebar3 eunit` en verde tras implementar el módulo, que partía del esqueleto `-export([]).` de `rebar3 new lib`)
Tests y comandos / Tests and commands:
- `rebar3 compile` en `erlang/core/algorithms/naive_sort` -> `===> Compiling naive_sort` (exit 0, 0 warnings)
- `rebar3 eunit` -> `Finished in 0.068 seconds` y `21 tests, 0 failures` (exit 0; 3 algoritmos × 7 casos)
README(s) verificado(s) / README(s) verified: yes (`erlang/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 14/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm) -> 15/49 (…, Elm, Erlang)
Observaciones / Notes: Decimoquinta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Erlang no tiene estructuras mutables (single assignment), así que los tres algoritmos son recursivos y devuelven una lista nueva: el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` se devuelve dentro de un par (`bubble_pass/1` -> `{Lista, Swapped}`), conservando la salida temprana. `rest/2` elimina la primera aparición del mínimo en lugar de una posición concreta, sin efecto observable porque ese valor es el que acaba de extraerse. Caso nulo omitido: Erlang no tiene `null`/`nil` y el tipo `list()` no admite entradas inválidas; una llamada con un término que no sea lista queda fuera del contrato y provoca `function_clause`. Ubicación desviada de la especificación: no hay `run_tests.erl` porque `rebar3 eunit` descubre automáticamente los módulos `*_test.erl` de `test/`; los nombres de archivo y la separación `src/` ↔ `test/` sí coinciden. La suite usa generadores de EUnit (funciones `*_test_()`), de modo que cada uno de los 21 tests aparece en la salida con su nombre descriptivo. El índice de fase `erlang/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): forth
Código verificado / Code verified: yes (mitigaciones aplicadas: (1) `selection-sort` usaba la palabra inexistente `min_idx`, que impedía cargar el módulo — se declaró `variable min-idx` y se reescribió el bucle interno; (2) `swap-cells` era `over @ over @ rot ! swap !`, que por el orden de `!` almacenaba cada valor en su propia celda, es decir un no-op silencioso — se reescribió cruzando los dos almacenamientos con `swap-tmp`; (3) `bubble-sort` usaba `j` (índice externo) dentro del bucle interno, donde el índice interno es `i`, y la bandera `swapped?` se asignaba pero nunca se leía — se corrigió el índice y se añadió la salida temprana con `leave`)
Tests y comandos / Tests and commands:
- `gforth -e "include src/naive_sort.forth bye"` en `forth/core/algorithms/naive_sort` -> sin salida (exit 0, el módulo carga sin errores)
- `cd test && gforth run-tests.forth` -> `tests runned 78`, `passed 78`, `failed 0` (exit 0; 3 algoritmos × 26 aserciones)
README(s) verificado(s) / README(s) verified: yes (`forth/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 15/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang) -> 16/49 (…, Erlang, Forth)
Observaciones / Notes: Decimosexta implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Forth no tiene tipo array: una secuencia es una dirección más un número de celdas, así que el contrato es `( addr count -- )` y ordena in-place (divergencia idiomática aceptada frente al `selection_sort(arr)` del pseudocódigo). La especificación exige entradas de longitud variable (0, 1, 5 y 6 elementos), imposible con aridad fija. En bucles `?do` anidados Forth da el índice interno en `i` y el externo en `j`, al revés de lo que sugiere el pseudocódigo. `swap-cells` documenta que `!` es `( x addr -- )`, por lo que un intercambio debe cruzar los dos almacenamientos y no puede reutilizarlos. Caso nulo omitido: no existe representación de array inválido. Ubicación desviada de la especificación: extensión `.forth` y naming `kebab-case` (`naive-sort-tests.forth`), siguiendo la convención de `numbers/`; el punto de entrada `test/run-tests.forth` sí existe y se añade el framework `test/test.forth`. El runner se extendió con `set-label`/`append-label` para que cada fallo identifique el caso con el formato `"{algoritmo} should sort {caso}"`, verificado con una contra-verificación. El caso del array vacío se ejecuta pero no produce aserciones: con `( addr count -- )` y count 0 no hay estado observable. El índice de fase `forth/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): fsharp
Código verificado / Code verified: yes (el esqueleto tuvo que recrearse: `dotnet new classlib` y `dotnet new xunit` se habían ejecutado sin `-lang F#` y generaron proyectos de C# — `Class1.cs`, `UnitTest1.cs`, `Naivesort.csproj` — sin `<ProjectReference>`; se borraron y se recrearon con las plantillas de F#, se apuntaron los `.fsproj` a `NaiveSort.fs` y `NaiveSortTests.fs` y se añadió la referencia entre proyectos. La implementación pasó ambas compuertas sin mitigaciones)
Tests y comandos / Tests and commands:
- `dotnet build NaiveSort.slnx` en `fsharp/core/algorithms/naive_sort` -> `Build succeeded.` con `0 Warning(s)` y `0 Error(s)` (exit 0)
- `dotnet test NaiveSort.slnx` -> `Passed!  - Failed:     0, Passed:     3, Skipped:     0, Total:     3, Duration: 21 ms` (exit 0; 3 algoritmos × 7 casos = 21 aserciones)
README(s) verificado(s) / README(s) verified: yes (`fsharp/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 16/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth) -> 17/49 (…, Forth, F#)
Observaciones / Notes: Decimoséptima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. F# usa `int list`, que es inmutable, así que los tres algoritmos devuelven una lista nueva y el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` se devuelve dentro de un par (`bubblePass` -> `int list * bool`), conservando la salida temprana. Los helpers (`pickMin`, `bubblePass`, `insert`) son funciones locales, de modo que la única API son las 3 funciones del contrato — a diferencia de `numbers/`, donde los helpers son públicos. `insert` usa `x <= y`, lo que hace la ordenación estable. Caso nulo omitido: F# no permite el literal `null` para `int list` y no existe representación de lista inválida; el hermano de C# sí lo modela porque tiene los nullable reference types habilitados. Ubicación desviada de la especificación: `src/NaiveSort.fs` (PascalCase, igual que el módulo, como `Numbers.fs`) y `test/NaiveSortTests.fs`; no hay `run_tests` porque `dotnet test` descubre los tests de la solución. El layout es plano (`src/{Modulo}.fsproj` y `test/{Modulo}.Tests.fsproj`), siguiendo `numbers/` en lugar del `-o src/{Modulo}` de la guía. El `.gitignore` de la raíz del submódulo cubre `bin/` y `obj/`, con 0 artefactos rastreados. El índice de fase `fsharp/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): gleam
Código verificado / Code verified: yes (mitigaciones aplicadas: la primera pasada sólo tenía `selection_sort`, así que `bubble_sort` e `insertion_sort` faltaban y el archivo no estaba formateado; el autor los completó y el formato quedó limpio. Sin cambios míos sobre el código)
Tests y comandos / Tests and commands:
- `gleam build` en `gleam/core/algorithms/naive_sort` -> `Compiled in 0.27s` sin warnings (exit 0)
- `gleam format --check src test` -> sin salida (exit 0); es el comando que ejecuta el CI del propio scaffold
- `gleam test` -> `3 passed, no failures` (exit 0; 3 algoritmos × 7 casos = 21 aserciones)
README(s) verificado(s) / README(s) verified: yes (`gleam/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 17/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth, F#) -> 18/49 (…, F#, Gleam)
Observaciones / Notes: Decimoctava implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Gleam no tiene bucles ni mutabilidad, así que los tres algoritmos son recursivos y devuelven una lista nueva: el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` se pasa como parámetro a `bubble_pass` y se devuelve dentro de un par `#(List(Int), Bool)`, conservando la salida temprana. Los helpers (`pick_min`, `bubble_pass`, `insert`) son privados (`fn` sin `pub`), de modo que la única API son las 3 funciones del contrato. `insert` usa `x <= y`, lo que hace la ordenación estable. `pick_min` devuelve el resto en el orden en que lo acumuló, sin efecto observable porque se vuelve a ordenar. Caso nulo omitido: Gleam no tiene `null`/`nil` ni representación de lista inválida. Ubicación: `src/naive_sort.gleam` y `test/naive_sort_test.gleam` coinciden con el naming esperado; no hay `run_tests` porque el entry point de gleeunit es una función `main` dentro del propio módulo de pruebas, y `gleam test` además exige que ese módulo se llame `<name>_test` según el campo `name` de `gleam.toml`. Se eliminó la función `main` de ejemplo que genera `gleam new` en `src/`, igual que en `numbers/`. El índice de fase `gleam/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): go
Código verificado / Code verified: yes (el esqueleto se entregó sin implementación — sólo `package src` y la cabecera del contrato — y `go test ./...` fallaba con `imported and not used` y `undefined: SelectionSort/BubbleSort/InsertionSort`; el autor añadió las tres funciones y ambas compuertas pasaron sin mitigaciones. Sin cambios míos sobre el código)
Tests y comandos / Tests and commands:
- `go vet ./...` en `go/core/algorithms/naive_sort` -> sin salida (exit 0)
- `gofmt -l .` -> sin salida (exit 0)
- `go build ./...` -> sin salida (exit 0)
- `go test ./... -v -count=1` -> `--- PASS: TestSelectionSort`, `--- PASS: TestBubbleSort`, `--- PASS: TestInsertionSort`, `PASS`, `ok example.com/naive_sort/tests 0.003s` (exit 0; 3 algoritmos × (7 casos + caso nulo) = 24 aserciones)
- Contra-verificación en copia desechable (`/tmp`, ya eliminada): cambiando `arr[j] < arr[minIdx]` por `>` en `selection_sort` -> `--- FAIL: TestSelectionSort` con `Messages: selection_sort should sort an unsorted array` (y los demás casos afectados), exit 1; revertido -> `ok`
README(s) verificado(s) / README(s) verified: yes (`go/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 18/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth, F#, Gleam) -> 19/49 (…, Gleam, Go)
Observaciones / Notes: Decimonovena implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. Go sí puede representar el caso nulo y ordenar in-place, así que los tres algoritmos mutan el slice recibido y lo devuelven, y el indicador de fallo es el slice `nil`: la guarda `len(arr) <= 1` devuelve el propio slice sin tocarlo, de modo que `nil` entra y `nil` sale sin comprobación especial ni `panic`. Es el segundo hermano de la fase, tras C# con `int[]?`, que cubre el caso nulo de forma explícita; el caso nulo se prueba por separado del caso vacío porque `nil` y `[]int{}` son valores distintos en Go. Como los fixtures de la suite son variables compartidas a nivel de paquete y los algoritmos mutan in-place, cada caso ordena una copia creada con `copyInput` (`make` + `copy`). La bandera `swapped` se conserva usando `for swapped` como condición del bucle externo, equivalente al `swapped` + `break` del pseudocódigo sin contar pasadas con un índice externo; `selection_sort` intercambia sin la guarda `if min_idx != i` del pseudocódigo, sin efecto observable porque un auto-intercambio es un no-op. Naming exportado en `PascalCase` (`SelectionSort`, `BubbleSort`, `InsertionSort`), obligatorio porque los tests viven en el paquete `tests` separado del paquete `src`. Ubicación desviada de la especificación: el directorio de pruebas es `tests/` en plural (siguiendo `numbers/`) y no existe `run_tests` porque `go test ./...` descubre automáticamente las funciones `TestXxx`; la extensión `.go` y el nombre `naive_sort.go` sí coinciden. `.gitignore`: no se añade uno de módulo porque el de la raíz de `go/` ya cubre los artefactos, verificado con `git check-ignore -v tests/tests.test` -> `.gitignore:12:*.test`, con 0 artefactos rastreados. La versión de `testify` se fijó a `v1.11.1` para que `go.mod` coincida exactamente con el de `numbers/` (`go mod tidy` había resuelto `v1.12.1`). El índice de fase `go/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-15
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): grain
Código verificado / Code verified: yes (tres pasadas. Las dos primeras no compilaban: faltaba `=>` en las ocho definiciones de función, los `match` no llevaban paréntesis, los brazos usaban `|` inicial y comas omitidas, el patrón `x::xs` no existe en Grain, `not swapped` no es operador y `List.get`/`List.set` no existen en la biblioteca estándar; además los nombres exportados eran `selectionsort`/`bubblesort`/`insertionsort`. Con autorización del autor se reescribió el módulo: sintaxis válida de Grain 0.7.2, naming `camelCase`, `pickMin`/`removeFirst`/`bubblePass`/`insert` anidados con `let rec` dentro de su función padre como en `numbers/`, y sin ninguna llamada a biblioteca — se eliminó el `List.reduce` que usaba `insertionSort` y el `from "list" include List`, de modo que el módulo sólo usa literales `[...]`, pattern matching `[x, ...xs]`, comparaciones y recursión)
Tests y comandos / Tests and commands:
- `make build` en `grain/core/algorithms/naive_sort` -> sin salida (exit 0, sin warnings)
- `make test` -> `grain compile tests/run_tests.gr` + `grain run tests/run_tests.wasm`, `--- Test Summary ---`, `Tests: 21 passed, 0 failed, 21 total` (exit 0; 3 algoritmos × 7 casos)
- `grep -n "List\.\|include\|import" src/naive_sort.gr` -> sin coincidencias (0 llamadas a biblioteca en la implementación)
- Contra-verificación en copia desechable (`/tmp`, ya eliminada): invirtiendo `x < minValue` por `x > minValue` en el `pickMin` de `selectionSort` -> `FAILED: selection_sort should sort an unsorted array — expected [1, 2, 5, 5, 6, 9], got [9, 6, 5, 5, 2, 1]` y otros 3 casos, `Tests: 17 passed, 4 failed, 21 total`; revertido -> `21 passed, 0 failed`
README(s) verificado(s) / README(s) verified: yes (`grain/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 19/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth, F#, Gleam, Go) -> 20/49 (…, Go, Grain)
Observaciones / Notes: Vigésima implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. El literal `[1, 2, 3]` de Grain construye una `List<Number>`, que es inmutable — `Array` es el tipo mutable, pero ni el literal idiomático ni `numbers/` lo usan —, así que los tres algoritmos son recursivos y devuelven una lista nueva: el `swap` in-place del pseudocódigo no es representable (divergencia idiomática aceptada). La bandera `swapped` se devuelve dentro de un par `(List<Number>, Bool)`, conservando la salida temprana: una lista ya ordenada se resuelve en una sola pasada. `insert` usa `x <= y`, lo que hace la ordenación estable. `removeFirst` elimina la primera aparición del mínimo, sin efecto observable aunque el mínimo se repita (caso `[7, 7, 7, 7]`). Caso nulo omitido: Grain no tiene `null`/`nil` ni listas inválidas, igual que F# y Gleam. La implementación no importa ningún módulo de la biblioteca estándar y no hace ninguna llamada `List.*`, en línea con el criterio de aceptación de la especificación; los helpers van anidados con `let rec` dentro de la función padre, por lo que son privados a ese ámbito y la única API pública son las 3 funciones del contrato (`insertionSort` no lleva `rec` porque la recursión vive en su helper `loop`, igual que el enfoque con acumulador de `numbers/`). Ubicación desviada de la especificación: el directorio de pruebas es `tests/` en plural (siguiendo `numbers/`) y la extensión es `.gr`; el punto de entrada `tests/run_tests.gr` sí existe y se le añade `tests/testing.gr`, el mini framework reutilizado literalmente de `numbers/` (md5 `b50574efd745fbc03c47c3c30ded2312`). `.gitignore` propio con `target/`, `*.gro`, `*.wasm` y `*.wasm.map`: los dos últimos no estaban cubiertos en `numbers/` (donde `tests/run_tests.wasm` queda como artefacto no ignorado), verificado con `git check-ignore -v` sobre los 5 artefactos y con 0 artefactos rastreados. El índice de fase `grain/core/algorithms/README.md` se creó en este cierre.

Fecha / Date: 2026-09-16
Fase / Phase: core.algorithms
Módulo(s) / Module(s): core.algorithms.naive_sort
Lenguaje(s) / Language(s): groovy
Código verificado / Code verified: yes (sin mitigaciones. `./gradlew compileGroovy compileTestGroovy` compila `src/main` y `src/test` sin ningún diagnóstico; los 4 avisos `Deprecated Gradle features` que emite Gradle provienen del bloque `testlogger` de `lib/build.gradle:53-57` —sintaxis de asignación con espacio, retirada en Gradle 10— y son idénticos, línea por línea, en el bloque homólogo de `foundations/numbers`, así que se documentan en el README como aviso heredado del scaffold y no como defecto del código)
Tests y comandos / Tests and commands:
- `./gradlew clean test --rerun-tasks --console=plain` en `groovy/core/algorithms/naive_sort` -> `> Task :lib:test`, `org.example.NaiveSortTest`, `Test selection_sort should sort all cases PASSED`, `Test bubble_sort should sort all cases PASSED`, `Test insertion_sort should sort all cases PASSED`, `SUCCESS: Executed 3 tests in 655ms`, `BUILD SUCCESSFUL in 2s` (exit 0; 3 tests × (7 casos + caso nulo) = 24 aserciones)
- `git check-ignore -v` sobre `.gradle/8.14.3/gc.properties`, `lib/build/.../NaiveSort.class`, `build/reports/.../index.html` y `lib/bin/.../NaiveSort.groovy` -> cubiertos por `.gitignore:2:.gradle`, `.gitignore:5:build` y `.gitignore:11:bin`; 0 artefactos rastreados en el módulo
- Contra-verificación en copia desechable (`/tmp`, ya eliminada): invirtiendo `arr[j] > key` por `arr[j] < key` en el bucle interno de `insertionSort` -> `Test insertion_sort should sort all cases FAILED`, `insertion_sort should sort an unsorted array`, `FAILURE: Executed 3 tests in 937ms (1 failed)`; revertido -> `SUCCESS: Executed 3 tests`
README(s) verificado(s) / README(s) verified: yes (`groovy/core/algorithms/naive_sort/README.md`)
Cambio en ROADMAP.md / ROADMAP.md change: `core.algorithms.naive_sort` 20/49 (Ada, Assembly, Ballerina, C, C#, Clojure, COBOL, Common Lisp, C++, Crystal, D, Dart, Elixir, Elm, Erlang, Forth, F#, Gleam, Go, Grain) -> 21/49 (…, Grain, Groovy)
Observaciones / Notes: Vigesimoprimera implementación homologada de la Fase 1. No cierra la fase: faltan los demás lenguajes y los módulos restantes. El scaffold se generó con `gradle init --type groovy-library`, que produce un proyecto Gradle multiproyecto con submódulo `lib`; se eliminaron los placeholders `Library.groovy` y `LibraryTest.groovy` y se añadió a `lib/build.gradle` el plugin `com.adarshr.test-logger` 4.0.0 con su bloque `testlogger`, para que la salida muestre cada test por nombre igual que en `numbers/`. La especificación admite ordenar in-place o devolver una copia: las tres funciones hacen `list.clone()` y ordenan la copia, de modo que la lista del llamador nunca se muta mientras la mutación interna sigue siendo la del pseudocódigo. Groovy admite `null` en `List<Integer>`, así que el caso nulo sí es representable y se cubre de forma explícita: `if (list == null) return null`, sin lanzar excepciones, y separado del caso vacío porque `null` y `[]` son valores distintos. La bandera `swapped` se implementa con `do { ... } while (swapped)`, equivalente al `swapped` + `break` del pseudocódigo, conservando el mejor caso $O(n)$; el bucle interno no se acorta con el contador de pasadas (`for j = 0 to n - 2 - i`), lo que no altera el comportamiento observable ni la complejidad prometida y queda documentado en el README. `insertionSort` desplaza con `arr[j] > key` estricto, lo que la hace estable. Naming `camelCase` (`NaiveSort.selectionSort(list)`), coherente con `Numbers.sumFirstNRec(n)`; los tres cuerpos son autocontenidos, con los bucles internos inline. Ubicación desviada de la especificación: el layout es `lib/src/main/groovy/org/example/` y `lib/src/test/groovy/org/example/` (árbol estándar de Gradle y paquete `org.example`, igual que `numbers/`) y no existe `run_tests` porque `./gradlew test` descubre las clases `Specification` de Spock. El `.gitignore` añade `bin` a las entradas generadas (`.gradle`, `build`, `.kotlin`) para cubrir las clases que algunos IDE compilan fuera de `build/`, verificado con `git check-ignore -v`. El índice de fase `groovy/core/algorithms/README.md` se creó en este cierre.
