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

ES: Los símbolos pueden combinarse. ⛓️ ✅ significa que el comando es el primero de una secuencia verificada en el README de un módulo de este repositorio; ⛓️ 🔧 significa que es el primero de una secuencia cuya herramienta es el estándar del ecosistema. Un comando sin ⛓️ es un único paso; un comando sin ✅ ni 🔧 es manual y no está verificado en un README del repositorio.

EN: Symbols may combine. ⛓️ ✅ means the command is the first of a verified sequence, documented in a module README of this repository; ⛓️ 🔧 means it is the first of a sequence whose tool is the ecosystem standard. A command without ⛓️ is a single step; a command without ✅ or 🔧 is manual and is not verified in a repository README.
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

Las rutas de la columna Manifiesto son relativas a la carpeta del módulo.
Lenguaje	Comando de inicialización	Manifiesto / archivos clave	Pruebas
ada	⛓️ ✅ alr init --lib --in-place {module}	alire.toml, {module}.gpr, config/, tests/	✅ alr -C tests run
assembly	✍️ mkdir -p src test + Makefile	Makefile	✅ make run
ballerina	🔧 bal new {module}	Ballerina.toml, {module}.bal, tests/	✅ bal test
c	✍️ mkdir -p include src test + Makefile	include/{module}.h, Makefile	✅ make test
clojure	⛓️ 🔧 clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib	deps.edn, build.clj, src/{module}/	✅ clojure -T:build test
cobol	✍️ mkdir -p src/copybooks src/lib test	Makefile, run_tests	✅ make test
common-lisp	⛓️ 🔧 cl-project:make-project vía ros + quicklisp	{module}.asd, src/{module}.lisp y tests/{module}-test.lisp (con guion), run-tests.lisp	✅ ros run --load run-tests.lisp --eval '(uiop:quit)'
cpp	✅ Configuración manual de Bazel (MODULE.bazel, WORKSPACE, targets en BUILD)	BUILD, MODULE.bazel, .bazelversion	✅ bazelisk test //...
crystal	🔧 crystal init lib {module}	shard.yml	✅ crystal spec
csharp	⛓️ ✅ dotnet new sln -n {Module}	{Module}.slnx, src/{Module}/{Module}.csproj, test/{Module}.Tests/	✅ dotnet test {Module}.slnx
d	✅ dub init {module} --format=sdl	dub.sdl	✅ dub test
dart	✅ dart create -t package {module}	pubspec.yaml, analysis_options.yaml	✅ dart test
elixir	🔧 mix new {module} --module {Module}	mix.exs	✅ mix test
elm	🔧 elm init	elm.json	✅ elm-test
erlang	✅ rebar3 new lib {module}	rebar.config, src/{module}.app.src	✅ rebar3 eunit
forth	✍️ mkdir -p src test	— (runner casero test.forth)	✅ cd test && gforth run-tests.forth
fsharp	⛓️ 🔧 dotnet new sln -n {Module} (después classlib -lang F# y xunit; el layout homologado es plano)	{Module}.slnx, src/{Module}.fsproj, test/{Module}.Tests.fsproj	✅ dotnet test
gleam	✅ gleam new {module}	gleam.toml, manifest.toml	✅ gleam test
go	✅ go mod init example.com/{module}	go.mod	✅ go test ./...
grain	✍️ mkdir -p src tests + Makefile	Makefile	✅ make test
groovy	⛓️ ✅ gradle init --type groovy-library --dsl groovy --use-defaults	settings.gradle, lib/build.gradle, gradle/	✅ ./gradlew test
haskell	🔧 cabal init --lib	{module}.cabal	✅ cabal test
haxe	⛓️ ✅ mkdir -p src test (después haxelib install utest)	build.hxml, RunTests.hx	✅ haxe build.hxml
java	✍️ pom.xml a mano (el arquetipo quickstart es de aplicación: R2)	pom.xml	✅ mvn test
javascript	🔧 npm init -y	package.json, jest.config.js	✅ npm test
julia	⛓️ 🔧 julia -e 'using Pkg; Pkg.generate("{module}")'	Project.toml, src/{Module}.jl, test/	✅ julia --project=. test/run_tests.jl
kotlin	⛓️ ✅ gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project	build.gradle.kts, settings.gradle.kts	✅ gradle test
lua	🔧 luarocks init	{module}.rockspec, .busted	✅ busted
nim	⛓️ ✅ nimble init (tipo library; `nimble init -y`)	{module}.nimble, src/{module}.nim, test/config.nims	✅ nimble test
ocaml	⛓️ ✅ dune init proj {module} (crea la carpeta del módulo)	dune-project, lib/dune, test/dune	✅ dune runtest
perl	✍️ mkdir -p lib test	—	✅ prove --ext=.pl test/
php	✍️ mkdir -p src test + composer init -n + composer require --dev --no-update phpunit/phpunit	composer.json, phpunit.xml, .gitignore	✅ composer test
prolog	✍️ mkdir -p src test	—	✅ cd test && swipl -q -f {suite}.pl -t halt
purescript	🔧 spago init	spago.yaml	✅ spago test
python	⛓️ ✅ uv init --lib .	pyproject.toml, src/{module}/, conftest.py, tests/	✅ pytest
r	✅ mkdir -p R tests/testthat	—	✅ make test
racket	⛓️ 🔧 raco new library {module}	info.rkt, {module}.rkt (con guiones), tests/, Makefile	✅ raco test -x .
raku	✅ mkdir -p lib t	—	✅ prove6 -l t/
rescript	⛓️ ✅ mkdir -p src test (después el manifiesto con npm pkg set)	rescript.json, package.json, jest.config.js	✅ npm test
rexx	✅ mkdir -p src test	—	✅ rexx test/{suite}.rexx
ruby	⛓️ ✅ mkdir -p src test (después bundle init y bundle install)	Gemfile, .rspec	✅ bundle exec rspec
rust	✅ cargo init --lib	Cargo.toml	✅ cargo test
scala	✍️ mkdir -p src/main/scala src/test/scala project + build.sbt (el runner instalado, sbt 2.0.8, ya no trae sbt new)	build.sbt, project/build.properties	✅ sbt -batch -no-colors test
scheme	✍️ mkdir -p src test	—	✅ cd test && guile --no-auto-compile -s {suite}_guile.scm
swift	🔧 swift package init --type library	Package.swift, Sources/{Module}/	✅ swift test
tcl-tk	✅ mkdir -p src test	src/pkgIndex.tcl	✅ cd test && TCLLIBPATH="$(cd ../src && pwd)" tclsh9.0 {suite}.test
typescript	✅ npm init -y	package.json, tsconfig.json, jest.config.cjs	✅ npm test
v	⛓️ ✅ v init --lib (no interactivo; quitar el .git anidado y fijar la versión)	v.mod, {module}.v, test/	✅ v test .
vala	⛓️ 🔧 meson init --language vala --type library --name {module}	meson.build, src/, test/	✅ valac src/{module}.vala test/{suite}.vala --pkg glib-2.0 -o /tmp/{module}-tests && /tmp/{module}-tests
zig	✅ zig init	build.zig	✅ zig build test
## 🔗 Secuencias de varios pasos / Multi-step sequences

**ES:** Estos lenguajes necesitan **más de un comando**. La tabla lista, por lenguaje, la secuencia completa de inicialización y lo que se completa a mano después. Los generadores que crean la carpeta por su cuenta (`ballerina`, `crystal`, `d`, `dart`, `elixir`, `erlang`, `gleam`) se lanzan desde la carpeta de la fase; los demás, desde dentro de la carpeta del módulo.

**EN:** These languages need **more than one command**. The table lists, per language, the full initialisation sequence and what is completed by hand afterwards. Generators that create the folder themselves (`ballerina`, `crystal`, `d`, `dart`, `elixir`, `erlang`, `gleam`) run from the phase folder; the rest, from inside the module folder.

**ES:** Un lenguaje que no aparece aquí se resuelve con el comando de la **tabla maestra**.

**EN:** A language that does not appear here is handled by the **master table**'s command.

Lenguaje / Language	Secuencia de inicialización / Initialisation sequence	Completado posterior a mano / Later completion by hand
ada	alr init --lib --in-place {module} → alr init --bin tests → alr with {module} --use=.. → alr with aunit (los dos últimos, dentro de tests/)	Licencia GPL-3.0-or-later en alire.toml y tests/alire.toml, y description del subproyecto de pruebas
clojure	clojure -Sdeps '{:deps {io.github.seancorfield/deps-new …}}' -Tnew create :template lib :name {module} :target-dir {module}	Sustituir el test de plantilla
common-lisp	ros -e '(ql:quickload :cl-project)' -e '(cl-project:make-project #p"{module}" :depends-on nil)'	Homologar el andamiaje con guion y no subrayado, sistema de pruebas con fiveam y run-tests.lisp
csharp	dotnet new sln → dotnet new classlib → dotnet new xunit → dotnet sln add → dotnet add test/{Module}.Tests/{Module}.Tests.csproj reference src/{Module}/{Module}.csproj	Borrar Class1.cs y UnitTest1.cs y añadir .gitignore
fsharp	Igual que C# con -lang F#	Aplanar a src/{Module}.fsproj, <ProjectReference>, borrar Library.fs y Tests.fs, .gitignore
groovy	gradle init --type groovy-library --dsl groovy --use-defaults	Borrar Library.groovy y LibraryTest.groovy
haxe	mkdir -p src test → haxelib install utest	build.hxml y RunTests.hx son contenido del sprint
julia	julia -e 'using Pkg; Pkg.generate("{module}")'	Completar test/ y su runner; añadir uuid, [compat], [extras] y [targets]
kotlin	gradle init --type kotlin-library --dsl kotlin --use-defaults --no-split-project	Borrar Library.kt y LibraryTest.kt
nim	nimble init -y → rm -rf src/{module} → la task `test` apuntando a tests/{module}_tests.nim	Borrar la muestra anidada src/{module}/ y dejar la task `test` apuntando a tests/{module}_tests.nim
ocaml	dune init proj {module}	El código va en lib/ y la suite en test/: se usa el layout generado tal cual
python	uv init --lib .	Borrar el .git que crea uv, añadir conftest.py y tests/ con configuración de pytest, y declarar pytest (uv add --dev pytest --no-sync)
racket	raco new library {module} → render portátil (mv + sed -i, con el código renombrado a {module}.rkt con guiones) → rm -rf .github pull_request_template.md render-template.sh profile	Las suites requieren la librería por ruta relativa ("../../{module}-lib/{module}.rkt", con guiones) y el runner es raco test -x ., sin enlazar paquetes
rescript	mkdir -p src test → npm init -y → npm pkg set	El manifiesto y sus devDependencies se declaran con `npm pkg set`; los baja `npm install`
ruby	mkdir -p src test → bundle init → bundle install	rspec en el Gemfile y .rspec
v	v init --lib (lo conduce expect)	Quitar el .git anidado, llevar tests/ a test/ y fijar version: '0.1.0' en v.mod
vala	meson init --language vala --type library --name {module}	Completar src/ y test/ y decidir el build con meson

    ES: Si el generador crea un main o un app de ejemplo (caso de dub init en D, zig init; cargo init --lib genera solo la librería), bórralo cuando el módulo sea una biblioteca: un main propio rompe el runner de tests generado por la herramienta. Ese borrado es parte del completado posterior.
    EN: If the generator creates an example main or app (e.g. dub init in D, zig init; cargo init --lib generates only the library), delete it when the module is a library: a main of your own breaks the tool's generated test runner. That deletion is part of the later completion.

ES: Un lenguaje que no aparece aquí se resuelve con el comando único de la tabla maestra.
EN: A language that does not appear here is handled by the single command in the master table.
## 🔨 Generación manual (lib) / Manual generation (lib)

> **ES:** **Todo el esqueleto se puede hacer con comandos de consola**: `mkdir -p`, `cd`, `touch` y la declaración idiomática de cada fichero. No hace falta ninguna herramienta especial para esta parte. Hoy la guía cubre el caso **lib**; bin y web se añadirán después.
>
> **EN:** The whole skeleton can be built with console commands: `mkdir -p`, `cd`, `touch` and each file's idiomatic declaration. No special tooling is needed for this part. Today the guide covers the **lib** case; bin and web come later.

**ES:** Para los lenguajes sin herramienta aceptada (✍️), la secuencia manual es: crear las carpetas, crear los ficheros con `touch` y pegarles la declaración idiomática del lenguaje. Ejemplos (lib):

**EN:** For languages without an accepted tool (✍️), the manual sequence is: create the folders, create the files with `touch`, and give them the language's idiomatic declaration. Examples (lib):

| Lenguaje / Language | Comandos / Commands | Declaración idiomática / Idiomatic declaration |
|---|---|---|
| `assembly` | `mkdir -p src test` · `touch src/{module}.asm` | `global {module}_init` + `.text` |
| `c` | `mkdir -p include src test` · `touch include/{module}.h src/{module}.c` | `#ifndef {MODULE}_H` + `#define {MODULE}_H` en la cabecera; `#include "{module}.h"` en la fuente |
| `cobol` | `mkdir -p src/copybooks src/lib test` · `touch src/lib/{module}.cbl` | `IDENTIFICATION DIVISION.` + `PROGRAM-ID. {Module}.` |
| `forth` | `mkdir -p src test` · `touch src/{module}.forth` | `: {module}-init` |
| `grain` | `mkdir -p src tests` · `touch src/{module}.gr` | `module {Module}` |
| `java` | `mkdir -p src/main/java src/test/java` · `touch src/main/java/{Module}.java` | `public class {Module} { }` |
| `perl` | `mkdir -p src test` · `touch src/{module}.pl` | `package {Module};` + `use strict;` + `use warnings;` + `1;` |
| `php` | `mkdir -p src test` · `touch src/{Module}.php` | `<?php` + `declare(strict_types=1);` + `namespace {Module};` |
| `prolog` | `mkdir -p src test` · `touch src/{module}.pl` | `:- module({module}, []).` |
| `scala` | `mkdir -p src/main/scala src/test/scala project` · `touch src/main/scala/{Module}.scala` | `object {Module}` |
| `scheme` | `mkdir -p src test` · `touch src/{module}.scm` | `(define-library ({module}) (export) (import (scheme base)))` |

**ES:** En los lenguajes con herramienta, la secuencia manual equivalente es su comando de la **tabla maestra** seguido de lo que lista la sección **Secuencias de varios pasos**.

**EN:** For languages with a tool, the equivalent manual sequence is its **master table** command followed by what the **Multi-step sequences** section lists.

## 🧱 Estructuras de referencia / Reference structures

ES: Cuando el lenguaje no ofrece una herramienta de inicialización aceptada (R2/R5), la estructura se replica con mkdir -p; los árboles siguientes son los que usan los módulos reales de core/foundations/numbers/ y core/algorithms/naive_sort/. En los lenguajes que sí tienen herramienta, la sección correspondiente empieza diciendo cuál es y qué queda por completar: allí el árbol es el completado y la estructura que el módulo seguirá usando hasta que se retome (R6).

EN: When the language has no accepted scaffolding tool (R2/R5), the structure is replicated with mkdir -p; the trees below are those used by the real modules under core/foundations/numbers/ and core/algorithms/naive_sort/. For languages that do have a tool, the matching section starts by naming it and what is left to complete: there the tree is the completion and the structure the module will keep using until it is retaken (R6).
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
├── run_tests                # script de ejecución
├── src/copybooks/           # copybooks
├── src/lib/                 # programa principal
└── test/                    # ASSERTS.cpy + suites + RUN-TESTS.cbl
```

### Common Lisp — ASDF + src/ + tests/

ES: Herramienta (R1): cl-project:make-project vía ros + quicklisp, desde la carpeta de la fase; es el generador de la comunidad y sustituyó a quickproject el 2026-09-29, porque aquel dejaba el proyecto plano. Exige un pathname, así que la cadena no vale: #p"{module}" no es opcional. Deja {module}/ con {module}.asd, src/main.lisp, tests/main.lisp, README.org, README.markdown y .gitignore. Para que el andamiaje quede homologado hay que aplicar seis correcciones —medidas el 2026-09-29 al dejar homologado common-lisp/core/algorithms/data_structures_basics/, que queda como referencia—: 1) nombrar los ficheros como el módulo y con guion ({module}.asd, src/{module}.lisp, tests/{module}-test.lisp), porque main es el nombre de la plantilla y el subrayado no es la convención de Lisp; 2) el .asd con defsystem/test-op y uiop:symbol-call; 3) el paquete con guion; 4) el sistema de pruebas sobre fiveam, como numbers.asd y naive-sort.asd, y no sobre rove, que no está instalado aquí; 5) el paquete de pruebas {module}/tests con :export #:run-tests y un run-tests que llama a run!; y 6) run-tests.lisp, que cl-project no genera y el comando de pruebas del módulo exige. Los dos READMEs de la plantilla los sustituye el README del módulo, y el código de salida del runner y el guardia del depurador son deuda del runner compartido (afectan también a naive_sort y numbers).

EN: Tool (R1): cl-project:make-project through ros + quicklisp, from the phase folder; it is the community generator and it replaced quickproject on 2026-09-29, because the latter left the project flat. It requires a pathname, so a plain string will not do: #p"{module}" is not optional. It leaves {module}/ with {module}.asd, src/main.lisp, tests/main.lisp, README.org, README.markdown and .gitignore. To homologate the scaffolding six corrections must be applied —measured on 2026-09-29 when common-lisp/core/algorithms/data_structures_basics/ was homologated, kept as the reference—: 1) name the files after the module and with hyphens ({module}.asd, src/{module}.lisp, tests/{module}-test.lisp), because main is the template name and underscores are not the Lisp convention; 2) the .asd with defsystem/test-op and uiop:symbol-call; 3) the package with hyphens; 4) the test system over fiveam, like numbers.asd and naive-sort.asd, and not over rove, which is not installed here; 5) the test package {module}/tests with :export #:run-tests and a run-tests calling run!; and 6) run-tests.lisp, which cl-project does not generate and the module's test command requires. The template's two READMEs are replaced by the module's README, and the runner's exit code and debugger guard are debt of the shared runner (they also affect naive_sort and numbers).
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

ES: Herramienta (R1): julia -e 'using Pkg; Pkg.generate("{module}")', desde la carpeta de la fase (Pkg.generate(".") falla). Lo que sigue es la estructura homologada actual; el generador crea src/{module}.jl en minúscula, así que el módulo se actualizará al retomarlo (R6). A completar: uuid, [compat], [extras] y [targets] en el Project.toml, y el runner test/run_tests.jl.

EN: Tool (R1): julia -e 'using Pkg; Pkg.generate("{module}")', from the phase folder (Pkg.generate(".") fails). What follows is the current homologated structure; the generator creates lowercase src/{module}.jl, so the module will be updated when retaken (R6). To complete: uuid, [compat], [extras] and [targets] in Project.toml, plus the test/run_tests.jl runner.
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

### Perl — src/ + test/

ES: Herramienta (R1): module-starter --module={module} --dir=. (necesita Module::Starter y su PERL5LIB). El generador usa el layout de distribución (lib/, t/, xt/, Makefile.PL, MANIFEST), así que el runner pasa a prove -l t/ y el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura homologada actual.

EN: Tool (R1): module-starter --module={module} --dir=. (needs Module::Starter and its PERL5LIB). The generator uses the distribution layout (lib/, t/, xt/, Makefile.PL, MANIFEST), so the runner moves to prove -l t/ and the module will be updated when retaken (R6); what follows is the current homologated structure.
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.pl
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

### Python — src-layout (PEP 621)

ES: Herramienta (R1): uv init --lib . (en el sitio; crea también un .git que hay que borrar). El generador usa un paquete src/{module}/ con py.typed y backend uv_build, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura homologada actual. A completar: conftest.py, tests/ y la configuración de pytest.

EN: Tool (R1): uv init --lib . (in place; it also creates a .git that must be deleted). The generator uses a package src/{module}/ with py.typed and the uv_build backend, so the module will be updated when retaken (R6); what follows is the current homologated structure. To complete: conftest.py, tests/ and the pytest configuration.
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

ES: El módulo es un paquete de R: DESCRIPTION (nombre, versión, licencia y dependencias), NAMESPACE (lo que se exporta), el código en R/ y las suites en tests/testthat/, con el prefijo test- que testthat descubre por defecto. El runner es make test, que llama a testthat::test_local() —carga el paquete con pkgload::load_all(), sin instalarlo— y el "verificador" analiza los fuentes de R/ con parse().

EN: The module is an R package: DESCRIPTION (name, version, license and dependencies), NAMESPACE (what is exported), the code in R/ and the suites in tests/testthat/, with the test- prefix testthat discovers by default. The runner is make test, which calls testthat::test_local() —it loads the package with pkgload::load_all(), without installing it— and the "verifier" analyses the sources under R/ with parse().
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

ES: Herramienta (R1): raco new library {module} —de raco-new, que clona las plantillas de github.com/racket-templates—, desde la carpeta de la fase: el clon deja el proyecto ya con el nombre del módulo. Da el layout lib/test/doc de la comunidad ({module}/ metapaquete, {module}-lib/ con el código, {module}-test/ con las suites y {module}-doc/ con los scribblings) más Makefile, .gitignore y los documentos del template. La secuencia de new cierra las tres adecuaciones que el template no resuelve aquí: 1) su render-template.sh es interactivo y usa sed -i '' (BSD), que en Linux falla con can't read s/<project>/… y deja los marcadores <project> y <username> en los cuatro info.rkt, así que el render se hace con mv y sed -i de GNU, que además renombra el código a {module}.rkt con guiones —la convención de nombres de Racket—; 2) se borran .github/, pull_request_template.md, render-template.sh y profile/, que son del generador; y 3) las suites requieren la librería por ruta relativa ((require "../../{module}-lib/{module}.rkt"), con guiones), no por el nombre de la colección, para que corran sin instalar ni enlazar nada. El runner es raco test -x .: prueba los archivos con submodule test y no requiere los demás, así que no necesita el raco pkg install --link del Makefile del template, sale limpio y devuelve código 1 cuando algún caso falla.

EN: Tool (R1): raco new library {module} —from raco-new, which clones the templates in github.com/racket-templates—, from the phase folder: the clone leaves the project already named after the module. It gives the community's lib/test/doc layout ({module}/ metapackage, {module}-lib/ with the code, {module}-test/ with the suites and {module}-doc/ with the scribblings) plus Makefile, .gitignore and the template's documents. new's sequence closes the three adaptations the template does not solve here: 1) its render-template.sh is interactive and uses BSD sed -i '', which fails on Linux with can't read s/<project>/… and leaves the <project> and <username> placeholders in the four info.rkt files, so the render is done with mv and GNU sed -i, which also renames the code to {module}.rkt with dashes —Racket's naming convention—; 2) .github/, pull_request_template.md, render-template.sh and profile/ are removed, as they belong to the generator; and 3) the suites require the library by relative path ((require "../../{module}-lib/{module}.rkt"), with dashes), not by collection name, so they run without installing or linking anything. The runner is raco test -x .: it tests the files with a test submodule and does not require the others, so it needs neither the template Makefile's raco pkg install --link nor pollutes the output, and it returns exit code 1 when any case fails.
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
```bash
mkdir -p lib t
```

```text
{module}/
├── lib/{Module}.rakumod
└── t/                       # suites .rakutest por enfoque
```

### Rexx — src/ + test/
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
bundle install --local        # resuelve con las gemas instaladas; sin red
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

### Scheme — src/ + test/
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

### Tcl — src/ + test/
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.tcl         # namespace + package provide
├── src/pkgIndex.tcl         # permite package require
└── test/                    # suites .test con Tcltest
```

ES: Las suites cargan el paquete con TCLLIBPATH, no con una ruta relativa:

EN: Suites load the package through TCLLIBPATH, not a relative path:
```bash
cd test
TCLLIBPATH="$(cd ../src && pwd)" tclsh9.0 recursive.test
```

### Vala — src/ + test/

ES: Herramienta (R1): meson init --language vala --type library --name {module} (R4: meson es el build más usado del ecosistema). El generador deja meson.build y las fuentes en la raíz, así que el módulo se actualizará al retomarlo (R6); lo de abajo es la estructura homologada actual. A completar: src/ y test/.

EN: Tool (R1): meson init --language vala --type library --name {module} (R4: meson is the ecosystem's most used build). The generator leaves meson.build and the sources at the root, so the module will be updated when retaken (R6); what follows is the current homologated structure. To complete: src/ and test/.
```bash
mkdir -p src test
```

```text
{module}/
├── src/{module}.vala
└── test/                    # una suite .vala por enfoque (GLib.Test)
```

### V — módulo V

ES: Herramienta (R1): v init --lib, **no interactivo** (no pregunta). Crea {module}.v en la raíz, tests/, .editorconfig, .gitattributes, un .git anidado que hay que quitar y v.mod con version: '0.0.0', que se sube a '0.1.0'; el módulo se actualizará al retomarlo (R6) y lo de abajo es la estructura homologada actual.

EN: Tool (R1): v init --lib, **non-interactive** (it asks nothing). It creates {module}.v at the root, tests/, .editorconfig, .gitattributes, a nested .git that must be removed and v.mod with version: '0.0.0', which is raised to '0.1.0'; the module will be updated when retaken (R6) and what follows is the current homologated structure.
```bash
mkdir -p src test
v init                        # genera v.mod (no interactivo)
```

```text
{module}/
├── v.mod
├── src/{module}.v
└── test/                    # archivos _test.v con funciones test_*
```

### Manifiestos que mkdir no crea / Manifests mkdir does not create

ES: Cuando el lenguaje exige un manifiesto mínimo, escríbelo a mano después del mkdir -p: Project.toml en Julia, v.mod en V, {module}.nimble en Nim, {module}.rockspec en Lua, pom.xml en Java, build.gradle(.kts) en Groovy y Kotlin.

EN: When the language requires a minimal manifest, write it by hand after mkdir -p: Project.toml in Julia, v.mod in V, {module}.nimble in Nim, {module}.rockspec in Lua, pom.xml in Java, build.gradle(.kts) in Groovy and Kotlin.
## 📁 Convenciones comunes / Common conventions

ES:

    Separar fuente y pruebas. src/ (o lib/, source/) para el código y test/ (o tests/, spec/, t/) para las suites. Ninguna suite vive junto al código de producción.

    Una suite por enfoque cuando el módulo tenga variantes (rec / acc / ite). El nombre del archivo refleja el enfoque: numbers_rec_test, numbers_ite_test, recursive_tests, iterative_tests.

    Un .gitignore por módulo que excluya los artefactos del lenguaje: bin/, obj/, target/, _build/, .dart_tool/, .spago/, build/, .zig-cache/, node_modules/, lib/bs/, etc.

    Sin main propio cuando el runner de tests lo genera: declarar main en un target de librería rompe el runner (caso real en D con dub test y en C# con dotnet test).

    Cerrar el módulo con su README.md generado desde README_Template.md, el registro en ROADMAP_UPDATE_CHECKLIST.md y la actualización de ROADMAP.md.

EN:

    Separate sources and tests. src/ (or lib/, source/) for code and test/ (or tests/, spec/, t/) for suites. No suite lives next to production code.

    One suite per approach when the module has variants (rec / acc / ite). The file name reflects the approach.

    One .gitignore per module excluding the language's artifacts: bin/, obj/, target/, _build/, .dart_tool/, .spago/, build/, .zig-cache/, node_modules/, lib/bs/, etc.

    No main of your own when the test runner generates one: declaring main in a library target breaks the runner (real cases: dub test in D and dotnet test in C#).

    Close the module with its README.md generated from README_Template.md, the record in ROADMAP_UPDATE_CHECKLIST.md, and the update of ROADMAP.md.

## 📝 Notas / Notes

    ES: Los comandos marcados ✅ provienen de los READMEs de este repositorio; si actualizas un módulo y cambia su comando de inicialización, actualiza también esta tabla.

    EN: Commands marked ✅ come from this repository's READMEs; if you update a module and its initialization command changes, update this table too.

    ES: Los comandos marcados 🔧 son la herramienta oficial del ecosistema, útil cuando se quiere empezar desde una plantilla en lugar de la estructura manual. Algunos generan carpetas extra que este repositorio no usa; se pueden borrar.

    EN: Commands marked 🔧 are the ecosystem's official tool, useful to start from a template instead of the manual structure. Some generate extra folders this repository does not use; they can be deleted.

    ES: Este documento no cubre la instalación de toolchains. Cada lenguaje la documenta en {lenguaje}/README.md y en los READMEs de sus módulos.

    EN: This document does not cover toolchain installation. Each language documents it in {language}/README.md and in its module READMEs.

    **ES:** Si además usas la **herramienta de apoyo** que incluye este repositorio (`glot`), ten en cuenta que solo **facilita** este trabajo: ejecuta estos mismos comandos por ti y confirma cada paso con su commit. La guía no depende de ella — sirve igual para desarrollar fuera de este entorno — y aprender el lenguaje nunca pasa por conocerla.

    **EN:** If you also use the repository's **support tool** (`glot`), note that it only **makes this work easier**: it runs these very commands for you and confirms each step with its commit. The guide does not depend on it — it works just as well for developing outside this environment — and learning the language never goes through knowing it.

*[← Volver a Core](README.md) · [↑ Inicio / Back to home](../index.md)*
