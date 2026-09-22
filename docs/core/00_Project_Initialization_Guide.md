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

**ES:** Este documento cubre la **creación del esqueleto** (carpetas, manifiesto y archivos base). El código, la especificación y los tests siguen el flujo normal: especificación en `docs/core/`, implementación en `{lenguaje}/core/{fase}/{modulo}/`, README al cerrar el módulo.

**EN:** This document covers **skeleton creation** (folders, manifest, and base files). Code, specification, and tests follow the normal flow: spec in `docs/core/`, implementation in `{language}/core/{phase}/{module}/`, README when closing the module.

---

## 🧭 Cómo leer esta guía / How to read this guide

Todos los comandos se ejecutan **desde la raíz del submódulo del lenguaje**, dentro de la carpeta del módulo:

```bash
cd {lenguaje}/core/{fase}/{modulo}
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

`{modulo}` es el nombre del módulo (`numbers`, `naive_sort`, …) y `{Modulo}` su forma en `PascalCase` cuando el lenguaje lo exige (`Numbers`, `NaiveSort`).

---

## 📊 Tabla maestra / Master table

Las rutas de la columna **Manifiesto** son relativas a la carpeta del módulo.

| Lenguaje | Comando de inicialización | Manifiesto / archivos clave | Pruebas |
|----------|---------------------------|-----------------------------|---------|
| **ada** | ✅ `alr init --lib {modulo}` | `alire.toml`, `{modulo}.gpr`, `config/` | ✅ `alr -C tests run` |
| **assembly** | ✍️ `mkdir -p src test` + `Makefile` | `Makefile` | ✅ `make run` |
| **ballerina** | 🔧 `bal new {modulo}` | `Ballerina.toml`, `{modulo}.bal`, `tests/` | ✅ `bal test` |
| **c** | ✍️ `mkdir -p include src test` + `Makefile` | `include/{modulo}.h`, `Makefile` | ✅ `make test` |
| **clojure** | ✅ `clojure -T:build new` | `deps.edn`, `build.clj` | ✅ `clojure -T:build test` |
| **cobol** | ✍️ `mkdir -p src/copybooks src/lib test` | `Makefile`, `run_tests` | ✅ `make test` |
| **common-lisp** | ✍️ `mkdir -p src tests` | `{modulo}.asd`, `run-tests.lisp` | ✅ `ros run --load run-tests.lisp` |
| **cpp** | ✅ Configuración manual de Bazel (`MODULE.bazel`, `WORKSPACE`, targets en `BUILD`) | `BUILD`, `MODULE.bazel`, `.bazelversion` | ✅ `bazelisk test //...` |
| **crystal** | 🔧 `crystal init lib {modulo}` | `shard.yml` | ✅ `crystal spec` |
| **csharp** | ✅ `dotnet new classlib -n {Modulo} -o src/{Modulo}` | `{Modulo}.slnx`, `src/{Modulo}/{Modulo}.csproj` | ✅ `dotnet test {Modulo}.slnx` |
| **d** | ✅ `dub init {modulo} --format=sdl` | `dub.sdl` | ✅ `dub test` |
| **dart** | ✅ `dart create -t package {modulo}` | `pubspec.yaml`, `analysis_options.yaml` | ✅ `dart test` · ✅ `dart analyze` |
| **elixir** | 🔧 `mix new {modulo} --module {Modulo}` | `mix.exs` | ✅ `mix test` |
| **elm** | 🔧 `elm init` | `elm.json` | ✅ `elm-test` |
| **erlang** | ✅ `rebar3 new lib {modulo}` | `rebar.config`, `src/{modulo}.app.src` | ✅ `rebar3 eunit` |
| **forth** | ✍️ `mkdir -p src test` | — (runner casero `test.forth`) | ✅ `cd test && gforth run-tests.forth` |
| **fsharp** | 🔧 `dotnet new classlib -lang F# -n {Modulo} -o src/{Modulo}` | `{Modulo}.slnx`, `src/{Modulo}/{Modulo}.fsproj` | ✅ `dotnet test` |
| **gleam** | ✅ `gleam new {modulo}` | `gleam.toml`, `manifest.toml` | ✅ `gleam test` |
| **go** | ✅ `go mod init example.com/{modulo}` | `go.mod` | ✅ `go test ./...` |
| **grain** | ✍️ `mkdir -p src tests` + `Makefile` | `Makefile` | ✅ `make test` |
| **groovy** | 🔧 `gradle init --type groovy-library` | `build.gradle`, `settings.gradle`, `gradle/wrapper/` | ✅ `./gradlew test` |
| **haskell** | 🔧 `cabal init --lib` | `{modulo}.cabal` | ✅ `cabal test` |
| **haxe** | ✅ `mkdir -p src test` | `build.hxml`, `RunTests.hx` | ✅ `haxe build.hxml` |
| **java** | 🔧 `mvn archetype:generate -DgroupId=com.example -DartifactId={modulo} -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false` | `pom.xml` | ✅ `mvn test` |
| **javascript** | 🔧 `npm init -y` | `package.json`, `jest.config.js` | ✅ `npm test` |
| **julia** | ✍️ `mkdir -p src test` + `Project.toml` | `Project.toml`, `Manifest.toml` | ✅ `julia --project=. test/run_tests.jl` |
| **kotlin** | 🔧 `gradle init --type kotlin-library` | `build.gradle.kts`, `settings.gradle.kts` | ✅ `./gradlew test` |
| **lua** | 🔧 `luarocks init` | `{modulo}.rockspec`, `.busted` | ✅ `busted` |
| **nim** | 🔧 `nimble init` | `{modulo}.nimble`, `test/config.nims` | ✅ `nimble test` · ✅ `nim c -r test/{suite}.nim` |
| **ocaml** | 🔧 `dune init proj {modulo}` | `dune-project`, `src/dune`, `test/dune` | ✅ `dune runtest` |
| **perl** | ✍️ `mkdir -p src test` | — | ✅ `prove --ext=.pl test/` |
| **php** | ✍️ `mkdir -p src test` + `composer require --dev phpunit/phpunit` | `composer.json`, `phpunit.xml`, `.gitignore` | ✅ `composer test` |
| **prolog** | ✍️ `mkdir -p src test` | — | ✅ `swipl -q -f {suite}.pl -t halt` |
| **purescript** | 🔧 `spago init` | `spago.yaml` | ✅ `spago test` |
| **python** | 🔧 `uv init --lib` | `pyproject.toml`, `conftest.py` | ✅ `pytest` |
| **r** | ✅ `mkdir -p src test` | — | ✅ `Rscript test/run_tests.R` |
| **racket** | ✅ `mkdir -p src test` | — | ✅ `racket test/run_tests.rkt` |
| **raku** | ✅ `mkdir -p lib t` | — | ✅ `prove6 -l t/` |
| **rescript** | ✅ `mkdir -p src test` | `rescript.json`, `package.json`, `jest.config.js` | ✅ `npm test` |
| **rexx** | ✅ `mkdir -p src test` | — | ✅ `rexx test/{suite}.rexx` |
| **ruby** | ✅ `mkdir -p src test` | `Gemfile`, `.rspec` | ✅ `bundle exec rspec` |
| **rust** | ✅ `cargo init --lib` | `Cargo.toml` | ✅ `cargo test` |
| **scala** | ✅ `mkdir -p src/main/scala src/test/scala project` | `build.sbt`, `project/build.properties` | ✅ `sbt test` |
| **scheme** | ✍️ `mkdir -p src test` | — | ✅ `guile -s test/{suite}.scm` |
| **swift** | 🔧 `swift package init --type library` | `Package.swift`, `Sources/{Modulo}/` | ✅ `swift test` |
| **tcl-tk** | ✅ `mkdir -p src test` | `src/pkgIndex.tcl` | ✅ `tclsh9.0 {suite}.test` |
| **typescript** | ✅ `npm init -y` | `package.json`, `tsconfig.json`, `jest.config.cjs` | ✅ `npm test` |
| **v** | ✍️ `mkdir -p src test` + `v.mod` | `v.mod` | ✅ `v test .` |
| **vala** | ✍️ `mkdir -p src test` | — | ✅ `valac src/{modulo}.vala test/{suite}.vala -o /tmp/{modulo}` |
| **zig** | ✅ `zig init` | `build.zig` | ✅ `zig build test` |

---

## 🔗 Secuencias de varios pasos / Multi-step sequences

**ES:** Estos lenguajes necesitan más de un comando. Se ejecutan en orden, desde la carpeta del módulo.

**EN:** These languages need more than one command. Run them in order, from the module folder.

```bash
# Ada — biblioteca + subproyecto de tests
alr init --lib {modulo}
alr init --bin tests

# C# — solución + biblioteca + proyecto de tests enlazado
dotnet new sln -n {Modulo}
dotnet new classlib -n {Modulo} -o src/{Modulo}
dotnet new xunit -n {Modulo}.Tests -o test/{Modulo}.Tests
dotnet sln add src/{Modulo}/{Modulo}.csproj test/{Modulo}.Tests/{Modulo}.Tests.csproj

# F# — igual que C# pero con plantillas de F#
dotnet new sln -n {Modulo}
dotnet new classlib -lang F# -n {Modulo} -o src/{Modulo}
dotnet new xunit -n {Modulo}.Tests -o test/{Modulo}.Tests
dotnet sln add src/{Modulo}/{Modulo}.fsproj test/{Modulo}.Tests/{Modulo}.Tests.fsproj

# Haxe — estructura manual + framework de pruebas
mkdir -p src test
haxelib install utest

# ReScript — estructura manual + dependencias de npm (compilador, Jest)
mkdir -p src test
npm install

# Ruby — estructura manual + Bundler (RSpec se declara en el Gemfile)
mkdir -p src test
bundle init
bundle install

# V — estructura manual + manifiesto del módulo
mkdir -p src test
v init

# Groovy / Kotlin — alternativa manual al generador de Gradle
mkdir -p src/main/groovy src/test/groovy      # Groovy
mkdir -p src/main/kotlin src/test/kotlin      # Kotlin

# Java / OCaml / Python — alternativa manual al generador
mkdir -p src/main/java src/test/java          # Java  (+ pom.xml)
mkdir -p src test                             # OCaml (+ dune-project, src/dune, test/dune)
mkdir -p src tests                            # Python (+ pyproject.toml, conftest.py)
```

> **ES:** Si el generador crea un `main` o un `app` de ejemplo (caso de `dub init` en D, `zig init`, `cargo init --lib` genera solo la librería), bórralo cuando el módulo sea una biblioteca: un `main` propio rompe el runner de tests generado por la herramienta.
> **EN:** If the generator creates an example `main` or `app` (e.g. `dub init` in D, `zig init`), delete it when the module is a library: a `main` of your own breaks the tool's generated test runner.

---

## 🧱 Estructuras para lenguajes sin scaffolding / Manual structures

**ES:** Cuando el lenguaje no ofrece una herramienta de inicialización (o el proyecto se creó a mano en este repositorio), la estructura se replica con `mkdir -p`. Los árboles siguientes son los que usan los módulos reales de `core/foundations/numbers/` y `core/algorithms/naive_sort/`.

**EN:** When the language has no scaffolding tool (or the project was created by hand in this repository), the structure is replicated with `mkdir -p`. The trees below are those used by the real modules under `core/foundations/numbers/` and `core/algorithms/naive_sort/`.

### Assembly — `Makefile` + `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── Makefile
├── src/                     # un archivo .asm por enfoque
└── test/                    # suites + run_tests.asm + test_macros.inc + test_utils.asm
```

### C — `Makefile` + `include/` + `src/` + `test/`

```bash
mkdir -p include src test
```

```text
{modulo}/
├── Makefile
├── include/{modulo}.h       # header público
├── src/{modulo}.c           # implementación
└── test/                    # una suite .c por enfoque
```

### COBOL — `Makefile` + `src/copybooks` + `test/`

```bash
mkdir -p src/copybooks src/lib test
```

```text
{modulo}/
├── Makefile
├── run_tests                # script de ejecución
├── src/copybooks/           # copybooks
├── src/lib/                 # programa principal
└── test/                    # ASSERTS.cpy + suites + RUN-TESTS.cbl
```

### Common Lisp — ASDF + `src/` + `tests/`

```bash
mkdir -p src tests
```

```text
{modulo}/
├── {modulo}.asd             # definición del sistema ASDF (+ test-op)
├── run-tests.lisp           # runner FiveAM
├── src/{modulo}.lisp
└── tests/                   # una suite .lisp por enfoque
```

### Forth — `src/` + `test/` sin gestor de paquetes

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.forth
└── test/                    # test.forth (runner casero) + suites + run-tests.forth
```

### Grain — `Makefile` + `src/` + `tests/`

```bash
mkdir -p src tests
```

```text
{modulo}/
├── Makefile
├── src/{modulo}.gr
└── tests/                   # suites + run_tests.gr + testing.gr
```

### Haxe — `build.hxml` + `src/` + `test/`

```bash
mkdir -p src test
haxelib install utest         # framework de pruebas
```

```text
{modulo}/
├── build.hxml               # target de compilación y de tests
├── RunTests.hx              # runner de utest
├── src/{Modulo}.hx
└── test/                    # una suite .hx por enfoque
```

### Java — layout Maven estándar

```bash
mkdir -p src/main/java src/test/java
```

```text
{modulo}/
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
{modulo}/
├── package.json
├── jest.config.js
├── src/{modulo}.js
└── test/                    # una suite por enfoque
```

### Julia — paquete estándar de `Pkg`

```bash
mkdir -p src test
```

```text
{modulo}/
├── Project.toml
├── Manifest.toml
├── src/{Modulo}.jl
└── test/                    # suites + run_tests.jl
```

### Kotlin — layout Gradle estándar

```bash
mkdir -p src/main/kotlin src/test/kotlin
```

```text
{modulo}/
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
{modulo}/
├── dune-project
├── src/dune                 # declara la librería
├── src/{modulo}.ml          # (+ {modulo}.mli opcional)
└── test/dune                # declara el ejecutable de tests
```

### Perl — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.pl
└── test/                    # una suite .pl por enfoque (Test2::Bundle::More)
```

### PHP — `src/` + `test/` con Composer y PHPUnit

```bash
mkdir -p src test
composer require --dev phpunit/phpunit
```

```text
{modulo}/
├── composer.json            # PHPUnit (dev) + autoload classmap + script test
├── phpunit.xml              # bootstrap + suite sobre test/
├── .gitignore               # vendor/, composer.lock y cachés
├── src/{Modulo}.php
└── test/{Modulo}Test.php    # una suite PHPUnit por enfoque
```

### Prolog — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.pl          # base de conocimiento
└── test/                    # suites plunit por enfoque
```

### Python — src-layout (PEP 621)

```bash
mkdir -p src tests
```

```text
{modulo}/
├── pyproject.toml           # metadatos + configuración de pytest
├── conftest.py              # añade src/ a sys.path
├── src/{modulo}.py
└── tests/                   # conftest.py + una suite por enfoque
```

### R — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.R
└── test/                    # suites + run_tests.R
```

### Racket — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.rkt
└── test/                    # suites + run_tests.rkt
```

### Raku — `lib/` + `t/`

```bash
mkdir -p lib t
```

```text
{modulo}/
├── lib/{Modulo}.rakumod
└── t/                       # suites .rakutest por enfoque
```

### Rexx — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.rexx
└── test/                    # una suite .rexx por enfoque
```

### Ruby — Bundler + RSpec

```bash
mkdir -p src test
bundle init
bundle install
```

```text
{modulo}/
├── Gemfile
├── .rspec
├── src/{modulo}.rb
└── test/                    # una suite _tests.rb por enfoque
```

### Scala — layout sbt estándar

```bash
mkdir -p src/main/scala src/test/scala project
```

```text
{modulo}/
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
{modulo}/
├── src/{modulo}.scm
└── test/                    # suites por enfoque (+ variantes _guile.scm)
```

### Swift — Swift Package Manager

```bash
mkdir -p Sources/{Modulo} Tests/{Modulo}Tests
```

```text
{modulo}/
├── Package.swift
├── Sources/{Modulo}/        # código público
└── Tests/{Modulo}Tests/     # suites XCTest
```

### Tcl — `src/` + `test/`

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.tcl         # namespace + package provide
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

```bash
mkdir -p src test
```

```text
{modulo}/
├── src/{modulo}.vala
└── test/                    # una suite .vala por enfoque (GLib.Test)
```

### V — módulo V

```bash
mkdir -p src test
v init                        # genera v.mod
```

```text
{modulo}/
├── v.mod
├── src/{modulo}.v
└── test/                    # archivos _test.v con funciones test_*
```

### Manifiestos que `mkdir` no crea / Manifests `mkdir` does not create

**ES:** Cuando el lenguaje exige un manifiesto mínimo, escríbelo a mano después del `mkdir -p`: `Project.toml` en Julia, `v.mod` en V, `{modulo}.nimble` en Nim, `{modulo}.rockspec` en Lua, `pom.xml` en Java, `build.gradle(.kts)` en Groovy y Kotlin.

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
