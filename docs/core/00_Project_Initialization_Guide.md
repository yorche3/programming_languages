---
layout: default
title: 00 — Project Initialization Guide
description: Comandos de inicialización por lenguaje para crear el esqueleto de un módulo / Per-language initialization commands to scaffold a module
nav_order: 0
parent: Core
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

**ES:** Esta guía reúne los **comandos completos** que necesita cada lenguaje para crear el esqueleto de un módulo: las carpetas, el manifiesto, los archivos base y lo que hay que completar después a mano. Está pensada para usarse **tal cual**, desde la raíz del submódulo del lenguaje y dentro de la carpeta del módulo, y no da nada por hecho: cada lenguaje dice qué herramienta usa, qué deja hecho y qué queda pendiente. Ojo con una cosa: la secuencia **no descarga bibliotecas** — escribe los manifiestos que las declaran —, y las baja el propio gestor del lenguaje cuando se construye el proyecto o se lanzan las pruebas.

**EN:** This guide gathers the **complete commands** each language needs to create a module's skeleton: the folders, the manifest, the base files and what has to be completed by hand afterwards. It is meant to be used **as is**, from the language submodule root and inside the module folder, and it takes nothing for granted: every language says which tool it uses, what the tool leaves done and what is still pending. One thing to watch: the sequence **downloads no libraries** — it writes the manifests that declare them — and the language's own package manager pulls them when the project is built or the tests are run.

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
|---|---|
| ✅ | Comando **verificado**: está documentado en el README de un módulo de este repositorio. |
| 🔧 | Comando **estándar del ecosistema**: es la herramienta oficial del lenguaje para generar un esqueleto tipo librería. |
| ✍️ | **Sin herramienta** de scaffolding: el proyecto se crea a mano. Se describe la estructura que usan los módulos de ese lenguaje. |
| ⛓️ | **Inicialización por secuencia**: el comando mostrado es el primero de una secuencia; el detalle está en *Secuencias de varios pasos*. |

{module} es el nombre del módulo (numbers, naive_sort, …) y {Module} su forma en PascalCase cuando el lenguaje lo exige (Numbers, NaiveSort).

**ES:** Los símbolos pueden combinarse. ⛓️ ✅ significa que el comando es el primero de una secuencia verificada en el README de un módulo de este repositorio; ⛓️ 🔧 significa que es el primero de una secuencia cuya herramienta es el estándar del ecosistema. Un comando sin ⛓️ es un único paso; un comando sin ✅ ni 🔧 es manual y no está verificado en un README del repositorio.

**EN:** Symbols may combine. ⛓️ ✅ means the command is the first of a verified sequence, documented in a module README of this repository; ⛓️ 🔧 means it is the first of a sequence whose tool is the ecosystem standard. A command without ⛓️ is a single step; a command without ✅ or 🔧 is manual and is not verified in a repository README.

### Cómo se elige la herramienta / How the tool is chosen

**ES:** Reglas fijadas el 2026-09-26; deciden qué comando aparece en la tabla y cuándo un lenguaje se queda en ✍️:

- **R1** — Se usa la herramienta del ecosistema instalada, aunque su salida difiera de la convención anterior, y lo que falte se completa a mano (carpetas, manifiesto, configuración del runner): es lo que haría un desarrollador. El tooling solo automatiza ejecutar comandos.
- **R2** — Se descarta la herramienta cuyo esqueleto es para una aplicación y no para una biblioteca.
- **R3** — Se acepta la herramienta que añada documentos o carpetas extra que no alejen del proyecto de biblioteca.
- **R4** — La herramienta de construcción puede cambiarse por la más usada del lenguaje (Make, CMake, meson…), pero no es obligatorio cambiarla.
- **R5** — Decide el uso y la aceptación de la comunidad del lenguaje.
- **R6** — Si la herramienta impone otra estructura, el módulo ya homologado se actualiza al retomar ese lenguaje: es deuda declarada, no trabajo de la fase en curso.

**EN:** Rules set on 2026-09-26; they decide which command appears in the table and when a language stays ✍️:

- **R1** — The installed ecosystem tool is used, even when its output differs from the previous convention, and whatever is missing is completed by hand (folders, manifest, runner configuration): that is what a developer would do. The tooling only automates running commands.
- **R2** — A tool whose skeleton is for an application rather than a library is rejected.
- **R3** — A tool that adds extra documents or folders which do not move the library project away is accepted.
- **R4** — The build tool may be swapped for the language's most used one (Make, CMake, meson…), but changing it is not mandatory.
- **R5** — Community usage and acceptance decides.
- **R6** — When the tool imposes another structure, the already-homologated module is updated when that language is retaken: it is declared debt, not work for the phase in progress.

**ES:** Con R1–R6 el reparto es **32 `tool` · 18 `manual`**: los primeros traen una herramienta de biblioteca aceptada y los segundos se arman a mano. Un lenguaje no se marca ✍️ por tener un generador distinto, sino solo cuando no hay herramienta de biblioteca aceptada (R2/R5) o cuando no existe generador.

**EN:** Under R1–R6 the split is **32 `tool` · 18 `manual`**: the first ones come with an accepted library tool and the second ones are assembled by hand. A language is not marked ✍️ for having a different generator, but only when there is no accepted library tool (R2/R5) or no generator at all.

## 📊 Tabla maestra / Master table

Las rutas de la columna Manifiesto son relativas a la carpeta del módulo. La marca ⛓️ señala los lenguajes con **más de un comando**: su secuencia completa está en *Secuencias de varios pasos*.

The Manifiesto column paths are relative to the module folder. The ⛓️ mark flags the languages with **more than one command**: their full sequence is in *Multi-step sequences*.

| Lenguaje / Language | Comando de inicialización / Initialisation command | Manifiesto / archivos clave | Pruebas / Tests |
|---|---|---|---|
| **ada** | ⛓️ ✅ `alr init --lib --in-place {module}` | `alire.toml`, `{module}.gpr`, `config/`, `tests/` | ✅ `alr -C tests run` |
| **assembly** | ✍️ `mkdir -p src test` + `Makefile` | `Makefile` | ✅ `make run` |
| **ballerina** | ⛓️ 🔧 `bal new {module}` → adecuaciones de biblioteca / library adaptations | `Ballerina.toml`, `{module}.bal`, `tests/lib_test.bal` | ✅ `bal test` |
| **c** | ✍️ `mkdir -p include src test` + `Makefile` | `include/{module}.h`, `Makefile` | ✅ `make test` |
| **clojure** | ⛓️ 🔧 `clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib` | `deps.edn`, `build.clj`, `src/{module}/` | ✅ `clojure -T:build test` |
| **cobol** | ✍️ `mkdir -p src/copybooks src/lib test` | `Makefile`, `run_tests` | ✅ `make test` |
| **common-lisp** | ⛓️ 🔧 `cl-project:make-project` vía `ros` + quicklisp | `{module}.asd`, `src/{module}.lisp` y `tests/{module}-test.lisp` (con guion), `run-tests.lisp` | ✅ `ros run --load run-tests.lisp --eval '(uiop:quit)'` |
| **cpp** | ✅ Configuración manual de Bazel (`MODULE.bazel`, `WORKSPACE`, targets en `BUILD`) | `BUILD`, `MODULE.bazel`, `.bazelversion` | ✅ `bazelisk test //...` |
| **crystal** | 🔧 `crystal init lib {module}` | `shard.yml` | ✅ `crystal spec` |
| **csharp** | ⛓️ ✅ `dotnet new sln -n {Module}` | `{Module}.slnx`, `src/{Module}/{Module}.csproj`, `test/{Module}.Tests/` | ✅ `dotnet test {Module}.slnx` |
| **d** | ✅ `dub init {module} --format=sdl` | `dub.sdl` | ✅ `dub test` |
| **dart** | ✅ `dart create -t package {module}` | `pubspec.yaml`, `analysis_options.yaml` | ✅ `dart test` |
| **elixir** | 🔧 `mix new {module} --module {Module}` | `mix.exs` | ✅ `mix test` |
| **elm** | 🔧 `elm init` | `elm.json` | ✅ `elm-test` |
| **erlang** | ✅ `rebar3 new lib {module}` | `rebar.config`, `src/{module}.app.src` | ✅ `rebar3 eunit` |
| **forth** | ✍️ `mkdir -p src test` | — (runner casero `test.forth`) | ✅ `cd test && gforth run-tests.forth` |
| **fsharp** | ⛓️ 🔧 `dotnet new sln -n {Module}` (después `classlib -lang F#` y `xunit`; el layout homologado es plano) | `{Module}.slnx`, `src/{Module}.fsproj`, `test/{Module}.Tests.fsproj` | ✅ `dotnet test` |
| **gleam** | ✅ `gleam new {module}` | `gleam.toml`, `manifest.toml` | ✅ `gleam test` |
| **go** | ✅ `go mod init example.com/{module}` | `go.mod` | ✅ `go test ./...` |
| **grain** | ✍️ `mkdir -p src tests` + `Makefile` | `Makefile` | ✅ `make test` |
| **groovy** | ⛓️ ✅ `gradle init --type groovy-library --dsl groovy --use-defaults` | `settings.gradle`, `lib/build.gradle`, `gradle/` | ✅ `./gradlew test` |
| **haskell** | 🔧 `cabal init --lib` | `{module}.cabal` | ✅ `cabal test .:tests --ghc-options=-Werror=missing-home-modules` |
| **haxe** | ⛓️ ✅ `mkdir -p src test` (después `haxelib install utest`) | `build.hxml`, `RunTests.hx` | ✅ `haxe build.hxml` |
| **java** | ✍️ `pom.xml` a mano (el arquetipo quickstart es de aplicación: R2) | `pom.xml` | ✅ `mvn test` |
| **javascript** | 🔧 `npm init -y` | `package.json`, `jest.config.js` | ✅ `npm test` |
| **julia** | ⛓️ 🔧 `julia -e 'using Pkg; Pkg.generate("{module}")'` | `Project.toml`, `src/{Module}.jl`, `test/` | ✅ `julia --project=. test/run_tests.jl` |
| **kotlin** | ⛓️ ✅ `gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project` | `build.gradle.kts`, `settings.gradle.kts` | ✅ `gradle test` |
| **lua** | 🔧 `luarocks init` | `{module}.rockspec`, `.busted` | ✅ `busted` |
| **nim** | ⛓️ ✅ `nimble init` (tipo library; `nimble init -y`) | `{module}.nimble`, `src/{module}.nim`, `test/config.nims` | ✅ `nimble test` |
| **ocaml** | ⛓️ ✅ `dune init proj {module}` (crea la carpeta del módulo) | `dune-project`, `lib/dune`, `test/dune` | ✅ `dune runtest` |
| **perl** | ✍️ `mkdir -p lib test` | — | ✅ TAP::Harness (comando abajo / command below) |
| **php** | ✍️ `mkdir -p src test` + `composer init -n` + `composer require --dev --no-update phpunit/phpunit` | `composer.json`, `phpunit.xml`, `.gitignore` | ✅ `composer test` |
| **prolog** | ✍️ `mkdir -p src test` | — | ✅ SWI-Prolog + PlUnit (comando abajo / command below) |
| **purescript** | 🔧 `spago init` | `spago.yaml` | ✅ `spago test` |
| **python** | ⛓️ ✅ `uv init --lib .` | `pyproject.toml`, `src/{module}/`, `conftest.py`, `tests/` | ✅ `pytest` |
| **r** | ✅ `mkdir -p R tests/testthat` + `Makefile` | `Makefile` | ✅ `make test` |
| **racket** | ⛓️ 🔧 `raco new library {module}` | `info.rkt`, `{module}.rkt` (con guiones), `tests/`, `Makefile` | ✅ `raco test -x .` |
| **raku** | ✅ `mkdir -p lib t` | — | ✅ TAP + Path::Finder (comando abajo / command below) |
| **rescript** | ⛓️ ✅ `mkdir -p src test` (después el manifiesto con `npm pkg set`) | `rescript.json`, `package.json`, `jest.config.js` | ✅ `npm test` |
| **rexx** | ✅ `mkdir -p src test` | — | ✅ `rexx test/{suite}.rexx` |
| **ruby** | ⛓️ ✅ `mkdir -p src test` (después `bundle init` y `bundle install`) | `Gemfile`, `.rspec` | ✅ `bundle exec rspec` |
| **rust** | ✅ `cargo init --lib` | `Cargo.toml` | ✅ `cargo test` |
| **scala** | ✅ `mkdir -p src/main/scala src/test/scala project` + build sbt (el runner instalado, sbt 2.0.8, ya no trae `sbt new`) | `build.sbt`, `project/build.properties` | ✅ sbt + ScalaTest (comando abajo / command below) |
| **scheme** | ✍️ `mkdir -p src test` | — | ✅ Guile + SRFI-64 (comando abajo / command below) |
| **swift** | 🔧 `swift package init --type library` | `Package.swift`, `Sources/{Module}/` | ✅ `swift test` |
| **tcl-tk** | ✅ `mkdir -p src test` | `src/pkgIndex.tcl` | ✅ Tcltest (comando abajo / command below) |
| **typescript** | ✅ `npm init -y` | `package.json`, `tsconfig.json`, `jest.config.cjs` | ✅ `npm test` |
| **v** | ⛓️ ✅ `v init --lib` (no interactivo; quitar el `.git` anidado y fijar la versión) | `v.mod`, `{module}.v`, `test/` | ✅ `v test .` |
| **vala** | ⛓️ 🔧 `meson init --language vala --type library --name {module}` | `meson.build`, `src/`, `test/` | ✅ `valac src/{module}.vala test/{suite}.vala --pkg glib-2.0 -o /tmp/{module}-tests && /tmp/{module}-tests` |
| **zig** | ✅ `zig init` | `build.zig` | ✅ `zig build test` |

## 🔗 Secuencias de varios pasos / Multi-step sequences

**ES:** Estos lenguajes necesitan **más de un comando**. La tabla lista, por lenguaje, la secuencia completa de inicialización y lo que se completa a mano después. Los generadores que crean la carpeta por su cuenta (`ballerina`, `crystal`, `d`, `dart`, `elixir`, `erlang`, `gleam`) se lanzan desde la carpeta de la fase; los demás, desde dentro de la carpeta del módulo.

**EN:** These languages need **more than one command**. The table lists, per language, the full initialisation sequence and what is completed by hand afterwards. Generators that create the folder themselves (`ballerina`, `crystal`, `d`, `dart`, `elixir`, `erlang`, `gleam`) run from the phase folder; the rest, from inside the module folder.

**ES:** Un lenguaje que no aparece aquí se resuelve con el comando de la **tabla maestra**.

**EN:** A language that does not appear here is handled by the **master table**'s command.

| Lenguaje / Language | Secuencia de inicialización / Initialisation sequence | Completado posterior a mano / Later completion by hand |
|---|---|---|
| **ada** | `alr init --lib --in-place {module}` → `alr init --bin tests` → `alr with {module} --use=..` → `alr with aunit` (los dos últimos, dentro de `tests/`) | Licencia GPL-3.0-or-later en `alire.toml` y `tests/alire.toml`, y `description` del subproyecto de pruebas |
| **ballerina** | `bal new {module}` → renombrado protegido `main.bal` a `{module}.bal` → retirar solo el ejemplo verificado → crear `tests/lib_test.bal` vacío si falta | El generador no crea `tests/`; revisar únicamente contenido de ejemplo desconocido y patrones de `.gitignore` |
| **clojure** | `clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib :name {module} :target-dir {module}` | Sustituir el test de plantilla |
| **common-lisp** | `ros -e '(ql:quickload :cl-project)' -e '(cl-project:make-project #p"{module}" :depends-on nil)'` | Homologar el andamiaje con guion y no subrayado, sistema de pruebas con fiveam y `run-tests.lisp` |
| **cpp** | `mkdir -p src include tests` → `touch MODULE.bazel BUILD .bazelversion .gitignore` | Declarar targets y dependencias Bazel; conservar `tests/` de las bases homologadas |
| **crystal** | `crystal init lib {module}` → comprobar `shard.yml` y `spec/` | Conservar `src/`, `spec/spec_helper.cr` y `spec/`; no añadir `test/` ni borrar el gitfile |
| **csharp** | `dotnet new sln` → `dotnet new classlib` → `dotnet new xunit` → `dotnet sln add` → `dotnet add test/{Module}.Tests/{Module}.Tests.csproj reference src/{Module}/{Module}.csproj` | Borrar `Class1.cs` y `UnitTest1.cs` y añadir `.gitignore` |
| **d** | `dub init {module} --format=sdl` → retirar solo el ejemplo verificado → crear `source/{module}.d` y `test/` → configurar `unittest` solo en el manifiesto generado reconocido | En otros manifiestos comprobar que `dub test` incluye `test/`; revisar cualquier `source/app.d` diferente del ejemplo y conservar contenido propio |
| **fsharp** | Igual que C# con `-lang F#`, incluido `dotnet add test/{Module}.Tests/{Module}.Tests.fsproj reference src/{Module}/{Module}.fsproj` | Conservar los proyectos anidados y su referencia; cualquier renombrado de `Library.fs`/`Tests.fs` actualiza sus `Compile Include` y conserva contenido propio |
| **groovy** | `gradle init --type groovy-library --dsl groovy --project-name {module} --package {module} --use-defaults` → retirar solo la pareja de muestras verificada, si no hay otros archivos en `lib/src` | Conservar muestras distintas o con otros archivos y revisar; Gradle puede devolver éxito sin casos |
| **go** | `go mod init example.com/{module}` → `mkdir -p src tests` | El paquete externo de `tests/` importa `example.com/{module}/src`, sin imponer `test/` |
| **haskell** | `cabal init --lib -n --source-dir=lib --package-name={module-kebab} --expose-module={Module}` → crear `lib/{Module}.hs` solo si falta | `{module-kebab}` sustituye subrayados por guiones; declarar `module {Module} where`, conservar `hs-source-dirs: lib` y completar test-suite/runner |
| **haxe** | `mkdir -p src test` → `haxelib install utest` | `build.hxml` y `RunTests.hx` son contenido del sprint |
| **julia** | `julia -e 'using Pkg; Pkg.generate("{module}")'` | Completar `test/` y su runner; añadir `uuid`, `[compat]`, `[extras]` y `[targets]` |
| **kotlin** | `gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project` | Borrar `Library.kt` y `LibraryTest.kt` |
| **nim** | `nimble init -y` → `rm -rf src/{module}` → la task `test` apuntando a `tests/{module}_tests.nim` | Borrar la muestra anidada `src/{module}/` y dejar la task `test` apuntando a `tests/{module}_tests.nim` |
| **ocaml** | `dune init proj {module}` | El código va en `lib/` y la suite en `test/`: se usa el layout generado tal cual |
| **python** | `uv init --lib .` | Borrar el `.git` que crea `uv`, añadir `conftest.py` y `tests/` con configuración de pytest, y declarar pytest (`uv add --dev pytest --no-sync`) |
| **purescript** | `spago init` → crear `src/{Module}.purs` y `test/Test/Main.purs` mínimo si faltan → retirar o sustituir solo las muestras verificadas de `Main.purs` | Conservar código y runners propios; completar `spago.yaml` y `test-unit` según la suite y revisar `.gitignore`. El runner vacío devuelve éxito sin validar una suite / The empty runner succeeds without validating a suite |
| **racket** | `raco new library {module}` → render portátil (`mv` + `sed -i`, con el código renombrado a `{module}.rkt` con guiones) → `rm -rf .github pull_request_template.md render-template.sh profile` | Las suites requieren la librería por ruta relativa (`"../../{module}-lib/{module}.rkt"`, con guiones) y el runner es `raco test -x .`, sin enlazar paquetes |
| **rescript** | `mkdir -p src test` → `npm init -y` → `npm pkg set` | El manifiesto y sus devDependencies se declaran con `npm pkg set`; los baja `npm install` |
| **ruby** | `mkdir -p src test` → `bundle init` → `bundle install` | `rspec` en el `Gemfile` y `.rspec` |
| **v** | `v init --lib` (no interactivo) → `mkdir -p src tests` | Conservar `tests/`, fuentes y gitfile; fijar `version: '0.1.0'` en `v.mod`. No renombrar carpetas sin actualizar imports |
| **vala** | `meson init --language vala --type library --name {module}` | Completar `src/` y `test/` y decidir el build con meson |

> **ES:** Si el generador crea un `main` o un `app` de ejemplo (`dub init` en D, `zig init`; `cargo init --lib` genera solo la librería), debe retirarse cuando el módulo sea una biblioteca: un `main` propio rompe el runner de tests. En D solo se retira automáticamente la muestra verificada; el contenido diferente se conserva para revisión.
>
> **EN:** If the generator creates an example main or app (`dub init` in D, `zig init`; `cargo init --lib` generates only the library), remove it for a library: a main of your own breaks the test runner. For D only the verified sample is removed automatically; different content is preserved for review.

## 🔨 Generación manual (lib) / Manual generation (lib)

> **ES:** **Todo el esqueleto se puede hacer con comandos de consola**: `mkdir -p`, `cd`, `touch` y la declaración idiomática de cada fichero. No hace falta ninguna herramienta especial para esta parte. Hoy la guía cubre el caso **lib**; bin y web se añadirán después.
>
> **EN:** The whole skeleton can be built with console commands: `mkdir -p`, `cd`, `touch` and each file's idiomatic declaration. No special tooling is needed for this part. Today the guide covers the **lib** case; bin and web come later.

**ES:** Para los lenguajes sin herramienta aceptada (✍️), la secuencia manual es: crear las carpetas, crear los ficheros con `touch` y pegarles la declaración idiomática del lenguaje. Ejemplos (lib):

**EN:** For languages without an accepted tool (✍️), the manual sequence is: create the folders, create the files with `touch`, and give them the language's idiomatic declaration. Examples (lib):

| Lenguaje / Language | Comandos / Commands | Declaración idiomática / Idiomatic declaration |
|---|---|---|
| `assembly` | `mkdir -p src test` · crear `src/{module}.asm` si falta | `section .text`; el contrato declara sus símbolos en el paso 4b |
| `c` | `mkdir -p include src test` · crear `include/{module}.h` y `src/{module}.c` si faltan | `#ifndef {Module}_H` + `#define {Module}_H` en la cabecera; `#include "{module}.h"` en la fuente |
| `cobol` | `mkdir -p src/copybooks src/lib test` · crear `src/lib/{module}.cbl` y `test/RUN-TESTS.cbl` si faltan | Programa mínimo con `PROGRAM-ID. {Module}.` y `GOBACK.` |
| `forth` | `mkdir -p src test` · crear `src/{module}.forth` y `test/run-tests.forth` si faltan | Fuente inicialmente vacía; el runner la carga y anuncia que no hay pruebas |
| `grain` | `mkdir -p src tests` · crear `src/{module}.gr` y `tests/run_tests.gr` si faltan | `module {Module}`; el runner importa la fuente y anuncia que no hay tests |
| `java` | `mkdir -p src/main/java src/test/java` · `touch src/main/java/{Module}.java` | `public class {Module} { }` |
| `perl` | `mkdir -p lib test` · `touch lib/{module}.pl` | `package {Module};` + `use strict;` + `use warnings;` + `1;` |
| `php` | `mkdir -p src test` · `touch src/{Module}.php` | `<?php` + `declare(strict_types=1);` + `namespace {Module};` |
| `prolog` | `mkdir -p src test` · crear `src/{module}.pl` si falta | Fuente inicialmente vacía, consultada como en las bases homologadas |
| `scala` | `mkdir -p src/main/scala src/test/scala project` · crear `src/main/scala/{Module}.scala` si falta | `object {Module}` |
| `scheme` | `mkdir -p src test` · crear `src/{module}.scm` si falta | `(define-module ({module}))` (Guile) |

**ES:** En los lenguajes con herramienta, la secuencia manual equivalente es su comando de la **tabla maestra** seguido de lo que lista la sección **Secuencias de varios pasos**.

**EN:** For languages with a tool, the equivalent manual sequence is its **master table** command followed by what the **Multi-step sequences** section lists.

## 🧱 Estructuras de referencia / Reference structures

**ES:** Cuando el lenguaje no ofrece una herramienta de inicialización aceptada (R2/R5), la estructura se replica con `mkdir -p`; los árboles siguientes son los que usan los módulos reales de `core/foundations/numbers/` y `core/algorithms/naive_sort/`. En los lenguajes que sí tienen herramienta, la sección correspondiente empieza diciendo cuál es y qué queda por completar: allí el árbol es el completado y la estructura que el módulo seguirá usando hasta que se retome (R6).

**EN:** When the language has no accepted scaffolding tool (R2/R5), the structure is replicated with `mkdir -p`; the trees below are those used by the real modules under `core/foundations/numbers/` and `core/algorithms/naive_sort/`. For languages that do have a tool, the matching section starts by naming it and what is left to complete: there the tree is the completion and the structure the module will keep using until it is retaken (R6).
### Assembly — Makefile + src/ + test/
```bash
mkdir -p src test
```

```text
{module}/
├── Makefile
├── src/                     # un archivo .asm por enfoque
└── test/                    # suites + run_tests.asm + test_macros.inc + test_utils.asm
```

**ES:** El scaffold incluye un runner NASM mínimo que informa que todavía no
hay tests; la suite debe conectar sus grupos y propagar los fallos. Si falta
`.gitignore`, se crea con exclusiones para `obj/` y el ejecutable del runner;
uno existente se conserva y debe verificarse.

**EN:** Scaffold includes a minimal NASM runner reporting that no tests are
configured; the suite must connect its groups and propagate failures. A missing
`.gitignore` is created with patterns for `obj/` and the runner executable;
an existing one is preserved and must be checked.

### C — Criterion + Makefile

**ES:** Criterion aporta el runner de `make test`: sin casos arranca y comunica
que ejecutó cero. El scaffold conserva fuentes y manifiestos existentes; si
falta `.gitignore`, lo crea con `bin/` y `obj/`.

**EN:** Criterion supplies the `make test` runner: without test cases it starts
and reports zero tests. Scaffold preserves existing sources and build files and
creates a missing `.gitignore` for `bin/` and `obj/`.

### Ballerina — biblioteca en la raíz y tests/

**ES:** `bal new {module}` se ejecuta desde la carpeta de la fase y genera
`main.bal`, **no** `{module}.bal` ni `tests/` (verificado con 2201.13.4).
Desde la raíz del paquete, las adecuaciones repetibles son las siguientes;
detenerse si una falla. `{root}` es la raíz del clon, `{module}` el id canónico
con subrayados. La plantilla de comparación vive en
`scripts/data/scaffold_templates/ballerina.main.bal`; no se utiliza un marcador
`{module_idiomatic}` sin resolución.

**EN:** Run the generator from the phase directory. It produces `main.bal`,
not the library source or tests directory. From the package root, apply the
following adaptations and stop on failure. Resolve clone-root and canonical
module placeholders before execution.

**ES:** `bal test` puede devolver éxito sin casos, incluso con todos los tests
deshabilitados. Ese resultado no valida una suite.

**EN:** `bal test` can succeed with no cases, including when all tests are
disabled. That result does not validate a suite.

```bash
if [[ -L main.bal || -L {module}.bal ||
      ( -e main.bal && ! -f main.bal ) ||
      ( -e {module}.bal && ! -f {module}.bal ) ]]; then
  printf 'scaffold: origen o destino no regular / source or target is not a regular file\n' >&2
  false
elif [[ -f main.bal && ! -e {module}.bal ]]; then
  mv -n -- main.bal {module}.bal && test ! -e main.bal
elif [[ ! -e main.bal && -f {module}.bal ]]; then
  :
else
  printf 'scaffold: renombrado ambiguo o fuente ausente / ambiguous rename or missing source\n' >&2
  false
fi
```

**ES:** Renombrar no elimina un `main`. Solo se vacía el fuente cuando coincide
exactamente con el ejemplo de la herramienta verificado; un fuente distinto se
conserva para revisión, nunca se reemplaza por un supuesto esqueleto.

**EN:** Renaming does not remove a main function. Empty only an exact verified
generator sample; preserve other content for review.

```bash
test -f {root}/scripts/data/scaffold_templates/ballerina.main.bal && {
  cmp -s -- {module}.bal {root}/scripts/data/scaffold_templates/ballerina.main.bal
  result=$?
  if [[ "$result" == 0 ]]; then
      : > {module}.bal
  elif [[ "$result" != 1 ]]; then
      printf 'scaffold: no se pudo comparar la plantilla / could not compare the template\n' >&2
      false
  fi
}
```

```bash
if [[ -L tests || -L tests/lib_test.bal ||
      ( -e tests/lib_test.bal && ! -f tests/lib_test.bal ) ]]; then
  printf 'scaffold: ruta de pruebas no segura / unsafe test path\n' >&2
  false
else
  mkdir -p tests && { test -e tests/lib_test.bal || touch tests/lib_test.bal; }
fi
```

```text
{module}/
├── Ballerina.toml
├── {module}.bal             # vacío tras retirar el ejemplo conocido
├── .gitignore
└── tests/lib_test.bal       # vacío; los casos pertenecen a suite
```

**ES:** Conservar `.gitignore` si ya existe; rechazar symlinks/directorios en esa
ruta. La comprobación nativa del andamiaje es `bal test --offline`: **No tests
found** es esperado antes de escribir la suite, no demuestra cobertura.

**EN:** Preserve an existing ignore file and reject symlink/directory ignore
paths. Native scaffold verification reports no tests, as expected before suite
creation; this is not coverage evidence.

### C — Makefile + include/ + src/ + test/
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

### COBOL — Makefile + src/copybooks + test/
```bash
mkdir -p src/copybooks src/lib test
```

```text
{module}/
├── Makefile
├── run_tests                # ejecutable generado por el Makefile
├── src/copybooks/           # copybooks
├── src/lib/                 # programa principal
└── test/                    # ASSERTS.cpy + suites + RUN-TESTS.cbl
```

**ES:** El scaffold crea una fuente y un runner mínimos compilables. El
Makefile enlaza primero `RUN-TESTS.cbl` y exige su presencia incluso si ya
existe el ejecutable. La suite conecta los grupos y propaga sus fallos;
`.gitignore` excluye el ejecutable y los artefactos generados si faltaba.

**EN:** Scaffold creates a minimal compilable source and runner. The Makefile
links `RUN-TESTS.cbl` first and requires it even when the executable already
exists. The suite connects its groups and propagates failures; a missing
`.gitignore` is created to exclude the executable and build artifacts.

### Common Lisp — ASDF + src/ + tests/

**ES:** Herramienta (R1): cl-project:make-project vía ros + quicklisp, desde la carpeta de la fase; es el generador de la comunidad y sustituyó a quickproject el 2026-09-29, porque aquel dejaba el proyecto plano. Exige un pathname, así que la cadena no vale: #p"{module}" no es opcional. Deja {module}/ con {module}.asd, src/main.lisp, tests/main.lisp, README.org, README.markdown y .gitignore. Para que el andamiaje quede homologado hay que aplicar seis correcciones —medidas el 2026-09-29 al dejar homologado common-lisp/core/algorithms/data_structures_basics/, que queda como referencia—: 1) nombrar los ficheros como el módulo y con guion ({module}.asd, src/{module}.lisp, tests/{module}-test.lisp), porque main es el nombre de la plantilla y el subrayado no es la convención de Lisp; 2) el .asd con defsystem/test-op y uiop:symbol-call; 3) el paquete con guion; 4) el sistema de pruebas sobre fiveam, como numbers.asd y naive-sort.asd, y no sobre rove, que no está instalado aquí; 5) el paquete de pruebas {module}/tests con :export #:run-tests y un run-tests que llama a run!; y 6) run-tests.lisp, que cl-project no genera y el comando de pruebas del módulo exige. Los dos READMEs de la plantilla los sustituye el README del módulo, y el código de salida del runner y el guardia del depurador son deuda del runner compartido (afectan también a naive_sort y numbers).

**EN:** Tool (R1): cl-project:make-project through ros + quicklisp, from the phase folder; it is the community generator and it replaced quickproject on 2026-09-29, because the latter left the project flat. It requires a pathname, so a plain string will not do: #p"{module}" is not optional. It leaves {module}/ with {module}.asd, src/main.lisp, tests/main.lisp, README.org, README.markdown and .gitignore. To homologate the scaffolding six corrections must be applied —measured on 2026-09-29 when common-lisp/core/algorithms/data_structures_basics/ was homologated, kept as the reference—: 1) name the files after the module and with hyphens ({module}.asd, src/{module}.lisp, tests/{module}-test.lisp), because main is the template name and underscores are not the Lisp convention; 2) the .asd with defsystem/test-op and uiop:symbol-call; 3) the package with hyphens; 4) the test system over fiveam, like numbers.asd and naive-sort.asd, and not over rove, which is not installed here; 5) the test package {module}/tests with :export #:run-tests and a run-tests calling run!; and 6) run-tests.lisp, which cl-project does not generate and the module's test command requires. The template's two READMEs are replaced by the module's README, and the runner's exit code and debugger guard are debt of the shared runner (they also affect naive_sort and numbers).
```text
{module}/
├── {module}.asd             # sistema ASDF (+ test-op); el nombre va con guion
├── run-tests.lisp           # runner FiveAM
├── src/{module}.lisp
└── tests/                   # una suite .lisp por enfoque
```

### Forth — src/ + test/ sin gestor de paquetes
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.forth
└── test/                    # test.forth (runner casero) + suites + run-tests.forth
```

**ES:** El scaffold crea una fuente vacía, el framework `test.forth` y un
runner que anuncia que no hay tests y termina. `test-report` devuelve código
no cero ante fallos. Se conservan los archivos existentes; la suite conecta
sus grupos antes del reporte.

**EN:** Scaffold creates an empty source, the `test.forth` framework and a
runner that announces that there are no tests and exits. `test-report`
returns a nonzero exit code for failures. Existing files are preserved; the
suite connects its groups before the report.

### Grain — Makefile + src/ + tests/
```bash
mkdir -p src tests
```

```text
{module}/
├── Makefile
├── src/{module}.gr
└── tests/                   # suites + run_tests.gr + testing.gr
```

**ES:** El scaffold crea una fuente mínima, un runner y `test_status.gr`, además
de `Makefile` y `.gitignore` si faltan. El helper `TestStatus.finish` devuelve
código 1 ante un resultado falso; la suite debe conectar los grupos y pasarle
el resultado del framework, por ejemplo `TestStatus.finish(Testing.printSummary())`.
Se conservan los archivos propios y se actualiza solo el runner vacío anterior
reconocido. El framework se adapta al dominio en el completado.

**EN:** Scaffold creates a minimal source, runner and `test_status.gr`, plus a
missing `Makefile` and `.gitignore`. `TestStatus.finish` exits with code 1 on
false; the suite connects its groups and passes it the framework's result, for
example `TestStatus.finish(Testing.printSummary())`. Authored files are
preserved; only the recognized previous empty runner is upgraded. The
framework is adapted to the domain during completion.

### Groovy — Gradle + lib/src/

**ES:** Desde la raíz del paquete, retirar únicamente las muestras exactas de
Gradle 9.6.1 si son los únicos archivos o enlaces en `lib/src`. Si alguna
difiere, falta, o hay otros archivos, conservar ambas para revisión. El comando
de pruebas puede salir con éxito y `test NO-SOURCE`: no valida una suite.

**EN:** From the package root, remove only the exact Gradle 9.6.1 samples when
they are the only files or links in `lib/src`. Preserve both for review if
either differs or is missing, or other files exist. The test command can
succeed with `test NO-SOURCE`; that does not validate a suite.

```bash
src=lib/src/main/groovy/{module}/Library.groovy
tst=lib/src/test/groovy/{module}/LibraryTest.groovy
unsafe=0
for path in lib lib/src lib/src/main lib/src/main/groovy \
  lib/src/main/groovy/{module} lib/src/test lib/src/test/groovy \
  lib/src/test/groovy/{module}; do
  if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then unsafe=1; fi
done
if [[ "$unsafe" == 1 || ! -d lib/src || -L "$src" || -L "$tst" ||
      ( -e "$src" && ! -f "$src" ) || ( -e "$tst" && ! -f "$tst" ) ]]; then
  printf 'scaffold: ruta Groovy no segura o fuentes ausentes / unsafe Groovy path or missing sources\n' >&2
  false
elif [[ -f "$src" && -f "$tst" ]]; then
  source_sample="$(sed 's/@MODULE@/{module}/g' {root}/scripts/data/scaffold_templates/groovy.Library.groovy)" &&
  test -n "$source_sample" &&
  test_sample="$(sed 's/@MODULE@/{module}/g' {root}/scripts/data/scaffold_templates/groovy.LibraryTest.groovy)" &&
  test -n "$test_sample" && {
    cmp -s "$src" <(printf '%s\n' "$source_sample"); a=$?
    cmp -s "$tst" <(printf '%s\n' "$test_sample"); b=$?
    if [[ "$a" -gt 1 || "$b" -gt 1 ]]; then
      printf 'scaffold: no se pudo comparar la muestra Groovy / could not compare Groovy sample\n' >&2
      false
    elif [[ "$a" == 0 && "$b" == 0 ]]; then
      extra="$(find lib/src \( -type f -o -type l \) ! -path "$src" ! -path "$tst" -print -quit)" &&
        { [[ -n "$extra" ]] || rm -- "$tst" "$src"; }
    fi
  }
fi
```

### Haxe — build.hxml + src/ + test/
```bash
mkdir -p src test
haxelib install utest         # framework de pruebas (una vez)
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
npm pkg set type=module 'devDependencies.jest=^30.0.5'    # lo declara; los baja npm install
mkdir -p src test
```

```text
{module}/
├── package.json
├── jest.config.js
├── src/{module}.js
└── test/                    # una suite por enfoque
```

### Julia — paquete estándar de Pkg

**ES:** Herramienta (R1): julia -e 'using Pkg; Pkg.generate("{module}")', desde la carpeta de la fase (Pkg.generate(".") falla). Lo que sigue es la estructura homologada actual; el generador crea src/{module}.jl en minúscula, así que el módulo se actualizará al retomarlo (R6). A completar: uuid, [compat], [extras] y [targets] en el Project.toml, y el runner test/run_tests.jl.

**EN:** Tool (R1): julia -e 'using Pkg; Pkg.generate("{module}")', from the phase folder (Pkg.generate(".") fails). What follows is the current homologated structure; the generator creates lowercase src/{module}.jl, so the module will be updated when retaken (R6). To complete: uuid, [compat], [extras] and [targets] in Project.toml, plus the test/run_tests.jl runner.
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
dune init proj {module}
```

```text
{module}/
├── dune-project
├── {module}.opam            # generado
├── bin/                     # ejemplo generado
├── lib/
│   ├── dune                 # declara la librería
│   └── {module}.ml          # (+ {module}.mli opcional)
└── test/dune                # declara el ejecutable de tests
```

### Perl — lib/ + test/

**ES:** Andamiaje manual: la fuente va en `lib/` y las suites en `test/`, como
los módulos homologados y el verificador del catálogo. `module-starter` no forma
parte de esta secuencia. Crear la fuente solo si falta; no truncar una previa.
El comando usa la selección de archivos y el harness de `prove --ext=.pl
test/`, pero falla explícitamente si no hay archivos o si todos los casos se
omiten. Un scaffold vacío necesita su suite antes de poder validar.

**EN:** Manual scaffolding uses `lib/` and `test/`, matching verified modules
and the catalogue verifier. Module::Starter is not part of this sequence.
Create only a missing source. The command uses prove's file selection and TAP
harness, but fails explicitly when no files or no non-skipped cases are run.
An empty scaffold needs its suite before validation.

```bash
perl -MApp::Prove::State -MTAP::Harness::Env -e 'my $s = App::Prove::State->new({extensions => [".pl"]}); my @tests = $s->get_tests(0, "test/"); @tests or die "No Perl test files configured in test/\n"; my $result = TAP::Harness::Env->create({})->runtests(@tests); exit 1 if $result->has_errors; die "No Perl test cases executed\n" unless $result->total > $result->skipped;'
```

```bash
if [[ -L lib || -L test || -L lib/{module}.pl ||
      ( -e lib/{module}.pl && ! -f lib/{module}.pl ) ]]; then
  printf 'scaffold: ruta de Perl no segura / unsafe Perl path\n' >&2
  false
else
  mkdir -p lib test && {
      test -e lib/{module}.pl ||
          (set -C; printf 'package {Module};\n\nuse strict;\nuse warnings;\n\n1;\n' > lib/{module}.pl)
  }
fi
```

```text
{module}/
├── lib/{module}.pl
└── test/                    # una suite .pl por enfoque (Test2::Bundle::More)
```

### PHP — src/ + test/ con Composer y PHPUnit
```bash
mkdir -p src test
composer init -n --name={module}/{module}
composer require --dev --no-update phpunit/phpunit        # lo declara; los baja composer install
```

```text
{module}/
├── composer.json            # PHPUnit (dev) + autoload classmap + script test
├── phpunit.xml              # bootstrap + suite sobre test/
├── .gitignore               # vendor/, composer.lock y cachés
├── src/{Module}.php
└── test/{Module}Test.php    # una suite PHPUnit por enfoque
```

### Prolog — src/ + test/
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.pl          # base de conocimiento
└── test/                    # suites plunit por enfoque
```

**ES:** El scaffold conserva la fuente existente o crea una vacía, sin imponer
un módulo que oculte predicados a `consult/1`. El comando recoge todas las
suites `*_test.pl` y `*_tests.pl`; sin archivos anuncia el scaffold vacío.
Con archivos de prueba exige casos ejecutados y propaga fallos o errores.
Informa también los casos bloqueados, que no cuentan como ejecutados.

**EN:** Scaffold preserves an existing source or creates an empty one, without
imposing a module that hides predicates from `consult/1`. The command discovers
all `*_test.pl` and `*_tests.pl` suites; with no files it announces the empty
scaffold. With test files it requires executed cases and propagates failures
or errors. Blocked cases are also reported and do not count as executed.

```bash
cd test
swipl -q --on-error=status -g "use_module(library(plunit)), expand_file_name('*_test.pl', A), expand_file_name('*_tests.pl', B), append(A, B, Fs), (Fs = [] -> (expand_file_name('*.pl', Other), (Other = [] -> (consult('../src/{module}.pl'), writeln('Scaffold: no tests configured')); (format(user_error, 'No recognized Prolog test files~n', []), fail))); (maplist(consult, Fs), run_tests(all, [summary(S)]), get_dict(passed, S, P), get_dict(failed, S, F), get_dict(timeout, S, T), get_dict(blocked, S, BCount), format('Prolog tests: ~d passed, ~d failed, ~d timed out, ~d blocked~n', [P, F, T, BCount]), (P > 0, F =:= 0, T =:= 0 -> true; (P =:= 0, F =:= 0, T =:= 0 -> (format(user_error, 'No Prolog test cases executed~n', []), fail); fail)))), halt" -t 'halt(1)'
```

### Python — src-layout (PEP 621)

**ES:** Herramienta (R1): uv init --lib . (en el sitio; crea también un .git que hay que borrar). El generador usa un paquete src/{module}/ con py.typed y backend uv_build, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura homologada actual. A completar: conftest.py, tests/ y la configuración de pytest.

**EN:** Tool (R1): uv init --lib . (in place; it also creates a .git that must be deleted). The generator uses a package src/{module}/ with py.typed and the uv_build backend, so the module will be updated when retaken (R6); what follows is the current homologated structure. To complete: conftest.py, tests/ and the pytest configuration.
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

### R — paquete (R/ + tests/testthat/)

**ES:** El módulo es un paquete de R: DESCRIPTION (nombre, versión, licencia y dependencias), NAMESPACE (lo que se exporta), el código en R/ y las suites en tests/testthat/, con el prefijo test- que testthat descubre por defecto. El Makefile común deja el runner `make test`, que llama a `testthat::test_local()` —carga el paquete con pkgload::load_all(), sin instalarlo—; el "verificador" analiza los fuentes de R/ con `parse()`.

**EN:** The module is an R package: DESCRIPTION (name, version, license and dependencies), NAMESPACE (what is exported), the code in R/ and the suites in tests/testthat/, with the test- prefix testthat discovers by default. Its shared Makefile provides `make test`, which calls `testthat::test_local()`—it loads the package with `pkgload::load_all()`, without installing it—and the verifier analyses sources under R/ with `parse()`.

**ES:** Si faltan, el scaffold crea metadatos iniciales, fuente y NAMESPACE
vacíos, `tests/testthat.R` y un `test-scaffold.R` sin casos para que
`test_local()` arranque. No sustituye archivos existentes: el completado
revisa los metadatos y los exports, y la suite añade sus propios tests.

**EN:** When missing, scaffold creates initial metadata, an empty source and
NAMESPACE, `tests/testthat.R` and a case-free `test-scaffold.R` so
`test_local()` can start. Existing files are preserved: completion reviews
metadata and exports, and the suite adds its own tests.
```bash
mkdir -p R tests/testthat
```

```text
{module}/
├── DESCRIPTION              # metadatos del paquete
├── NAMESPACE                # lo que se exporta
├── Makefile                 # runner: make test
├── R/{module}.R
└── tests/                   # testthat.R + test-*.R
```

### Racket — paquete de cuatro colecciones ({module}-lib/ + {module}-test/)

**ES:** Herramienta (R1): raco new library {module} —de raco-new, que clona las plantillas de github.com/racket-templates—, desde la carpeta de la fase: el clon deja el proyecto ya con el nombre del módulo. Da el layout lib/test/doc de la comunidad ({module}/ metapaquete, {module}-lib/ con el código, {module}-test/ con las suites y {module}-doc/ con los scribblings) más Makefile, .gitignore y los documentos del template. La secuencia de new cierra las tres adecuaciones que el template no resuelve aquí: 1) su render-template.sh es interactivo y usa sed -i '' (BSD), que en Linux falla con can't read s/<project>/… y deja los marcadores <project> y <username> en los cuatro info.rkt, así que el render se hace con mv y sed -i de GNU, que además renombra el código a {module}.rkt con guiones —la convención de nombres de Racket—; 2) se borran .github/, pull_request_template.md, render-template.sh y profile/, que son del generador; y 3) las suites requieren la librería por ruta relativa ((require "../../{module}-lib/{module}.rkt"), con guiones), no por el nombre de la colección, para que corran sin instalar ni enlazar nada. El runner es raco test -x .: prueba los archivos con submodule test y no requiere los demás, así que no necesita el raco pkg install --link del Makefile del template, sale limpio y devuelve código 1 cuando algún caso falla.

**EN:** Tool (R1): raco new library {module} —from raco-new, which clones the templates in github.com/racket-templates—, from the phase folder: the clone leaves the project already named after the module. It gives the community's lib/test/doc layout ({module}/ metapackage, {module}-lib/ with the code, {module}-test/ with the suites and {module}-doc/ with the scribblings) plus Makefile, .gitignore and the template's documents. new's sequence closes the three adaptations the template does not solve here: 1) its render-template.sh is interactive and uses BSD sed -i '', which fails on Linux with can't read s/<project>/… and leaves the <project> and <username> placeholders in the four info.rkt files, so the render is done with mv and GNU sed -i, which also renames the code to {module}.rkt with dashes —Racket's naming convention—; 2) .github/, pull_request_template.md, render-template.sh and profile/ are removed, as they belong to the generator; and 3) the suites require the library by relative path ((require "../../{module}-lib/{module}.rkt"), with dashes), not by collection name, so they run without installing or linking anything. The runner is raco test -x .: it tests the files with a test submodule and does not require the others, so it needs neither the template Makefile's raco pkg install --link nor pollutes the output, and it returns exit code 1 when any case fails.
```bash
raco new library {module}
mv project {module} && mv project-lib {module}-lib && mv project-test {module}-test && mv project-doc {module}-doc
mv {module}-lib/main.rkt {module}-lib/$(printf '%s' {module} | tr '_' '-').rkt
sed -i 's/<project>/{module}/g; s/<username>/yorche3/g' {module}/info.rkt {module}-lib/info.rkt {module}-test/info.rkt {module}-doc/info.rkt
rm -rf .github pull_request_template.md render-template.sh profile
```

```text
{module}/
├── {module}/                # metapaquete (info.rkt)
├── {module}-lib/            # el código ({module}.rkt, con guiones)
├── {module}-test/           # las suites (tests/)
├── {module}-doc/            # scribblings
├── Makefile
└── .gitignore
```

### Raku — lib/ + t/

**ES:** Crear la fuente y el `.gitignore` solo si faltan; conservar contenido
existente y rechazar enlaces simbólicos en estas rutas. El comando usa el
descubrimiento y harness de `prove6 -l t/`, pero falla cuando no hay suites o
todos los casos se omiten; un scaffold vacío necesita su suite antes de validar.

**EN:** Create the source and `.gitignore` only when absent; preserve existing
content and reject symlinks at these paths. The test command uses prove6's
discovery and TAP harness but rejects runs without suites or non-skipped cases;
an empty scaffold needs its suite before validation.

```bash
raku -e 'use TAP:ver<0.3.4+>; use Path::Finder:ver<0.4.4+>; my @sources = find("t/", :and[ :or[ { :depth(0) }, { :ext(any(<t rakutest t6>)), :skip-hidden } ], :file ]).sort; @sources.elems or die "No Raku test files configured in t/\n"; my $result = TAP::Harness.new.run(@sources, :cwd($*CWD), :include-dirs[$*CWD.add("lib")]).result; if $result.bailout.defined { note $result.bailout.message; exit 1 }; exit 1 if $result.has-errors; die "Raku test execution incomplete\n" unless $result.result-count == @sources.elems; die "No Raku test cases executed\n" unless [+] $result.results.map({ .tests-run - .skipped });'
```

```bash
if [[ -L lib || -L t || -L lib/{Module}.rakumod || -L .gitignore ||
      ( -e lib/{Module}.rakumod && ! -f lib/{Module}.rakumod ) ||
      ( -e .gitignore && ! -f .gitignore ) ]]; then
  printf 'scaffold: ruta de Raku no segura / unsafe Raku path\n' >&2
  false
else
  mkdir -p lib t &&
    { test -e lib/{Module}.rakumod || (set -C; printf 'unit module {Module};\n' > lib/{Module}.rakumod); } &&
    { test -e .gitignore || (set -C; printf '.precomp/\nlib/.precomp/\n' > .gitignore); }
fi
```

```text
{module}/
├── lib/{Module}.rakumod
├── t/                       # suites .rakutest por enfoque
└── .gitignore               # precompilación de Raku
```

### Rexx — src/ + test/

**ES:** Crear la fuente solo si falta y rechazar enlaces simbólicos en las
rutas del scaffold. La selección de varias suites y la propagación de fallos
de ooRexxUnit siguen pendientes: el comando actual solo admite una suite y
una suite existente puede informar fallos sin devolver error.

**EN:** Create the source only when absent and reject symbolic scaffold paths.
Multiple-suite selection and ooRexxUnit failure propagation remain pending:
the current command accepts only one suite, and an existing suite can report
failures while returning success.

```bash
if [[ -L src || -L test || -L src/{module}.rexx ||
      ( -e src/{module}.rexx && ! -f src/{module}.rexx ) ]]; then
  printf 'scaffold: ruta de Rexx no segura / unsafe Rexx path\n' >&2
  false
else
  mkdir -p src test && {
    test -e src/{module}.rexx || (set -C; : > src/{module}.rexx)
  }
fi
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
bundle install --local        # resuelve con las gemas instaladas; sin red
```

```text
{module}/
├── Gemfile
├── .rspec
├── src/{module}.rb
└── test/                    # una suite _tests.rb por enfoque
```

### Rust — conservar el punto de entrada de Cargo

**ES:** `cargo init --lib` genera `Cargo.toml` y `src/lib.rs`. Ese es el punto de
entrada predeterminado; no renombrarlo a `src/{module}.rs` sin una decisión y
configuración explícita. El scaffold comprueba ambos archivos y los conserva:

**EN:** Cargo's library initializer generates its default entry point.
Scaffolding checks and preserves it; do not rename it without explicit crate
configuration.

```bash
test -f Cargo.toml && test -f src/lib.rs
```

**ES:** Los ejemplos de funciones/tests que genere Cargo se revisan en el paso
4a; no representan la suite del contrato. Verificado con `cargo test --offline`
en un paquete temporal, sin tocar módulos homologados.

**EN:** Review Cargo-generated function/test examples in step 4a; they are not
the contract suite. Verified offline in a temporary package, not actual modules.

### Scala — layout sbt estándar

**ES:** Crear la fuente mínima, el build con ScalaTest, la versión sbt y el
ignore solo si faltan, siguiendo las bases homologadas. Conservar los archivos
existentes y rechazar enlaces simbólicos en estas rutas. Revisar los archivos
previos vacíos y adecuar la fuente al contrato del módulo.

**EN:** Create the minimal source, ScalaTest build, sbt version and ignore file
only when missing, following the homologated bases. Preserve existing files and
reject symlinks at these paths. Review empty existing files and adapt the source
to the module contract.

```bash
if [[ -L src || -L src/main || -L src/main/scala || -L src/test ||
      -L src/test/scala || -L project || -L src/main/scala/{Module}.scala ||
      -L build.sbt || -L project/build.properties || -L .gitignore ||
      ( -e src/main/scala/{Module}.scala && ! -f src/main/scala/{Module}.scala ) ||
      ( -e build.sbt && ! -f build.sbt ) ||
      ( -e project/build.properties && ! -f project/build.properties ) ||
      ( -e .gitignore && ! -f .gitignore ) ]]; then
  printf 'scaffold: ruta de Scala no segura / unsafe Scala path\n' >&2
  false
else
  mkdir -p src/main/scala src/test/scala project &&
    { test -e src/main/scala/{Module}.scala || (set -C; printf 'object {Module}\n' > src/main/scala/{Module}.scala); } &&
    { test -e build.sbt || (set -C; printf 'ThisBuild / version := "0.1.0-SNAPSHOT"\nThisBuild / scalaVersion := "3.9.0"\n\nlazy val root = (project in file("."))\n  .settings(\n    name := "{module}",\n    libraryDependencies += "org.scalatest" %%%% "scalatest" %% "3.2.19" %% Test\n  )\n' > build.sbt); } &&
    { test -e project/build.properties || (set -C; printf 'sbt.version=1.10.1\n' > project/build.properties); } &&
    { test -e .gitignore || (set -C; printf 'target/\n.bsp/\n.scala-build/\n.metals/\n.idea/\n' > .gitignore); }
fi
```

```text
{module}/
├── build.sbt
├── project/build.properties
├── .gitignore
└── src/
    ├── main/scala/{Module}.scala  # fuente mínima
    └── test/scala/          # suites ScalaTest por enfoque
```

**ES:** El comando conserva `test` y su informe nativos, y comprueba sus
resultados estructurados para rechazar ejecuciones sin casos aprobados.
Está verificado para los proyectos sbt de un módulo usados aquí.

**EN:** The command keeps native `test` and its report, and checks structured
results to reject runs without passing cases. It is verified for the
single-project sbt builds used here.

```bash
sbt -batch -no-colors 'set Test / test := { (Test / test).value; val result = (Test / executeTests).value; if (result.overall != sbt.protocol.testing.TestResult.Passed) throw new MessageOnlyException("Scala tests failed"); if (result.events.values.map(_.passedCount).sum == 0) throw new MessageOnlyException("No Scala test cases passed") }' test
```

### Scheme — src/ + test/

**ES:** Crear la fuente Guile y el `.gitignore` solo si faltan, conservando
archivos existentes y rechazando enlaces simbólicos en esas rutas. El comando
ejecuta todas las suites `*_guile.scm`, comprueba sus resultados SRFI-64 y
rechaza suites ausentes, vacías, incompletas o con salida anticipada.

**EN:** Create the Guile source and `.gitignore` only when absent, preserving
existing files and rejecting symlinks at these paths. The command runs all
`*_guile.scm` suites, checks SRFI-64 results and rejects missing, empty,
incomplete or prematurely exited suites.

```bash
cd test && { found=0; failed=0; for suite in ./*_guile.scm; do [ -f "$suite" ] || continue; found=1; guile --no-auto-compile -c '(use-modules (srfi srfi-64)) (define runner (test-runner-simple)) (define bad-group #f) (define old-count (test-runner-on-bad-count runner)) (define old-name (test-runner-on-bad-end-name runner)) (test-runner-on-bad-count! runner (lambda args (set! bad-group #t) (apply old-count args))) (test-runner-on-bad-end-name! runner (lambda args (set! bad-group #t) (apply old-name args))) (test-runner-current runner) (catch (quote quit) (lambda () (load (canonicalize-path (cadr (command-line))))) (lambda (key . args) (error "Scheme suite exited before validation" args))) (when (or bad-group (not (null? (test-runner-group-stack runner)))) (error "Scheme test group mismatch")) (when (= 0 (+ (test-runner-pass-count runner) (test-runner-fail-count runner) (test-runner-xfail-count runner) (test-runner-xpass-count runner))) (error "No Scheme test cases executed")) (exit (= 0 (test-runner-fail-count runner) (test-runner-xpass-count runner)))' "$suite" || failed=1; done; if [ "$found" -eq 0 ]; then printf 'No Scheme test files configured in test/\n' >&2; false; else [ "$failed" -eq 0 ]; fi; }
```

```bash
if [[ -L src || -L test || -L src/{module}.scm || -L .gitignore ||
      ( -e src/{module}.scm && ! -f src/{module}.scm ) ||
      ( -e .gitignore && ! -f .gitignore ) ]]; then
  printf 'scaffold: ruta de Scheme no segura / unsafe Scheme path\n' >&2
  false
else
  mkdir -p src test &&
    { test -e src/{module}.scm || (set -C; printf '(define-module ({module}))\n' > src/{module}.scm); } &&
    { test -e .gitignore || (set -C; printf '*.log\n' > .gitignore); }
fi
```

```text
{module}/
├── src/{module}.scm
├── test/                    # suites por enfoque (+ variantes _guile.scm)
└── .gitignore               # logs de SRFI-64
```

### Swift — Swift Package Manager

**ES:** El generador deja un test `example` sin aserciones. El scaffold
sustituye esa muestra únicamente si coincide exactamente con la plantilla
verificada de SwiftPM 6.3.3; conserva cualquier variante propia y pide
revisarla. Conserva el manifiesto y el ignore existentes, rechaza enlaces en
las rutas usadas por el scaffold y
requiere un `Package.swift` regular. Hay que revisar fuentes y nombres.
`swift test` puede devolver éxito con cero casos; no es una suite validada.

**EN:** The generator leaves an assertion-free `example` test. Scaffold
replaces it only if it exactly matches the verified SwiftPM 6.3.3 template;
it preserves and requests review of any other version. It preserves the
manifest and ignore file, rejects symlinks in scaffold paths and requires a regular
`Package.swift`. Source and names need review. `swift test` can succeed with
zero cases; that is not a validated suite.

```bash
if [[ -L Package.swift || ! -f Package.swift || -L Sources || -L Tests ||
      -L Tests/{module}Tests || -L Tests/{module}Tests/{module}Tests.swift ||
      -L .gitignore ||
      ( -e Tests/{module}Tests && ! -d Tests/{module}Tests ) ||
      ( -e Tests/{module}Tests/{module}Tests.swift && ! -f Tests/{module}Tests/{module}Tests.swift ) ||
      ( -e .gitignore && ! -f .gitignore ) ]]; then
  printf 'scaffold: ruta Swift no segura o manifiesto ausente / unsafe Swift path or missing manifest\n' >&2
  false
else
  mkdir -p Tests &&
    { test -e .gitignore || (set -C; printf '.DS_Store\n/.build\n/Packages\nxcuserdata/\nDerivedData/\n.swiftpm/configuration/registries.json\n.swiftpm/xcode/package.xcworkspace/contents.xcworkspacedata\n.netrc\n' > .gitignore); }
fi &&
if [[ -f Tests/{module}Tests/{module}Tests.swift ]]; then
  sample="$(sed 's/@MODULE@/{module}/g' {root}/scripts/data/scaffold_templates/swift.Test.swift)" &&
    test -n "$sample" && {
      cmp -s Tests/{module}Tests/{module}Tests.swift <(printf '%s\n' "$sample")
      result=$?
      if [[ "$result" == 0 ]]; then
        printf 'import Testing\n@testable import {module}\n' > Tests/{module}Tests/{module}Tests.swift
      elif [[ "$result" != 1 ]]; then
        printf 'scaffold: no se pudo comparar la muestra Swift / could not compare Swift sample\n' >&2
        false
      fi
    }
fi
```

```text
{module}/
├── Package.swift
├── Sources/{module}/        # código público generado
└── Tests/{module}Tests/     # suites XCTest o Swift Testing
```

### Tcl — src/ + test/

**ES:** Crear la fuente, el índice de paquete y el ignore solo si faltan;
conservar archivos existentes y rechazar enlaces simbólicos en estas rutas.
Revisar los archivos previos que estén vacíos.

**EN:** Create the source, package index and ignore file only when missing;
preserve existing files and reject symlinks at these paths. Review any
pre-existing empty files.

```bash
if [[ -L src || -L test || -L src/{module}.tcl || -L src/pkgIndex.tcl ||
      -L .gitignore || ( -e src/{module}.tcl && ! -f src/{module}.tcl ) ||
      ( -e src/pkgIndex.tcl && ! -f src/pkgIndex.tcl ) ||
      ( -e .gitignore && ! -f .gitignore ) ]]; then
  printf 'scaffold: ruta de Tcl no segura / unsafe Tcl path\n' >&2
  false
else
  mkdir -p src test &&
    { test -e src/{module}.tcl || (set -C; printf 'namespace eval {Module} {}\n\npackage provide {module} 1.0\n' > src/{module}.tcl); } &&
    { test -e src/pkgIndex.tcl || (set -C; printf '%s\n' 'package ifneeded {module} 1.0 [list source [file join $dir {module}.tcl]]' > src/pkgIndex.tcl); } &&
    { test -e .gitignore || (set -C; printf '*.log\n' > .gitignore); }
fi
```

```text
{module}/
├── src/{module}.tcl         # namespace + package provide
├── src/pkgIndex.tcl         # permite package require
├── test/                    # suites .test con Tcltest
└── .gitignore               # logs de tests
```

**ES:** El comando ejecuta cada suite `.test`, añade `src/` a `auto_path` y
comprueba los contadores de Tcltest en `cleanupTests`. Rechaza suites sin
casos efectivos, fallos, salidas anticipadas y cambios en el hook de limpieza.
Las suites deben finalizar sus casos con `cleanupTests` y no sustituir ese hook.

**EN:** The command runs each `.test` suite, adds `src/` to `auto_path` and
checks Tcltest counters at `cleanupTests`. It rejects suites with no effective
cases, failures, premature exits and changes to the cleanup hook. Suites must
finalize their cases with `cleanupTests` and must not replace that hook.
```bash
cd test && { found=0; failed=0; for suite in ./*.test; do [ -f "$suite" ] || continue; found=1; printf '%s\n' 'set suite [file normalize [lindex $argv 0]]; set argv {}; set argv0 $suite; package require tcltest; set auto_path [linsert $auto_path 0 [file normalize ../src]]; set ::glotTotal 0; set ::glotSkipped 0; set ::glotFailed 0; set ::glotCleanups 0; proc ::tcltest::cleanupTestsHook {} {variable numTests; incr ::glotCleanups; incr ::glotTotal $numTests(Total); incr ::glotSkipped $numTests(Skipped); incr ::glotFailed $numTests(Failed)}; set ::glotHookBody [info body ::tcltest::cleanupTestsHook]; rename ::exit ::glotExit; proc ::exit {{status 0}} {return -code error "Tcl test suite exited before validation ($status)"}; if {[catch {source $suite} message options]} {puts stderr "Tcl suite error: $message"; if {[dict exists $options -errorinfo]} {puts stderr [dict get $options -errorinfo]}; ::glotExit 1}; if {![llength [info procs ::tcltest::cleanupTestsHook]] || [info body ::tcltest::cleanupTestsHook] ne $::glotHookBody} {puts stderr "Tcl cleanup hook changed"; ::glotExit 1}; if {$::glotCleanups == 0} {puts stderr "Tcl test suite did not call cleanupTests"; ::glotExit 1}; if {$::tcltest::numTests(Total) != 0} {puts stderr "Tcl test cases not finalized"; ::glotExit 1}; if {$::glotTotal == $::glotSkipped} {puts stderr "No Tcl test cases executed"; ::glotExit 1}; ::glotExit [expr {$::glotFailed > 0}]' | tclsh9.0 /dev/stdin "$suite" || failed=1; done; if [ "$found" -eq 0 ]; then printf 'No Tcl test files configured in test/\n' >&2; false; else [ "$failed" -eq 0 ]; fi; }
```

### Vala — src/ + test/

**ES:** Herramienta (R1): meson init --language vala --type library --name {module} (R4: meson es el build más usado del ecosistema). El generador deja meson.build y las fuentes en la raíz, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura homologada actual. A completar: src/ y test/.

**EN:** Tool (R1): meson init --language vala --type library --name {module} (R4: meson is the ecosystem's most used build). The generator leaves meson.build and the sources at the root, so the module will be updated when retaken (R6); what follows is the current homologated structure. To complete: src/ and test/.
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.vala
└── test/                    # una suite .vala por enfoque (GLib.Test)
```

### V — módulo V

**ES:** Herramienta (R1): `v init --lib`, **no interactivo**. Crea `{module}.v` en la raíz, `tests/`, `.editorconfig`, `.gitattributes`, `.git` y `v.mod`. Conservar `tests/` y el gitfile; crear `src/` sin mover fuentes desconocidas. El traslado de código a `src/` requiere cambiar los imports a `{module}.src`; no se puede hacer renombrando carpetas solamente.

**EN:** `v init --lib` is non-interactive and creates a root source, `tests/`, configuration files and Git metadata. Preserve the test directory and gitfile; moving code into `src/` also requires updating imports to `{module}.src`, not just renaming folders.
```bash
v init --lib                  # genera v.mod (no interactivo)
mkdir -p src tests
```

```text
{module}/
├── v.mod
├── src/{module}.v
└── tests/                   # archivos _test.v con funciones test_*
```

### Manifiestos que mkdir no crea / Manifests mkdir does not create

**ES:** Cuando el lenguaje exige un manifiesto mínimo, escríbelo a mano después del mkdir -p: Project.toml en Julia, v.mod en V, {module}.nimble en Nim, {module}.rockspec en Lua, pom.xml en Java, build.gradle(.kts) en Groovy y Kotlin.

**EN:** When the language requires a minimal manifest, write it by hand after `mkdir -p`: `Project.toml` in Julia, `v.mod` in V, `{module}.nimble` in Nim, `{module}.rockspec` in Lua, `pom.xml` in Java, `build.gradle(.kts)` in Groovy and Kotlin.

## 📁 Convenciones comunes / Common conventions

**ES:**

- **Separar fuente y pruebas.** `src/` (o `lib/`, `source/`) para el código y `test/` (o `tests/`, `spec/`, `t/`) para las suites. Ninguna suite vive junto al código de producción.
- **Una suite por enfoque** cuando el módulo tenga variantes (`rec` / `acc` / `ite`). El nombre del archivo refleja el enfoque: `numbers_rec_test`, `numbers_ite_test`, `recursive_tests`, `iterative_tests`.
- **Un `.gitignore` por módulo**, creado si el inicializador no lo deja, que excluya los artefactos del lenguaje: `bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`, `.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, etc.
- **Sin `main` propio** cuando el runner de tests lo genera: declarar `main` en un target de librería rompe el runner (caso real en D con `dub test` y en C# con `dotnet test`).
- **Cerrar el módulo** con su `README.md` generado desde [`README_Template.md`](../README_Template.md), el registro en [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) y la actualización de [`ROADMAP.md`](../ROADMAP.md).

**EN:**

- **Separate sources and tests.** `src/` (or `lib/`, `source/`) for code and `test/` (or `tests/`, `spec/`, `t/`) for suites. No suite lives next to production code.
- **One suite per approach** when the module has variants (`rec` / `acc` / `ite`). The file name reflects the approach: `numbers_rec_test`, `numbers_ite_test`, `recursive_tests`, `iterative_tests`.
- **One `.gitignore` per module**, created if the initializer does not provide one, excluding the language's artifacts: `bin/`, `obj/`, `target/`, `_build/`, `.dart_tool/`, `.spago/`, `build/`, `.zig-cache/`, `node_modules/`, `lib/bs/`, etc.
- **No `main` of your own** when the test runner generates one: declaring `main` in a library target breaks the runner (real cases: `dub test` in D and `dotnet test` in C#).
- **Close the module** with its `README.md` generated from [`README_Template.md`](../README_Template.md), the record in [`ROADMAP_UPDATE_CHECKLIST.md`](../ROADMAP_UPDATE_CHECKLIST.md) and the update of [`ROADMAP.md`](../ROADMAP.md).

## 📝 Notas / Notes

**ES:** Los comandos marcados ✅ provienen de los READMEs de este repositorio; si actualizas un módulo y cambia su comando de inicialización, actualiza también esta tabla.

**EN:** Commands marked ✅ come from this repository's READMEs; if you update a module and its initialization command changes, update this table too.

**ES:** Los comandos marcados 🔧 son la herramienta oficial del ecosistema, útil cuando se quiere empezar desde una plantilla en lugar de la estructura manual. Algunos generan carpetas extra que este repositorio no usa; se pueden borrar.

**EN:** Commands marked 🔧 are the ecosystem's official tool, useful to start from a template instead of the manual structure. Some generate extra folders this repository does not use; they can be deleted.

**ES:** Este documento no cubre la instalación de toolchains. Cada lenguaje la documenta en `{lenguaje}/README.md` y en los READMEs de sus módulos.

**EN:** This document does not cover toolchain installation. Each language documents it in `{language}/README.md` and in its module READMEs.

**ES:** Si además usas la **herramienta de apoyo** que incluye este repositorio (`glot`), ten en cuenta que solo **facilita** este trabajo: ejecuta estos mismos comandos por ti y confirma cada paso con su commit. La guía no depende de ella — sirve igual para desarrollar fuera de este entorno — y aprender el lenguaje nunca pasa por conocerla.

**EN:** If you also use the repository's **support tool** (`glot`), note that it only **makes this work easier**: it runs these very commands for you and confirms each step with its commit. The guide does not depend on it — it works just as well for developing outside this environment — and learning the language never goes through knowing it.

*[← Volver a Core](README.md) · [↑ Inicio / Back to home](../index.md)*
