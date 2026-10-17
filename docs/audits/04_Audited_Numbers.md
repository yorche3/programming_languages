# Auditoría de Módulo: 04_Numbers
# Module Audit: 04_Numbers

Registro de deuda técnica del módulo `04_Numbers`. / Technical debt record for the `04_Numbers` module.

- **Especificación / Specification:** [`04_Numbers.md`](../core/foundations/04_Numbers.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** 2026-10-16 (pase completo y **cerrado**, 50/50)

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
- **Comentarios de plantilla (4, heredados de la auditoría 03):** `ballerina` (`+ a - parameter description`), `clojure` (`FIXME: my new library.`), `crystal` (`# TODO: Write documentation…`) y `dart` (`/// Support for doing something awesome.`). La 03 los anotó para este pase porque los módulos hermanos homologados los comparten.

> **ES:** **Hallazgo retirado el 2026-10-16:** `ada` no incumple nada — sus tres suites llevan las **11 aserciones** agrupadas en 5 procedimientos de AUnit, así que el «5» de su resumen es el recuento del framework, no la cobertura.
>
> **ES:** **Hallazgo retirado el 2026-10-16:** `common-lisp` tampoco incumple: su `run-tests` sí llama a los tres runners y la ejecución completa da **33 checks en 3 suites** (11 por suite, `Pass: 11 (100%)` ×3). El `Pass 5` / `Did 11 checks` que anoté era el último de los tres resúmenes de FiveAM, que `tail` recortaba.
>
> **EN:** Findings **retired on 2026-10-16**: `ada` does not breach anything (its three suites carry the 11 assertions grouped in 5 AUnit procedures) and neither does `common-lisp` (its `run-tests` calls the three runners: 33 checks in 3 suites).

### 🔵 Aceptados por el autor / Accepted by the author

- — (todavía ninguno / none yet)

### 🟢 Homologados / Homologated

- **50 lenguajes** con las dos capas cumplidas y evidencia de ejecución: los **43** que ya estaban más `ballerina`, `clojure`, `crystal`, `dart`, `elm`, `ocaml` y `tcl-tk`, cuyos hallazgos se corrigieron e integraron durante el cierre.
- Los 50 declaran su combinación en el README y cubren los 11 casos por variante implementada: 33 pruebas con las tres (`assembly`, `clojure`, `grain`, `haskell`, `racket`, `scheme`…), 22 con dos (`C`, `C++`, `Go`, `Forth`, `Groovy`, `Julia`, `R`, `Zig`…) y ninguna con una sola variante.

## Deuda por lenguaje / Debt per language

| 1 | `dune runtest` no compila: `bin/dune` declara `main` sin `bin/main.ml` | Añadir `bin/main.ml`, como se hizo en `unit_test/calculator` durante la auditoría 03 | `ocaml` | ✅ integrada |
| 2 | README fuera de la plantilla de Nivel 3 | Reescribir las secciones con los nombres de la plantilla (y corregir `Concectos`) | `elm` | ✅ integrada |
| 3 | Cabecera obligatoria renombrada | `🚀 Ejecución` → `🚀 Compilación y ejecución` | `tcl-tk` | ✅ integrada |
| 4 | Comentarios y textos de plantilla | Sustituirlos por documentación real del módulo | `ballerina`, `clojure`, `crystal`, `dart` | ✅ integrada |

## Plan de cierre / Closure plan

**ES:** El pase está **cerrado** (2026-10-16): las 50 suites ejecutadas, los 11 casos por variante comprobados y los 7 hallazgos integrados en el `main` de sus 7 submódulos y empujados, con los punteros del monorepo sincronizados. El módulo queda 🟢 50/50: sin 🔴, sin 🟡 y sin desviaciones aceptadas, así que no hay fichas nuevas en `docs/ruleset/idioms/`. El cierre queda registrado en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) y en la nota del módulo en [`ROADMAP.md`](../ROADMAP.md) —el contador del sprint no se toca—.

**EN:** The pass is **closed** (2026-10-16): 50/50 suites executed, the 11 cases per variant checked and the 7 findings integrated into their 7 submodules' `main` and pushed, with the monorepo pointers synced. The module sits at 🟢 50/50: no 🔴, no 🟡 and no accepted deviations, so no new records under `docs/ruleset/idioms/`. The closure is logged in [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) and in the module's note in [`ROADMAP.md`](../ROADMAP.md) —the sprint counter is untouched—.

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
| 2026-10-16 | Revisión de los dos hallazgos provisionales | `ros run --load run-tests.lisp` en `common-lisp`, con recuento de resúmenes | **33 checks en 3 suites** (11 por suite, `Pass: 11 (100%)` ×3): el agregador sí orquesta las tres y el hallazgo se **retira** |
| 2026-10-16 | **Integración y re-ejecución de los siete** | `bal test` · `clojure -T:build test` · `crystal spec` · `dart test` · `elm-test` · `dune runtest` · `tclsh9.0 {iterative,recursive}.test`, todos sobre el `main` integrado | **8/8 rc=0** (33 aserciones en Clojure, 33 pruebas en Elm, 10 en Crystal y Dart, `Total 11 Passed 11` por suite en Tcl-Tk); 7 commits de `align` fusionados y empujados, sin ramas de trabajo y con los punteros sincronizados |
