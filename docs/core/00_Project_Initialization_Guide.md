---
layout: default
title: 00 — Project Initialization Guide
description: Comandos de inicialización por lenguaje para crear el esqueleto de un módulo / Per-language initialization commands to scaffold a module
nav_order: 0
parent: Core
grand_parent: Programming Languages Monorepo
---

# 🧰 00 — Guía de inicialización de proyectos / Project Initialization Guide

> [← Volver a Core](README.md) · [↑ Inicio / Back to home](../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Concentrar en **un solo archivo** los comandos de inicialización de los **50 lenguajes** homologados, para crear el esqueleto de un módulo nuevo sin tener que recordar la herramienta de cada ecosistema. Los requisitos de instalación no se repiten aquí: cada lenguaje los documenta en su propio README. | Gather in a **single file** the initialization commands for the **50 standardized languages**, so the skeleton of a new module can be created without remembering each ecosystem's tooling. Installation requirements are not repeated here: each language documents them in its own README. |

**ES:** Este documento cubre la **creación del esqueleto** (carpetas, manifiesto y archivos base). El código, la especificación y los tests siguen el flujo normal: especificación en `docs/core/`, implementación en `{lenguaje}/core/{fase}/{module}/`, README al cerrar el módulo.

**EN:** This document covers **skeleton creation** (folders, manifest, and base files). Code, specification, and tests follow the normal flow: spec in `docs/core/`, implementation in `{language}/core/{phase}/{module}/`, README when closing the module.

---

## 🧭 Cómo leer esta guía / How to read this guide

Todos los comandos se ejecutan **desde la raíz del submódulo del lenguaje**, dentro de la carpeta del módulo:

```bash
cd {lenguaje}/core/{fase}/{module}
```

Ejemplos reales de ruta:

```text
ada/core/foundations/numbers       # Fase 0 — Fundamentos
dart/core/algorithms/naive_sort    # Fase 1 — Algoritmos Puros
```

### Leyenda / Legend

| Marca | Significado / Meaning |
|:-----:|----------------------|
| ✅ | Comando **verificado**: está documentado en el README de un módulo de este repositorio. |
| 🔧 | Comando **estándar del ecosistema**: no está documentado en este repositorio, pero es la herramienta oficial del lenguaje para generar un esqueleto tipo librería. |
| ✍️ | **Sin herramienta de scaffolding**: el proyecto se crea a mano. Se describe la estructura usada por el módulo `numbers/` de ese lenguaje. |
| ⛓️ | **Inicialización por secuencia**: el comando mostrado es el primero de una secuencia, y puede haber un **completado posterior** a mano. El detalle está en [Secuencias de varios pasos](#-secuencias-de-varios-pasos--multi-step-sequences) y, como dato, en [`scripts/data/init_sequences.tsv`](../../scripts/data/init_sequences.tsv). |

`{module}` es el nombre del módulo (`numbers`, `naive_sort`, …) y `{Module}` su forma en `PascalCase` cuando el lenguaje lo exige (`Numbers`, `NaiveSort`).

### Cómo se elige la herramienta / How the tool is chosen

**ES:** Reglas fijadas el 2026-09-26; deciden qué comando aparece en la tabla y cuándo un lenguaje se queda en `✍️`:

- **R1 — Se usa la herramienta del ecosistema instalada**, aunque su salida difiera de la convención anterior, y **lo que falte se completa a mano** (carpetas, manifiesto, configuración del runner): es lo que haría un desarrollador. El tooling solo **automatiza ejecutar comandos**.
- **R2 — Se descarta** la herramienta cuyo esqueleto es para una **aplicación** y no para una **biblioteca**.
- **R3 — Se acepta** la herramienta que añada documentos o carpetas extra que no alejen del proyecto de biblioteca.
- **R4 — La herramienta de construcción** puede cambiarse por la más usada del lenguaje (Make, CMake, meson…), pero **no es obligatorio** cambiarla.
- **R5 — Decide el uso y la aceptación de la comunidad** del lenguaje.
- **R6 — Si la herramienta impone otra estructura, el módulo ya homologado se actualiza al retomar ese lenguaje**: es deuda declarada, no trabajo de la fase en curso.

**EN:** Rules set on 2026-09-26; they decide which command appears in the table and when a language stays `✍️`:

- **R1 — The installed ecosystem tool is used**, even when its output differs from the previous convention, and **whatever is missing is completed by hand** (folders, manifest, runner configuration): that is what a developer would do. The tooling only **automates running commands**.
- **R2 — A tool whose skeleton is for an application** rather than a **library** is rejected.
- **R3 — A tool that adds extra documents or folders** which do not move the library project away is accepted.
- **R4 — The build tool** may be swapped for the language's most used one (Make, CMake, meson…), but changing it is **not mandatory**.
- **R5 — Community usage and acceptance decides**.
- **R6 — When the tool imposes another structure, the already-homologated module is updated when that language is retaken**: it is declared debt, not work for the phase in progress.

**ES:** Con R1–R6 el reparto del catálogo es **33 `tool` · 17 `manual` · 0 `deferred`**. Un lenguaje **no** se marca `✍️` por tener un generador distinto, sino solo cuando no hay herramienta de biblioteca aceptada (R2/R5) o cuando no existe generador.

**EN:** Under R1–R6 the catalogue splits **33 `tool` · 17 `manual` · 0 `deferred`**. A language is **not** marked `✍️` for having a different generator, but only when there is no accepted library tool (R2/R5) or no generator at all.

---

## 📊 Tabla maestra / Master table

Las rutas de la columna **Manifiesto** son relativas a la carpeta del módulo.

| Lenguaje | Comando de inicialización | Manifiesto / archivos clave | Pruebas |
|----------|---------------------------|-----------------------------|---------|
| **ada** | ⛓️ ✅ `alr init --lib --in-place {module}` | `alire.toml`, `{module}.gpr`, `config/`, `tests/` | ✅ `alr -C tests run` |
| **assembly** | ✍️ `mkdir -p src test` + `Makefile` | `Makefile` | ✅ `make run` |
| **ballerina** | 🔧 `bal new {module}` | `Ballerina.toml`, `{module}.bal`, `tests/` | ✅ `bal test` |
| **c** | ✍️ `mkdir -p include src test` + `Makefile` | `include/{module}.h`, `Makefile` | ✅ `make test` |
| **clojure** | ⛓️ 🔧 `clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib` | `deps.edn`, `build.clj`, `src/{module}/` | ✅ `clojure -T:build test` |
| **cobol** | ✍️ `mkdir -p src/copybooks src/lib test` | `Makefile`, `run_tests` | ✅ `make test` |
| **common-lisp** | ⛓️ 🔧 `quickproject:make-project` vía `ros` + quicklisp | `{module}.asd`, `package.lisp`, `src/`, `test/`, `run-tests.lisp` | ✅ `ros run --load run-tests.lisp --eval '(uiop:quit)'` |
| **cpp** | ✅ Configuración manual de Bazel (`MODULE.bazel`, `WORKSPACE`, targets en `BUILD`) | `BUILD`, `MODULE.bazel`, `.bazelversion` | ✅ `bazelisk test //...` |
| **crystal** | 🔧 `crystal init lib {module}` | `shard.yml` | ✅ `crystal spec` |
| **csharp** | ⛓️ ✅ `dotnet new sln -n {Module}` | `{Module}.slnx`, `src/{Module}/{Module}.csproj`, `test/{Module}.Tests/` | ✅ `dotnet test {Module}.slnx` |
| **d** | ✅ `dub init {module} --format=sdl` | `dub.sdl` | ✅ `dub test` |
| **dart** | ✅ `dart create -t package {module}` | `pubspec.yaml`, `analysis_options.yaml` | ✅ `dart test` · ✅ `dart analyze` |
| **elixir** | 🔧 `mix new {module} --module {Module}` | `mix.exs` | ✅ `mix test` |
| **elm** | 🔧 `elm init` | `elm.json` | ✅ `elm-test` |
| **erlang** | ✅ `rebar3 new lib {module}` | `rebar.config`, `src/{module}.app.src` | ✅ `rebar3 eunit` |
| **forth** | ✍️ `mkdir -p src test` | — (runner casero `test.forth`) | ✅ `cd test && gforth run-tests.forth` |
| **fsharp** | ⛓️ 🔧 `dotnet new sln -n {Module}` (después `classlib -lang F#` y `xunit`; el layout homologado es plano) | `{Module}.slnx`, `src/{Module}.fsproj`, `test/{Module}.Tests.fsproj` | ✅ `dotnet test` |
| **gleam** | ✅ `gleam new {module}` | `gleam.toml`, `manifest.toml` | ✅ `gleam test` |
| **go** | ✅ `go mod init example.com/{module}` | `go.mod` | ✅ `go test ./...` |
| **grain** | ✍️ `mkdir -p src tests` + `Makefile` | `Makefile` | ✅ `make test` |
| **groovy** | ⛓️ ✅ `gradle init --type groovy-library --dsl groovy --use-defaults` | `settings.gradle`, `lib/build.gradle`, `gradle/` | ✅ `./gradlew test` |
| **haskell** | 🔧 `cabal init --lib` | `{module}.cabal` | ✅ `cabal test` |
| **haxe** | ⛓️ ✅ `mkdir -p src test` (después `haxelib install utest`) | `build.hxml`, `RunTests.hx` | ✅ `haxe build.hxml` |
| **java** | ✍️ `pom.xml` a mano (el arquetipo `quickstart` es de aplicación: R2) | `pom.xml` | ✅ `mvn test` |
| **javascript** | 🔧 `npm init -y` | `package.json`, `jest.config.js` | ✅ `npm test` |
| **julia** | ⛓️ 🔧 `julia -e 'using Pkg; Pkg.generate("{module}")'` | `Project.toml`, `src/{Module}.jl`, `test/` | ✅ `julia --project=. test/run_tests.jl` |
| **kotlin** | ⛓️ ✅ `gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project` | `build.gradle.kts`, `settings.gradle.kts` | ✅ `gradle test` |
| **lua** | 🔧 `luarocks init` | `{module}.rockspec`, `.busted` | ✅ `busted` |
| **nim** | ⛓️ ✅ `nimble init` (tipo `library`; lo conduce `expect`) | `{module}.nimble`, `src/{module}.nim`, `test/config.nims` | ✅ `nimble test` |
| **ocaml** | ⛓️ ✅ `dune init proj {module}` (quitar `bin/` y el `.opam`) | `dune-project`, `src/dune`, `test/dune` | ✅ `dune runtest` |
| **perl** | ⛓️ 🔧 `module-starter --module={module} --dir=.` | `Makefile.PL`, `lib/{module}.pm`, `t/` | ✅ `prove --ext=.pl test/` |
| **php** | ✍️ `mkdir -p src test` + `composer require --dev phpunit/phpunit` | `composer.json`, `phpunit.xml`, `.gitignore` | ✅ `composer test` |
| **prolog** | ✍️ `mkdir -p src test` | — | ✅ `cd test && swipl -q -f {suite}.pl -t halt` |
| **purescript** | 🔧 `spago init` | `spago.yaml` | ✅ `spago test` |
| **python** | ⛓️ ✅ `uv init --lib .` | `pyproject.toml`, `src/{module}/`, `conftest.py`, `tests/` | ✅ `pytest` |
| **r** | ✅ `mkdir -p src test` | — | ✅ `Rscript test/run_tests.R` |
| **racket** | ⛓️ 🔧 `raco pkg new {module}` | `info.rkt`, `main.rkt`, `scribblings/` | ✅ `racket test/run_tests.rkt` |
| **raku** | ✅ `mkdir -p lib t` | — | ✅ `prove6 -l t/` |
| **rescript** | ⛓️ ✅ `mkdir -p src test` (el `package.json` va antes del `npm install`) | `rescript.json`, `package.json`, `jest.config.js` | ✅ `npm test` |
| **rexx** | ✅ `mkdir -p src test` | — | ✅ `rexx test/{suite}.rexx` |
| **ruby** | ⛓️ ✅ `mkdir -p src test` (después `bundle init` y `bundle install`) | `Gemfile`, `.rspec` | ✅ `bundle exec rspec` |
| **rust** | ✅ `cargo init --lib` | `Cargo.toml` | ✅ `cargo test` |
| **scala** | ✍️ `mkdir -p src/main/scala src/test/scala project` + `build.sbt` (el runner instalado, sbt 2.0.8, ya no trae `sbt new`) | `build.sbt`, `project/build.properties` | ✅ `sbt -batch -no-colors test` |
| **scheme** | ✍️ `mkdir -p src test` | — | ✅ `cd test && guile --no-auto-compile -s {suite}_guile.scm` |
| **swift** | 🔧 `swift package init --type library` | `Package.swift`, `Sources/{Module}/` | ✅ `swift test` |
| **tcl-tk** | ✅ `mkdir -p src test` | `src/pkgIndex.tcl` | ✅ `cd test && TCLLIBPATH="$(cd ../src && pwd)" tclsh9.0 {suite}.test` |
| **typescript** | ✅ `npm init -y` | `package.json`, `tsconfig.json`, `jest.config.cjs` | ✅ `npm test` |
| **v** | ⛓️ ✅ `v init --lib` (lo conduce `expect`; quitar el `.git` anidado) | `v.mod`, `{module}.v`, `test/` | ✅ `v test .` |
| **vala** | ⛓️ 🔧 `meson init --language vala --type library --name {module}` | `meson.build`, `src/`, `test/` | ✅ `valac src/{module}.vala test/{suite}.vala --pkg glib-2.0 -o /tmp/{module}-tests && /tmp/{module}-tests` |
| **zig** | ✅ `zig init` | `build.zig` | ✅ `zig build test` |

---

## 🔗 Secuencias de varios pasos / Multi-step sequences

**ES:** Estos lenguajes necesitan más de un comando, **otro directorio de trabajo** o un **completado posterior** a mano. El comando se ejecuta desde la **carpeta del módulo** (`{lenguaje}/core/{fase}/{module}`), que es donde deja al autor `glot use`; la excepción son los **cuatro** generadores que **crean la carpeta ellos mismos** y se ejecutan desde la **fase**: `common-lisp`, `julia`, `clojure` y `racket` (medido el 2026-09-26: `quickproject:make-project` crea el directorio del proyecto).

**EN:** These languages need more than one command, **another working directory** or a later **completion** by hand. The command runs from the **module folder** (`{language}/core/{phase}/{module}`), where `glot use` leaves the author; the exception is the **four** generators that **create the folder themselves** and run from the **phase**: `common-lisp`, `julia`, `clojure` and `racket` (measured on 2026-09-26: `quickproject:make-project` creates the project directory).

**ES:** La **fuente de verdad es el dato** [`scripts/data/init_sequences.tsv`](../../scripts/data/init_sequences.tsv): una fila por paso, con lenguaje, orden, directorio de trabajo, modo (`run`/`expect`), comando, requisito, respuestas de `expect` y lo que falta por completar. La tabla de abajo es su **lectura humana**, y el tooling comprueba que las dos no se separen.

**EN:** The **source of truth is the data** in [`scripts/data/init_sequences.tsv`](../../scripts/data/init_sequences.tsv): one row per step, with language, order, working directory, mode (`run`/`expect`), command, requirement, `expect` answers and what is left to complete. The table below is its **human reading**, and the tooling checks that the two do not drift apart.

| Lenguaje | Secuencia | Completado posterior |
|---|---|---|
| `ada` | `alr init --lib --in-place {module}` → `alr init --bin tests` | Licencia `GPL-3.0-or-later` y `tests/alire.toml` (`description`, `[[depends-on]]`, `[[pins]] path='..'`, `aunit`) |
| `clojure` | `clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib :name {module} :target-dir {module}` | Sustituir el test de plantilla |
| `common-lisp` | `ros -e '(ql:quickload :quickproject)' -e '(quickproject:make-project "{module}")'` | Añadir `src/`, `test/` y `run-tests.lisp` |
| `csharp` | `dotnet new sln` → `dotnet new classlib` → `dotnet new xunit` → `dotnet sln add` | `<ProjectReference>` a `src`, borrar `Class1.cs` y `UnitTest1.cs`, `.gitignore` |
| `fsharp` | Igual que C# con `-lang F#` | Aplanar a `src/{Module}.fsproj`, `<ProjectReference>`, borrar `Library.fs` y `Tests.fs`, `.gitignore` |
| `groovy` | `gradle init --type groovy-library --dsl groovy --use-defaults` | Borrar `Library.groovy` y `LibraryTest.groovy` |
| `haxe` | `mkdir -p src test` → `haxelib install utest` | `build.hxml` y `RunTests.hx` son contenido del sprint |
| `julia` | `julia -e 'using Pkg; Pkg.generate("{module}")'` | Completar `test/` y su runner; añadir `uuid`, `[compat]`, `[extras]` y `[targets]` |
| `kotlin` | `gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project` | Borrar `Library.kt` y `LibraryTest.kt` |
| `nim` | `nimble init` (tipo `library`; lo conduce `expect`) | Llevar `src/{module}/{module}.nim` a `src/{module}.nim`, `tests/` a `test/` y añadir la `task test` |
| `ocaml` | `dune init proj {module}` | Quitar `bin/`, aplanar a `src/` y borrar el `.opam` |
| `perl` | `module-starter --module={module} --dir=.` | Aceptar `lib/` y `t/`, pasar el runner a `prove -l t/`; `PERL5LIB` y `PATH` |
| `python` | `uv init --lib .` | Borrar el `.git` que crea `uv`, añadir `conftest.py` y `tests/` con configuración de pytest |
| `racket` | `raco pkg new {module}` | Quitar `.github/` si no se usa y decidir el paso a `src/` y `test/` |
| `rescript` | `mkdir -p src test` → `npm install` | El `package.json` con el compilador y Jest va **antes** |
| `ruby` | `mkdir -p src test` → `bundle init` → `bundle install` | `rspec` en el `Gemfile` y `.rspec` |
| `v` | `v init --lib` (lo conduce `expect`) | Quitar el `.git` anidado y llevar `tests/` a `test/` |
| `vala` | `meson init --language vala --type library --name {module}` | Completar `src/` y `test/` y decidir el build con meson |

> **ES:** Si el generador crea un `main` o un `app` de ejemplo (caso de `dub init` en D, `zig init`; `cargo init --lib` genera solo la librería), bórralo cuando el módulo sea una biblioteca: un `main` propio rompe el runner de tests generado por la herramienta. Ese borrado es parte del **completado posterior**.
> **EN:** If the generator creates an example `main` or `app` (e.g. `dub init` in D, `zig init`; `cargo init --lib` generates only the library), delete it when the module is a library: a `main` of your own breaks the tool's generated test runner. That deletion is part of the **later completion**.

**ES:** Un lenguaje que **no** aparece aquí se resuelve con el comando único de la tabla maestra.
**EN:** A language that does **not** appear here is handled by the single command in the master table.

---

## 🧱 Estructuras de referencia / Reference structures

**ES:** Cuando el lenguaje no ofrece una herramienta de inicialización aceptada (R2/R5), la estructura se replica con `mkdir -p`; los árboles siguientes son los que usan los módulos reales de `core/foundations/numbers/` y `core/algorithms/naive_sort/`. En los lenguajes que **sí** tienen herramienta, la sección correspondiente empieza diciendo cuál es y qué queda por **completar**: allí el árbol es el **completado** y la estructura que el módulo seguirá usando hasta que se retome (R6).

**EN:** When the language has no accepted scaffolding tool (R2/R5), the structure is replicated with `mkdir -p`; the trees below are those used by the real modules under `core/foundations/numbers/` and `core/algorithms/naive_sort/`. For languages that **do** have a tool, the matching section starts by naming it and what is left to **complete**: there the tree is the **completion** and the structure the module will keep using until it is retaken (R6).

### Assembly — `Makefile` + `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── Makefile
├── src/                     # un archivo .asm por enfoque
└── test/                    # suites + run_tests.asm + test_macros.inc + test_utils.asm
```

### C — `Makefile` + `include/` + `src/` + `test/`

```bash
mkdir -p include src test
```

```text
{module}/
├── Makefile
├── include/{module}.h       # header público
├── src/{module}.c           # implementación
└── test/                    # una suite .c por enfoque
```

### COBOL — `Makefile` + `src/copybooks` + `test/`

```bash
mkdir -p src/copybooks src/lib test
```

```text
{module}/
├── Makefile
├── run_tests                # script de ejecución
├── src/copybooks/           # copybooks
├── src/lib/                 # programa principal
└── test/                    # ASSERTS.cpy + suites + RUN-TESTS.cbl
```

### Common Lisp — ASDF + `src/` + `tests/`

**ES:** Herramienta (R1): `quickproject:make-project` vía `ros` + quicklisp, desde la carpeta de la fase. Lo que sigue es la estructura **homologada actual**; el generador deja `{module}.asd`, `{module}.lisp` y `package.lisp` en la raíz, así que el módulo se actualizará al retomarlo (R6). A **completar** tras el generador: `src/`, `tests/` y el runner.

**EN:** Tool (R1): `quickproject:make-project` through `ros` + quicklisp, from the phase folder. What follows is the **current homologated** structure; the generator leaves `{module}.asd`, `{module}.lisp` and `package.lisp` at the root, so the module will be updated when retaken (R6). To **complete** after the generator: `src/`, `tests/` and the runner.

```bash
mkdir -p src tests
```

```text
{module}/
├── {module}.asd             # definición del sistema ASDF (+ test-op)
├── run-tests.lisp           # runner FiveAM
├── src/{module}.lisp
└── tests/                   # una suite .lisp por enfoque
```

### Forth — `src/` + `test/` sin gestor de paquetes

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.forth
└── test/                    # test.forth (runner casero) + suites + run-tests.forth
```

### Grain — `Makefile` + `src/` + `tests/`

```bash
mkdir -p src tests
```

```text
{module}/
├── Makefile
├── src/{module}.gr
└── tests/                   # suites + run_tests.gr + testing.gr
```

### Haxe — `build.hxml` + `src/` + `test/`

```bash
mkdir -p src test
haxelib install utest         # framework de pruebas
```

```text
{module}/
├── build.hxml               # target de compilación y de tests
├── RunTests.hx              # runner de utest
├── src/{Module}.hx
└── test/                    # una suite .hx por enfoque
```

### Java — layout Maven estándar

```bash
mkdir -p src/main/java src/test/java
```

```text
{module}/
├── pom.xml
└── src/
    ├── main/java/           # clase del módulo
    └── test/java/           # una suite JUnit 5 por enfoque
```

### JavaScript — npm + Jest

```bash
npm init -y
npm install --save-dev jest
mkdir -p src test
```

```text
{module}/
├── package.json
├── jest.config.js
├── src/{module}.js
└── test/                    # una suite por enfoque
```

### Julia — paquete estándar de `Pkg`

**ES:** Herramienta (R1): `julia -e 'using Pkg; Pkg.generate("{module}")'`, desde la carpeta de la fase (`Pkg.generate(".")` falla). Lo que sigue es la estructura **homologada actual**; el generador crea `src/{module}.jl` en minúscula, así que el módulo se actualizará al retomarlo (R6). A **completar**: `uuid`, `[compat]`, `[extras]` y `[targets]` en el `Project.toml`, y el runner `test/run_tests.jl`.

**EN:** Tool (R1): `julia -e 'using Pkg; Pkg.generate("{module}")'`, from the phase folder (`Pkg.generate(".")` fails). What follows is the **current homologated** structure; the generator creates lowercase `src/{module}.jl`, so the module will be updated when retaken (R6). To **complete**: `uuid`, `[compat]`, `[extras]` and `[targets]` in `Project.toml`, plus the `test/run_tests.jl` runner.

```bash
mkdir -p src test
```

```text
{module}/
├── Project.toml
├── Manifest.toml
├── src/{Module}.jl
└── test/                    # suites + run_tests.jl
```

### Kotlin — layout Gradle estándar

```bash
mkdir -p src/main/kotlin src/test/kotlin
```

```text
{module}/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle/wrapper/
└── src/
    ├── main/kotlin/         # archivo del módulo
    └── test/kotlin/         # suites Kotest por enfoque
```

### Ocaml — Dune

```bash
mkdir -p src test
```

```text
{module}/
├── dune-project
├── src/dune                 # declara la librería
├── src/{module}.ml          # (+ {module}.mli opcional)
└── test/dune                # declara el ejecutable de tests
```

### Perl — `src/` + `test/`

**ES:** Herramienta (R1): `module-starter --module={module} --dir=.` (necesita `Module::Starter` y su `PERL5LIB`). El generador usa el layout de **distribución** (`lib/`, `t/`, `xt/`, `Makefile.PL`, `MANIFEST`), así que el runner pasa a `prove -l t/` y el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura **homologada actual**.

**EN:** Tool (R1): `module-starter --module={module} --dir=.` (needs `Module::Starter` and its `PERL5LIB`). The generator uses the **distribution** layout (`lib/`, `t/`, `xt/`, `Makefile.PL`, `MANIFEST`), so the runner moves to `prove -l t/` and the module will be updated when retaken (R6); what follows is the **current homologated** structure.

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.pl
└── test/                    # una suite .pl por enfoque (Test2::Bundle::More)
```

### PHP — `src/` + `test/` con Composer y PHPUnit

```bash
mkdir -p src test
composer require --dev phpunit/phpunit
```

```text
{module}/
├── composer.json            # PHPUnit (dev) + autoload classmap + script test
├── phpunit.xml              # bootstrap + suite sobre test/
├── .gitignore               # vendor/, composer.lock y cachés
├── src/{Module}.php
└── test/{Module}Test.php    # una suite PHPUnit por enfoque
```

### Prolog — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.pl          # base de conocimiento
└── test/                    # suites plunit por enfoque
```

### Python — src-layout (PEP 621)

**ES:** Herramienta (R1): `uv init --lib .` (en el sitio; crea también un `.git` que hay que borrar). El generador usa un **paquete** `src/{module}/` con `py.typed` y backend `uv_build`, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura **homologada actual**. A **completar**: `conftest.py`, `tests/` y la configuración de pytest.

**EN:** Tool (R1): `uv init --lib .` (in place; it also creates a `.git` that must be deleted). The generator uses a **package** `src/{module}/` with `py.typed` and the `uv_build` backend, so the module will be updated when retaken (R6); what follows is the **current homologated** structure. To **complete**: `conftest.py`, `tests/` and the pytest configuration.

```bash
mkdir -p src tests
```

```text
{module}/
├── pyproject.toml           # metadatos + configuración de pytest
├── conftest.py              # añade src/ a sys.path
├── src/{module}.py
└── tests/                   # conftest.py + una suite por enfoque
```

### R — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.R
└── test/                    # suites + run_tests.R
```

### Racket — `src/` + `test/`

**ES:** Herramienta (R1): `raco pkg new {module}`, desde la carpeta de la fase. Genera un **paquete** (`info.rkt`, `main.rkt`, `scribblings/`, licencias), que es la forma idiomática de distribuir una biblioteca en Racket y admite los archivos extra (R3); el módulo se actualizará al retomarlo (R6) y lo de abajo es la estructura **homologada actual**.

**EN:** Tool (R1): `raco pkg new {module}`, from the phase folder. It generates a **package** (`info.rkt`, `main.rkt`, `scribblings/`, licences), which is Racket's idiomatic way of shipping a library and accepts the extra files (R3); the module will be updated when retaken (R6) and what follows is the **current homologated** structure.

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.rkt
└── test/                    # suites + run_tests.rkt
```

### Raku — `lib/` + `t/`

```bash
mkdir -p lib t
```

```text
{module}/
├── lib/{Module}.rakumod
└── t/                       # suites .rakutest por enfoque
```

### Rexx — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.rexx
└── test/                    # una suite .rexx por enfoque
```

### Ruby — Bundler + RSpec

```bash
mkdir -p src test
bundle init
bundle install
```

```text
{module}/
├── Gemfile
├── .rspec
├── src/{module}.rb
└── test/                    # una suite _tests.rb por enfoque
```

### Scala — layout sbt estándar

```bash
mkdir -p src/main/scala src/test/scala project
```

```text
{module}/
├── build.sbt
├── project/build.properties
└── src/
    ├── main/scala/          # objeto del módulo
    └── test/scala/          # suites ScalaTest por enfoque
```

### Scheme — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.scm
└── test/                    # suites por enfoque (+ variantes _guile.scm)
```

### Swift — Swift Package Manager

```bash
mkdir -p Sources/{Module} Tests/{Module}Tests
```

```text
{module}/
├── Package.swift
├── Sources/{Module}/        # código público
└── Tests/{Module}Tests/     # suites XCTest
```

### Tcl — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.tcl         # namespace + package provide
├── src/pkgIndex.tcl         # permite package require
└── test/                    # suites .test con Tcltest
```

**ES:** Las suites cargan el paquete con `TCLLIBPATH`, no con una ruta relativa:

**EN:** Suites load the package through `TCLLIBPATH`, not a relative path:

```bash
cd test
TCLLIBPATH="$(cd ../src && pwd)" tclsh9.0 recursive.test
```

### Vala — `src/` + `test/`

**ES:** Herramienta (R1): `meson init --language vala --type library --name {module}` (R4: meson es el build más usado del ecosistema). El generador deja `meson.build` y las fuentes en la raíz, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura **homologada actual**. A **completar**: `src/` y `test/`.

**EN:** Tool (R1): `meson init --language vala --type library --name {module}` (R4: meson is the ecosystem's most used build). The generator leaves `meson.build` and the sources at the root, so the module will be updated when retaken (R6); what follows is the **current homologated** structure. To **complete**: `src/` and `test/`.

```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.vala
└── test/                    # una suite .vala por enfoque (GLib.Test)
```

### V — módulo V

**ES:** Herramienta (R1): `v init --lib`, con las preguntas conducidas con `expect` (descripción, versión, licencia). Crea `{module}.v` en la raíz, `tests/`, `.editorconfig`, `.gitattributes` y un **`.git` anidado** que hay que quitar; el módulo se actualizará al retomarlo (R6) y lo de abajo es la estructura **homologada actual**.

**EN:** Tool (R1): `v init --lib`, with the prompts driven by `expect` (description, version, licence). It creates `{module}.v` at the root, `tests/`, `.editorconfig`, `.gitattributes` and a **nested `.git`** that must be removed; the module will be updated when retaken (R6) and what follows is the **current homologated** structure.

```bash
mkdir -p src test
v init                        # genera v.mod
```

```text
{module}/
├── v.mod
├── src/{module}.v
└── test/                    # archivos _test.v con funciones test_*
```

### Manifiestos que `mkdir` no crea / Manifests `mkdir` does not create

**ES:** Cuando el lenguaje exige un manifiesto mínimo, escríbelo a mano después del `mkdir -p`: `Project.toml` en Julia, `v.mod` en V, `{module}.nimble` en Nim, `{module}.rockspec` en Lua, `pom.xml` en Java, `build.gradle(.kts)` en Groovy y Kotlin.

**EN:** When the language requires a minimal manifest, write it by hand after `mkdir -p`: `Project.toml` in Julia, `v.mod` in V, `{module}.nimble` in Nim, `{module}.rockspec` in Lua, `pom.xml` in Java, `build.gradle(.kts)` in Groovy and Kotlin.

---

## 📁 Convenciones comunes / Common conventions

**ES:**

1. **Separar fuente y pruebas.** `src/` (o `lib/`, `source/`) para el código y `test/` (o `tests/`, `spec/`, `t/`) para las suites. Ninguna suite vive junto al código de producción.
2. **Una suite por enfoque** cuando el módulo tenga variantes (`rec` / `acc` / `ite`). El nombre del archivo refleja el enfoque: `numbers_rec_test`, `numbers_ite_test`, `recursive_tests`, `iterative_tests`.
3. **Un `.gitignore` por módulo** que excluya los artefactos del lenguaje: `bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`, `.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, etc.
4. **Sin `main` propio** cuando el runner de tests lo genera: declarar `main` en un target de librería rompe el runner (caso real en D con `dub test` y en C# con `dotnet test`).
5. **Cerrar el módulo** con su `README.md` generado desde [`README_Template.md`](../README_Template.md), el registro en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) y la actualización de [`ROADMAP.md`](../ROADMAP.md).

**EN:**

1. **Separate sources and tests.** `src/` (or `lib/`, `source/`) for code and `test/` (or `tests/`, `spec/`, `t/`) for suites. No suite lives next to production code.
2. **One suite per approach** when the module has variants (`rec` / `acc` / `ite`). The file name reflects the approach.
3. **One `.gitignore` per module** excluding the language's artifacts: `bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`, `.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, etc.
4. **No `main` of your own** when the test runner generates one: declaring `main` in a library target breaks the runner (real cases: `dub test` in D and `dotnet test` in C#).
5. **Close the module** with its `README.md` generated from [`README_Template.md`](../README_Template.md), the record in [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md), and the update of [`ROADMAP.md`](../ROADMAP.md).

---

## 📝 Notas / Notes

- **ES:** Los comandos marcados ✅ provienen de los READMEs de este repositorio; si actualizas un módulo y cambia su comando de inicialización, actualiza también esta tabla.
- **EN:** Commands marked ✅ come from this repository's READMEs; if you update a module and its initialization command changes, update this table too.
- **ES:** Los comandos marcados 🔧 son la herramienta oficial del ecosistema, útil cuando se quiere empezar desde una plantilla en lugar de la estructura manual. Algunos generan carpetas extra que este repositorio no usa; se pueden borrar.
- **EN:** Commands marked 🔧 are the ecosystem's official tool, useful to start from a template instead of the manual structure. Some generate extra folders this repository does not use; they can be deleted.
- **ES:** Este documento no cubre la instalación de toolchains. Cada lenguaje la documenta en `{lenguaje}/README.md` y en los READMEs de sus módulos.
- **EN:** This document does not cover toolchain installation. Each language documents it in `{language}/README.md` and in its module READMEs.

---

*[← Volver a Core](README.md) · [↑ Inicio / Back to home](../index.md)*
