# Auditoría de Módulo: 03_Unit_Test_Calculator
# Module Audit: 03_Unit_Test_Calculator

Registro de deuda técnica del módulo `03_Unit_Test_Calculator`. / Technical debt record for the `03_Unit_Test_Calculator` module.

- **Especificación / Specification:** [`03_Unit_Test_Calculator.md`](../core/foundations/03_Unit_Test_Calculator.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Última verificación / Last verification:** 2026-10-16 (pase completo, 50/50)

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** Las cinco operaciones (`addition`, `subtraction`, `multiplication`, `division`, `modulus`); `multiplication` como suma repetitiva (**sin** `*`), `division` como resta repetitiva (**sin** `/`) y `modulus` construido con `division` y `multiplication` (**sin** `%`); la suite del módulo como runner propio donde el lenguaje no traiga uno; separación del código respecto de las pruebas (`src/`-`test/` o la disposición idiomática equivalente); solo biblioteca estándar y README de Nivel 3. Coste: $O(1)$ en `addition` y `subtraction`, $O(b)$ en `multiplication` y $O(a/b)$ en `division` —lineal **por diseño educativo**—.

> **ES:** Criterio corregido el **2026-10-16**: antes decía «las cuatro operaciones (`add`, `subtract`, `multiply`, `divide`)» y «coste $O(1)$ por operación». La capa sale de la especificación, que pide **cinco** operaciones con implementaciones educativas; el histórico queda aquí porque los pases ya cerrados no se reescriben.
>
> **ES:** La **división por cero queda fuera de la capa del módulo** por decisión del autor (2026-10-16): la especificación no la declara como criterio —su pseudocódigo la deja sin implementar y su ejemplo oficial lanza excepción—, así que el eje `failure` se marca `N/A` salvo que el lenguaje ya la maneje por su cuenta. Si se enmienda la especificación, el criterio entra en el pase siguiente.
>
> **EN:** Module layer corrected on **2026-10-16** (five operations, educational implementations, real complexity); **division by zero is out of the module layer** by the author's decision, so the `failure` axis is `N/A` unless the language already handles it.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | 50/50 con las cinco operaciones en su fuente; las 20 líneas que el barrido de operadores señaló eran comentarios, rutas de `#include` y manifiestos: **ninguna aritmética de biblioteca** en las implementaciones |
| 2. Lectura de código | Las cinco operaciones, la forma educativa, el camino de la división por cero y los comentarios | 50/50 implementan multiplicación como suma repetitiva, división como resta repetitiva y módulo con ambas; 14 lenguajes con deuda de idiomaticidad (5 de nombres, 6 de comentarios de plantilla y 3 de README), ya retirados los cuatro hallazgos que resultaron ser convención del repositorio |
| 3. Ejecución de suites | El comando de [`languages.tsv`](../../scripts/data/languages.tsv), copiado sin editar, en el directorio del módulo | **49/50 en verde con 5 pruebas**; `ocaml` rc=1 (`dune runtest` no compila `bin/`); 3 desajustes de catálogo (`forth`, `grain`, `julia`) resueltos con ejecución dirigida y 5 pruebas reales cada uno |
| 4. Documentación | Los 50 `README.md` contra [`README_Template.md`](../README_Template.md) y los comentarios del código | **47/50 con las cuatro secciones aplicables**; faltan en `erlang` (2/4), `scheme` (3/4) y `tcl-tk` (3/4), las tres por cabeceras renombradas |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | **50/50 limpios** y en `main`, sin ramas de trabajo abiertas |

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- **`ocaml`** — el comando del catálogo no llega a ejecutar la suite: `dune runtest` (rc=1) falla al compilar el ejecutable de `bin/`, cuyo `bin/dune` declara `(name main)` sin que exista `bin/main.ml`. La suite del módulo sí compila y pasa por su propio target (`dune build @test/runtest`, rc=0 el 2026-10-16), así que el defecto está en el andamiaje del módulo, no en las operaciones ni en las pruebas.
  **Arreglo / Fix:** retirar `bin/` (o añadir `bin/main.ml`) para que `dune runtest` —el comando del catálogo— termine en verde.

> **ES:** El **mismo `bin/dune` huérfano está en el módulo homologado `04_Numbers`** del propio submódulo (comprobado el 2026-10-16: `dune runtest` falla igual allí), así que esa mitad de la deuda le toca a la auditoría 04 y no se arregla en este pase.
>
> **EN:** The **same orphan `bin/dune` sits in the homologated `04_Numbers` module** of the same submodule (checked on 2026-10-16: `dune runtest` fails there too), so that half of the debt belongs to audit 04 and is not fixed in this pass.

### 🟡 Advertencias / Warnings

**ES:** Cumplen el contrato del módulo —cinco operaciones educativas, suite en verde, separación código/pruebas— pero arrastran deuda de idiomaticidad. Ninguna exige refactorizar las operaciones.

- **Nombres y ficheros de plantilla (5):** `csharp` (clase `Class1` en `src/Class1.cs` y `tests/UnitTest1.cs`), `fsharp` (`src/Library.fs`, `test/Tests.fs`), `julia` (runner `test/CalculatorTest.jl` donde el catálogo —y `04_Numbers`— usan `test/run_tests.jl`), `forth` (`run_tests.forth` en vez de `run-tests.forth`) y `grain` (`Makefile` sin target `test`: la suite corre con `make run`).
- **Comentarios y textos de plantilla (6):** `ballerina` (`+ a - parameter description` en las cinco operaciones), `dart` (`/// Support for doing something awesome.`, `/// Checks if you are awesome.` y dos `TODO` en `lib/`), `clojure` (`FIXME: my new library.` en `build.clj` y un `TODO` en `doc/intro.md`), `common-lisp` (`;; blah blah blah.`), `cpp` (tres `// TODO: Implement …` sobre código ya implementado) y `crystal` (dos `# TODO:`).
- **Cabeceras del README (3):** `erlang` (renombra `📂 Archivos y estructura` y `🛠️ Enfoque y construcción`) y `scheme` y `tcl-tk` (`🚀 Ejecución` en vez de `🚀 Compilación y ejecución`).

> **ES:** **Hallazgos retirados el 2026-10-16** al comprobar la convención en los módulos hermanos homologados (`04_Numbers`): el módulo o paquete `src` de `v`, `go` y `haxe` —y el fichero `calculator_base.dart` de `dart`— **son la convención del repositorio**, no una desviación (V y Haxe la exigen por la ruta, Go la repite en `numbers` y Dart repite `*_base.dart`); `testify` en `go` es el framework documentado de sus módulos. Se retiraron del estado y de la deuda, y `dart` conserva solo el hallazgo de comentarios de plantilla.
>
> **EN:** Findings **retired on 2026-10-16** after checking the convention in the homologated sibling modules (`04_Numbers`): the `src` module/package in `v`, `go` and `haxe` —and `dart`'s `calculator_base.dart`— **are the repository's convention**, not a deviation; `testify` in `go` is those modules' documented framework. They were removed from the state and the debt, and `dart` keeps only the template-comment finding.

> **ES:** Nota informativa, **no** es deuda: siete lenguajes (`assembly`, `scheme`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig`) protegen la división por cero con su indicador de fallo o su aserción (`-1`, `error`, `precondition`, `RangeError`, `@panic`, `assert_not_reached`). La capa del módulo no lo pide (decisión del autor, 2026-10-16) y la especificación no lo declara, así que solo se anota para el eje `failure` del ruleset.

### 🔵 Aceptados por el autor / Accepted by the author

- — (todavía ninguno / none yet). Los 17 hallazgos 🟡 se pueden corregir en su `align` o aceptar como desviación del autor, en cuyo caso estrenan ficha en `docs/ruleset/idioms/`.

### 🟢 Homologados / Homologated

- **35 lenguajes** con las dos capas cumplidas y evidencia de ejecución: `ada`, `assembly`, `c`, `cobol`, `d`, `elixir`, `elm`, `gleam`, `go`, `groovy`, `haskell`, `haxe`, `java`, `javascript`, `kotlin`, `lua`, `nim`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `swift`, `typescript`, `v`, `vala` y `zig`.
- `perl` y `racket` documentan su desviación de ubicación en el propio README (`📍 Desviaciones respecto a la ubicación esperada` y `🔀 Adaptaciones idiomáticas`): el orden `lib/`+`test/` y los paquetes de Racket son su convención, no una deuda.

## Deuda por lenguaje / Debt per language

| # | Deuda / Debt | Arreglo / Fix | Lenguaje(s) | Estado / Status |
|:-:|--------------|---------------|-------------|-----------------|
| 1 | `dune runtest` no compila: `bin/dune` declara `main` sin `bin/main.ml` | Añadido el punto de entrada de demostración que la stanza espera | `ocaml` | ✅ integrada |
| 2 | Nombres de plantilla en clase y suite | Renombrar a `Calculator`/`CalculatorTests` (y los ficheros con ellos) | `csharp`, `fsharp` | ✅ integrada |
| 3 | Runner del módulo fuera de la convención del repo | `test/run_tests.jl` (`julia`), `run-tests.forth` (`forth`) y target `test` en el `Makefile` (`grain`) | `julia`, `forth`, `grain` | ✅ integrada |
| 4 | Comentarios y textos de plantilla en el código | Limpiar los marcadores y escribir la documentación que anuncian | `ballerina`, `clojure`, `common-lisp`, `cpp`, `crystal`, `dart` | ✅ integrada |
| 5 | Cabeceras obligatorias del README renombradas | Restaurar los nombres de la plantilla | `erlang`, `scheme`, `tcl-tk` | ✅ integrada |

## Plan de cierre / Closure plan

**ES:** El pase está **cerrado** (2026-10-16): las 50 suites ejecutadas y los 15 hallazgos integrados en el `main` de sus 15 submódulos y empujados, con los punteros del monorepo sincronizados. El módulo queda 🟢 50/50: sin 🔴, sin 🟡 y sin desviaciones aceptadas, así que no hay fichas nuevas en `docs/ruleset/idioms/`. El cierre queda registrado en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) y en la nota del módulo en [`ROADMAP.md`](../ROADMAP.md) —el contador del sprint no se toca—.

**EN:** The pass is **closed** (2026-10-16): 50/50 suites executed and the 15 findings integrated into their 15 submodules' `main` and pushed, with the monorepo pointers synced. The module sits at 🟢 50/50: no 🔴, no 🟡 and no accepted deviations, so no new records under `docs/ruleset/idioms/`. The closure is logged in [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) and in the module's note in [`ROADMAP.md`](../ROADMAP.md) —the sprint counter is untouched—.

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-16 | Barrido léxico, estructura y árbol | `git ls-files` por submódulo + `grep -E` de operadores, `src`/`test`, cinco operaciones y las cuatro secciones del README | 50/50 con las cinco operaciones en su fuente; 47/50 con 4/4 secciones; 50/50 árboles limpios y en `main` |
| 2026-10-16 | Ejecución de suites (lote 1) | `alr -C tests run` · `make run` · `make test` · `crystal spec` · `dub test` · `dart test` · `mix test` · `rebar3 eunit` · `gleam test` | 10/10 rc=0, cinco pruebas en cada uno |
| 2026-10-16 | Ejecución de suites (lote 2) | `elm-test` · `gforth` · `dotnet test` · `go test ./...` · `make test` · `./gradlew test` · `cabal test` · `haxe build.hxml` · `mvn test` · `npm test` | 8/10 rc=0; `forth` y `grain` no admiten el comando del catálogo (ver deuda 5) |
| 2026-10-16 | Ejecución de suites (lote 3) | `julia --project=. test/run_tests.jl` · `gradle test` · `busted` · `nimble test` · `dune runtest` · `prove --ext=.pl test/` · `composer test` · `swipl` · `spago test` · `pytest` | 8/10 rc=0; `julia` (runner, ver deuda 5) y `ocaml` rc=1 (`Module "Main" doesn't exist`) |
| 2026-10-16 | Ejecución de suites (lotes 4 y 5) | `make test` · `raco test -x .` · `prove6 -l t/` · `npm test` · `rexx` · `bundle exec rspec` · `cargo test` · `sbt -batch -no-colors test` · `guile` · `swift test` · `tclsh9.0` · `v test .` · `valac` · `zig build test` | 15/15 rc=0, cinco pruebas en cada uno |
| 2026-10-16 | Ejecución dirigida donde había duda | `./gradlew test --rerun-tasks` · `gradle test --rerun-tasks` · `zig build test --summary all --cache-dir /tmp/…` · `julia --project=. test/CalculatorTest.jl` · `gforth run_tests.forth` · `make run` (grain) · `dune build @test/runtest` | Pruebas realmente ejecutadas: 5 en `groovy` y `kotlin` (informe XML), 5/5 en `zig`, 5 en `julia`, `Tests run: 5 Passed: 5` en `forth`, 5 `PASSED` en `grain`; `ocaml` compila su suite con el target propio (rc=0) |
| 2026-10-16 | Restos de plantilla | `git grep -nIE 'TODO\|FIXME\|parameter description\|blah blah\|awesome'` y `git ls-files` de nombres de plantilla | 9 lenguajes: `ballerina`, `clojure`, `common-lisp`, `cpp`, `crystal`, `dart`, `csharp`, `fsharp` y `haxe` (`src`); `v` y `go` por el módulo/paquete `src` |
| 2026-10-16 | Revisión de los hallazgos de convención | `git ls-files` y `git show` de `04_Numbers` en `v`, `go`, `haxe` y `dart` | Cuatro hallazgos retirados: el `src` como módulo o paquete es la convención del repositorio (V y Haxe la exigen por la ruta; Go la repite en `numbers`), lo mismo que `*_base.dart` en Dart y `testify` en Go |
| 2026-10-16 | Arreglo del 🔴 de `ocaml` | `dune exec test/test_calculator.exe` y `dune runtest` tras añadir `bin/main.ml` | 5 pruebas de Alcotest en verde y `dune runtest` rc=0 (antes: `Error: Module "Main" doesn't exist`); `dune exec calculator` imprime las cinco operaciones |
| 2026-10-16 | **Integración y re-ejecución de las 15 suites** | Los 15 comandos del catálogo sobre el `main` integrado: `bal test`, `clojure -T:build test`, `ros run --load run-tests.lisp …`, `bazelisk test //...`, `crystal spec`, `dotnet test calculator.slnx`, `dart test`, `rebar3 eunit`, `dotnet test`, `gforth run-tests.forth`, `make test`, `julia --project=. test/run_tests.jl`, `dune runtest`, `guile --no-auto-compile -s calculator_test_guile.scm`, `tclsh9.0 calculator.test` | **15/15 rc=0 con 5 pruebas cada uno**; `dune runtest` ya no falla; 15 commits de `align` fusionados en el `main` de su submódulo y empujados, sin ramas de trabajo abiertas y con los 15 punteros del monorepo sincronizados |
