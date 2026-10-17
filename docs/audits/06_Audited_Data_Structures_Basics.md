# Auditoría de Módulo: 06_Data_Structures_Basics
# Module Audit: 06_Data_Structures_Basics

Registro de deuda técnica del módulo `06_Data_Structures_Basics`. / Technical debt record for the `06_Data_Structures_Basics` module.

- **Especificación / Specification:** [`06_Data_Structures_Basics.md`](../core/algorithms/06_Data_Structures_Basics.md)
- **Convención de esta carpeta / Folder convention:** [`README.md`](README.md)
- **Alcance / Scope:** capa del módulo en [`README.md`](README.md) + los 9 ejes de [`IDIOMATICITY_LEVELS.md`](../ruleset/IDIOMATICITY_LEVELS.md)
- **Estado parcial / Partial state:** [`data/idiomaticity_state.tsv`](../ruleset/data/idiomaticity_state.tsv)
- **Última verificación / Last verification:** 2026-10-17

---

## Criterios de Evaluación / Evaluation Criteria

**ES:** Dos capas. La del **módulo** sale de los criterios de aceptación y de la política de resultados de su especificación; la del **lenguaje**, de los 9 ejes del ruleset.

**EN:** Two layers. The **module** layer comes from its specification's acceptance criteria and result policy; the **language** layer from the ruleset's 9 axes.

1. **Fidelidad al módulo.** `Node`, `LinkedList`, `Stack` y `Queue` construidos desde cero —sin colección de biblioteca que haga su trabajo—, la **política de resultados** por operación (el indicador de fallo del lenguaje, declarado en el README: `null`, `nil`, `#f`, `-1`, ausencia…), la suite de casos de la especificación y el README de Nivel 3. Techo: $O(1)$ por operación.
2. **Idiomaticidad del lenguaje.** `construction`, `naming`, `failure`, `access`, `encapsulation`, `unsafe`, `complexity`, `documentation` y `tests`, con la severidad de [`DEVIATION_POLICY.md`](../ruleset/DEVIATION_POLICY.md).

> **ES:** Precisiones fijadas al abrir la auditoría 06 (2026-10-17): el techo es **$O(1)$ en todas las operaciones salvo `delete`, que es $O(n)$** por especificación (antes este registro decía «$O(1)$ por operación»); los extremos finales (`insert_tail`, `enqueue`) son $O(1)$ **solo con celda mutable**, y donde la celda es inmutable la reconstrucción del camino los deja en $O(n)$, cota que cuenta como conforme si el README la declara; el **tipo opcional nativo** se admite únicamente en el enlace (`next`) y nunca como resultado de operación, que usa el centinela o el booleano declarados. Las 50 filas del estado se reescriben con el resultado real de este pase.
>
> **EN:** Precisions settled when audit 06 opened (2026-10-17): the ceiling is **$O(1)$ for every operation except `delete`, which is $O(n)$** by specification (this record used to say "$O(1)$ per operation"); end operations (`insert_tail`, `enqueue`) are $O(1)$ **only with a mutable cell**, and where the cell is immutable rebuilding the path leaves them at $O(n)$, a bound that counts as conforming when the README declares it; the **native optional type** is allowed only on the link (`next`) and never as an operation result, which uses the declared sentinel or boolean. The 50 state rows are rewritten with the real result of this pass.

## Comprobaciones por lenguaje / Per-language checks

**ES:** Con los criterios fijados, el paso 2 se reduce a siete comprobaciones por lenguaje.

**EN:** With the criteria settled, step 2 boils down to seven checks per language.

| # | Comprobación / Check | Cómo se verifica / How it is verified |
|---|---|---|
| 1 | Un solo `Node` compartido / One shared `Node` | Un único tipo de celda en la fuente; `LinkedList`, `Stack` y `Queue` con punteros propios (`head`/`tail`, `top`, `front`/`rear`) y su contador / A single cell type in the source; each structure with its own pointers and counter |
| 2 | Sin delegación / No delegation | `push`, `enqueue`, `pop` y `dequeue` no llaman a operaciones de la lista ni a colecciones de la biblioteca / they do not call list operations or library collections |
| 3 | `init` obligatorio / Mandatory `init` | La instancia se declara y `init` (`Make` o constructor) la inicializa antes de `is_empty`; contador a cero / declared, then initialized before `is_empty`; counter at zero |
| 4 | Indicador por tipo de retorno / Indicator per return type | Centinela numérico en las extracciones y booleano en éxito/fallo, declarados en el README / numeric sentinel for extraction, boolean for success/failure, declared in the README |
| 5 | Complejidad / Complexity | $O(1)$ salvo `delete` ($O(n)$); extremos $O(n)$ solo con celda inmutable y declarado / $O(1)$ except `delete`; ends $O(n)$ only for an immutable cell, declared |
| 6 | Casos como pasos sucesivos / Cases as successive steps | `Node` 2, `LinkedList` 5, `Stack` 4, `Queue` 4, sobre la misma instancia / on the same instance |
| 7 | README y aislamiento / README and isolation | Nivel 3, adaptaciones declaradas y sin imports de otros módulos del roadmap / Level 3, adaptations declared, no imports from other roadmap modules |

## Alcance y método de esta verificación / Scope and method

| Paso / Step | Alcance / Scope | Resultado / Result |
|-------------|-----------------|--------------------|
| 1. Barrido léxico | 50 lenguajes, solo archivos rastreados por git | ✅ 50/50 auditados |
| 2. Lectura de código | Constructor, enlaces, indicador de fallo y comentarios | ✅ 7 comprobaciones por lenguaje |
| 3. Ejecución de suites | Comando nativo del catálogo por lenguaje | ✅ 50/50 en verde |
| 4. Documentación | README del módulo y comentarios del código | ✅ 4/4 secciones en los 50 y sin comentarios de andamiaje tras el `align` |
| 5. Estado del árbol | `git status --short` en los 50 submódulos | ✅ 50/50 limpios tras revertir el artefacto de `ballerina` |

**ES:** Las **50 filas** que ya existen en el estado son **heredadas del flujo antiguo** (16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` y 2 `mostly-idiomatic`; ninguna en `idiomatic`) y se **reescriben** con el resultado real de este pase, incluido el commit de cada submódulo.

**EN:** The **50 rows** already present in the state are **legacy from the old workflow** (16 `transitional`, 15 `workaround`, 9 `not-started`, 8 `not-audited` and 2 `mostly-idiomatic`; none in `idiomatic`) and are **rewritten** with the real result of this pass, including each submodule's commit.

## Estado por Lenguaje / Status by Language

### 🔴 Requieren Refactorización (Fallo) / Require Refactoring (Fail)

- — (ninguno: `ocaml` quedó corregido en `b549ce8` y `a94f918`, integrado y verificado)

### 🟡 Advertencias / Warnings

- — (ninguna: `groovy`, `nim`, `common-lisp`, `fsharp`, `haskell`, `haxe`, `php`, `purescript` y `python` quedaron corregidos, integrados y verificados)

### 🔵 Aceptados por el autor / Accepted by the author

- — (ninguno / none)

### 🟢 Homologados / Homologated

- **50 lenguajes**: `ada`, `assembly`, `ballerina`, `c`, `clojure`, `cobol`, `common-lisp`, `cpp`, `crystal`, `csharp`, `d`, `dart`, `elixir`, `elm`, `erlang`, `forth`, `fsharp`, `gleam`, `go`, `grain`, `groovy`, `haskell`, `haxe`, `java`, `javascript`, `julia`, `kotlin`, `lua`, `nim`, `ocaml`, `perl`, `php`, `prolog`, `purescript`, `python`, `r`, `racket`, `raku`, `rescript`, `rexx`, `ruby`, `rust`, `scala`, `scheme`, `swift`, `tcl-tk`, `typescript`, `v`, `vala`, `zig`

## Deuda por lenguaje / Debt per language

**ES:** Las diez sub-tareas del pase están cerradas: diez commits de `align` (dos en `ocaml`, `groovy` y `nim`), integrados con `--no-ff` y empujados, y las diez suites re-ejecutadas sobre el `main` integrado.
**EN:** All ten sub-tasks of this pass are closed: ten `align` commits (two each in `ocaml`, `groovy` and `nim`), merged with `--no-ff` and pushed, and the ten suites re-run against the integrated `main`.

| Lenguaje / Language | Estado / Status | `align` | Integración / Merge | Qué se hizo / What was done |
|---|---|---|---|---|
| `ocaml` | ✅ | `b549ce8`, `a94f918` | `d2d841e` | Centinela `-1` en las cuatro lecturas y `option` solo en enlaces; demo real en `bin/main.ml` |
| `groovy` | ✅ | `a221b83`, `58fc2cd` | `51a4e0e` | `lib/bin` fuera del índice y en el `.gitignore`; cabeceras de andamiaje retiradas |
| `nim` | ✅ | `1b2d936`, `5bfbdf2` | `1a80d72` | Binario `.out` fuera del índice; cabecera de andamiaje retirada |
| `common-lisp` | ✅ | `3aa7115` | `e4f2497` | Un solo README (`.md`) |
| `fsharp` | ✅ | `69829ca` | `f53aaee` | Cabecera de andamiaje retirada |
| `haskell` | ✅ | `61b42bb` | `e843b27` | Cabecera de andamiaje retirada |
| `haxe` | ✅ | `8dd9209` | `86f80e3` | Cuatro cabeceras de andamiaje retiradas |
| `php` | ✅ | `e34bd1f` | `440e818` | Cabecera de andamiaje retirada |
| `purescript` | ✅ | `cf79a42` | `1c28b5b` | Cabecera de andamiaje retirada |
| `python` | ✅ | `10e3616` | `8201986` | Tres docstrings de andamiaje retirados |

## Plan de cierre / Closure plan

**ES:** **Cerrado el 2026-10-17.** El pase completo se ejecutó sobre los 50 lenguajes (5 pasos, 50 suites en verde), los diez hallazgos se corrigieron en diez commits de `align`, se integraron con `--no-ff` en el `main` de cada submódulo y se empujaron, y las diez suites se re-ejecutaron sobre el código integrado. El bloque de 50 filas de `data/idiomaticity_state.tsv` queda en `idiomatic` con el commit de integración de cada lenguaje.

**EN:** **Closed on 2026-10-17.** The full pass ran across the 50 languages (5 steps, 50 suites green), the ten findings were fixed in ten `align` commits, merged with `--no-ff` into each submodule's `main` and pushed, and the ten suites were re-run against the integrated code. The 50-row block in `data/idiomaticity_state.tsv` is `idiomatic` with each language's integration commit.

## Registro de verificaciones / Verification log

| Fecha / Date | Alcance / Scope | Comando / Command | Resultado / Result |
|--------------|-----------------|-------------------|--------------------|
| 2026-10-17 | Estructura del módulo (50) | `git ls-files core/algorithms/data_structures_basics` | Cuatro estructuras presentes en los 50; README con las cuatro secciones, 4/4 en los 50 |
| 2026-10-17 | Un solo `Node` y sin delegación (50) | `grep` de tipos de celda alternativos y de `insert_*` en pila/cola | Sin tipos duplicados; 0 archivos de `Stack`/`Queue` llaman a operaciones de la lista |
| 2026-10-17 | Colecciones de biblioteca (50) | `grep` de `java.util.*`, `collections.deque`, `std::collections`, `VecDeque`, `Data.Sequence`… | Sin uso; los `new LinkedList()` son la clase propia del módulo |
| 2026-10-17 | Indicador por tipo de retorno (50) | Lectura de fuentes y README | 1 hallazgo: `ocaml` usa `int option` en lecturas |
| 2026-10-17 | Artefactos rastreados (50) | `git ls-files` filtrado por directorios de build y binarios | 2 hallazgos: `groovy` (`lib/bin/`) y `nim` (`.out`) |
| 2026-10-17 | Comentarios de andamiaje (50) | `grep` de `step 4b`, `Contract stub`, «Implementación pendiente», «Esqueleto» | 8 hallazgos |
| 2026-10-17 | Los casos de la especificación | `grep` de los valores 10, 20, 30, 40 y 99 en las suites | 5/5 en los 50 |
| 2026-10-17 | Suites nativas (50) | Comando del catálogo [`scripts/data/languages.tsv`](../../scripts/data/languages.tsv) | 50/50 rc=0 |
| 2026-10-17 | Estado del árbol (50) | `git status --short` | 50/50 limpios; `ballerina` escribió `Dependencies.toml` y se revirtió |
| 2026-10-17 | `align` de `ocaml` | `dune build`, `dune runtest --force`, `dune exec data_structures_basics` | `b549ce8`: 4 tests OK; `a94f918`: la demo recorre las cuatro estructuras y muestra `-1` en vacío |
| 2026-10-17 | `align` de los nueve restantes | Suite nativa tras cada cambio | `fsharp` 23 · `groovy` 4 (XML) · `haskell` PASS · `haxe` 4 bloques · `nim` todas · `php` 4/15 · `purescript` 5 · `python` 4 · `common-lisp` 15 comprobaciones |
| 2026-10-17 | Artefactos y andamiaje tras el `align` | `git ls-files` y `grep` de las frases de andamiaje | `lib/bin` y `.out` fuera del índice; una sola README en `common-lisp`; cero cabeceras obsoletas en los 50 |
| 2026-10-17 | Integración (10 submódulos) | Re-ejecución sobre `main` | `ocaml` 4 · `fsharp` 23 · `groovy` 4 · `haskell` PASS · `haxe` 4 bloques · `nim` todas · `php` 4/15 · `purescript` 5 · `python` 4 · `common-lisp` 15 |

### Resultado de las suites por lenguaje / Suite result per language

| Lenguaje | Comando / Command | Resultado / Result |
|---|---|---|
| `ada` | `alr -C tests run` | 4 tests, 0 errores |
| `assembly` | `make run` | 15 aserciones |
| `ballerina` | `bal test` | 0 fallos, 0 omitidos |
| `c` | `make test` | 4 de 4 |
| `clojure` | `clojure -T:build test` | 4 tests, 46 aserciones |
| `cobol` | `make test` | 49 aserciones |
| `common-lisp` | `ros run --load run-tests.lisp` | 15 comprobaciones, 4 tests |
| `cpp` | `bazelisk test //...` | 1 test, PASSED |
| `crystal` | `crystal spec` | 4 ejemplos |
| `csharp` | `dotnet test DataStructuresBasics.slnx` | 4 tests |
| `d` | `dub test` | 1 módulo |
| `dart` | `dart test` | 4 tests |
| `elixir` | `mix test` | 4 pasan |
| `elm` | `elm-test` | 4 pasan |
| `erlang` | `rebar3 eunit` | 23 tests |
| `forth` | `gforth run-tests.forth` | 114 aserciones |
| `fsharp` | `dotnet test` | 23 tests |
| `gleam` | `gleam test` | 4 pasan |
| `go` | `go test ./...` | ok |
| `grain` | `make test` | 51 casos |
| `groovy` | `./gradlew test` | 4 tests (XML) |
| `haskell` | `cabal test` | PASS |
| `haxe` | `haxe build.hxml` | 4 bloques OK |
| `java` | `mvn test` | 23 tests (surefire) |
| `javascript` | `npm test` | 4 pasan |
| `julia` | `julia --project=. test/run_tests.jl` | 51 pasan |
| `kotlin` | `gradle test` | 4 tests (XML) |
| `lua` | `busted` | 4 éxitos |
| `nim` | `nimble test` | todas pasan |
| `ocaml` | `dune runtest --force` | 4 tests |
| `perl` | `prove --ext=.pl test/` | 4 tests, PASS |
| `php` | `composer test` | 4 tests, 15 aserciones |
| `prolog` | `swipl -q -f data_structures_basics_tests.pl -t halt` | 23 pasan |
| `purescript` | `spago test` | 5 pasan |
| `python` | `pytest` | 4 pasan |
| `r` | `make test` | 55 pasan |
| `racket` | `raco test -x .` | 53 pasan |
| `raku` | `prove6 -l t/` | 4 archivos, PASS |
| `rescript` | `npm test` | 15 pasan |
| `rexx` | `rexx test/data_structures_basics_tests.rexx` | 23 ejecuciones, 106 aserciones |
| `ruby` | `bundle exec rspec` | 4 ejemplos |
| `rust` | `cargo test` | 22 pasan |
| `scala` | `sbt -batch test` | 19 pasan |
| `scheme` | `guile -s data_structures_basics_tests_guile.scm` | 85 pasan |
| `swift` | `swift test` | 4 XCTest |
| `tcl-tk` | `tclsh9.0 data_structures_basics.test` | 19 pasan |
| `typescript` | `npm test` | 5 pasan |
| `v` | `v test .` | 1 archivo, pasa |
| `vala` | `valac … && /tmp/…` | 4 ok |
| `zig` | `zig build test` | rc=0 |
