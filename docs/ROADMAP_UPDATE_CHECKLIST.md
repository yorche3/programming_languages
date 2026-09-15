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
