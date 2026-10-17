# Auditoría de Módulo: 04_Numbers
# Module Audit: 04_Numbers

Registro de deuda técnica del módulo `04_Numbers`. / Technical debt record for the `04_Numbers` module.

- **Especificación / Specification:** [`04_Numbers.md`](../core/foundations/04_Numbers.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** 2026-10-16 (pase completo, 50/50)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** Los **cinco algoritmos** (suma de los primeros `n`, factorial, Fibonacci, MCD y MCM) en las variantes que el lenguaje permita: `_rec` **siempre**; `_acc` **solo si el lenguaje garantiza TCO**; `_ite` **solo si ofrece iteración nativa**; y el README de Nivel 3 **declarando la combinación aplicada y por qué** (33, 22 o 11 pruebas). `_rec` es recursión directa, `_acc` lleva acumulador (estilo tail-call) y `_ite` usa bucles con memoria constante. Sin delegar los cinco algoritmos en una rutina de biblioteca, separación del código respecto de las pruebas (`src/`-`test/` o la disposición idiomática equivalente) y solo biblioteca estándar. Techo: $O(n)$ en las sumatorias y el factorial y $O(\log n)$ en el MCD; `fibonacci_rec` es $O(2^n)$ **por diseño educativo** y no es una desviación.

> **ES:** Capa corregida el **2026-10-16** al abrir el pase: antes pedía «las tres variantes implementadas y probadas por separado» —contra la regla condicional de la especificación— y «trabajo sobre la secuencia indexable», que ningún algoritmo de este módulo recibe como entrada: la especificación introduce esa primitiva para los módulos posteriores. El histórico queda aquí porque los pases cerrados no se reescriben.
>
> **EN:** Layer corrected on **2026-10-16**: it used to ask for the three variants implemented and tested unconditionally, and for work over the indexable sequence, which this module's algorithms never take as input.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | 50/50 con el módulo presente; 14 lo disponen a la idiomática del lenguaje (`lib/`, `source/`, `R/`, `Sources/`, `lib/src/main`, paquetes de Racket) y 50/50 árboles limpios |
| 2. Lectura de código | Las tres variantes, la aritmética y la recursión, y los comentarios | Los 50 declaran en su README la combinación de suites que aplican y por qué (TCO e iteración nativa), las implementaciones no delegan los cinco algoritmos en una rutina de biblioteca, y las suites cubren los 11 casos por variante implementada (33, 22 o 11 pruebas) |
| 3. Ejecución de suites | El comando del catálogo por lenguaje, copiado sin editar | **49/50 en verde**; `ocaml` rc=1 (`dune runtest` → `Error: Module "Main" doesn't exist`, el `bin/dune` huérfano heredado de la auditoría 03). Las 12 suites múltiples (`prolog` ×3, `rexx` ×2, `scheme` ×3, `vala` ×2, `tcl-tk` ×2) y `zig` (10 pruebas) también en verde |
| 4. Documentación | Los 50 `README.md` contra [`README_Template.md`](../README_Template.md) | **47/50 con las cuatro secciones aplicables**; `elm` **0/4** (usa su propia estructura y trae el typo `Concectos`) y `tcl-tk` **3/4** (`🚀 Ejecución` por `🚀 Compilación y ejecución`) |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | **50/50 limpios** y en `main`, sin ramas de trabajo abiertas |

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- **`ocaml`** — el comando del catálogo no ejecuta: `dune runtest` (rc=1) falla al compilar el ejecutable de `bin/`, cuyo `bin/dune` declara `(name main)` sin `bin/main.ml`. Es **el mismo caso que la auditoría 03 dejó anotado** (re-comprobado el 2026-10-16: idéntico `bin/dune` al que tenía `unit_test/calculator`, que ya lleva su `main.ml`; la suite de `numbers` pasa por su propio target con 5 tests de Alcotest).
  **Arreglo / Fix:** añadir `bin/main.ml` (el punto de entrada que la stanza espera), como en `unit_test/calculator`.

### 🟡 Advertencias / Warnings

**ES:** Cumplen el contrato del módulo —la combinación de variantes que declara su README, con las suites en verde y los 11 casos por variante— pero arrastran deuda.

- **Cabeceras del README (2):** `elm` no usa la plantilla de Nivel 3 en ninguna de sus cuatro secciones aplicables (su README va con `📦 Módulo Numbers`, `🧠 Paradigmas explicados`, `🧪 Tests`, `🚀 Uso`…) y trae el typo `🏗️ Concectos clave de Elm demostrados`; `tcl-tk` renombra `🚀 Compilación y ejecución` como `🚀 Ejecución`.
- **Punto de entrada de las suites (1):** `common-lisp` llama a un único `run-tests` y la ejecución da `Pass 5`: los tres ficheros de `tests/` declaran y exportan `run-tests` en el mismo paquete, así que solo entra el último cargado y la ejecución cubre 11 casos de los 33 (cada suite sí tiene sus 11).
- **Comentarios de plantilla (4, heredados de la auditoría 03):** `ballerina` (`+ a - parameter description`), `clojure` (`FIXME: my new library.`), `crystal` (`# TODO: Write documentation…`) y `dart` (`/// Support for doing something awesome.`). La 03 los anotó para este pase porque los módulos hermanos homologados los comparten.

> **ES:** **Hallazgo retirado el 2026-10-16:** `ada` no incumple nada — sus tres suites llevan las **11 aserciones** agrupadas en 5 procedimientos de AUnit, así que el «5» de su resumen es el recuento del framework, no la cobertura. Se retira del estado y de la deuda, y el snapshot queda aquí porque el registro no se reescribe.
>
> **EN:** Finding **retired on 2026-10-16**: `ada` does not breach anything — its three suites carry the 11 assertions grouped in 5 AUnit procedures, so the `5` in its summary is the framework count, not the coverage.

### 🔵 Aceptados por el autor / Accepted by the author

- — (todavía ninguno / none yet)

### 🟢 Homologados / Homologated

- **42 lenguajes** con las dos capas cumplidas y evidencia de ejecución: `ada`, `assembly`, `c`, `cobol`, `cpp`, `csharp`, `d`, `elixir`, `erlang`, `forth`, `fsharp`, `gleam`, `go`, `grain`, `groovy`, `haskell`, `haxe`, `java`, `javascript`, `julia`, `kotlin`, `lua`, `nim`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `scheme`, `swift`, `typescript`, `v`, `vala` y `zig`.
- Los 50 declaran su combinación en el README y cubren los 11 casos por variante implementada: 33 pruebas con las tres (`assembly`, `clojure`, `grain`, `haskell`, `racket`, `scheme`…), 22 con dos (`C`, `C++`, `Go`, `Forth`, `Groovy`, `Julia`, `R`, `Zig`…) y ninguna con una sola variante.

## Deuda por lenguaje / Debt per language

| 1 | `dune runtest` no compila: `bin/dune` declara `main` sin `bin/main.ml` | Añadir `bin/main.ml`, como se hizo en `unit_test/calculator` durante la auditoría 03 | `ocaml` | ⏳ pendiente |
| 2 | README fuera de la plantilla de Nivel 3 | Reescribir las secciones con los nombres de la plantilla (y corregir `Concectos`) | `elm` | ⏳ pendiente |
| 3 | Cabecera obligatoria renombrada | `🚀 Ejecución` → `🚀 Compilación y ejecución` | `tcl-tk` | ⏳ pendiente |
| 4 | El punto de entrada solo ejecuta una de las tres suites | Que `run-tests` orqueste las tres (un paquete o una función por suite) | `common-lisp` | ⏳ pendiente |
| 5 | Comentarios y textos de plantilla | Sustituirlos por documentación real del módulo | `ballerina`, `clojure`, `crystal`, `dart` | ⏳ pendiente |

## Plan de cierre / Closure plan

**ES:** El pase está **verificado** (2026-10-16): 50/50 lenguajes con los cinco pasos hechos y evidencia real. Queda el arreglo de los 8 hallazgos —el 🔴 de `ocaml` y los 7 🟡—, que el autor puede corregir en su `align` o aceptar como desviación con su ficha en `docs/ruleset/idioms/`, y el cierre cuando estén integrados. Ver [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

**EN:** The pass is **verified** (2026-10-16): 50/50 languages with the five steps done and real evidence. What remains is fixing the 8 findings —the `ocaml` 🔴 and the 7 🟡—, which the author may fix in their `align` or accept as a deviation with its record under `docs/ruleset/idioms/`, and the closure once they are integrated. See [`AUDIT_WORKFLOW.md`](../AUDIT_WORKFLOW.md).

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-16 | Barrido léxico, estructura, README y árbol | `git ls-files` + `grep` de las variantes (`_rec`/`_acc`/`_ite`), de las cuatro secciones de plantilla y de `TCO` en los 50 | 50/50 con el módulo; 14 con disposición idiomática; 47/50 con 4/4 secciones; 50/50 árboles limpios |
| 2026-10-16 | Ejecución de suites (lote A) | `alr -C tests run` · `make run` · `bal test` · `make test` · `clojure -T:build test` · `make test` · `ros run --load run-tests.lisp …` · `bazelisk test //...` · `crystal spec` · `dotnet test numbers.slnx` · `dub test` · `dart test` · `mix test` · `elm-test` | 14/14 rc=0 |
| 2026-10-16 | Ejecución de suites (lote B) | `rebar3 eunit` · `gforth run-tests.forth` · `dotnet test` · `gleam test` · `go test ./...` · `make test` · `./gradlew test` · `cabal test` · `haxe build.hxml` · `mvn test` · `npm test` · `julia --project=. test/run_tests.jl` · `gradle test` · `busted` · `nimble test` · `dune runtest` · `prove --ext=.pl test/` | 16/17 rc=0; `ocaml` rc=1 (`Module "Main" doesn't exist`) |
| 2026-10-16 | Ejecución de suites (lote C) | `composer test` · `spago test` · `pytest` · `make test` · `raco test -x .` · `prove6 -l t/` · `npm test` · `bundle exec rspec` · `cargo test` · `sbt -batch -no-colors test` · `swift test` · `npm test` · `v test .` · `zig build test` | 14/14 rc=0 |
| 2026-10-16 | Suites múltiples y re-ejecución dirigida | `swipl -q -f {iterative,recursive,recursive_with_acc}_tests.pl -t halt` · `rexx test/{iterative,recursive}_tests.rexx` · `guile --no-auto-compile -s {…}_guile.scm` ×3 · `valac src/numbers.vala test/{iterative,recursive}_tests.vala …` ×2 · `tclsh9.0 {iterative,recursive}.test` ×2 · `zig build test --summary all --cache-dir /tmp/…` | 12/12 rc=0 (tcl-tk `Total 11 Passed 11` por suite; `zig`: 5/5 y 10 pruebas reales) |
| 2026-10-16 | Recuentos por framework | `grep` de los resúmenes de los 50 registros y de los informes XML de `kotlin` | La mayoría agrupa dos casos por función de test (`php`: `10 tests, 22 assertions`; `erlang`: `10 tests` con 11 casos por suite) |
| 2026-10-16 | Verificación caso a caso de los 11 casos por variante | Lectura de las suites con la marca propia de cada framework (`Assert.Equal`, `cr_expect_eq`, `expect`, `assert`, `?assertEqual`, `assert-equals`, `shouldBe`, `is(`, `test-equal`, `^test`, `MOVE … EXPECTED`, tablas de casos…) en los 50 | **50/50 cubren los 11 casos por variante implementada** (33, 22 o 11 según la combinación del README); se retira el hallazgo provisional de `ada`, que era el recuento de AUnit (5 procedimientos con 11 aserciones cada uno) |
