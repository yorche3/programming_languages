#!/usr/bin/env bash
# Harness de pruebas de glot — sin dependencias externas.
#
# Uso / Usage:
#   ./scripts/tests/glot_test.sh
#
# Ejecuta el glot.sh del repositorio (no una copia) y, cuando hace falta, desde
# un directorio temporal, para no depender de la ruta del clon.

set -euo pipefail

TESTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
GLOT_SH="$TESTS_DIR/../glot.sh"
REPO="$(cd -- "$TESTS_DIR/../.." && pwd -P)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf -- "$WORK_DIR"' EXIT

# La versión esperada se lee del script: una versión nueva no debería obligar a tocar
# el harness, que es justo lo que se olvida al abrirla.
LIVE_VERSION="$(sed -n 's/^GLOT_VERSION="\(.*\)"$/\1/p' "$GLOT_SH")"

# Estado aislado: ningún caso toca el estado real del usuario.
export GLOT_STATE_FILE="$WORK_DIR/state"

# El harness prueba **este** repositorio, así que no puede heredar el entorno del autor:
# con `GLOT_ROOT` apuntando a otro monorepo, o con `GLOT_STATE_DIR`/`GLOT_DATA_DIR` de un
# laboratorio (lo normal si se trabaja fuera de él), las comprobaciones mirarían el
# repositorio, el estado o el catálogo equivocados. Las variables se fijan por caso donde
# hacen falta (`glot_run_in`, `glot_run_state`, el `GLOT_DATA_DIR` inyectado…).
unset GLOT_ROOT
unset GLOT_TOOLCHAINS_FILE
unset GLOT_STATE_DIR
unset GLOT_DATA_DIR
unset GLOT_DELEGATE
unset GLOT_DELEGATE_COP
unset GLOT_DELEGATE_AGY
unset GLOT_DELEGATE_AIDER

passed=0
failed=0

out=""
err=""
rc_last=0

# --- utilidades --------------------------------------------------------------

fail_case() {
    failed=$((failed + 1))
    printf 'FAIL  %s\n' "$1"
    printf '      esperado / expected: %s\n' "$2"
    printf '      obtenido / actual:   %s\n' "$3"
}

assert_eq() { # descripción, esperado, obtenido
    if [[ "$2" == "$3" ]]; then
        passed=$((passed + 1))
    else
        fail_case "$1" "$2" "$3"
    fi
}

assert_contains() { # descripción, aguja, texto
    if [[ "$3" == *"$2"* ]]; then
        passed=$((passed + 1))
    else
        fail_case "$1" "(contiene / contains) $2" "$3"
    fi
}

# glot_run [args...] — ejecuta glot y captura stdout, stderr y código.
glot_run() {
    local rc=0
    out="$("$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_stdin <entrada> [args...] — igual, alimentando stdin (interpreta
# escapes como \n o \r\n, para reproducir entradas CRLF y LF).
glot_run_stdin() {
    local input="$1"
    shift
    local rc=0
    out="$(printf '%b' "$input" | "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_in <directorio> [args...] — ejecuta glot desde otro directorio y sin
# GLOT_ROOT, para comprobar la resolución de la raíz.
glot_run_in() {
    local dir="$1"
    shift
    local rc=0
    out="$(cd -- "$dir" && env -u GLOT_ROOT "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# --- casos de la especificación v0.3.0 ---------------------------------------

# version
glot_run version
assert_eq 'version: salida' "glot $LIVE_VERSION" "$out"
assert_eq 'version: código' '0' "$rc_last"
assert_eq 'version: stdout con una sola línea' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"

# --version
glot_run --version
assert_eq '--version: salida' "glot $LIVE_VERSION" "$out"
assert_eq '--version: código' '0' "$rc_last"

# help general y por verbo
glot_run help
assert_contains 'help: lista greet' 'greet' "$out"
assert_contains 'help: lista doctor' 'doctor' "$out"
assert_eq 'help: código' '0' "$rc_last"

glot_run help greet
assert_contains 'help greet: menciona el verbo' 'greet' "$out"
assert_eq 'help greet: código' '0' "$rc_last"

glot_run
assert_contains 'sin argumentos: muestra la ayuda' 'Uso / Usage' "$out"
assert_eq 'sin argumentos: código' '0' "$rc_last"

# verbo desconocido
glot_run nope
assert_eq 'verbo desconocido: código' '2' "$rc_last"
assert_eq 'verbo desconocido: stdout vacío' '' "$out"
assert_contains 'verbo desconocido: mensaje en stderr' 'unknown verb' "$err"
assert_contains 'verbo desconocido: pista general' 'glot help' "$err"

# v1.1.0: un encargo es un verbo a medias; `glot suite` no existe, pero se sugiere el verbo
# que lo arma en vez de dejarlo en la pista general
glot_run suite
assert_eq 'verbo de encargo: código' '2' "$rc_last"
assert_eq 'verbo de encargo: stdout vacío' '' "$out"
assert_contains 'verbo de encargo: mensaje en stderr' 'unknown verb: suite' "$err"
assert_contains 'verbo de encargo: sugiere glot prompt' 'glot prompt suite' "$err"
assert_eq 'verbo de encargo: sin pista general' 'no' "$([[ "$err" == *'glot help'* ]] && echo si || echo no)"

glot_run ../etc/passwd
assert_eq 'verbo con ruta: código' '2' "$rc_last"
assert_eq 'verbo con ruta: no sugiere un encargo' 'no' "$([[ "$err" == *'glot prompt'* ]] && echo si || echo no)"

# opción desconocida
glot_run --nope
assert_eq 'opción desconocida: código' '2' "$rc_last"
assert_eq 'opción desconocida: stdout vacío' '' "$out"

# greet
glot_run greet Ada
assert_eq 'greet argumento: salida' 'Hello, Ada!' "$out"
assert_eq 'greet argumento: código' '0' "$rc_last"

glot_run greet 'Grace Hopper'
assert_eq 'greet con espacios: salida' 'Hello, Grace Hopper!' "$out"

glot_run_stdin 'Ada\n' greet
assert_eq 'greet stdin: salida' 'Hello, Ada!' "$out"
assert_eq 'greet stdin: código' '0' "$rc_last"

glot_run_stdin 'Grace Hopper\r\n' greet
assert_eq 'greet stdin CRLF: salida' 'Hello, Grace Hopper!' "$out"

glot_run_stdin '' greet
assert_eq 'greet sin nombre: código' '2' "$rc_last"
assert_eq 'greet sin nombre: stdout vacío' '' "$out"

# `hello` se retiró en la v0.10.0: el alias de compatibilidad de la v0.2.0 ya no existe
# y el aviso de verbo desconocido ya no ofrece el saludo

glot_run hello Ada
assert_eq 'hello retirado: código' '2' "$rc_last"
assert_eq 'hello retirado: sin saludo' '' "$out"
assert_contains 'hello retirado: error' 'unknown verb: hello' "$err"
assert_contains 'hello retirado: sugiere la ayuda' 'glot help' "$err"
assert_eq 'hello retirado: sin sugerencia de greet' '0' "$(printf '%s\n' "$err" | grep -c 'greet' || true)"

# un nombre suelto ya no es un nombre: falla rápido y sugiere la ayuda
glot_run Ada
assert_eq 'nombre suelto: código' '2' "$rc_last"
assert_eq 'nombre suelto: stdout vacío' '' "$out"
assert_contains 'nombre suelto: sugiere la ayuda' 'glot help' "$err"

# doctor dentro del monorepo
glot_run doctor
assert_eq 'doctor dentro: código' '0' "$rc_last"
assert_contains 'doctor dentro: versión' "version: $LIVE_VERSION" "$out"
assert_contains 'doctor dentro: script_dir' 'script_dir:' "$out"
assert_contains 'doctor dentro: raíz detectada' 'root: /' "$out"
assert_contains 'doctor dentro: ruta del estado' 'state_file:' "$out"

# doctor con -q silencia el encabezado de stderr
glot_run -q doctor
assert_eq 'doctor -q: código' '0' "$rc_last"
assert_eq 'doctor -q: stderr vacío' '' "$err"

# doctor fuera del monorepo
glot_run_in "$WORK_DIR" doctor
assert_eq 'doctor fuera: código' '1' "$rc_last"
assert_contains 'doctor fuera: raíz no detectada' 'no detectado' "$out"

# --- almacén de estado (v0.4.0) ----------------------------------------------

# path
glot_run path
assert_eq 'path: código' '0' "$rc_last"
assert_eq 'path: ruta del estado aislado' "$GLOT_STATE_FILE" "$out"

# set + get
glot_run set lang php
assert_eq 'set: código' '0' "$rc_last"
assert_eq 'set: stdout vacío (el aviso va a stderr)' '' "$out"
glot_run get lang
assert_eq 'get: salida' 'php' "$out"
assert_eq 'get: código' '0' "$rc_last"

# get de clave inexistente
glot_run get nope
assert_eq 'get inexistente: código' '1' "$rc_last"
assert_eq 'get inexistente: stdout vacío' '' "$out"
assert_contains 'get inexistente: mensaje' 'key not found' "$err"

# valores con espacios, con '=' y vacío
glot_run set nota 'hola mundo'
glot_run get nota
assert_eq 'valor con espacios' 'hola mundo' "$out"
glot_run set kv 'a=b'
glot_run get kv
assert_eq 'valor con igual' 'a=b' "$out"
glot_run set vacio ''
assert_eq 'valor vacío: código' '0' "$rc_last"
glot_run get vacio
assert_eq 'valor vacío: código al leer' '0' "$rc_last"
assert_eq 'valor vacío: salida vacía' '' "$out"

# validaciones
glot_run set 'clave mala' v
assert_eq 'clave inválida: código' '2' "$rc_last"
assert_eq 'clave inválida: stdout vacío' '' "$out"
glot_run set k $'a\nb'
assert_eq 'valor con salto de línea: código' '2' "$rc_last"
assert_eq 'valor con salto de línea: stdout vacío' '' "$out"
glot_run set solo-una-clave
assert_eq 'set sin valor: código' '2' "$rc_last"

# list ordenado por clave
glot_run list
assert_eq 'list: orden por clave' "$(printf '%s\n' 'kv=a=b' 'lang=php' 'nota=hola mundo' 'vacio=')" "$out"

# dry-run no escribe
glot_run -n set otro x
assert_eq 'dry-run: plan en stdout' 'otro=x' "$out"
assert_eq 'dry-run: código' '0' "$rc_last"
glot_run get otro
assert_eq 'dry-run: no se escribió' '1' "$rc_last"

# unset idempotente
glot_run unset lang
assert_eq 'unset: código' '0' "$rc_last"
glot_run get lang
assert_eq 'unset: la clave ya no está' '1' "$rc_last"
glot_run unset lang
assert_eq 'unset repetido: código' '0' "$rc_last"

# concurrencia: dos escrituras en paralelo con flock
("$GLOT_SH" set c1 uno >/dev/null 2>&1) &
("$GLOT_SH" set c2 dos >/dev/null 2>&1) &
wait || true
glot_run list
assert_contains 'concurrencia: c1 presente' 'c1=uno' "$out"
assert_contains 'concurrencia: c2 presente' 'c2=dos' "$out"

# permisos del estado y de su directorio
assert_eq 'permisos del archivo' '600' "$(stat -c '%a' "$GLOT_STATE_FILE")"
assert_eq 'permisos del directorio' '700' "$(stat -c '%a' "$(dirname -- "$GLOT_STATE_FILE")")"

# doctor refleja el estado
glot_run doctor
assert_contains 'doctor: ruta del estado aislado' "state_file: $GLOT_STATE_FILE" "$out"
assert_contains 'doctor: estado legible' 'state_file_ok: yes' "$out"

# --- asignación `use` (v0.5.0) ----------------------------------------------

SANDBOX="$WORK_DIR/sandbox"

# sandbox_make — monorepo de mentira: .gitmodules, especificación y un submódulo
# `php` con su propio repo y un remoto desnudo, para que `use` prepare y publique
# la rama sin salir de $WORK_DIR ni tocar la red.
sandbox_make() {
    rm -rf -- "$SANDBOX"
    mkdir -p -- "$SANDBOX/docs/core/algorithms" "$SANDBOX/docs/core/foundations" "$SANDBOX/remote"
    printf '# 05 — Naive Sort\n' >"$SANDBOX/docs/core/algorithms/05_Naive_Sort.md"
    # el módulo 06 se partió en dos: el sandbox declara el actual, que es el que usan los casos
    printf '# 06 — Data Structures Basics\n' >"$SANDBOX/docs/core/algorithms/06_Data_Structures_Basics.md"
    printf '# 10 — Searching\n' >"$SANDBOX/docs/core/algorithms/10_Searching.md"
    # Fase con nombres divergentes: el id del roadmap no es el de la carpeta ni el
    # del documento, que es justo lo que el conversor tiene que resolver.
    printf '# 01 — Hello World\n' >"$SANDBOX/docs/core/foundations/01_Hello_World.md"
    printf '# 03 — Unit Test Calculator\n' >"$SANDBOX/docs/core/foundations/03_Unit_Test_Calculator.md"

    cat >"$SANDBOX/.gitmodules" <<'EOF'
[submodule "php"]
	path = php
	url = ../remote/php.git
[submodule "ruby"]
        path = ruby
        url = ../remote/ruby.git
[submodule "rescript"]
        path = rescript
        url = ../remote/rescript.git
[submodule "python"]
        path = python
        url = ../remote/python.git
[submodule "java"]
        path = java
        url = ../remote/java.git
[submodule "javascript"]
        path = javascript
        url = ../remote/javascript.git
[submodule "typescript"]
        path = typescript
        url = ../remote/typescript.git
[submodule "julia"]
        path = julia
        url = ../remote/julia.git
[submodule "assembly"]
        path = assembly
        url = ../remote/assembly.git
[submodule "c"]
        path = c
        url = ../remote/c.git
[submodule "cobol"]
        path = cobol
        url = ../remote/cobol.git
[submodule "grain"]
        path = grain
        url = ../remote/grain.git
[submodule "r"]
        path = r
        url = ../remote/r.git
[submodule "ballerina"]
        path = ballerina
        url = ../remote/ballerina.git
[submodule "perl"]
        path = perl
        url = ../remote/perl.git
[submodule "prolog"]
        path = prolog
        url = ../remote/prolog.git
[submodule "raku"]
        path = raku
        url = ../remote/raku.git
[submodule "rexx"]
        path = rexx
        url = ../remote/rexx.git
[submodule "scheme"]
        path = scheme
        url = ../remote/scheme.git
[submodule "scala"]
        path = scala
        url = ../remote/scala.git
[submodule "elm"]
        path = elm
        url = ../remote/elm.git
[submodule "vala"]
        path = vala
        url = ../remote/vala.git
[submodule "swift"]
        path = swift
        url = ../remote/swift.git
[submodule "tcl-tk"]
        path = tcl-tk
        url = ../remote/tcl-tk.git
[submodule "rust"]
        path = rust
        url = ../remote/rust.git
[submodule "cpp"]
        path = cpp
        url = ../remote/cpp.git
[submodule "crystal"]
        path = crystal
        url = ../remote/crystal.git
[submodule "csharp"]
        path = csharp
        url = ../remote/csharp.git
[submodule "d"]
        path = d
        url = ../remote/d.git
[submodule "forth"]
        path = forth
        url = ../remote/forth.git
[submodule "purescript"]
        path = purescript
        url = ../remote/purescript.git
[submodule "fsharp"]
        path = fsharp
        url = ../remote/fsharp.git
[submodule "go"]
        path = go
        url = ../remote/go.git
[submodule "haskell"]
        path = haskell
        url = ../remote/haskell.git
[submodule "groovy"]
        path = groovy
        url = ../remote/groovy.git
[submodule "kotlin"]
        path = kotlin
        url = ../remote/kotlin.git
[submodule "nim"]
        path = nim
        url = ../remote/nim.git
[submodule "haxe"]
        path = haxe
        url = ../remote/haxe.git
[submodule "v"]
        path = v
        url = ../remote/v.git
EOF
    cp -- "$SANDBOX/.gitmodules" "$WORK_DIR/gitmodules.base"
    git -C "$SANDBOX" init -q
    mkdir -p -- "$SANDBOX/assembly/core/algorithms" "$SANDBOX/c/core/algorithms" \
        "$SANDBOX/cobol/core/algorithms" "$SANDBOX/grain/core/algorithms" \
        "$SANDBOX/r/core/algorithms" "$SANDBOX/haxe/core/algorithms" \
        "$SANDBOX/scripts/data"
    cp -R -- "$TESTS_DIR/../data/scaffold_templates" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/gradle_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/haskell_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/haskell_sync.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/haskell_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/gradle_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/nim_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/nim_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/v_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/ballerina_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/rexx_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/swift_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/purescript_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/typescript_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/csharp_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/common_lisp_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/cpp_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/go_test_runner.go" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/elixir_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/elixir_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/elixir_test_runner.exs" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/erlang_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/erlang_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/gleam_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/gleam_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/crystal_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/ocaml_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/ocaml_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/vala_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/vala_test.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/rust_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/rust_test.sh" "$SANDBOX/scripts/data/"
    cp -R -- "$TESTS_DIR/../data/scaffold_templates/vala.source.vala" \
        "$SANDBOX/scripts/data/scaffold_templates/vala.source.vala"
    cp -R -- "$TESTS_DIR/../data/scaffold_templates/vala.test.vala" \
        "$SANDBOX/scripts/data/scaffold_templates/vala.test.vala"
    cp -R -- "$TESTS_DIR/../data/scaffold_templates/vala.meson.build" \
        "$SANDBOX/scripts/data/scaffold_templates/vala.meson.build"
    cp -R -- "$TESTS_DIR/../data/scaffold_templates/vala.sentinel.vala" \
        "$SANDBOX/scripts/data/scaffold_templates/vala.sentinel.vala"
    cp -- "$TESTS_DIR/../data/haxe_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/java_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/javascript_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/julia_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/php_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/ruby_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/rescript_scaffold.sh" "$SANDBOX/scripts/data/"
    cp -- "$TESTS_DIR/../data/typescript_scaffold.sh" "$SANDBOX/scripts/data/"
    git init -q --bare "$SANDBOX/remote/php.git"
    git -C "$SANDBOX/remote/php.git" symbolic-ref HEAD refs/heads/main

    mkdir -p -- "$SANDBOX/php/core/algorithms" "$SANDBOX/php/core/foundations/unit_test/calculator"
    git -C "$SANDBOX/php" init -q -b main
    git -C "$SANDBOX/php" config user.email 'glot@test'
    git -C "$SANDBOX/php" config user.name 'glot test'
    printf '# php\n' >"$SANDBOX/php/README.md"
    printf '# algorithms\n' >"$SANDBOX/php/core/algorithms/README.md"
    printf '# foundations\n' >"$SANDBOX/php/core/foundations/README.md"
    printf '# calculator\n' >"$SANDBOX/php/core/foundations/unit_test/calculator/README.md"
    git -C "$SANDBOX/php" add -A
    git -C "$SANDBOX/php" commit -q -m 'chore: base'
    git -C "$SANDBOX/php" remote add origin "$SANDBOX/remote/php.git"
    git -C "$SANDBOX/php" push -q -u origin main

    # `new` necesita más de un tipo de inicialización: `ruby` tiene secuencia
    # (mkdir + Bundler) y `java` es manual (crea carpetas, sin red).
    local extra=""
    for extra in ruby python java rescript javascript typescript julia; do
        mkdir -p -- "$SANDBOX/$extra/core/algorithms"
        if [[ "$extra" == julia ]]; then
            cp -- "$REPO/julia/.gitignore" "$SANDBOX/$extra/.gitignore"
        fi
        git init -q --bare "$SANDBOX/remote/$extra.git"
        git -C "$SANDBOX/remote/$extra.git" symbolic-ref HEAD refs/heads/main
        git -C "$SANDBOX/$extra" init -q -b main
        git -C "$SANDBOX/$extra" config user.email 'glot@test'
        git -C "$SANDBOX/$extra" config user.name 'glot test'
        printf '# %s\n' "$extra" >"$SANDBOX/$extra/README.md"
        printf '# algorithms\n' >"$SANDBOX/$extra/core/algorithms/README.md"
        git -C "$SANDBOX/$extra" add -A
        git -C "$SANDBOX/$extra" commit -q -m 'chore: base'
        git -C "$SANDBOX/$extra" remote add origin "$SANDBOX/remote/$extra.git"
        git -C "$SANDBOX/$extra" push -q -u origin main
    done
}

# glot_run_sandbox [args...] — ejecuta glot con GLOT_ROOT apuntando al sandbox.
glot_run_sandbox() {
    local rc=0
    out="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_from <directorio> [args...] — igual, pero desde otro directorio.
glot_run_from() {
    local dir="$1"
    shift
    local rc=0
    out="$(cd -- "$dir" && GLOT_ROOT="$SANDBOX" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_no_home [args...] — ejecuta glot sin HOME, sin XDG_STATE_HOME, sin
# GLOT_STATE_FILE y sin GLOT_STATE_DIR, para comprobar que el estado falla con un
# mensaje propio aunque la sesión tenga las variables exportadas.
glot_run_no_home() {
    local rc=0
    out="$(cd -- "$WORK_DIR" && env -u HOME -u XDG_STATE_HOME -u GLOT_STATE_FILE -u GLOT_STATE_DIR -u GLOT_ROOT \
        "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_nodelegate [args...] — ejecuta glot sin ningún delegado, para que el caso no
# dependa de lo que tenga exportado la sesión (las cuatro variables: los tres nombres y el
# alias antiguo).
glot_run_nodelegate() {
    local rc=0
    out="$(env -u GLOT_DELEGATE -u GLOT_DELEGATE_COP -u GLOT_DELEGATE_AGY -u GLOT_DELEGATE_AIDER \
        "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_delegates <cop> <agy> [args...] — ejecuta glot fijando los dos delegados del
# caso (cadena vacía = sin definir), para probar la elección y la expansión de marcadores
# sin salir del directorio temporal.
glot_run_delegates() {
    local cop="$1"
    local agy="$2"
    shift 2
    local -a env_args=(-u GLOT_DELEGATE -u GLOT_DELEGATE_COP -u GLOT_DELEGATE_AGY -u GLOT_DELEGATE_AIDER)
    local rc=0
    [[ -n "$cop" ]] && env_args+=(GLOT_DELEGATE_COP="$cop")
    [[ -n "$agy" ]] && env_args+=(GLOT_DELEGATE_AGY="$agy")
    out="$(env "${env_args[@]}" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_run_delegate <orden> [args...] — ejecuta glot con GLOT_DELEGATE apuntando a esa
# orden, para verificar la estrategia de envío sin salir del directorio temporal.
glot_run_delegate() {
    local delegate="$1"
    shift
    local rc=0
    out="$(GLOT_DELEGATE="$delegate" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

sandbox_make

sandbox_restore_gitmodules() {
    cp -- "$WORK_DIR/gitmodules.base" "$SANDBOX/.gitmodules"
}

# módulo nuevo: crea la rama desde main, la publica con -u y crea su carpeta
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use: código' '0' "$rc_last"
assert_eq 'use: carpeta de la fase en stdout' "$SANDBOX/php/core/algorithms" "$out"
assert_eq 'use: stdout con una sola línea' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'use: crea el directorio del módulo' 'si' "$([[ -d "$SANDBOX/php/core/algorithms/naive_sort" ]] && echo si || echo no)"
assert_eq 'use: no avisa de módulo existente' 'no' "$(case "$err" in *'no se genera esqueleto'*) echo si ;; *) echo no ;; esac)"
assert_eq 'use: activa la rama' 'feat/algorithms/naive-sort' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_eq 'use: la rama nace de main' "$(git -C "$SANDBOX/php" rev-parse main)" "$(git -C "$SANDBOX/php" rev-parse feat/algorithms/naive-sort)"
assert_eq 'use: rama publicada con upstream' 'feat/algorithms/naive-sort' "$(git -C "$SANDBOX/php" rev-parse --abbrev-ref --symbolic-full-name '@{u}' | sed 's|^origin/||')"
assert_eq 'use: la rama existe en el remoto' 'si' "$(git -C "$SANDBOX/remote/php.git" show-ref --verify --quiet refs/heads/feat/algorithms/naive-sort && echo si || echo no)"

glot_run get lang
assert_eq 'use: estado lang' 'php' "$out"
glot_run get phase
assert_eq 'use: estado phase' 'algorithms' "$out"
glot_run get module
assert_eq 'use: estado module' 'naive_sort' "$out"
glot_run get branch
assert_eq 'use: estado branch' 'feat/algorithms/naive-sort' "$out"
glot_run get spec
assert_eq 'use: estado spec' 'docs/core/algorithms/05_Naive_Sort.md' "$out"
glot_run get repo
assert_eq 'use: estado repo' 'php' "$out"

# módulo existente: avisa, no crea nada y republica la rama activa
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use repetido: código' '0' "$rc_last"
assert_eq 'use repetido: carpeta de la fase' "$SANDBOX/php/core/algorithms" "$out"
assert_contains 'use repetido: aviso de módulo existente' 'no se genera esqueleto' "$err"
assert_contains 'use repetido: aviso de que no hay esqueleto' 'no scaffolding' "$err"
assert_contains 'use repetido: rama ya activa' 'rama ya activa' "$err"
assert_contains 'use repetido: republica' 'published: origin/feat/algorithms/naive-sort' "$err"

# ensayo con módulo y rama existentes: avisa y publica en el plan, sin crear nada
glot_run_sandbox -n use php algorithms/naive_sort
assert_eq 'use -n con todo existente: código' '0' "$rc_last"
assert_contains 'use -n con todo existente: aviso de módulo' 'no se genera esqueleto' "$err"
assert_contains 'use -n con todo existente: plan de publicación' 'push -u origin feat/algorithms/naive-sort' "$out"
assert_eq 'use -n con todo existente: sin mkdir' 'no' "$(case "$out" in *'mkdir -p'*) echo si ;; *) echo no ;; esac)"
assert_eq 'use -n con todo existente: sin checkout' 'no' "$(case "$out" in *checkout*) echo si ;; *) echo no ;; esac)"

# ensayo con módulo y rama inexistentes: plan de creación completa y ningún efecto
git -C "$SANDBOX/php" switch -q main
git -C "$SANDBOX/php" branch -q -D feat/algorithms/naive-sort
rm -rf -- "$SANDBOX/php/core/algorithms/naive_sort"
glot_run unset branch
glot_run_sandbox -n use php algorithms/naive_sort
assert_eq 'use -n: código' '0' "$rc_last"
assert_contains 'use -n: plan de rama desde main' 'switch -c feat/algorithms/naive-sort main' "$out"
assert_contains 'use -n: plan de publicación' 'push -u origin feat/algorithms/naive-sort' "$out"
assert_contains 'use -n: plan de creación del directorio' 'mkdir -p '"$SANDBOX"'/php/core/algorithms/naive_sort' "$out"
assert_contains 'use -n: plan de estado' 'branch=feat/algorithms/naive-sort' "$out"
assert_eq 'use -n: no crea el directorio' 'no' "$([[ -e "$SANDBOX/php/core/algorithms/naive_sort" ]] && echo si || echo no)"
assert_eq 'use -n: no crea la rama' 'no' "$(git -C "$SANDBOX/php" show-ref --verify --quiet refs/heads/feat/algorithms/naive-sort && echo si || echo no)"
assert_eq 'use -n: sigue en main' 'main' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
glot_run get branch
assert_eq 'use -n: no escribe el estado' '1' "$rc_last"

# módulo nuevo con otro tipo: la rama nace de main con ese tipo
glot_run_sandbox use php algorithms/naive_sort docs
assert_eq 'use docs: código' '0' "$rc_last"
assert_eq 'use docs: activa la rama' 'docs/algorithms/naive-sort' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_eq 'use docs: la rama nace de main' "$(git -C "$SANDBOX/php" rev-parse main)" "$(git -C "$SANDBOX/php" rev-parse docs/algorithms/naive-sort)"

# módulo cerrado (limpio, sobre main) con tipo explícito: abre rama de mantenimiento
git -C "$SANDBOX/php" switch -q main
git -C "$SANDBOX/php" branch -q -D docs/algorithms/naive-sort
glot_run_sandbox use php algorithms/naive_sort docs
assert_eq 'use de módulo cerrado: código' '0' "$rc_last"
assert_contains 'use de módulo cerrado: avisa de la rama creada' 'rama creada desde main' "$err"
assert_eq 'use de módulo cerrado: activa la rama' 'docs/algorithms/naive-sort' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_eq 'use de módulo cerrado: la rama nace de main' "$(git -C "$SANDBOX/php" rev-parse main)" "$(git -C "$SANDBOX/php" rev-parse docs/algorithms/naive-sort)"
assert_eq 'use de módulo cerrado: publicada con upstream' 'docs/algorithms/naive-sort' "$(git -C "$SANDBOX/php" rev-parse --abbrev-ref --symbolic-full-name '@{u}' | sed 's|^origin/||')"
assert_eq 'use de módulo cerrado: la rama está en el remoto' 'si' "$(git -C "$SANDBOX/remote/php.git" show-ref --verify --quiet refs/heads/docs/algorithms/naive-sort && echo si || echo no)"

# módulo cerrado sin tipo: avisa y no crea nada (el feat por defecto es del módulo nuevo)
git -C "$SANDBOX/php" switch -q main
git -C "$SANDBOX/php" branch -q -D docs/algorithms/naive-sort
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use de módulo cerrado sin tipo: código' '0' "$rc_last"
assert_contains 'use de módulo cerrado sin tipo: avisa' 'ya está cerrado y no se indicó tipo' "$err"
assert_contains 'use de módulo cerrado sin tipo: sugiere el tipo' 'test|fix|refactor|docs|chore' "$err"
assert_eq 'use de módulo cerrado sin tipo: no crea la rama' 'no' "$(git -C "$SANDBOX/php" show-ref --verify --quiet refs/heads/feat/algorithms/naive-sort && echo si || echo no)"
assert_eq 'use de módulo cerrado sin tipo: sigue en main' 'main' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"

# árbol limpio y rama del módulo ya existente: la activa y la publica
git -C "$SANDBOX/php" branch -q feat/algorithms/naive-sort main
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use con rama existente: código' '0' "$rc_last"
assert_contains 'use con rama existente: informa de la activación' 'rama activada' "$err"
assert_eq 'use con rama existente: activa la rama' 'feat/algorithms/naive-sort' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_contains 'use con rama existente: publica' 'published: origin/feat/algorithms/naive-sort' "$err"

# módulo ausente pero con la rama ya creada: la activa en vez de recrearla
git -C "$SANDBOX/php" switch -q main
git -C "$SANDBOX/php" switch -q -C feat/algorithms/naive-sort main
rm -rf -- "$SANDBOX/php/core/algorithms/naive_sort"
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use con rama previa: código' '0' "$rc_last"
assert_contains 'use con rama previa: informa de rama activada' 'rama existente activada' "$err"
assert_eq 'use con rama previa: activa la rama existente' 'feat/algorithms/naive-sort' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_eq 'use con rama previa: crea el directorio' 'si' "$([[ -d "$SANDBOX/php/core/algorithms/naive_sort" ]] && echo si || echo no)"

# desde dentro del submódulo se puede omitir el lenguaje
glot_run_from "$SANDBOX/php" use algorithms/naive_sort fix
assert_eq 'use sin lenguaje dentro del submódulo: código' '0' "$rc_last"
glot_run get branch
assert_eq 'use sin lenguaje dentro del submódulo: rama esperada' 'fix/algorithms/naive-sort' "$out"

# trabajo sin confirmar dentro del módulo (reanudar): no crea ni cambia ramas
printf 'work in progress\n' > "$SANDBOX/php/core/algorithms/naive_sort/wip.txt"
git -C "$SANDBOX/php" switch -q main
glot_run_sandbox use php algorithms/naive_sort test
assert_eq 'use reanudando en main: código' '0' "$rc_last"
assert_contains 'use reanudando en main: avisa del trabajo sin confirmar' 'trabajo sin confirmar y la rama no existe' "$err"
assert_eq 'use reanudando en main: no crea la rama' 'no' "$(git -C "$SANDBOX/php" show-ref --verify --quiet refs/heads/test/algorithms/naive-sort && echo si || echo no)"
assert_eq 'use reanudando en main: sigue en main' 'main' "$(git -C "$SANDBOX/php" symbolic-ref --short HEAD)"
assert_eq 'use reanudando en main: conserva el trabajo' 'si' "$([[ -f "$SANDBOX/php/core/algorithms/naive_sort/wip.txt" ]] && echo si || echo no)"

# reanudar sobre la rama del módulo: se republica y el trabajo no se toca
git -C "$SANDBOX/php" switch -q feat/algorithms/naive-sort
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use reanudando en la rama: código' '0' "$rc_last"
assert_contains 'use reanudando en la rama: rama ya activa' 'rama ya activa' "$err"
assert_contains 'use reanudando en la rama: republica' 'published: origin/feat/algorithms/naive-sort' "$err"
assert_eq 'use reanudando en la rama: conserva el trabajo' 'si' "$([[ -f "$SANDBOX/php/core/algorithms/naive_sort/wip.txt" ]] && echo si || echo no)"
assert_eq 'use reanudando en la rama: el árbol sigue sucio' 'si' "$([[ -n "$(git -C "$SANDBOX/php" status --porcelain)" ]] && echo si || echo no)"

# el trabajo del módulo no cuenta como suciedad ajena, pero el de fuera sí
printf 'x\n' > "$SANDBOX/php/otro.txt"
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use con cambios fuera del módulo: código' '1' "$rc_last"
assert_contains 'use con cambios fuera del módulo: avisa' 'fuera del módulo' "$err"
rm -f -- "$SANDBOX/php/otro.txt"

# errores de uso
glot_run_sandbox use
assert_eq 'use sin argumentos: código' '2' "$rc_last"
glot_run_sandbox use php
assert_eq 'use con un solo argumento: código' '2' "$rc_last"
glot_run_sandbox use php algorithms/naive_sort malo
assert_eq 'use con tipo no permitido: código' '2' "$rc_last"
assert_contains 'use con tipo no permitido: error' 'tipo no permitido' "$err"
glot_run_sandbox use php algorithms/naive_sort feat extra
assert_eq 'use con demasiados argumentos: código' '2' "$rc_last"
glot_run_sandbox use php algorithms/naive_sort --force
assert_eq 'use con opción desconocida: código' '2' "$rc_last"

# errores de entorno o de datos
glot_run_sandbox use nope algorithms/naive_sort
assert_eq 'use con lenguaje desconocido: código' '1' "$rc_last"
assert_contains 'use con lenguaje desconocido: error' 'no registrado en .gitmodules' "$err"
glot_run_sandbox use php algorithms/nope
assert_eq 'use con módulo sin especificación: código' '1' "$rc_last"
assert_contains 'use con módulo sin especificación: error' 'especificación ausente' "$err"
glot_run_sandbox use php nope/naive_sort
assert_eq 'use con fase inexistente: código' '1' "$rc_last"
assert_contains 'use con fase inexistente: error' 'fase inexistente' "$err"

# árbol sucio: un cambio ajeno al directorio del módulo lo bloquea
git -C "$SANDBOX/php" checkout -q main
printf 'x\n' >>"$SANDBOX/php/README.md"
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use con árbol sucio: código' '1' "$rc_last"
assert_contains 'use con árbol sucio: error' 'sin confirmar' "$err"
git -C "$SANDBOX/php" checkout -q -- .

# la ruta del módulo existe pero no es un directorio
rm -rf -- "$SANDBOX/php/core/algorithms/naive_sort"
printf 'choque\n' >"$SANDBOX/php/core/algorithms/naive_sort"
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use con la ruta ocupada por un archivo: código' '1' "$rc_last"
assert_contains 'use con la ruta ocupada por un archivo: error' 'no es un directorio' "$err"
rm -f -- "$SANDBOX/php/core/algorithms/naive_sort"

# --- casos de la especificación v0.6.0 (L2.5, catálogo) ----------------------

registered="$(git config --file "$REPO/.gitmodules" --get-regexp '\.path$' | wc -l | tr -d ' ')"
roadmap_core="$(grep -cE '^core\.[a-z_]+\.[a-z_0-9]+[[:space:]]' "$REPO/docs/ROADMAP.md" | tr -d ' ')"

# langs: un lenguaje por línea, con su comando nativo de pruebas
glot_run langs
assert_eq 'langs: código' '0' "$rc_last"
assert_eq 'langs: un registro por lenguaje registrado' "$registered" "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'langs: dos columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=2')"
assert_eq 'langs: ninguno sin comando de pruebas' '' "$(printf '%s\n' "$out" | awk -F'\t' '$2=="" || $2=="-"')"
assert_eq 'langs: ordenado' "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort)" "$(printf '%s\n' "$out" | cut -f1)"

# modules: el catálogo del roadmap, con la especificación resuelta
glot_run modules
assert_eq 'modules: código' '0' "$rc_last"
assert_eq 'modules: un registro por módulo del roadmap' "$roadmap_core" "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'modules: cuatro columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=4')"
assert_eq 'modules: identificadores del roadmap' '' "$(printf '%s\n' "$out" | awk -F'\t' '$1!="core."$2"."$3')"
assert_eq 'modules: las especificaciones que declara existen' '' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$4!="-"' | while IFS=$'\t' read -r _id _phase _module spec; do
        [[ -f "$REPO/$spec" ]] || printf '%s\n' "$spec"
    done)"

glot_run modules foundations
assert_eq 'modules foundations: cuatro módulos' '4' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_contains 'modules foundations: incluye unit_test' 'core.foundations.unit_test' "$out"
assert_contains 'modules foundations: documento divergente resuelto' 'docs/core/foundations/03_Unit_Test_Calculator.md' "$out"

glot_run modules nope
assert_eq 'modules con fase inexistente: código' '1' "$rc_last"
assert_contains 'modules con fase inexistente: error' 'fase sin módulos' "$err"

# v1.6.3: `glot models` publica el catálogo tal cual (una fila por perfil). Es el dato del que
# se alimenta el autocompletado de la clave `model`, que es la del delegado de **AGY**: por eso
# se comprueba que el campo 7 está y que es el catálogo, no una lista copiada en el completado.
glot_run models
assert_eq 'models: código' '0' "$rc_last"
assert_eq 'models: el catálogo tal cual' \
    "$(awk 'NF && $1 !~ /^#/' "$TESTS_DIR/../data/models.tsv")" "$out"
assert_eq 'models: siete columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=7')"
assert_eq 'models: deep AGY sin modelo disponible no inventa uno' '-' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$1=="deep" {print $7}')"
assert_eq 'models: ningún encargo en dos perfiles' '0' \
    "$(printf '%s\n' "$out" | cut -f6 | tr ',' '\n' | sed 's/^ *//' | grep -v '^$' | LC_ALL=C sort | uniq -d | wc -l | tr -d ' ')"

glot_run models extra
assert_eq 'models con argumentos: código' '2' "$rc_last"

glot_run help models
assert_eq 'help models: código' '0' "$rc_last"
assert_contains 'help models: las siete columnas' 'perfil<TAB>modelo Copilot' "$out"
assert_contains 'help models: dónde encaja la clave' 'glot delegates' "$out"

# v1.7.0: `glot delegates` publica el catálogo de alias por delegado, que es el dato del que
# se alimenta el autocompletado de la clave de modelo. Se comprueba que es el catálogo
# tal cual, con tres columnas y sin alias repetidos dentro de un delegado.
glot_run delegates
assert_eq 'delegates: código' '0' "$rc_last"
assert_eq 'delegates: el catálogo tal cual' \
    "$(awk 'NF && $1 !~ /^#/' "$TESTS_DIR/../data/delegates.tsv")" "$out"
assert_eq 'delegates: tres columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=3')"
assert_eq 'delegates: ningún alias repetido dentro de un delegado' '0' \
    "$(printf '%s\n' "$out" | awk -F'\t' '{print $1"/"$2}' | LC_ALL=C sort | uniq -d | wc -l | tr -d ' ')"
# v1.7.2 retiró aider y la v1.7.3 añade las filas de Copilot (los modelos de OpenRouter)
assert_eq 'delegates: las tres rutas del catálogo' 'agy
copilot
open-router' \
    "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"

glot_run delegates agy
assert_eq 'delegates agy: código' '0' "$rc_last"
assert_eq 'delegates agy: solo sus dos filas' '2' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'delegates agy: la primera columna, el delegado' 'agy' "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"

# v1.7.3: las filas de Copilot llevan ids de OpenRouter (`vendedor/modelo`), y esa barra es la
# que distingue el modelo que viaja al proveedor propio del que viaja a GitHub
glot_run delegates copilot
assert_eq 'delegates copilot: código' '0' "$rc_last"
assert_eq 'delegates copilot: sus ocho filas' '8' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'delegates copilot: la primera columna, el delegado' 'copilot' "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"
assert_eq 'delegates copilot: no mezcla modelos de OpenRouter' '0' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$3 ~ /\//' | wc -l | tr -d ' ')"
assert_eq 'delegates copilot: el alias `default` es el modelo de la documentación' 'gemini-3.8-flash' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$2=="default" {print $3}')"

glot_run delegates nope
assert_eq 'delegates con delegado desconocido: código' '2' "$rc_last"

glot_run help delegates
assert_eq 'help delegates: código' '0' "$rc_last"
assert_contains 'help delegates: las tres columnas' 'delegado<TAB>alias<TAB>modelo' "$out"

# progress: contadores globales y coherencia con el roadmap
glot_run progress
assert_eq 'progress: código' '0' "$rc_last"
assert_eq 'progress: cinco claves' '5' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'progress: registrados = lenguajes de .gitmodules' "$registered" "$(printf '%s\n' "$out" | sed -n 's/^registrados=//p')"
assert_eq 'progress: modulos = módulos del roadmap' "$roadmap_core" "$(printf '%s\n' "$out" | sed -n 's/^modulos=//p')"
assert_eq 'progress: pares_total = módulos por lenguajes' \
    "$((roadmap_core * registered))" "$(printf '%s\n' "$out" | sed -n 's/^pares_total=//p')"
# Recuento independiente: módulos cuyo contador del roadmap está completo.
expected_done="$(grep -E '^core\.[a-z_]+\.[a-z_0-9]+[[:space:]]' "$REPO/docs/ROADMAP.md" |
    grep -oE '[0-9]+/[0-9]+' | awk -F/ '$1==$2' | wc -l | tr -d ' ')"
assert_eq 'progress: homologados = módulos completos del roadmap' \
    "$expected_done" "$(printf '%s\n' "$out" | sed -n 's/^homologados=//p')"

glot_run progress foundations
assert_eq 'progress foundations: cuatro módulos' '4' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_contains 'progress foundations: hello_world completo' "$(printf 'hello_world\tdone')" "$out"
assert_eq 'progress foundations: denominador = registrados' '' \
    "$(printf '%s\n' "$out" | awk -F'\t' -v n="$registered" '$4!=n')"

glot_run progress nope
assert_eq 'progress con fase inexistente: código' '1' "$rc_last"

# completion: se imprime, no se instala
glot_run completion
assert_eq 'completion sin argumento: bash por defecto' '0' "$rc_last"
assert_contains 'completion sin argumento: guion de bash' 'complete -F _glot_complete glot' "$out"

glot_run completion bash
assert_eq 'completion bash: código' '0' "$rc_last"
assert_contains 'completion bash: completa el catálogo' '"$glot" langs' "$out"

glot_run completion zsh
assert_eq 'completion zsh: código' '0' "$rc_last"
assert_contains 'completion zsh: registra el compdef' 'compdef _glot_zsh glot' "$out"

glot_run completion fish
assert_eq 'completion con shell no soportado: código' '2' "$rc_last"
assert_contains 'completion con shell no soportado: error' 'shell no soportado' "$err"

glot_run completion bash zsh
assert_eq 'completion con dos argumentos: código' '2' "$rc_last"

# el autocompletado de bash completa de verdad: verbos y catálogo en vivo
bash_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot la); COMP_CWORD=1; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: completa un verbo' 'langs' "$bash_comp"

bash_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot use ph); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: completa el lenguaje' 'php' "$bash_comp"

bash_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot use php alg); COMP_CWORD=3; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"' | head -1)"
assert_eq 'completion bash: completa fase/módulo' 'algorithms/naive_sort' "$bash_comp"

bash_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot get a); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: completa una clave reservada' 'antigravity-model' "$bash_comp"

# el autocompletado de zsh se verifica solo si zsh está instalado: no es una
# dependencia del repositorio
if command -v zsh >/dev/null 2>&1; then
    assert_eq 'completion zsh: sintaxis' '0' "$(zsh -n "$REPO/scripts/completions/glot.zsh" >/dev/null 2>&1 && echo 0 || echo 1)"
    zsh_comp="$(GLOT_CMD="$GLOT_SH" zsh -f -c 'autoload -Uz compinit && compinit -u && source '"$REPO"'/scripts/completions/glot.zsh && print -r -- ${_comps[glot]}' 2>/dev/null)"
    assert_eq 'completion zsh: registra el compdef' '_glot_zsh' "$zsh_comp"
fi

# doctor: comprueba lo que el almacén y el catálogo necesitan de verdad
glot_run doctor
assert_eq 'doctor: código' '0' "$rc_last"
for tool in flock mktemp sort awk cat; do
    assert_contains "doctor: comprueba $tool" "$tool: " "$out"
done
assert_contains 'doctor: ruta del catálogo de datos' 'data_file: ' "$out"
assert_contains 'doctor: cobertura de comandos nativos' "native_commands: $registered de / of $registered" "$out"
assert_contains 'doctor: módulos del roadmap' 'roadmap_modules: ' "$out"
assert_contains 'doctor: autocompletado bash' 'completion_bash: yes' "$out"
assert_contains 'doctor: autocompletado zsh' 'completion_zsh: yes' "$out"

# el catálogo solo se comprueba contra sí mismo: la guía de inicialización es su lectura
# humana y quien la contrasta es `docs/tests/docs_check.sh`. El harness del tooling **no
# lee nada fuera de `scripts/`** (2026-10-13): un dato que el tooling necesite vive aquí.

# deriva interna del catálogo: mismos lenguajes en `languages.tsv` y en las dos fases de
# `init_sequences.tsv` (ya comprobado arriba con `comm`), y las secuencias al completo
data_seq="$(awk -F'\t' 'FNR > 1 {print $1}' "$REPO/scripts/data/init_sequences.tsv" | LC_ALL=C sort -u)"
assert_eq 'secuencias: el dato trae los 50 lenguajes' '50' "$(printf '%s\n' "$data_seq" | wc -l | tr -d ' ')"

# la regla del directorio de trabajo: solo los generadores que crean la carpeta salen de
# `module`, y la guía tiene que nombrarlos a los cinco. La sección se lee una vez: con
# `pipefail`, un `awk | grep -q` muere por SIGPIPE cuando `grep` acierta y sale antes.
# la regla del directorio de trabajo (v2): los generadores que crean la carpeta por su cuenta
# corren desde la fase (`cwd = phase`) y la guía los nombra uno a uno en esa sección.
CREATORS='ballerina clojure common-lisp crystal d dart elixir erlang gleam julia ocaml racket'
missing_phase=""
for lang in $CREATORS; do
    awk -F'\t' -v l="$lang" 'FNR > 1 && $1 == l && $2 == "new" && $4 == "phase" {s = 1} END {exit !s}' \
        "$REPO/scripts/data/init_sequences.tsv" || missing_phase+="dato:$lang "
done
assert_eq 'secuencias: los creadores de carpeta salen de la fase' '' "$missing_phase"

# la referencia entre proyectos de C# es un paso del dato, no una nota (medido el
# 2026-10-02: sin ella el proyecto de producción no se compila y `dotnet test` pasa
# en verde con un caso de plantilla).
assert_eq 'secuencias: C# enlaza el proyecto de pruebas' '1' \
    "$(awk -F'\t' '$1 == "csharp" && $6 ~ /reference/ {n++} END {print n+0}' "$REPO/scripts/data/init_sequences.tsv")"

# el conversor resuelve el id del roadmap aunque no coincida con la carpeta ni con
# el documento: es el fallo que el fixture anterior no podía ver
sandbox_make

glot_run_sandbox -n use php foundations/unit_test
assert_eq 'use con nombre divergente: código' '0' "$rc_last"
assert_contains 'use con nombre divergente: id canónico' 'module=unit_test' "$out"
assert_contains 'use con nombre divergente: documento divergente' 'spec=docs/core/foundations/03_Unit_Test_Calculator.md' "$out"
assert_contains 'use con nombre divergente: carpeta anidada' 'unit_test/calculator' "$err"
assert_contains 'use con nombre divergente: avisa de que no genera esqueleto' 'no se genera esqueleto' "$err"
assert_eq 'use con nombre divergente: sin mkdir' 'no' "$(case "$out" in *'mkdir -p'*) echo si ;; *) echo no ;; esac)"

glot_run_sandbox -n use php foundations/helloworld
assert_eq 'use con el nombre de la carpeta: código' '0' "$rc_last"
assert_contains 'use con el nombre de la carpeta: id canónico' 'module=hello_world' "$out"
assert_contains 'use con el nombre de la carpeta: especificación' 'spec=docs/core/foundations/01_Hello_World.md' "$out"
assert_contains 'use con el nombre de la carpeta: rama en kebab' 'branch=feat/foundations/hello-world' "$out"

glot_run_sandbox use php foundations/nope
assert_eq 'use sin especificación: código' '1' "$rc_last"
assert_contains 'use sin especificación: error' 'especificación ausente' "$err"
assert_contains 'use sin especificación: sugiere el catálogo' 'glot modules foundations' "$err"

# el estado no se inventa una ruta si no hay HOME ni XDG_STATE_HOME
glot_run_no_home path
assert_eq 'sin HOME: path falla con 1' '1' "$rc_last"
assert_contains 'sin HOME: mensaje propio' 'define GLOT_STATE_DIR' "$err"

glot_run_no_home get lang
assert_eq 'sin HOME: get devuelve 3' '3' "$rc_last"

# --- casos de la especificación v0.7.0 (L3, ejecución) ----------------------

# la plantilla del catálogo se expande con el módulo real: {module}, {Module} y {suite}
glot_run -n test php algorithms/naive_sort
assert_eq 'test -n: código' '0' "$rc_last"
assert_eq 'test -n: un plan y solo uno' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_contains 'test -n: cambia al directorio del módulo' '/php/core/algorithms/naive_sort && ' "$out"
assert_contains 'test -n: comando nativo del lenguaje' 'composer test' "$out"

glot_run -n test csharp algorithms/naive_sort
assert_contains 'test -n: {Modulo} en PascalCase' 'dotnet test NaiveSort.slnx' "$out"

glot_run -n test prolog algorithms/naive_sort
assert_contains 'test -n: Prolog recoge suites' "expand_file_name('*_tests.pl'" "$out"
assert_contains 'test -n: respeta el cd del comando' '&& cd test && ' "$out"

glot_run -n test scheme algorithms/naive_sort
assert_contains 'test -n: recoge suites Guile' './*_guile.scm' "$out"

glot_run -n test vala algorithms/naive_sort
assert_contains 'test -n: {suite} dentro de una ruta' 'test/naive_sort_tests.vala' "$out"
assert_contains 'test -n: {module} en el binario' '/tmp/naive_sort-tests' "$out"

VALA_SCAFFOLD="$SANDBOX/vala/core/algorithms/naive_sort"
mkdir -p -- "$VALA_SCAFFOLD"
glot_run_sandbox scaffold vala algorithms/naive_sort
assert_eq 'scaffold Vala: crea directorios' '0' "$rc_last"
assert_eq 'scaffold Vala: crea src y test' 'yes' \
    "$([[ -d "$VALA_SCAFFOLD/src" && -d "$VALA_SCAFFOLD/test" ]] && echo yes || echo no)"
glot_run_sandbox scaffold vala algorithms/naive_sort
assert_eq 'scaffold Vala: rerun' '0' "$rc_last"

VALA_HELPER="$TESTS_DIR/../data/vala_scaffold.sh"
VALA_EXACT="$WORK_DIR/vala-exact"
mkdir -p -- "$VALA_EXACT"
sed 's/@MODULE@/naive_sort/g' \
    "$TESTS_DIR/../data/scaffold_templates/vala.source.vala" \
    >"$VALA_EXACT/naive_sort.vala"
sed 's/@MODULE@/naive_sort/g' \
    "$TESTS_DIR/../data/scaffold_templates/vala.test.vala" \
    >"$VALA_EXACT/naive_sort_test.vala"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/vala.meson.build" \
    >"$VALA_EXACT/meson.build"
(cd -- "$VALA_EXACT" && bash "$VALA_HELPER" naive_sort)
assert_contains 'scaffold Vala: mueve fuente exacta' 'namespace naive_sort' \
    "$(cat -- "$VALA_EXACT/src/naive_sort.vala")"
assert_contains 'scaffold Vala: crea sentinel exacto' 'assert_not_reached' \
    "$(cat -- "$VALA_EXACT/test/naive_sort_test.vala")"
assert_contains 'scaffold Vala: actualiza fuente Meson' "'src/naive_sort.vala'" \
    "$(cat -- "$VALA_EXACT/meson.build")"
assert_contains 'scaffold Vala: actualiza test Meson' "'test/naive_sort_test.vala'" \
    "$(cat -- "$VALA_EXACT/meson.build")"
vala_source_before="$(cat -- "$VALA_EXACT/src/naive_sort.vala")"
vala_test_before="$(cat -- "$VALA_EXACT/test/naive_sort_test.vala")"
vala_meson_before="$(cat -- "$VALA_EXACT/meson.build")"
rc=0
(cd -- "$VALA_EXACT" && bash "$VALA_HELPER" naive_sort) || rc=$?
assert_eq 'scaffold Vala: rerun tras adaptar' '0' "$rc"
assert_eq 'scaffold Vala: conserva fuente adaptada' "$vala_source_before" \
    "$(cat -- "$VALA_EXACT/src/naive_sort.vala")"
assert_eq 'scaffold Vala: conserva sentinel en rerun' "$vala_test_before" \
    "$(cat -- "$VALA_EXACT/test/naive_sort_test.vala")"
assert_eq 'scaffold Vala: conserva Meson en rerun' "$vala_meson_before" \
    "$(cat -- "$VALA_EXACT/meson.build")"
if command -v valac >/dev/null 2>&1; then
    rc=0
    (cd -- "$VALA_EXACT" && bash "$TESTS_DIR/../data/vala_test.sh") \
        >/dev/null 2>&1 || rc=$?
    assert_eq 'test Vala: sentinel falla' '1' "$([[ "$rc" -ne 0 ]] && echo 1 || echo 0)"
fi
printf 'authored suite\n' >"$VALA_EXACT/test/naive_sort_test.vala"
(cd -- "$VALA_EXACT" && bash "$VALA_HELPER" naive_sort)
assert_eq 'scaffold Vala: conserva suite propia en rerun' 'authored suite' \
    "$(cat -- "$VALA_EXACT/test/naive_sort_test.vala")"
printf 'conflicting source\n' >"$VALA_EXACT/naive_sort.vala"
rc=0
(cd -- "$VALA_EXACT" && bash "$VALA_HELPER" naive_sort) >/dev/null 2>&1 || rc=$?
assert_eq 'scaffold Vala: rechaza conflicto de fuente' '1' "$rc"
assert_eq 'scaffold Vala: conserva fuente ante conflicto' "$vala_source_before" \
    "$(cat -- "$VALA_EXACT/src/naive_sort.vala")"
assert_eq 'scaffold Vala: conserva archivo en raíz ante conflicto' 'conflicting source' \
    "$(cat -- "$VALA_EXACT/naive_sort.vala")"
rm -- "$VALA_EXACT/naive_sort.vala"
printf 'conflicting test\n' >"$VALA_EXACT/naive_sort_test.vala"
rc=0
(cd -- "$VALA_EXACT" && bash "$VALA_HELPER" naive_sort) >/dev/null 2>&1 || rc=$?
assert_eq 'scaffold Vala: rechaza conflicto de test' '1' "$rc"
assert_eq 'scaffold Vala: conserva suite ante conflicto' 'authored suite' \
    "$(cat -- "$VALA_EXACT/test/naive_sort_test.vala")"

if command -v valac >/dev/null 2>&1; then
    VALA_BASES="$WORK_DIR/vala-bases"
    mkdir -p -- "$VALA_BASES/data_structures_basics/src" "$VALA_BASES/data_structures_basics/test"
    mkdir -p -- "$VALA_BASES/numbers/src" "$VALA_BASES/numbers/test"
    cp -- "$REPO/vala/core/algorithms/data_structures_basics/src/"*.vala \
        "$VALA_BASES/data_structures_basics/src/"
    cp -- "$REPO/vala/core/algorithms/data_structures_basics/test/"*.vala \
        "$VALA_BASES/data_structures_basics/test/"
    cp -- "$REPO/vala/core/foundations/numbers/src/"*.vala \
        "$VALA_BASES/numbers/src/"
    cp -- "$REPO/vala/core/foundations/numbers/test/"*.vala \
        "$VALA_BASES/numbers/test/"
    for reference in data_structures_basics numbers; do
        rc=0
        (cd -- "$VALA_BASES/$reference" && bash "$TESTS_DIR/../data/vala_test.sh") \
            >/dev/null 2>&1 || rc=$?
        assert_eq "test Vala: $reference pasa" '0' "$rc"
    done
fi

VALA_TARGET="$WORK_DIR/vala-scaffold-target"
VALA_LINK_SCAFFOLD="$SANDBOX/vala/core/algorithms/data_structures_basics"
mkdir -p -- "$VALA_TARGET"
printf 'authored marker\n' >"$VALA_TARGET/marker"
mkdir -p -- "$VALA_LINK_SCAFFOLD"
ln -s -- "$VALA_TARGET" "$VALA_LINK_SCAFFOLD/src"
glot_run_sandbox scaffold vala algorithms/data_structures_basics
assert_eq 'scaffold Vala symlink: bloquea' '4' "$rc_last"
assert_contains 'scaffold Vala symlink: diagnóstico' 'unsafe Vala path' "$err"
assert_eq 'scaffold Vala symlink: preserva destino' 'authored marker' \
    "$(cat -- "$VALA_TARGET/marker")"
assert_eq 'scaffold Vala symlink: no crea test' 'no' \
    "$([[ -e "$VALA_LINK_SCAFFOLD/test" ]] && echo yes || echo no)"

ELM_SCAFFOLD="$SANDBOX/elm/core/foundations/unit_test/calculator"
mkdir -p -- "$ELM_SCAFFOLD"
printf '{}\n' >"$ELM_SCAFFOLD/elm.json"
glot_run_sandbox scaffold elm foundations/unit_test/calculator
assert_eq 'scaffold Elm: prepara directorios e ignore' '0' "$rc_last"
assert_eq 'scaffold Elm: src y tests' 'yes' \
    "$([[ -d "$ELM_SCAFFOLD/src" && -d "$ELM_SCAFFOLD/tests" ]] && echo yes || echo no)"
assert_eq 'scaffold Elm: ignore correcto' '0' \
    "$(cmp -s "$ELM_SCAFFOLD/.gitignore" "$TESTS_DIR/../data/scaffold_templates/elm.gitignore"; echo $?)"
printf 'authored pattern\n' >>"$ELM_SCAFFOLD/.gitignore"
glot_run_sandbox scaffold elm foundations/unit_test/calculator
assert_eq 'scaffold Elm: rerun' '0' "$rc_last"
assert_contains 'scaffold Elm: conserva ignore propio' 'authored pattern' \
    "$(cat -- "$ELM_SCAFFOLD/.gitignore")"

ELM_TARGET="$WORK_DIR/elm-scaffold-target"
ELM_LINK="$SANDBOX/elm/core/foundations/helloworld"
mkdir -p -- "$ELM_TARGET" "$ELM_LINK"
printf 'authored marker\n' >"$ELM_TARGET/marker"
printf '{}\n' >"$ELM_LINK/elm.json"
ln -s -- "$ELM_TARGET" "$ELM_LINK/tests"
glot_run_sandbox scaffold elm foundations/helloworld
assert_eq 'scaffold Elm symlink: bloquea' '4' "$rc_last"
assert_contains 'scaffold Elm symlink: diagnóstico' 'unsafe Elm path' "$err"
assert_eq 'scaffold Elm symlink: preserva destino' 'authored marker' \
    "$(cat -- "$ELM_TARGET/marker")"
assert_eq 'scaffold Elm symlink: no crea src' 'no' \
    "$([[ -e "$ELM_LINK/src" ]] && echo yes || echo no)"

ELIXIR_SCAFFOLD="$WORK_DIR/elixir-scaffold"
ELIXIR_HELPER="$TESTS_DIR/../data/elixir_scaffold.sh"
mkdir -p -- "$ELIXIR_SCAFFOLD/lib" "$ELIXIR_SCAFFOLD/test"
sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module.ex" \
    >"$ELIXIR_SCAFFOLD/lib/naive_sort.ex"
sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module_test.exs" \
    >"$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
printf 'ExUnit.start()\n' >"$ELIXIR_SCAFFOLD/test/test_helper.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_eq 'scaffold Elixir: retira fuente de muestra' 'no' \
    "$([[ -e "$ELIXIR_SCAFFOLD/lib/naive_sort.ex" ]] && echo yes || echo no)"
assert_contains 'scaffold Elixir: sentinel' 'No tests configured' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"
printf 'authored suite\n' >"$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_eq 'scaffold Elixir: conserva suite en rerun' 'authored suite' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"

sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module.ex" \
    >"$ELIXIR_SCAFFOLD/lib/naive_sort.ex"
sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module_test.exs" \
    >"$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
printf 'authored extra\n' >"$ELIXIR_SCAFFOLD/test/extra.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_contains 'scaffold Elixir: conserva pareja con otros archivos' 'def hello do' \
    "$(cat -- "$ELIXIR_SCAFFOLD/lib/naive_sort.ex")"
assert_contains 'scaffold Elixir: conserva test de muestra con otros archivos' 'greets the world' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"
printf '# authored change\n' >>"$ELIXIR_SCAFFOLD/lib/naive_sort.ex"
rm -- "$ELIXIR_SCAFFOLD/test/extra.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_contains 'scaffold Elixir: conserva fuente modificada' '# authored change' \
    "$(cat -- "$ELIXIR_SCAFFOLD/lib/naive_sort.ex")"
assert_contains 'scaffold Elixir: conserva test si fuente modificada' 'greets the world' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"
sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module.ex" \
    >"$ELIXIR_SCAFFOLD/lib/naive_sort.ex"
printf '# authored test\n' >>"$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_contains 'scaffold Elixir: conserva test modificado' '# authored test' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"
assert_contains 'scaffold Elixir: conserva fuente si test modificado' 'def hello do' \
    "$(cat -- "$ELIXIR_SCAFFOLD/lib/naive_sort.ex")"
sed 's/@MODULE@/NaiveSort/g' "$TESTS_DIR/../data/scaffold_templates/elixir.module_test.exs" \
    >"$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
printf '# authored helper\n' >>"$ELIXIR_SCAFFOLD/test/test_helper.exs"
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort)
assert_contains 'scaffold Elixir: conserva fuente si helper modificado' 'def hello do' \
    "$(cat -- "$ELIXIR_SCAFFOLD/lib/naive_sort.ex")"
assert_contains 'scaffold Elixir: conserva test si helper modificado' 'greets the world' \
    "$(cat -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs")"
mv -- "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs" "$ELIXIR_SCAFFOLD/original-test"
ln -s -- "$ELIXIR_SCAFFOLD/original-test" "$ELIXIR_SCAFFOLD/test/naive_sort_test.exs"
rc=0
(cd -- "$ELIXIR_SCAFFOLD" && bash "$ELIXIR_HELPER" naive_sort NaiveSort) \
    2>"$WORK_DIR/elixir-scaffold.err" || rc=$?
assert_eq 'scaffold Elixir symlink: bloquea' '1' "$rc"
assert_contains 'scaffold Elixir symlink: diagnóstico' 'unsafe Elixir file' \
    "$(cat -- "$WORK_DIR/elixir-scaffold.err")"
assert_contains 'scaffold Elixir symlink: preserva destino' 'greets the world' \
    "$(cat -- "$ELIXIR_SCAFFOLD/original-test")"

if command -v elixir >/dev/null 2>&1; then
    ELIXIR_TEST_PROJECT="$WORK_DIR/elixir-test-project"
    mkdir -p -- "$ELIXIR_TEST_PROJECT/test"
    cat >"$ELIXIR_TEST_PROJECT/mix.exs" <<'EOF'
defmodule GlotTest.MixProject do
  use Mix.Project
  def project, do: [app: :glot_test, version: "0.1.0"]
end
EOF
    cat >"$ELIXIR_TEST_PROJECT/test/test_helper.exs" <<'EOF'
defmodule GlotTestFormatter do
  use GenServer
  def init(opts), do: {:ok, opts}
  def handle_cast({:suite_finished, _}, state) do
    File.write!("formatter-ran", "yes")
    {:noreply, state}
  end
  def handle_cast(_, state), do: {:noreply, state}
end
ExUnit.start(formatters: [ExUnit.CLIFormatter, GlotTestFormatter], exclude: [:excluded])
EOF
    elixir_runner_run() {
        local rc=0
        out="$(cd -- "$ELIXIR_TEST_PROJECT" && MIX_HOME="$WORK_DIR/mix-home" \
            HEX_HOME="$WORK_DIR/hex-home" bash "$TESTS_DIR/../data/elixir_test.sh" \
            2>"$WORK_DIR/elixir-runner.err")" || rc=$?
        err="$(cat -- "$WORK_DIR/elixir-runner.err")"
        rc_last=$rc
    }

    elixir_runner_run
    assert_eq 'test Elixir: rechaza ausencia de archivos' '1' "$rc_last"
    assert_contains 'test Elixir: informa cero casos sin archivos' 'no passing ExUnit cases' "$err"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: rechaza suite vacía' '1' "$rc_last"
    assert_contains 'test Elixir: informa cero casos' 'no passing ExUnit cases' "$err"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
  @tag :skip
  test "skipped", do: flunk("skipped")
  @tag :excluded
  test "excluded", do: flunk("excluded")
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: rechaza solo omitidos y excluidos' '1' "$rc_last"
    assert_contains 'test Elixir: informa omitidos y excluidos' '1 skipped, 1 excluded' "$out"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
  test "pass" do
    assert 1 + 1 == 2
    assert System.argv() == ["test"]
  end
  @tag :skip
  test "skipped", do: flunk("skipped")
  @tag :excluded
  test "excluded", do: flunk("excluded")
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: acepta aprobados con omitidos' '0' "$rc_last"
    assert_contains 'test Elixir: cuenta casos' '1 passed, 0 failed, 1 skipped, 1 excluded' "$out"
    assert_eq 'test Elixir: conserva formatter propio' 'yes' "$(cat -- "$ELIXIR_TEST_PROJECT/formatter-ran")"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
  test "failure", do: flunk("intentional failure")
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: rechaza fallo' '2' "$rc_last"
    assert_contains 'test Elixir: muestra fallo' 'intentional failure' "$out"
    printf 'defmodule Broken do\n' >"$ELIXIR_TEST_PROJECT/test/example_test.exs"
    elixir_runner_run
    assert_eq 'test Elixir: rechaza error de compilación' '1' "$rc_last"
    printf 'ExUnit.start(after_suite: [])\n' >"$ELIXIR_TEST_PROJECT/test/test_helper.exs"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
  test "pass", do: assert(true)
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: rechaza callback reemplazado' '1' "$rc_last"
    assert_contains 'test Elixir: informa resultado ausente' 'missing ExUnit result' "$err"
    printf 'ExUnit.start()\nExUnit.run()\n' >"$ELIXIR_TEST_PROJECT/test/test_helper.exs"
    elixir_runner_run
    assert_eq 'test Elixir: rechaza ejecuciones múltiples' '1' "$rc_last"
    assert_contains 'test Elixir: informa ejecuciones múltiples' 'multiple runs' "$err"
    printf 'ExUnit.start()\n' >"$ELIXIR_TEST_PROJECT/test/test_helper.exs"
    cat >"$ELIXIR_TEST_PROJECT/test/example_test.exs" <<'EOF'
defmodule ExampleTest do
  use ExUnit.Case
  test "abort", do: System.halt(0)
end
EOF
    elixir_runner_run
    assert_eq 'test Elixir: rechaza salida prematura' '1' "$rc_last"
    assert_contains 'test Elixir: informa ejecución incompleta' 'incomplete ExUnit run' "$err"
fi

ERLANG_SCAFFOLD="$WORK_DIR/erlang-scaffold"
ERLANG_HELPER="$TESTS_DIR/../data/erlang_scaffold.sh"
mkdir -p -- "$ERLANG_SCAFFOLD/src"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/erlang.module.erl" \
    >"$ERLANG_SCAFFOLD/src/naive_sort.erl"
(cd -- "$ERLANG_SCAFFOLD" && bash "$ERLANG_HELPER" naive_sort)
assert_contains 'scaffold Erlang: crea sentinel' 'no_contract_tests_configured' \
    "$(cat -- "$ERLANG_SCAFFOLD/test/naive_sort_test.erl")"
printf 'authored suite\n' >"$ERLANG_SCAFFOLD/test/naive_sort_test.erl"
(cd -- "$ERLANG_SCAFFOLD" && bash "$ERLANG_HELPER" naive_sort)
assert_eq 'scaffold Erlang: conserva suite en rerun' 'authored suite' \
    "$(cat -- "$ERLANG_SCAFFOLD/test/naive_sort_test.erl")"
rm -- "$ERLANG_SCAFFOLD/test/naive_sort_test.erl"
printf 'authored extra\n' >"$ERLANG_SCAFFOLD/test/another_test.erl"
(cd -- "$ERLANG_SCAFFOLD" && bash "$ERLANG_HELPER" naive_sort)
assert_eq 'scaffold Erlang: no crea sentinel con otra suite' 'no' \
    "$([[ -e "$ERLANG_SCAFFOLD/test/naive_sort_test.erl" ]] && echo yes || echo no)"
rm -- "$ERLANG_SCAFFOLD/test/another_test.erl"
printf '%% authored source\n' >>"$ERLANG_SCAFFOLD/src/naive_sort.erl"
(cd -- "$ERLANG_SCAFFOLD" && bash "$ERLANG_HELPER" naive_sort)
assert_eq 'scaffold Erlang: no crea sentinel con fuente propia' 'no' \
    "$([[ -e "$ERLANG_SCAFFOLD/test/naive_sort_test.erl" ]] && echo yes || echo no)"
assert_contains 'scaffold Erlang: conserva fuente propia' '% authored source' \
    "$(cat -- "$ERLANG_SCAFFOLD/src/naive_sort.erl")"
rmdir -- "$ERLANG_SCAFFOLD/test"
ln -s -- "$ERLANG_SCAFFOLD/src" "$ERLANG_SCAFFOLD/test"
rc=0
(cd -- "$ERLANG_SCAFFOLD" && bash "$ERLANG_HELPER" naive_sort) \
    2>"$WORK_DIR/erlang-scaffold.err" || rc=$?
assert_eq 'scaffold Erlang: rechaza directorio simbólico' '1' "$rc"
assert_contains 'scaffold Erlang: informa directorio inseguro' 'unsafe or missing Erlang directory' \
    "$(cat -- "$WORK_DIR/erlang-scaffold.err")"

ERLANG_FAKE_BIN="$WORK_DIR/erlang-fake-bin"
ERLANG_OUTPUT="$WORK_DIR/erlang-output"
mkdir -p -- "$ERLANG_FAKE_BIN"
cat >"$ERLANG_FAKE_BIN/rebar3" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == eunit ]] || exit 2
cat -- "$ERLANG_OUTPUT"
exit "${ERLANG_FAKE_STATUS:-0}"
EOF
chmod +x -- "$ERLANG_FAKE_BIN/rebar3"
erlang_runner_run() {
    local rc=0
    out="$(ERLANG_OUTPUT="$ERLANG_OUTPUT" ERLANG_FAKE_STATUS="${1:-0}" \
        PATH="$ERLANG_FAKE_BIN:$PATH" bash "$TESTS_DIR/../data/erlang_test.sh" \
        2>"$WORK_DIR/erlang-runner.err")" || rc=$?
    err="$(cat -- "$WORK_DIR/erlang-runner.err")"
    rc_last=$rc
}
printf 'Finished in 0.001 seconds\n0 tests\n' >"$ERLANG_OUTPUT"
erlang_runner_run
assert_eq 'test Erlang: rechaza cero casos' '1' "$rc_last"
printf 'Finished in 0.001 seconds\n2 tests, 0 failures\n' >"$ERLANG_OUTPUT"
erlang_runner_run
assert_eq 'test Erlang: acepta casos aprobados' '0' "$rc_last"
assert_contains 'test Erlang: conserva salida nativa' '2 tests, 0 failures' "$out"
printf '\033[0;32m2 tests, 0 failures\n\033[0m\n' >"$ERLANG_OUTPUT"
erlang_runner_run
assert_eq 'test Erlang: acepta resumen coloreado' '0' "$rc_last"
printf 'incomplete output\n' >"$ERLANG_OUTPUT"
erlang_runner_run
assert_eq 'test Erlang: rechaza resumen ausente' '1' "$rc_last"
assert_contains 'test Erlang: explica resumen ausente' 'missing, ambiguous or empty EUnit summary' "$err"
printf '1 tests, 0 failures\n2 tests, 0 failures\n' >"$ERLANG_OUTPUT"
erlang_runner_run
assert_eq 'test Erlang: rechaza resumen ambiguo' '1' "$rc_last"
printf '1 tests, 1 failures\n' >"$ERLANG_OUTPUT"
erlang_runner_run 7
assert_eq 'test Erlang: propaga fallo del proceso' '7' "$rc_last"
erlang_runner_run
assert_eq 'test Erlang: rechaza fallo con proceso en cero' '1' "$rc_last"

GLEAM_SCAFFOLD="$WORK_DIR/gleam-scaffold"
GLEAM_HELPER="$TESTS_DIR/../data/gleam_scaffold.sh"
mkdir -p -- "$GLEAM_SCAFFOLD/src" "$GLEAM_SCAFFOLD/test"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/gleam.module.gleam" \
    >"$GLEAM_SCAFFOLD/src/naive_sort.gleam"
cp -- "$TESTS_DIR/../data/scaffold_templates/gleam.module_test.gleam" \
    "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam"
(cd -- "$GLEAM_SCAFFOLD" && bash "$GLEAM_HELPER" naive_sort)
assert_eq 'scaffold Gleam: retira fuente de muestra' 'no' \
    "$([[ -e "$GLEAM_SCAFFOLD/src/naive_sort.gleam" ]] && echo yes || echo no)"
assert_contains 'scaffold Gleam: crea sentinel' 'No contract tests configured' \
    "$(cat -- "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam")"
printf 'authored suite\n' >"$GLEAM_SCAFFOLD/test/naive_sort_test.gleam"
(cd -- "$GLEAM_SCAFFOLD" && bash "$GLEAM_HELPER" naive_sort)
assert_eq 'scaffold Gleam: conserva suite en rerun' 'authored suite' \
    "$(cat -- "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam")"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/gleam.module.gleam" \
    >"$GLEAM_SCAFFOLD/src/naive_sort.gleam"
cp -- "$TESTS_DIR/../data/scaffold_templates/gleam.module_test.gleam" \
    "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam"
printf 'authored extra\n' >"$GLEAM_SCAFFOLD/test/extra.gleam"
(cd -- "$GLEAM_SCAFFOLD" && bash "$GLEAM_HELPER" naive_sort)
assert_contains 'scaffold Gleam: conserva pareja con otros archivos' 'Hello from naive_sort!' \
    "$(cat -- "$GLEAM_SCAFFOLD/src/naive_sort.gleam")"
assert_contains 'scaffold Gleam: conserva test con otros archivos' 'hello_world_test' \
    "$(cat -- "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam")"
rm -- "$GLEAM_SCAFFOLD/test/extra.gleam"
printf '// authored test\n' >>"$GLEAM_SCAFFOLD/test/naive_sort_test.gleam"
(cd -- "$GLEAM_SCAFFOLD" && bash "$GLEAM_HELPER" naive_sort)
assert_contains 'scaffold Gleam: conserva test modificado' '// authored test' \
    "$(cat -- "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam")"
assert_contains 'scaffold Gleam: conserva fuente si test modificado' 'Hello from naive_sort!' \
    "$(cat -- "$GLEAM_SCAFFOLD/src/naive_sort.gleam")"
mv -- "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam" "$GLEAM_SCAFFOLD/original-test"
ln -s -- "$GLEAM_SCAFFOLD/original-test" "$GLEAM_SCAFFOLD/test/naive_sort_test.gleam"
rc=0
(cd -- "$GLEAM_SCAFFOLD" && bash "$GLEAM_HELPER" naive_sort) \
    2>"$WORK_DIR/gleam-scaffold.err" || rc=$?
assert_eq 'scaffold Gleam: rechaza symlink' '1' "$rc"
assert_contains 'scaffold Gleam: informa symlink' 'unsafe Gleam file' \
    "$(cat -- "$WORK_DIR/gleam-scaffold.err")"
assert_contains 'scaffold Gleam: preserva destino' '// authored test' \
    "$(cat -- "$GLEAM_SCAFFOLD/original-test")"

GLEAM_FAKE_BIN="$WORK_DIR/gleam-fake-bin"
GLEAM_OUTPUT="$WORK_DIR/gleam-output"
mkdir -p -- "$GLEAM_FAKE_BIN"
cat >"$GLEAM_FAKE_BIN/gleam" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == test ]] || exit 2
cat -- "$GLEAM_OUTPUT"
exit "${GLEAM_FAKE_STATUS:-0}"
EOF
chmod +x -- "$GLEAM_FAKE_BIN/gleam"
gleam_runner_run() {
    local rc=0
    out="$(GLEAM_OUTPUT="$GLEAM_OUTPUT" GLEAM_FAKE_STATUS="${1:-0}" \
        PATH="$GLEAM_FAKE_BIN:$PATH" bash "$TESTS_DIR/../data/gleam_test.sh" \
        2>"$WORK_DIR/gleam-runner.err")" || rc=$?
    err="$(cat -- "$WORK_DIR/gleam-runner.err")"
    rc_last=$rc
}
printf 'No tests found!\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: rechaza cero casos' '1' "$rc_last"
printf '\033[0;32m2 passed, no failures\033[0m\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: acepta casos aprobados coloreados' '0' "$rc_last"
printf '0 passed, 0 failures, 1 skipped\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: rechaza solo omitidos' '1' "$rc_last"
printf '1 passed, 0 failures, 1 skipped\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: acepta mezcla con aprobados' '0' "$rc_last"
printf 'incomplete output\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: rechaza resumen ausente' '1' "$rc_last"
assert_contains 'test Gleam: informa resumen ausente' 'missing, ambiguous or empty Gleeunit summary' "$err"
printf '1 passed, no failures\n2 passed, no failures\n' >"$GLEAM_OUTPUT"
gleam_runner_run
assert_eq 'test Gleam: rechaza resumen ambiguo' '1' "$rc_last"
printf '0 passed, 1 failures\n' >"$GLEAM_OUTPUT"
gleam_runner_run 7
assert_eq 'test Gleam: propaga fallo del proceso' '7' "$rc_last"
gleam_runner_run
assert_eq 'test Gleam: rechaza fallos aunque el proceso dé cero' '1' "$rc_last"

if command -v python3 >/dev/null 2>&1; then
    CRYSTAL_FAKE_BIN="$WORK_DIR/crystal-fake-bin"
    CRYSTAL_REPORT="$WORK_DIR/crystal-report.xml"
    mkdir -p -- "$CRYSTAL_FAKE_BIN"
    cat >"$CRYSTAL_FAKE_BIN/crystal" <<'EOF'
#!/usr/bin/env bash
[[ "$1" == spec && "$2" == --junit_output && $# == 3 ]] || exit 2
if [[ -f "$CRYSTAL_REPORT" ]]; then cp -- "$CRYSTAL_REPORT" "$3"; fi
printf 'native Crystal output\n'
exit "${CRYSTAL_FAKE_STATUS:-0}"
EOF
    chmod +x -- "$CRYSTAL_FAKE_BIN/crystal"
    crystal_runner_run() {
        local rc=0
        out="$(CRYSTAL_REPORT="$CRYSTAL_REPORT" CRYSTAL_FAKE_STATUS="${1:-0}" \
            PATH="$CRYSTAL_FAKE_BIN:$PATH" bash "$TESTS_DIR/../data/crystal_test.sh" \
            2>"$WORK_DIR/crystal-runner.err")" || rc=$?
        err="$(cat -- "$WORK_DIR/crystal-runner.err")"
        rc_last=$rc
    }
    crystal_runner_run
    assert_eq 'test Crystal: rechaza informe ausente' '1' "$rc_last"
    assert_contains 'test Crystal: informa informe ausente' 'missing Crystal JUnit report' "$err"
    cat >"$CRYSTAL_REPORT" <<'EOF'
<testsuite tests="2" skipped="1" failures="0" errors="0"><testcase/><testcase><skipped/></testcase></testsuite>
EOF
    crystal_runner_run
    assert_eq 'test Crystal: acepta casos aprobados y pendientes' '0' "$rc_last"
    assert_contains 'test Crystal: conserva salida nativa' 'native Crystal output' "$out"
    cat >"$CRYSTAL_REPORT" <<'EOF'
<testsuite tests="1" skipped="1" failures="0" errors="0"><testcase><skipped/></testcase></testsuite>
EOF
    crystal_runner_run
    assert_eq 'test Crystal: rechaza todos pendientes' '1' "$rc_last"
    cat >"$CRYSTAL_REPORT" <<'EOF'
<testsuite tests="0" skipped="0" failures="0" errors="0"/>
EOF
    crystal_runner_run
    assert_eq 'test Crystal: rechaza cero casos' '1' "$rc_last"
    printf '<testsuite' >"$CRYSTAL_REPORT"
    crystal_runner_run
    assert_eq 'test Crystal: rechaza XML inválido' '1' "$rc_last"
    assert_contains 'test Crystal: informa XML inválido' 'invalid Crystal report' "$err"
    cat >"$CRYSTAL_REPORT" <<'EOF'
<testsuite tests="1" skipped="0" failures="0" errors="0"/>
EOF
    crystal_runner_run
    assert_eq 'test Crystal: rechaza recuento inconsistente' '1' "$rc_last"
    crystal_runner_run 7
    assert_eq 'test Crystal: propaga fallo del proceso' '7' "$rc_last"
fi

OCAML_SCAFFOLD="$WORK_DIR/ocaml-scaffold"
OCAML_HELPER="$TESTS_DIR/../data/ocaml_scaffold.sh"
mkdir -p -- "$OCAML_SCAFFOLD/test"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/ocaml.dune-project" \
    >"$OCAML_SCAFFOLD/dune-project"
cp -- "$TESTS_DIR/../data/scaffold_templates/ocaml.generated.opam" "$OCAML_SCAFFOLD/naive_sort.opam"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/ocaml.test-dune" \
    >"$OCAML_SCAFFOLD/test/dune"
: >"$OCAML_SCAFFOLD/test/test_naive_sort.ml"
(cd -- "$OCAML_SCAFFOLD" && bash "$OCAML_HELPER" naive_sort)
assert_contains 'scaffold OCaml: dependencia Dune' '(depends ocaml (alcotest :with-test))' \
    "$(cat -- "$OCAML_SCAFFOLD/dune-project")"
assert_contains 'scaffold OCaml: dependencia opam' '"alcotest" {with-test}' \
    "$(cat -- "$OCAML_SCAFFOLD/naive_sort.opam")"
assert_contains 'scaffold OCaml: target Alcotest' '(libraries naive_sort alcotest)' \
    "$(cat -- "$OCAML_SCAFFOLD/test/dune")"
assert_contains 'scaffold OCaml: sentinel' 'No contract tests configured' \
    "$(cat -- "$OCAML_SCAFFOLD/test/test_naive_sort.ml")"
printf 'authored suite\n' >"$OCAML_SCAFFOLD/test/test_naive_sort.ml"
(cd -- "$OCAML_SCAFFOLD" && bash "$OCAML_HELPER" naive_sort)
assert_eq 'scaffold OCaml: conserva suite en rerun' 'authored suite' \
    "$(cat -- "$OCAML_SCAFFOLD/test/test_naive_sort.ml")"
assert_eq 'scaffold OCaml: no duplica dependencia' '1' \
    "$(grep -c 'alcotest' "$OCAML_SCAFFOLD/dune-project")"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/ocaml.dune-project" \
    >"$OCAML_SCAFFOLD/dune-project"
cp -- "$TESTS_DIR/../data/scaffold_templates/ocaml.generated.opam" "$OCAML_SCAFFOLD/naive_sort.opam"
sed 's/@MODULE@/naive_sort/g' "$TESTS_DIR/../data/scaffold_templates/ocaml.test-dune" \
    >"$OCAML_SCAFFOLD/test/dune"
: >"$OCAML_SCAFFOLD/test/test_naive_sort.ml"
printf 'authored extra\n' >"$OCAML_SCAFFOLD/test/extra.ml"
(cd -- "$OCAML_SCAFFOLD" && bash "$OCAML_HELPER" naive_sort)
assert_eq 'scaffold OCaml: conserva proyecto con suite adicional' '0' \
    "$(cmp -s "$OCAML_SCAFFOLD/naive_sort.opam" "$TESTS_DIR/../data/scaffold_templates/ocaml.generated.opam"; echo $?)"
assert_eq 'scaffold OCaml: conserva test vacío con suite adicional' 'no' \
    "$([[ -s "$OCAML_SCAFFOLD/test/test_naive_sort.ml" ]] && echo yes || echo no)"
rm -- "$OCAML_SCAFFOLD/test/extra.ml"
printf '# authored metadata\n' >>"$OCAML_SCAFFOLD/naive_sort.opam"
(cd -- "$OCAML_SCAFFOLD" && bash "$OCAML_HELPER" naive_sort)
assert_contains 'scaffold OCaml: conserva opam propio' '# authored metadata' \
    "$(cat -- "$OCAML_SCAFFOLD/naive_sort.opam")"
assert_eq 'scaffold OCaml: no cambia proyecto con opam propio' 'no' \
    "$(grep -q 'alcotest' "$OCAML_SCAFFOLD/dune-project" && echo yes || echo no)"
mv -- "$OCAML_SCAFFOLD/test/dune" "$OCAML_SCAFFOLD/original-dune"
ln -s -- "$OCAML_SCAFFOLD/original-dune" "$OCAML_SCAFFOLD/test/dune"
rc=0
(cd -- "$OCAML_SCAFFOLD" && bash "$OCAML_HELPER" naive_sort) \
    2>"$WORK_DIR/ocaml-scaffold.err" || rc=$?
assert_eq 'scaffold OCaml: rechaza symlink' '1' "$rc"
assert_contains 'scaffold OCaml: informa symlink' 'unsafe OCaml file' \
    "$(cat -- "$WORK_DIR/ocaml-scaffold.err")"
assert_contains 'scaffold OCaml: preserva destino' '(libraries naive_sort)' \
    "$(cat -- "$OCAML_SCAFFOLD/original-dune")"

OCAML_FAKE_BIN="$WORK_DIR/ocaml-fake-bin"
OCAML_OUTPUT="$WORK_DIR/ocaml-output"
mkdir -p -- "$OCAML_FAKE_BIN"
cat >"$OCAML_FAKE_BIN/dune" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == 'runtest --force --display=short -j 1 --action-stdout-on-success=print --action-stderr-on-success=print' ]] || exit 2
cat -- "$OCAML_OUTPUT"
exit "${OCAML_FAKE_STATUS:-0}"
EOF
chmod +x -- "$OCAML_FAKE_BIN/dune"
ocaml_runner_run() {
    local rc=0
    out="$(OCAML_OUTPUT="$OCAML_OUTPUT" OCAML_FAKE_STATUS="${1:-0}" \
        PATH="$OCAML_FAKE_BIN:$PATH" bash "$TESTS_DIR/../data/ocaml_test.sh" \
        2>"$WORK_DIR/ocaml-runner.err")" || rc=$?
    err="$(cat -- "$WORK_DIR/ocaml-runner.err")"
    rc_last=$rc
}
printf '   suite alias test/runtest-suite\nTest Successful in 0.000s. 0 test run.\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: rechaza cero casos' '1' "$rc_last"
printf '   suite alias test/runtest-suite\n\033[32mTest Successful in 0.001s. 4 tests run.\033[0m\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: acepta resumen coloreado' '0' "$rc_last"
assert_contains 'test OCaml: conserva salida nativa' '4 tests run.' "$out"
printf '   first alias test/runtest-first\nTest Successful in 0.000s. 1 test run.\n  second alias test/runtest-second\nTest Successful in 0.001s. 5 tests run.\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: acepta varias suites' '0' "$rc_last"
printf '   first alias test/runtest-first\nTest Successful in 0.000s. 1 test run.\n  second alias test/runtest-second\nTest Successful in 0.000s. 0 test run.\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: rechaza suite vacía con otra aprobada' '1' "$rc_last"
printf '   first alias test/runtest-first\nTest Successful in 0.000s. 1 test run.\n  second alias test/runtest-second\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: rechaza acción silenciosa con otra aprobada' '1' "$rc_last"
printf '   first alias test/runtest-first\nTest Successful in 0.000s. 1 test run.\nTest Successful in 0.001s. 1 test run.\n  second alias test/runtest-second\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: rechaza resúmenes dobles y acción silenciosa' '1' "$rc_last"
printf 'incomplete output\n' >"$OCAML_OUTPUT"
ocaml_runner_run
assert_eq 'test OCaml: rechaza resumen ausente' '1' "$rc_last"
assert_contains 'test OCaml: informa resumen ausente' 'missing or empty Alcotest summary' "$err"
ocaml_runner_run 7
assert_eq 'test OCaml: propaga fallo del proceso' '7' "$rc_last"

HAXE_SCAFFOLD="$SANDBOX/haxe/core/algorithms/naive_sort"
HAXELIB_BIN="$WORK_DIR/haxelib-bin"
HAXELIB_LOG="$WORK_DIR/haxelib.log"
mkdir -p -- "$HAXELIB_BIN" "$HAXE_SCAFFOLD"
cat >"$HAXELIB_BIN/haxelib" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$HAXELIB_LOG"
EOF
chmod +x -- "$HAXELIB_BIN/haxelib"
HAXELIB_LOG="$HAXELIB_LOG" PATH="$HAXELIB_BIN:$PATH" \
    glot_run_sandbox scaffold haxe algorithms/naive_sort
assert_eq 'scaffold Haxe: código' '0' "$rc_last"
assert_eq 'scaffold Haxe: instala utest' 'install utest' \
    "$(cat -- "$HAXELIB_LOG")"
assert_eq 'scaffold Haxe: crea runner y sentinel' 'yes' \
    "$([[ -s "$HAXE_SCAFFOLD/build.hxml" && -s "$HAXE_SCAFFOLD/RunTests.hx" \
        && -s "$HAXE_SCAFFOLD/test/NaiveSortTest.hx" ]] && echo yes || echo no)"
assert_eq 'scaffold Haxe: crea ignore' '0' \
    "$(cmp -s "$HAXE_SCAFFOLD/.gitignore" \
        "$TESTS_DIR/../data/scaffold_templates/haxe.gitignore"; echo $?)"
if command -v haxe >/dev/null 2>&1 && command -v haxelib >/dev/null 2>&1 \
    && haxelib list 2>/dev/null | grep -q '^utest:'; then
    glot_run_sandbox test haxe algorithms/naive_sort
    assert_eq 'scaffold Haxe: sentinel falla el test' '4' "$rc_last"
    assert_contains 'scaffold Haxe: diagnóstico de sentinel' \
        'No tests configured' "$out$err"
fi
printf 'authored runner\n' >"$HAXE_SCAFFOLD/RunTests.hx"
printf 'authored pattern\n' >>"$HAXE_SCAFFOLD/.gitignore"
HAXELIB_LOG="$HAXELIB_LOG" PATH="$HAXELIB_BIN:$PATH" \
    glot_run_sandbox scaffold haxe algorithms/naive_sort
assert_eq 'scaffold Haxe: rerun' '0' "$rc_last"
assert_eq 'scaffold Haxe: conserva runner propio' 'authored runner' \
    "$(cat -- "$HAXE_SCAFFOLD/RunTests.hx")"
assert_contains 'scaffold Haxe: conserva ignore propio' 'authored pattern' \
    "$(cat -- "$HAXE_SCAFFOLD/.gitignore")"

HAXE_TARGET="$WORK_DIR/haxe-scaffold-target"
HAXE_LINK="$SANDBOX/haxe/core/algorithms/data_structures_basics"
mkdir -p -- "$HAXE_TARGET" "$HAXE_LINK"
printf 'authored marker\n' >"$HAXE_TARGET/marker"
ln -s -- "$HAXE_TARGET" "$HAXE_LINK/src"
HAXELIB_LOG="$HAXELIB_LOG" PATH="$HAXELIB_BIN:$PATH" \
    glot_run_sandbox scaffold haxe algorithms/data_structures_basics
assert_eq 'scaffold Haxe symlink: bloquea' '4' "$rc_last"
assert_contains 'scaffold Haxe symlink: diagnóstico' 'unsafe Haxe path' "$err"
assert_eq 'scaffold Haxe symlink: preserva destino' 'authored marker' \
    "$(cat -- "$HAXE_TARGET/marker")"
assert_eq 'scaffold Haxe symlink: no crea test' 'no' \
    "$([[ -e "$HAXE_LINK/test" ]] && echo yes || echo no)"

glot_run -n test tcl-tk algorithms/naive_sort
assert_contains 'test -n: recoge suites Tcl' './*.test' "$out"

glot_run -n test ada algorithms/naive_sort
assert_contains 'test -n: comando corregido de ada' 'alr -C tests run' "$out"

# el estado del sprint completa lo que no llega por argumento
glot_run set lang php
glot_run set phase algorithms
glot_run set module naive_sort
glot_run -n test
assert_eq 'test sin argumentos: código' '0' "$rc_last"
assert_contains 'test sin argumentos: usa el estado' 'composer test' "$out"
glot_run unset lang
glot_run unset phase
glot_run unset module
glot_run test
assert_eq 'test sin estado: código' '1' "$rc_last"
assert_contains 'test sin estado: sugiere use' 'glot use' "$err"

# errores de la capa de ejecución
glot_run -n test php algorithms/nope
assert_eq 'test con módulo desconocido: código' '1' "$rc_last"
glot_run -n test php nope/naive_sort
assert_eq 'test con fase inexistente: código' '1' "$rc_last"
glot_run -n test nope algorithms/naive_sort
assert_eq 'test con lenguaje fuera de .gitmodules: código' '1' "$rc_last"
glot_run -n test php algorithms/naive_sort extra mas
assert_eq 'test con demasiados argumentos: código' '2' "$rc_last"
glot_run -n test php algorithms/naive_sort -x
assert_eq 'test con opción desconocida: código' '2' "$rc_last"

# verify: sin verificador se informa y no falla; con él, imprime el comando
glot_run verify ada algorithms/naive_sort
assert_eq 'verify sin verificador: código' '0' "$rc_last"
assert_eq 'verify sin verificador: dato' 'skipped' "$out"
assert_contains 'verify sin verificador: aviso' 'sin verificador' "$err"

glot_run -n verify php algorithms/naive_sort
assert_contains 'verify -n: comando del catálogo' 'php -l src/NaiveSort.php' "$out"

glot_run -n verify rust algorithms/naive_sort
assert_contains 'verify -n: verificador sin marcadores' 'cargo fmt --check' "$out"

# el catálogo de verificadores se informa en doctor
glot_run doctor
assert_eq 'doctor: código' '0' "$rc_last"
assert_contains 'doctor: cobertura de verificadores' 'verify_commands: ' "$out"
assert_contains 'doctor: hay verificadores' 'verify_commands: 14 de / of 50' "$out"

# --- casos de la especificación v0.8.0 (L4, delegación) ---------------------

# registro de encargos: nombre<TAB>paso<TAB>descripción, leído del frontmatter
glot_run prompt
assert_eq 'prompt: código' '0' "$rc_last"
assert_eq 'prompt: once encargos' '11' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'prompt: cuatro columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=4')"
assert_contains 'prompt: scaffold en el paso 4' "$(printf 'scaffold\t4')" "$out"
assert_contains 'prompt: contract_stub en el paso 4b' "$(printf 'contract_stub\t4b')" "$out"
assert_contains 'prompt: suite después del contrato' "$(printf 'suite\t4c')" "$out"
assert_contains 'prompt: docs-language en el paso 8' "$(printf 'docs-language\t8')" "$out"
assert_contains 'prompt: el perfil sale de la plantilla' "$(printf 'validate\t6\teconomy')" "$out"

# el encargo lleva la cabecera con el estado del sprint y la plantilla expandida
glot_run prompt scaffold php algorithms/naive_sort
assert_eq 'prompt scaffold: código' '0' "$rc_last"
assert_contains 'prompt scaffold: nombre y objetivo' '# Encargo `scaffold` — php algorithms/naive_sort' "$out"
# v1.6.3: el encargo manda rutas **absolutas**. El delegado resuelve las relativas contra el
# repositorio en el que está —el submódulo, no el monorepo— y con `docs/…` relativo buscaba
# `{lenguaje}/docs/…`, que no existe: turnos y créditos en rutas que nunca iban a estar
# (medido el 2026-09-30 con `suite` en crystal). Se comprueban las dos caras: la cabecera
# manda absoluto y **no queda** ninguna cita relativa a la raíz en el encargo armado.
assert_contains 'prompt scaffold: spec del estado, absoluta' "| spec | $REPO/docs/core/algorithms/05_Naive_Sort.md |" "$out"
assert_contains 'prompt scaffold: la regla de las rutas va escrita' \
    'todas las rutas de este encargo son **absolutas**' "$out"
assert_contains 'prompt scaffold: las fuentes en absoluto' "$REPO/AGENTS.md" "$out"
assert_contains 'prompt scaffold: directorio del módulo' '/php/core/algorithms/naive_sort |' "$out"

# ...y en los once encargos, no solo en uno: cualquiera de ellos cita documentos del
# monorepo, y basta una plantilla que se quede atrás para volver a gastar créditos en rutas
# que el delegado no puede resolver.
for req in scaffold contract_stub suite build correct implement fix refactor validate docs-module docs-language; do
    glot_run prompt "$req" php algorithms/naive_sort
    assert_eq "prompt $req: código" '0' "$rc_last"
    assert_eq "prompt $req: ninguna ruta relativa a la raíz del monorepo" '' \
        "$(printf '%s\n' "$out" | grep -nE '(^|[^/[:alnum:]_.-])(AGENTS\.md|docs/|scripts/)' | grep -vF -- "$REPO" | head -5)"
    assert_eq "prompt $req: política incluida una sola vez" '1' \
        "$(printf '%s\n' "$out" | grep -c '^# Política compartida de delegación / Shared delegation policy$')"
    assert_contains "prompt $req: bases en orden persistente" \
        "$(printf '1. `%s/php/core/algorithms/data_structures_basics/`\n2. `%s/php/core/foundations/numbers/`' "$REPO" "$REPO")" "$out"
    assert_contains "prompt $req: fuente del rol visible" "- $REPO/docs/AGENT_ROLES.md" "$out"
    assert_contains "prompt $req: agrupación explícita" 'unidad/variante → casos aplicables → grupo lógico' "$out"
    assert_contains "prompt $req: guía para uso manual" "$REPO/scripts/prompts/Delegation_Policy.md" "$out"
done
assert_contains 'prompt scaffold: marcadores expandidos' 'php/core/algorithms/naive_sort' "$out"
assert_eq 'prompt scaffold: sin frontmatter de VS Code' 'no' "$(case "$out" in *'mode: agent'*) echo si ;; *) echo no ;; esac)"
assert_eq 'prompt scaffold: sin marcadores sin resolver' '' "$(printf '%s\n' "$out" | grep -oE '\{[a-zA-Z_]+\}' | sort -u)"

glot_run prompt implement php algorithms/naive_sort
assert_contains 'prompt implement: encargo del paso 5' 'Implementación del módulo' "$out"

# La política no depende del módulo ni del framework y no calcula la agrupación.
for lang in ada go cobol; do
    for target in algorithms/data_structures_basics foundations/numbers algorithms/data_structures_advanced; do
        glot_run prompt suite "$lang" "$target"
        assert_eq "política $lang $target: código" '0' "$rc_last"
        assert_contains "política $lang $target: referencias del lenguaje" \
            "$REPO/$lang/core/algorithms/data_structures_basics/" "$out"
        assert_contains "política $lang $target: no homologar autorreferencia" \
            'es el propio módulo en trabajo' "$out"
        assert_contains "política $lang $target: suite agregada permitida" \
            'Una suite agregada, varias suites o grupos dentro del mismo archivo' "$out"
        assert_contains "política $lang $target: casos por contrato" \
            'No multipliques todos los casos por todas las' "$out"
    done
done
glot_run_from "$SANDBOX/php" prompt suite php algorithms/naive_sort
assert_eq 'política desde submódulo sin bases: no inventa antecedentes' '0' "$rc_last"
assert_contains 'política desde submódulo: rutas de su raíz' \
    "$SANDBOX/php/core/algorithms/data_structures_basics/" "$out"
assert_contains 'política sin bases: informa el bloqueo si la otra no basta' \
    'si no basta, reporta el bloqueo' "$out"

glot_run prompt nope
assert_eq 'prompt con encargo desconocido: código' '1' "$rc_last"
assert_contains 'prompt con encargo desconocido: sugiere el registro' 'glot prompt' "$err"

# ask: sin delegado no hay nada que enviar
ask_nodelegate() {
    local rc=0
    out="$(env -u GLOT_DELEGATE -u GLOT_DELEGATE_COP -u GLOT_DELEGATE_AGY -u GLOT_DELEGATE_AIDER \
        "$GLOT_SH" ask "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

ask_nodelegate implement php algorithms/naive_sort
assert_eq 'ask sin delegado: código' '1' "$rc_last"
assert_contains 'ask sin delegado: explica GLOT_DELEGATE' 'GLOT_DELEGATE' "$err"
# El error trae el remedio entero: las dos líneas de invocación verificada, listas para el
# rc. Sin ellas el verbo decía qué variable faltaba y dejaba al autor buscando el comando.
# La de AGY va con `--model` **medido**: el binario no define `-m` (`flags provided but not
# defined: -m`) y el marcador `{model}` lo resuelve el perfil.
assert_contains 'ask sin delegado: imprime la línea de Copilot' "export GLOT_DELEGATE_COP='copilot -C {module_dir}" "$err"
assert_contains 'ask sin delegado: imprime la línea de Antigravity' "export GLOT_DELEGATE_AGY='agy --model {model}" "$err"
assert_eq 'ask sin delegado: ya no imprime la línea de aider (v1.7.2)' 'no' \
    "$([[ "$err" == *GLOT_DELEGATE_AIDER* ]] && echo si || echo no)"
assert_contains 'ask sin delegado: dice dónde van' 'van en tu rc' "$err"
assert_contains 'ask sin delegado: ofrece imprimir el encargo' 'glot prompt' "$err"
assert_contains 'ask sin delegado: no ensucia stdout' '' "$out"

# y con --delegate, la que falta se nombra sola
ask_nodelegate --delegate copilot implement php algorithms/naive_sort
assert_eq 'ask --delegate copilot sin delegado: código' '1' "$rc_last"
assert_contains 'ask --delegate copilot: nombra su variable' 'GLOT_DELEGATE_COP' "$err"
assert_contains 'ask --delegate copilot: imprime su línea' "export GLOT_DELEGATE_COP='copilot" "$err"
assert_eq 'ask --delegate copilot: no imprime la del otro' 'no' \
    "$([[ "$err" == *GLOT_DELEGATE_AGY* ]] && echo si || echo no)"

ask_nodelegate --delegate antigravity implement php algorithms/naive_sort
assert_eq 'ask --delegate antigravity sin delegado: código' '1' "$rc_last"
assert_contains 'ask --delegate antigravity: imprime su línea' "export GLOT_DELEGATE_AGY='agy" "$err"
assert_eq 'ask --delegate antigravity: no imprime la del otro' 'no' \
    "$([[ "$err" == *GLOT_DELEGATE_COP* ]] && echo si || echo no)"

# v1.7.2: el delegado `aider` se retira; pedirlo es un delegado desconocido
ask_nodelegate --delegate aider implement php algorithms/naive_sort
assert_eq 'ask --delegate aider (retirado en v1.7.2): código' '2' "$rc_last"
assert_contains 'ask --delegate aider: lista los válidos' 'copilot, antigravity' "$err"

# la ayuda de `ask` trae las tres líneas, que es donde se buscan
glot_run help ask
assert_contains 'help ask: trae la línea de Copilot' "export GLOT_DELEGATE_COP='copilot" "$out"
assert_contains 'help ask: la línea de Copilot lleva el adaptador de esfuerzo' '{reasoning_args}' "$out"
assert_contains 'help ask: trae la línea de Antigravity' "export GLOT_DELEGATE_AGY='agy" "$out"
assert_eq 'help ask: ya no trae la línea de aider (v1.7.2)' 'no' \
    "$([[ "$out" == *GLOT_DELEGATE_AIDER* ]] && echo si || echo no)"
assert_contains 'help ask: dice que install también las imprime' 'glot install' "$out"

ask_nodelegate
assert_eq 'ask sin encargo: código' '2' "$rc_last"

# ask con delegado: el encargo va por stdin y su salida a stdout
glot_run_delegate 'wc -l' ask implement php algorithms/naive_sort
assert_eq 'ask con delegado: código' '0' "$rc_last"
assert_eq 'ask con delegado: recibe el encargo por stdin' 'si' "$([[ "$out" =~ ^[[:space:]]*[0-9]+$ && "$out" -gt 20 ]] && echo si || echo no)"
assert_contains 'ask con delegado: lo anuncia por stderr' 'delegado / delegate' "$err"

for req in scaffold contract_stub suite build correct implement fix refactor validate docs-module docs-language; do
    glot_run prompt "$req" php algorithms/naive_sort
    expected_request="$out"
    glot_run_delegate 'cat' ask "$req" php algorithms/naive_sort
    assert_eq "política $req: delegado genérico recibe encargo íntegro" "$expected_request" "$out"
    glot_run_delegates 'cat' '' ask --delegate copilot "$req" php algorithms/naive_sort
    assert_eq "política $req: Copilot recibe encargo íntegro" "$expected_request" "$out"
    glot_run_delegates '' 'cat' ask --delegate antigravity "$req" php algorithms/naive_sort
    case "$req" in
        suite|implement|fix|refactor)
            assert_eq "política $req: AGY sin binding bloquea" '1' "$rc_last" ;;
        *) assert_eq "política $req: Antigravity recibe encargo íntegro" "$expected_request" "$out" ;;
    esac
done

glot_run_delegate 'false' ask implement php algorithms/naive_sort
assert_eq 'ask con delegado que falla: código' '1' "$rc_last"
assert_contains 'ask con delegado que falla: error' 'el delegado falló' "$err"

glot_run_delegate 'cat >/dev/null' -n ask implement php algorithms/naive_sort
assert_eq 'ask -n: código' '0' "$rc_last"
assert_contains 'ask -n: imprime el plan sin enviar' 'cat >/dev/null' "$out"

# v1.6.2/v1.7.0: el modelo del delegado se puede fijar **por sprint** con
# `glot set antigravity-model <alias>`, que es lo que permite cambiarlo a
# mitad de módulo: los límites de AGY no se pueden consultar desde su CLI. El alias se
# resuelve contra `data/delegates.tsv` y el entorno del delegado sigue ganando; Copilot no se
# entera (su modelo sale del perfil).
AGY_LINE='agy --model {model} -p "$(cat)" --add-dir {root}'
STATE_MODEL="$WORK_DIR/state-model"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set antigravity-model gemini >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" \
    "$GLOT_SH" ask -n --delegate antigravity docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'set antigravity-model: el alias llega resuelto a la orden de AGY' 'agy --model gemini-3.8-flash-low' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" GLOT_MODEL_AGY=argon \
    "$GLOT_SH" ask -n --delegate antigravity implement php algorithms/naive_sort 2>"$WORK_DIR/stderr" || true)"
assert_contains 'AGY: entorno no elude categoría' 'outside category' "$(cat -- "$WORK_DIR/stderr")"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" \
    GLOT_DELEGATE_COP='copilot -C {module_dir} -p "$(cat)" --add-dir {root}' \
    "$GLOT_SH" ask -n --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'set antigravity-model: el de Copilot sigue saliendo del perfil' 'COPILOT_MODEL=claude-sonnet-5' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" doctor 2>/dev/null || true)"
assert_contains 'set antigravity-model: doctor informa del alias fijado' 'antigravity_model_state: gemini' "$out"

# v1.7.3: el delegado de Copilot tiene su propia clave, `copilot-model`, y sus alias son ids de
# **OpenRouter**: es la vía de los encargos que no son de contrato, suite ni implementación
# (andamiaje, corrección y documentación). El alias **solo** sustituye a los modelos que ya son de
# OpenRouter: `gpt-5.6-terra` y `claude-sonnet-5` no llevan `/` y no se tocan.
COP_LINE='printf "P=%s|M=%s\n" "${COPILOT_PROVIDER_BASE_URL:-vacio}" "$COPILOT_MODEL"; cat >/dev/null'
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model default >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: default es Flash nativo' 'P=vacio|M=gemini-3.8-flash' "$out"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" unset copilot-model >/dev/null 2>&1
# el alias no toca lo que ya estaba: terra (contrato y suite) ni sonnet (implementación)
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot contract_stub php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: contrato usa Terra 6.1 vigente' 'P=vacio|M=gpt-6.1-terra' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: no cambia el modelo de la implementación (deep)' 'P=vacio|M=claude-sonnet-5.5' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test COPILOT_PROVIDER_BASE_URL=https://otro.example/v1 \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: ruta nativa no hereda endpoint externo' 'P=vacio|M=gemini-3.8-flash' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    env -u COPILOT_PROVIDER_API_KEY -u COPILOT_PROVIDER_BASE_URL \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>"$WORK_DIR/stderr" || true)"
assert_eq 'copilot-model: ruta nativa sin clave BYOK' 'P=vacio|M=gemini-3.8-flash' "$out"
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'copilot-model: anuncia ruta nativa' 'cop gemini-3.8-flash' "$err"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model kimi >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" -n ask --delegate copilot contract_stub php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'copilot-model: Kimi nativo para balanced' 'COPILOT_MODEL=kimi-k3' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" doctor 2>/dev/null || true)"
assert_contains 'copilot-model: doctor informa del id nativo fijado' 'copilot_model_state: kimi-k3' "$out"
# el esfuerzo del perfil viaja en la orden publicada, que es lo que lo hace efectivo: `low` en los
# encargos de OpenRouter y en el contrato, `high` en la implementación
COP_PUB='copilot -C {module_dir} -p "$(cat)" --add-dir {root} --allow-all-tools --reasoning-effort {effort}'
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_PUB" \
    "$GLOT_SH" -n ask --delegate copilot contract_stub php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'el esfuerzo balanced llega a la orden' '--reasoning-effort low' "$out"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" unset copilot-model >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_PUB" \
    "$GLOT_SH" -n ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'el esfuerzo de la implementación llega a la orden' '--reasoning-effort medium' "$out"
# sin clave de estado, el encargo de OpenRouter usa el modelo del perfil (y su proveedor)
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" unset copilot-model >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model sin fijar: manda el modelo del perfil' 'P=vacio|M=gemini-3.8-flash' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'un perfil de Copilot no toca el proveedor' 'P=vacio|M=claude-sonnet-5.5' "$out"
rc_bad=0
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model nope >/dev/null 2>&1 || rc_bad=$?
assert_eq 'set copilot-model con alias inválido: código' '2' "$rc_bad"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model nope 2>"$WORK_DIR/stderr" >/dev/null || true
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'set copilot-model con alias inválido: lista los válidos' 'default gemini argon terra sol kimi sonnet opus' "$err"

# v2.1.0: rutas explícitas, políticas compartidas y aislamiento sin inferencia.
route_run() {
    rc_last=0
    out="$(env -u GLOT_MODEL -u GLOT_MODEL_COP -u GLOT_MODEL_OR -u GLOT_EFFORT \
        -u COPILOT_PROVIDER_BASE_URL -u COPILOT_PROVIDERS_CONFIG \
        GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$WORK_DIR/route-state" \
        GLOT_DELEGATE_COP='cat >/dev/null; printf "%s|%s|%s|%s|%s|%s\n" "$GLOT_DELEGATE_ROUTE" "$COPILOT_MODEL" "${COPILOT_PROVIDER_BASE_URL:-native}" "${COPILOT_PROVIDER_MAX_PROMPT_TOKENS:--}" "${COPILOT_PROVIDER_MAX_OUTPUT_TOKENS:--}" "$GLOT_DELEGATE_EFFORT"' \
        COPILOT_PROVIDER_API_KEY=glot-test-placeholder \
        "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc_last=$?
    err="$(cat -- "$WORK_DIR/stderr")"
}
route_run ask --delegate open-router docs-module php algorithms/naive_sort
assert_eq 'OR: modelo/endpoint/límites/esfuerzo exactos' \
    'open-router|qwen/qwen3.7-plus|https://openrouter.ai/api/v1|131072|32768|-' "$out"
assert_eq 'OR: default sin esfuerzo artificial' '0' "$rc_last"
route_run ask --delegate open-router --effort low docs-module php algorithms/naive_sort
assert_eq 'OR Plus: effort explícito bloquea' '2' "$rc_last"
assert_contains 'OR Plus: effort tiene diagnóstico' 'does not support effort' "$err"
route_run ask --delegate open-router --model argon --effort high docs-module php algorithms/naive_sort
assert_eq 'OR Argon: identidad real, no familia fingida' \
    'open-router|google/gemini-4-argon|https://openrouter.ai/api/v1|131072|32768|high' "$out"
route_run ask --delegate open-router --model argon scaffold php algorithms/naive_sort
assert_eq 'OR Argon: solo documentación' '2' "$rc_last"
route_run ask --delegate open-router implement php algorithms/naive_sort
assert_eq 'OR: sin default deep no inventa modelo' '1' "$rc_last"
route_run ask --delegate copilot --model argon docs-module php algorithms/naive_sort
assert_eq 'Copilot Argon: no activa BYOK por identidad' 'cop|gemini-4-argon|native|-|-|low' "$out"
route_run ask --delegate copilot --model sol contract_stub php algorithms/naive_sort
assert_eq 'Sol: balanced nativo' 'cop|gpt-6.1-sol|native|-|-|low' "$out"
route_run ask --delegate copilot --model terra contract_stub php algorithms/naive_sort
assert_eq 'Terra: alias selecciona 6.1 y nunca 5.6' 'cop|gpt-6.1-terra|native|-|-|low' "$out"
route_run ask --delegate copilot --model opus suite php algorithms/naive_sort
assert_eq 'Opus: suite deep nativa' 'cop|claude-opus-5.5|native|-|-|medium' "$out"
route_run ask --delegate copilot --model terra docs-module php algorithms/naive_sort
assert_eq 'Terra: no se cuela en docs' '2' "$rc_last"
route_run ask --delegate copilot --model qwen/qwen3.7-plus docs-module php algorithms/naive_sort
assert_eq 'Copilot: id BYOK no cambia ruta implícitamente' '2' "$rc_last"
route_run ask --delegate copilot --effort invented implement php algorithms/naive_sort
assert_eq 'Copilot: effort desconocido bloquea' '2' "$rc_last"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$WORK_DIR/no-route-state" GLOT_DELEGATE_COP="$COP_LINE" \
    COPILOT_PROVIDER_BASE_URL=https://unrelated.example/v1 \
    "$GLOT_SH" -n ask --delegate open-router docs-module php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || true
assert_contains 'OR: endpoint heredado distinto bloquea' 'endpoint conflicts' "$(cat -- "$WORK_DIR/stderr")"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$WORK_DIR/no-route-state" GLOT_DELEGATE_COP="$COP_LINE" \
    COPILOT_PROVIDER_BASE_URL=https://unrelated.example/v1 COPILOT_PROVIDER_WIRE_MODEL=foreign \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || true
assert_eq 'Copilot: limpia proveedor aunque heredado' 'P=vacio|M=gemini-3.8-flash' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$WORK_DIR/no-route-state" GLOT_DELEGATE_COP=cat \
    GLOT_EFFORT=high "$GLOT_SH" -n ask --delegate copilot --effort low implement php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || true
assert_contains 'effort: flag gana a entorno' 'effort=low' "$out"
printf 'copilot-model=default\n' >"$WORK_DIR/route-state"
route_run ask --delegate copilot docs-module php algorithms/naive_sort
assert_eq 'estado legacy: alias ambiguo bloquea' '2' "$rc_last"
assert_contains 'estado legacy: explica migración' 'ambiguous legacy' "$err"
route_run ask --delegate copilot --model gemini docs-module php algorithms/naive_sort
assert_eq 'estado legacy: override explícito resuelve sin mutar' '0' "$rc_last"
rm -- "$WORK_DIR/route-state"

# v1.7.2: `aider-model` deja de ser clave reservada, así que ya no se valida contra el
# catálogo: `set` la guarda como cualquier clave del autor.
rc_bad=0
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set aider-model nope >/dev/null 2>&1 || rc_bad=$?
assert_eq 'set aider-model (ya no reservada en v1.7.2): se guarda como clave del autor' '0' "$rc_bad"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" unset aider-model >/dev/null 2>&1

# v1.7.1: el marcador `{spec}` se resuelve en la orden del delegado (lo usó la línea de aider
# para dar a Aider las fuentes por `--read`); el resto de marcadores sigue resolviéndose.
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP='echo {root}|{module_dir}|{spec}|{model}' \
    "$GLOT_SH" ask -n --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'copilot: `{spec}` se resuelve a la especificación' '05_Naive_Sort.md' "$out"
assert_contains 'copilot: `{module_dir}` se resuelve al módulo' '/php/core/algorithms/naive_sort' "$out"

# doctor informa de las plantillas, los catálogos y los delegados
glot_run doctor
assert_contains 'doctor: carpeta de plantillas' 'prompts: ' "$out"
assert_contains 'doctor: registro de encargos' 'prompts_ok: 11 encargos / requests' "$out"
assert_contains 'doctor: catálogo de delegados' 'delegates_file: ' "$out"
assert_contains 'doctor: alias por delegado' 'delegate_aliases: 14 alias / aliases (2 de AGY, 8 de Copilot, 4 de OpenRouter)' "$out"
assert_contains 'doctor: delegado COP sin configurar' 'delegate_cop: (sin configurar / not configured)' "$out"
assert_contains 'doctor: delegado AGY sin configurar' 'delegate_agy: (sin configurar / not configured)' "$out"
assert_eq 'doctor: ya no informa de un delegado aider (v1.7.2)' 'no' \
    "$([[ "$out" == *delegate_aider* ]] && echo si || echo no)"

# --- casos de la especificación v0.9.0 (L5, creación y registro) -------------

DATA_DIR="$TESTS_DIR/../data"

# el catálogo de inicialización es dato, y el dato tiene que cuadrar
assert_eq 'catálogo de inicialización: 4 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 4' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: tipos válidos' '0' \
    "$(awk -F'\t' '$2 != "tool" && $2 != "manual"' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"
# v2.0.0: `init_sequences.tsv` es la única fuente del esqueleto, así que cada lenguaje del
# catálogo tiene que traer sus dos fases: la carpeta (`new`) y la estructura (`scaffold`).
assert_eq 'catálogo de inicialización: cada lenguaje con su fase new' '0' \
    "$(comm -23 <(cut -f1 "$DATA_DIR/languages.tsv" | sort) \
                  <(awk -F'\t' 'FNR > 1 && $2 == "new" {print $1}' "$DATA_DIR/init_sequences.tsv" | sort -u) | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: cada lenguaje con su fase scaffold' '0' \
    "$(comm -23 <(cut -f1 "$DATA_DIR/languages.tsv" | sort) \
                  <(awk -F'\t' 'FNR > 1 && $2 == "scaffold" {print $1}' "$DATA_DIR/init_sequences.tsv" | sort -u) | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: la secuencia es de lenguajes del catálogo' '0' \
    "$(comm -13 <(cut -f1 "$DATA_DIR/languages.tsv" | sort) \
                  <(awk -F'\t' 'FNR > 1 {print $1}' "$DATA_DIR/init_sequences.tsv" | sort -u) | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: 9 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 9' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: fases válidas' '0' \
    "$(awk -F'\t' 'FNR > 1 && $2 != "new" && $2 != "scaffold"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: directorios de trabajo válidos' '0' \
    "$(awk -F'\t' 'FNR > 1 && $4 != "module" && $4 != "phase"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: modos válidos' '0' \
    "$(awk -F'\t' 'FNR > 1 && $5 != "run" && $5 != "expect" && $5 != "manual"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: modo expect con requisito expect' '0' \
    "$(awk -F'\t' '$5 == "expect" && $7 != "expect"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
# v1.3.0, en v2 por fase: el orden tiene que ser 1..n **dentro de cada fase**. Un hueco o
# un repetido rompe el plan sin que nadie lo note.
assert_eq 'secuencias de inicialización: órdenes contiguos por fase' '0' \
    "$(awk -F'\t' 'FNR > 1 {k = $1 "/" $2; rows[k]++; if ($3 > top[k]) top[k] = $3} END {for (k in rows) if (rows[k] != top[k]) bad++; print bad + 0}' "$DATA_DIR/init_sequences.tsv")"
# la novena columna no puede quedar vacía: una fila corta desplaza el completado a
# «respuestas» y lo silencia (medido el 2026-09-26: 3 filas de Ada con 7 campos)
assert_eq 'secuencias de inicialización: la columna 9 nunca queda vacía' '0' \
    "$(awk -F'\t' '$9 == ""' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
# El generador **plano** de Common Lisp quedó fuera del dato (v1.6.1): `cl-project` es el
# de la comunidad y deja `src/` y `tests/`, pero **exige un *pathname*** —con una cadena
# abre el depurador—, así que el `#p` no es opcional (medido el 2026-09-29 y el 2026-09-30).
assert_eq 'secuencias: common-lisp genera con cl-project y con pathname' '1' \
    "$(awk -F'\t' '$1 == "common-lisp" && index($6, "cl-project:make-project") > 0 && index($6, "#p") > 0 {print "1"}' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias: sin el generador plano de common-lisp' '' \
    "$(awk -F'\t' 'index($6, "quickproject") > 0 {print $1}' "$DATA_DIR/init_sequences.tsv")"
# el catálogo de commits: paso, alias, ámbito y mensaje
assert_eq 'catálogo de commits: 4 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 4' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de commits: ámbitos válidos' '0' \
    "$(awk -F'\t' '$3 != "submodule" && $3 != "monorepo"' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de commits: mensajes en Conventional Commits' '0' \
    "$(awk -F'\t' '$4 !~ /^(feat|fix|docs|chore|refactor|test|build)\(/ && $4 !~ /^(feat|fix|docs|chore|refactor|test|build):/' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"

# deriva: cada mensaje del catálogo tiene que estar en la tabla del sprint
# (la tabla es la fuente; el catálogo, la copia que usa `save`)
drift=0
drift_lines=""
while IFS=$'\t' read -r step alias scope message; do
    if ! grep -qF -- "\`$message\`" "$TESTS_DIR/../docs/SPRINT.md"; then
        drift=$((drift + 1))
        drift_lines+="$step "
    fi
done < <(awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$4}' "$DATA_DIR/commits.tsv")
assert_eq 'catálogo de commits: deriva con la tabla del sprint' '0' "$drift"
assert_eq 'catálogo de commits: sin mensajes huérfanos' '' "$drift_lines"

# deriva: cada alias de un paso del submódulo tiene que ser un encargo registrado,
# y los pasos del monorepo tienen que ser los que aún no se confirman aquí
orphans=""
monorepo_steps=""
while IFS=$'\t' read -r step alias scope message; do
    if [[ "$scope" == "monorepo" ]]; then
        monorepo_steps+="$step "
        continue
    fi
    [[ "$alias" == "-" ]] && continue
    glot_run prompt
    printf '%s\n' "$out" | cut -f1 | grep -qx -- "$alias" || orphans+="$step:$alias "
done < <(awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$4}' "$DATA_DIR/commits.tsv")
assert_eq 'catálogo de commits: alias registrados como encargo' '' "$orphans"
assert_eq 'catálogo de commits: los pasos del monorepo' '9 10 ' "$monorepo_steps"

# las plantillas son genéricas: los casos y los nombres salen de la especificación y de los
# módulos homologados, nunca del módulo que se estaba trabajando al escribir la plantilla
PROMPTS_DIR="$TESTS_DIR/../prompts"
assert_eq 'plantillas: sin los casos del módulo 05 dentro' '0' \
    "$(grep -rl '5, 2, 9, 1, 5, 6' "$PROMPTS_DIR" | wc -l | tr -d ' ')"
assert_eq 'plantillas: sin el id de un módulo concreto' '0' \
    "$(grep -rl 'naive_sort' "$PROMPTS_DIR" | wc -l | tr -d ' ')"
assert_eq 'plantillas: sin un nombre de módulo en PascalCase' '0' \
    "$(grep -rl 'NaiveSort' "$PROMPTS_DIR" | wc -l | tr -d ' ')"

# el encargo de la suite tiene que decir de dónde salen los casos y cómo se traducen
suite_prompt="$(cat -- "$PROMPTS_DIR/suite.prompt.md")"
assert_contains 'suite: extrae los casos de la especificación' 'Casos de prueba' "$suite_prompt"
assert_contains 'suite: la especificación es la autoridad de los casos' 'autoridad única de los casos' "$suite_prompt"
assert_contains 'suite: decide el tipo de secuencia del lenguaje' 'Tipo de secuencia' "$suite_prompt"
assert_contains 'suite: prohíbe inventar los casos' 'sustituyas por una lista inventada' "$suite_prompt"
assert_contains 'suite: declara las adaptaciones' 'La adaptación se declara' "$suite_prompt"
assert_contains 'suite: usa el contrato del paso 4b' 'encargo `contract_stub`, paso 4b' "$suite_prompt"
assert_contains 'suite: no declara el contrato por su cuenta' 'no los declara' "$suite_prompt"
assert_contains 'suite: el contrato ya deja esqueletos' 'contrato con sus esqueletos' "$suite_prompt"
assert_contains 'suite: el enlace roto es defecto del 4b' 'defecto del paso 4b' "$suite_prompt"

# 2026-10-17: la salida del 4c es la **fase roja** con cuatro datos, no un «falla» genérico. El
# caso que faltaba es el de los casos base, que **coinciden con el centinela** y pasan por
# casualidad: medido en `data_structures_advanced`, 2 de 17 tests salían verdes contra el contrato
# en stubs. Se declaran, no se tocan, para que el paso 5 compruebe que el conjunto no crece.
assert_contains 'suite: la salida es la fase roja' 'Verificación: la fase roja' "$suite_prompt"
assert_contains 'suite: exige tests ejecutados' 'cero tests**' "$suite_prompt"
assert_contains 'suite: distingue casos de contadores del framework' 'N casos o escenarios cubiertos y K tests ejecutados' "$suite_prompt"
assert_contains 'suite: separa aserción de excepción' 'Assertion_Error' "$suite_prompt"
assert_contains 'suite: declara los verdes por centinela' 'coinciden con el centinela' "$suite_prompt"
assert_contains 'suite: el defecto de la propia suite se corrige aquí' 'Corrígelo aquí y repite' "$suite_prompt"
assert_contains 'suite: el triaje manda la construcción al 4d' 'es el disparador del paso 4d' "$suite_prompt"

# el encargo de build es **condicional**: solo entra cuando el 4c no pudo alcanzar la fase roja
# (medido: cero commits del paso 4d en los cincuenta submódulos, y los enganches de pruebas los
# deja el andamiaje), y su éxito es la misma terna de datos.
build_prompt="$(cat -- "$PROMPTS_DIR/build.prompt.md")"
assert_contains 'build: el paso no es fijo' 'no es fijo' "$build_prompt"
assert_contains 'build: lo dispara un fallo de construcción no previsto en 4c' \
    'Este paso **no es fijo**: solo se' "$build_prompt"
assert_contains 'build: su éxito son los cuatro datos' 'cuatro datos' "$build_prompt"

# v1.5.0: el encargo del contrato se llama `contract_stub` y exige, además del contrato,
# el **esqueleto** de cada operación, para que el `4c` compile y enlace aunque el algoritmo
# sea del paso 5 (era el bloqueo que detuvo dos veces al delegado del `4c`)
contract_prompt="$(cat -- "$PROMPTS_DIR/contract_stub.prompt.md")"
assert_contains 'contract_stub: declara la entrada' '**Entrada**' "$contract_prompt"
assert_contains 'contract_stub: declara lo que queda fuera' '**Fuera de alcance**' "$contract_prompt"
assert_contains 'contract_stub: usa el indicador natural' 'indicador natural' "$contract_prompt"
assert_contains 'contract_stub: una firma por función' 'una firma por función' "$contract_prompt"
assert_contains 'contract_stub: exige el esqueleto de cada operación' 'esqueleto de cada operación' "$contract_prompt"
assert_contains 'contract_stub: el módulo compila y enlaza' 'compilar y enlazar' "$contract_prompt"
assert_contains 'contract_stub: el esqueleto no es implementación' 'resuelve ningún caso' "$contract_prompt"
assert_contains 'contract_stub: no escribe la suite' 'encargo `suite` (paso 4c)' "$contract_prompt"
assert_eq 'contract_stub: el encargo viejo ya no existe' '0' \
    "$(grep -c 'encargo `contract`' "$PROMPTS_DIR/contract_stub.prompt.md" || true)"

# el encargo del esqueleto declara su contrato y parte de lo que dejó `new`
scaffold_prompt="$(cat -- "$PROMPTS_DIR/scaffold.prompt.md")"
assert_contains 'scaffold: declara la entrada' '**Entrada**' "$scaffold_prompt"
assert_contains 'scaffold: declara lo que queda fuera' '**Fuera de alcance**' "$scaffold_prompt"
assert_contains 'scaffold: parte de lo que dejó new' 'glot new' "$scaffold_prompt"
assert_contains 'scaffold: no escribe la suite' 'encargo `suite`' "$scaffold_prompt"

# v1.5.0: el andamiaje regenera el índice de fuentes del lenguaje (medido el 2026-09-28: el
# `composer require` de `new` deja el classmap del `src/` vacío y la suite no ve la clase)
assert_contains 'scaffold: regenera el índice de fuentes' 'composer dump-autoload' "$scaffold_prompt"

# v1.3.0: el runner es del 4a. La frontera tiene que estar en un solo sitio, así que el caso
# comprueba las **dos mitades**: el esqueleto lo deja arrancando y la suite no lo crea.
# Medido el 2026-09-26 en `assembly`: el manifiesto era del 4a, el runner nunca se generó y
# `make build` se paró en el enlace (`ld: undefined reference to 'tests_failed'`).
assert_contains 'scaffold: el runner se completa en 4a' 'runner vacío ejecutable' "$scaffold_prompt"
assert_contains 'scaffold: exige que arranque sin casos' 'arranca sin casos' "$scaffold_prompt"
assert_contains 'scaffold: lo escribe si el framework no lo trae' 'escríbelo aquí' "$scaffold_prompt"
assert_eq 'suite: ya no dice que crea el runner' 'no' \
    "$([[ "$suite_prompt" == *'Si el framework no incluye runner propio'* ]] && echo si || echo no)"
assert_contains 'suite: conecta los grupos al runner de 4a' \
    'grupos reales al runner existente' "$suite_prompt"
assert_contains 'suite: no reemplaza infraestructura de pruebas' \
    'no se crea ni reemplaza la infraestructura de pruebas' "$suite_prompt"
assert_contains 'suite: runner ausente se reporta a 4a' \
    'reporta el defecto del paso 4a' "$suite_prompt"
assert_contains 'suite: no cruza casos de contratos distintos' 'Solo implementaciones alternativas del mismo contrato' "$suite_prompt"
assert_contains 'suite: admite escenarios de estado' 'Un test de escenario con estado propio' "$suite_prompt"
assert_contains 'correct: integra runner del módulo' '| Suite y runner del módulo | `4c` |' \
    "$(cat -- "$PROMPTS_DIR/correct.prompt.md")"
assert_contains 'correct: corrige construcción del 4d' '| Construcción y enlace | `4d` |' \
    "$(cat -- "$PROMPTS_DIR/correct.prompt.md")"
glot_run help save
assert_contains 'help save: distingue build' '4d (construcción/build)' "$out"
assert_contains 'help save: distingue correct' '4e (corrección/correct)' "$out"
assert_contains 'suite: cero casos se corrige conectando grupos al runner' \
    'Conecta los grupos de la suite al runner existente' "$suite_prompt"
assert_contains 'build: no sustituye un runner faltante' \
    'reporta el defecto del paso responsable' "$build_prompt"
assert_contains 'SPRINT: el 4a deja el runner arrancando' 'mínimo arrancando sin casos' \
    "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"
assert_contains 'SPRINT: el 4c conecta casos al runner de 4a' \
    'los conecta al runner mínimo del 4a' "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"
assert_contains 'SPRINT: registra el diagnóstico sin enlace del contrato' \
    'compilación sin enlace' "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"

# Quien comprueba que el encargo del README no vuelva a enumerar las secciones de la
# plantilla es `docs/tests/docs_check.sh`: allí se lee la plantilla, que es un documento.

# la plantilla de validación define el contrato del veredicto que `validate` lee
validate_prompt="$(cat -- "$PROMPTS_DIR/validate.prompt.md")"
assert_contains 'validate: la plantilla exige el veredicto legible' 'glot:validate verdict=clean findings=0' "$validate_prompt"
assert_contains 'validate: la plantilla exige la otra forma' 'glot:validate verdict=findings findings=' "$validate_prompt"
assert_contains 'validate: la plantilla se declara de solo lectura' 'solo lectura' "$validate_prompt"

# el autocompletado completa los pasos de `save` y no solo los verbos. La llamada
# va en su propio shell: el listado de pasos sale de un verbo que devuelve 2 (es
# la firma de `save` sin paso), y con `set -e` y `pipefail` no puede tumbar aquí.
save_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot save ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_contains 'completion bash: pasos de save' '4a' "$save_comp"
assert_contains 'completion bash: el contrato como paso propio' 'contract_stub' "$save_comp"
assert_contains 'completion bash: la suite se desplaza a 4c' '4c' "$save_comp"
assert_contains 'completion bash: alias de los pasos' 'scaffold' "$save_comp"
# v1.6.2: el cierre también se confirma con `save`, así que sus pasos y alias se ofrecen
assert_eq 'completion bash: los pasos del monorepo están' 'si' \
    "$(printf '%s\n' "$save_comp" | grep -qx '9' && printf '%s\n' "$save_comp" | grep -qx '10' && echo si || echo no)"
assert_contains 'completion bash: el alias del puntero' 'pointer' "$save_comp"
assert_contains 'completion bash: el alias del cierre' 'close' "$save_comp"
assert_eq 'completion bash: un candidato por línea' '26' "$(printf '%s\n' "$save_comp" | wc -l | tr -d ' ')"

# v1.6.2: `get`/`set`/`unset` complean **todas** las claves reservadas. La lista vive en tres
# sitios —el completado de bash, el de zsh y la ayuda del verbo— y estos casos la mantienen
# alineada: una clave nueva con un sitio olvidado es el fallo que dejó `target`, `cause` y
# `model` fuera del completado.
keys_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot get ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: las diez claves reservadas' \
    'antigravity-model branch cause copilot-model lang module open-router-model phase repo spec target' \
    "$(printf '%s\n' "$keys_comp" | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')"
assert_contains 'completion zsh: la misma lista de claves' \
    'lang phase module branch spec repo target cause antigravity-model copilot-model' "$(cat -- "$TESTS_DIR/../completions/glot.zsh")"
glot_run help set
assert_contains 'help set: la misma lista de claves' \
    'lang, phase, module, branch, spec, repo, target, cause, antigravity-model, copilot-model' "$out"

# v1.6.3/v1.7.0: `set` también se completa (le faltaba la rama entera), y tras cada clave de
# modelo salen los **alias** de su delegado en vivo (`glot delegates`), como los lenguajes
# salen de `langs`.
set_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot set ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: `set` completa las claves' \
    'lang phase module branch spec repo target cause antigravity-model copilot-model open-router-model' \
    "$(printf '%s\n' "$set_comp" | tr '\n' ' ' | sed 's/ $//')"
set_agy_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot set antigravity-model ""); COMP_CWORD=3; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
glot_run delegates agy
assert_eq 'completion bash: `set antigravity-model` completa los alias de AGY del catálogo' \
    "$(printf '%s\n' "$out" | cut -f2)" "$set_agy_comp"
# v1.7.3: la clave de Copilot completa los suyos, que salen del mismo catálogo
set_cop_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot set copilot-model ""); COMP_CWORD=3; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
glot_run delegates copilot
assert_eq 'completion bash: `set copilot-model` completa los alias de Copilot del catálogo' \
    "$(printf '%s\n' "$out" | cut -f2)" "$set_cop_comp"
delegates_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot delegates ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: las tres rutas del catálogo' 'agy copilot open-router' \
    "$(printf '%s\n' "$delegates_comp" | tr '\n' ' ' | sed 's/ $//')"
verb_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot mod); COMP_CWORD=1; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: los dos verbos del catálogo' 'modules
models' "$verb_comp"

# v1.7.0: `finish` entra en el autocompletado, con su lenguaje y su módulo como `close`
finish_verb_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot fin); COMP_CWORD=1; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: el verbo finish está' 'finish' "$finish_verb_comp"
finish_pos_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot finish ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
glot_run langs
assert_eq 'completion bash: `finish` completa el lenguaje' "$(printf '%s\n' "$out" | cut -f1)" "$finish_pos_comp"

# v1.1.0: los encargos se complean **en vivo** desde el registro, así que la lista no puede
# quedarse corta al añadir una plantilla (el fallo que dejaba `scaffold` sin descubrir)
prompt_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot prompt ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
glot_run prompt
assert_eq 'completion bash: los encargos salen del registro' \
    "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort)" \
    "$(printf '%s\n' "$prompt_comp" | LC_ALL=C sort)"
assert_contains 'completion bash: el contrato entre los encargos' 'contract_stub' "$prompt_comp"

# new: con herramienta, el plan es el comando del catálogo y el directorio del módulo
glot_run -n new php algorithms/naive_sort
assert_eq 'new tool -n: código' '0' "$rc_last"
assert_contains 'new tool -n: comando del catálogo' 'cd ' "$out"
assert_contains 'new tool -n: crea la carpeta del módulo' 'mkdir -p naive_sort' "$out"
assert_contains 'new tool -n: imprime la ruta como dato' '/php/core/algorithms/naive_sort' "$out"

glot_run -n new haskell algorithms/naive_sort
assert_eq 'new Haskell -n: código' '0' "$rc_last"
assert_contains 'new Haskell -n: genera el test-suite de Cabal' 'cabal init --lib --tests' "$out"

# new: la normalización declarada se enseña en el plan
glot_run -n new crystal algorithms/naive_sort
assert_eq 'new -n: sin restos de normalización' '' "$(printf '%s\n' "$out" | grep -E 'flat:|rm:' || true)"
glot_run -n new erlang algorithms/naive_sort
assert_contains 'new -n: aplanar el nido' 'rebar3 new lib naive_sort' "$out"

# v1.3.0: los flags globales valen en **cualquier** posición. Medido el 2026-09-26:
# `glot new -n ada …` → `opción desconocida: -n` y `glot save -n 4a …` tomaba `-n` por el paso.
glot_run new -n php algorithms/naive_sort
assert_eq 'new -n detrás del verbo: código' '0' "$rc_last"
assert_contains 'new -n detrás del verbo: imprime el plan' 'cd ' "$out"
glot_run new --dry-run php algorithms/naive_sort
assert_eq 'new --dry-run detrás del verbo: código' '0' "$rc_last"
assert_contains 'new --dry-run detrás del verbo: imprime el plan' 'cd ' "$out"
glot_run new -x -n php algorithms/naive_sort
assert_eq 'new: la opción desconocida sigue dando 2' '2' "$rc_last"

# new: sin inicializador validado no se inventa nada: skipped, como verify. El
# v2: el esqueleto solo lo declara `init_sequences.tsv`; un lenguaje sin fila `new` es un
# catálogo incompleto y `new` **no adivina** la carpeta: frena con código 1 y remite al dato.
# Se prueba con un catálogo inyectado al que se le quita la fila.
sandbox_make
glot_run_sandbox use python algorithms/naive_sort
assert_eq 'new sin secuencia: use deja el módulo' '0' "$rc_last"

BLANK_DIR="$WORK_DIR/sin-secuencia"
mkdir -p "$BLANK_DIR"
cp -- "$DATA_DIR/languages.tsv" "$BLANK_DIR/languages.tsv"
awk -F'\t' 'BEGIN {OFS="\t"} $1 != "python" || $2 != "new"' \
    "$DATA_DIR/init_sequences.tsv" >"$BLANK_DIR/init_sequences.tsv"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_DATA_DIR="$BLANK_DIR" "$GLOT_SH" new python algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'new sin secuencia: código' '1' "$rc_last"
assert_contains 'new sin secuencia: lo explica' 'steps in the catalogue' "$err"
assert_contains 'new sin secuencia: remite al dato' 'scripts/data/init_sequences.tsv' "$err"

# v1.3.0, en v2 por fase: el completado del dato (columna 9) tiene que llegar al autor.
# Antes se imprimía dentro del bucle de pasos y la salida de los propios comandos se lo
# comía; medido el 2026-09-26, el `tests/alire.toml` de Ada quedó sin `[[depends-on]]`,
# `[[pins]]` ni `aunit` hasta aplicarlo a mano. Ahora va en un bloque al final, y este caso
# lo comprueba con un dato inyectado (el comando es `mkdir`, así que no depende de la red).
SEQ_DIR="$WORK_DIR/sequence-data"
mkdir -p "$SEQ_DIR"
cp -R "$DATA_DIR/." "$SEQ_DIR/"
awk -F'\t' 'BEGIN {OFS="\t"} NR == 1 || !($1 == "java" && $2 == "new")' \
    "$DATA_DIR/init_sequences.tsv" >"$SEQ_DIR/init_sequences.tsv"
printf 'java\tnew\t1\tmodule\trun\tmkdir -p src test\t-\t-\tnota-de-completado-de-prueba\n' \
    >>"$SEQ_DIR/init_sequences.tsv"
glot_run_sandbox use java algorithms/naive_sort
assert_eq 'new con secuencia: use deja el módulo' '0' "$rc_last"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_DATA_DIR="$SEQ_DIR" "$GLOT_SH" new java algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'new con secuencia: código' '0' "$rc_last"
assert_contains 'new: el completado se anuncia al final' 'left to complete' "$err"
assert_contains 'new: el completado llega con su nota' 'nota-de-completado-de-prueba' "$err"
assert_contains 'new: el completado va numerado por su paso' '[1]' "$err"

# new: errores de objetivo y de argumentos
glot_run -n new php algorithms/nope
assert_eq 'new con módulo desconocido: código' '1' "$rc_last"
glot_run -n new nope algorithms/naive_sort
assert_eq 'new con lenguaje fuera de .gitmodules: código' '1' "$rc_last"
glot_run -n new php algorithms/naive_sort extra
assert_eq 'new con demasiados argumentos: código' '2' "$rc_last"
glot_run -n new php algorithms/naive_sort -x
assert_eq 'new con opción desconocida: código' '2' "$rc_last"

# new: ejecución real en el sandbox (v2: `new` crea la carpeta y `scaffold` la estructura).
# Se usa `java` porque su comando es `mkdir` y no depende de la red; `ruby` tiene
# secuencia con Bundler y se reserva para `save`.
sandbox_make
glot_run_sandbox use ruby algorithms/naive_sort
assert_eq 'sandbox new: use deja el módulo' '0' "$rc_last"
glot_run_sandbox use java algorithms/naive_sort
assert_eq 'sandbox new: use deja el módulo de java' '0' "$rc_last"

RB="$SANDBOX/ruby/core/algorithms/naive_sort"
JB="$SANDBOX/java/core/algorithms/naive_sort"
glot_run_sandbox new java algorithms/naive_sort
assert_eq 'sandbox new: código' '0' "$rc_last"
assert_eq 'sandbox new: dato = ruta del módulo' "$JB" "$out"
assert_eq 'sandbox new: crea la carpeta vacía' 'si' "$([[ -d "$JB" && -z "$(ls -A "$JB")" ]] && echo si || echo no)"
glot_run_sandbox scaffold java algorithms/naive_sort
assert_eq 'sandbox scaffold: código' '0' "$rc_last"
assert_eq 'sandbox scaffold: crea package Java' 'si' "$([[ -f "$JB/src/main/java/naive_sort/NaiveSort.java" ]] && echo si || echo no)"
assert_eq 'sandbox scaffold: declara package Java' 'package naive_sort;' "$(head -n 1 "$JB/src/main/java/naive_sort/NaiveSort.java")"
assert_contains 'sandbox scaffold: genera POM con JUnit' '<artifactId>junit-jupiter</artifactId>' "$(cat "$JB/pom.xml")"
assert_eq 'sandbox scaffold: POM Maven no vacío' 'si' "$([[ -s "$JB/pom.xml" ]] && echo si || echo no)"
assert_eq 'sandbox scaffold: ignora target' 'target/' "$(cat "$JB/.gitignore")"
assert_eq 'sandbox scaffold: crea package de tests' 'si' "$([[ -d "$JB/src/test/java/naive_sort" ]] && echo si || echo no)"
assert_eq 'sandbox scaffold: no escribe la suite' '0' "$(find "$JB/src/test/java" -type f | wc -l | tr -d ' ')"
printf 'authored class\n' >"$JB/src/main/java/naive_sort/NaiveSort.java"
printf 'authored pom\n' >"$JB/pom.xml"
glot_run_sandbox scaffold java algorithms/naive_sort
assert_eq 'sandbox scaffold repetido: conserva clase' 'authored class' \
    "$(cat "$JB/src/main/java/naive_sort/NaiveSort.java")"
assert_eq 'sandbox scaffold repetido: conserva POM' 'authored pom' "$(cat "$JB/pom.xml")"

JSB="$SANDBOX/javascript/core/algorithms/naive_sort"
mkdir -p -- "$JSB"
cat >"$JSB/package.json" <<'EOF'
{
  "name": "naive_sort",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
EOF
glot_run_sandbox scaffold javascript algorithms/naive_sort
assert_eq 'sandbox scaffold JavaScript: código' '0' "$rc_last"
assert_contains 'sandbox scaffold JavaScript: configura test' '"test": "jest"' "$(cat "$JSB/package.json")"
assert_contains 'sandbox scaffold JavaScript: declara Jest' '"jest": "^30.0.5"' "$(cat "$JSB/package.json")"
assert_contains 'sandbox scaffold JavaScript: ajusta main' '"main": "src/naive_sort.js"' "$(cat "$JSB/package.json")"
assert_eq 'sandbox scaffold JavaScript: no fuerza ESM' 'no' \
    "$([[ "$(node -p 'require(process.argv[1]).type || ""' "$JSB/package.json")" == module ]] && echo si || echo no)"
assert_contains 'sandbox scaffold JavaScript: configura descubrimiento' '"**/test/**/*.test.js"' "$(cat "$JSB/jest.config.js")"
assert_eq 'sandbox scaffold JavaScript: ignora dependencias' 'node_modules/' "$(cat "$JSB/.gitignore")"
cat >"$JSB/package.json" <<'EOF'
{
  "name": "naive_sort",
  "version": "1.0.0",
  "main": "src/naive_sort.js",
  "scripts": {
    "test": "node custom-runner.js"
  },
  "devDependencies": {
    "jest": "^30.0.5"
  },
  "private": true
}
EOF
printf 'authored Jest config\n' >"$JSB/jest.config.js"
printf 'authored ignore\n' >"$JSB/.gitignore"
glot_run_sandbox scaffold javascript algorithms/naive_sort
assert_eq 'sandbox scaffold JavaScript repetido: código' '0' "$rc_last"
assert_contains 'sandbox scaffold JavaScript repetido: conserva test' '"test": "node custom-runner.js"' "$(cat "$JSB/package.json")"
assert_contains 'sandbox scaffold JavaScript repetido: conserva package fields' '"private": true' "$(cat "$JSB/package.json")"
assert_eq 'sandbox scaffold JavaScript repetido: conserva config' 'authored Jest config' "$(cat "$JSB/jest.config.js")"
assert_eq 'sandbox scaffold JavaScript repetido: conserva ignore' 'authored ignore' "$(cat "$JSB/.gitignore")"

TSB="$SANDBOX/typescript/core/algorithms/naive_sort"
mkdir -p -- "$TSB"
cat >"$TSB/package.json" <<'EOF'
{
  "name": "typescript-naive_sort",
  "version": "1.0.0",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
EOF
glot_run_sandbox scaffold typescript algorithms/naive_sort
assert_eq 'sandbox scaffold TypeScript: código' '0' "$rc_last"
assert_contains 'sandbox scaffold TypeScript: configura test' '"test": "jest --runInBand"' "$(cat "$TSB/package.json")"
assert_contains 'sandbox scaffold TypeScript: configura build' '"build": "tsc --noEmit"' "$(cat "$TSB/package.json")"
assert_contains 'sandbox scaffold TypeScript: declara ts-jest' '"ts-jest": "^29.2.5"' "$(cat "$TSB/package.json")"
assert_contains 'sandbox scaffold TypeScript: configura compilación strict' '"strict": true' "$(cat "$TSB/tsconfig.json")"
assert_contains 'sandbox scaffold TypeScript: configura Jest' "preset: 'ts-jest'" "$(cat "$TSB/jest.config.cjs")"
assert_contains 'sandbox scaffold TypeScript: ignora salidas' 'dist/' "$(cat "$TSB/.gitignore")"
cat >"$TSB/package.json" <<'EOF'
{
  "name": "typescript-naive_sort",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "node custom-runner.js",
    "build": "node custom-build.js"
  },
  "devDependencies": {
    "@types/jest": "^29.5.14",
    "jest": "^29.7.0",
    "ts-jest": "^29.2.5",
    "typescript": "^5.8.3"
  }
}
EOF
printf 'authored tsconfig\n' >"$TSB/tsconfig.json"
printf 'authored Jest config\n' >"$TSB/jest.config.cjs"
printf 'authored ignore\n' >"$TSB/.gitignore"
glot_run_sandbox scaffold typescript algorithms/naive_sort
assert_eq 'sandbox scaffold TypeScript repetido: código' '0' "$rc_last"
assert_contains 'sandbox scaffold TypeScript repetido: conserva test' '"test": "node custom-runner.js"' "$(cat "$TSB/package.json")"
assert_contains 'sandbox scaffold TypeScript repetido: conserva build' '"build": "node custom-build.js"' "$(cat "$TSB/package.json")"
assert_eq 'sandbox scaffold TypeScript repetido: conserva tsconfig' 'authored tsconfig' "$(cat "$TSB/tsconfig.json")"
assert_eq 'sandbox scaffold TypeScript repetido: conserva Jest' 'authored Jest config' "$(cat "$TSB/jest.config.cjs")"
assert_eq 'sandbox scaffold TypeScript repetido: conserva ignore' 'authored ignore' "$(cat "$TSB/.gitignore")"

JLB="$SANDBOX/julia/core/algorithms/naive_sort"
mkdir -p -- "$JLB/src"
cat >"$JLB/Project.toml" <<'EOF'
name = "naive_sort"
uuid = "a96f58fe-899f-4f32-bd97-f062093da5d5"
version = "0.1.0"
authors = ["test"]
EOF
cat >"$JLB/src/naive_sort.jl" <<'EOF'
module naive_sort

greet() = print("Hello World!")

end # module naive_sort
EOF
glot_run_sandbox -n scaffold julia algorithms/naive_sort
assert_eq 'sandbox scaffold Julia -n: código' '0' "$rc_last"
assert_contains 'sandbox scaffold Julia -n: muestra el helper' 'julia_scaffold.sh naive_sort NaiveSort' "$out"
assert_eq 'sandbox scaffold Julia -n: no crea test' 'no' "$([[ -e "$JLB/test" ]] && echo yes || echo no)"
glot_run_sandbox scaffold julia algorithms/naive_sort
assert_eq 'sandbox scaffold Julia: código' '0' "$rc_last"
assert_eq 'sandbox scaffold Julia: renombra muestra exacta' 'yes' \
    "$([[ -f "$JLB/src/NaiveSort.jl" && ! -e "$JLB/src/naive_sort.jl" ]] && echo yes || echo no)"
assert_contains 'sandbox scaffold Julia: capitaliza el módulo' 'module NaiveSort' "$(cat "$JLB/src/NaiveSort.jl")"
assert_contains 'sandbox scaffold Julia: alinea el nombre del paquete' 'name = "NaiveSort"' "$(cat "$JLB/Project.toml")"
assert_contains 'sandbox scaffold Julia: agrega compatibilidad' 'julia = "1.10"' "$(cat "$JLB/Project.toml")"
assert_contains 'sandbox scaffold Julia: agrega Test' 'Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"' "$(cat "$JLB/Project.toml")"
assert_contains 'sandbox scaffold Julia: runner glot falla explícitamente' \
    'error("scaffold: runner Julia no configurado / Julia test runner not configured")' \
    "$(cat "$JLB/test/run_tests.jl")"
assert_eq 'sandbox scaffold Julia: agrega adaptador Pkg' 'include("run_tests.jl")' \
    "$(cat "$JLB/test/runtests.jl")"
assert_eq 'sandbox scaffold Julia: usa ignore del submódulo' 'no' \
    "$([[ -e "$JLB/.gitignore" ]] && echo yes || echo no)"
assert_contains 'sandbox scaffold Julia: avisa suite pendiente' \
    'glot prompt scaffold julia algorithms/naive_sort' "$err"
if command -v julia >/dev/null 2>&1; then
    julia_rc=0
    julia_out="$(cd "$JLB" && JULIA_PKG_OFFLINE=true julia --startup-file=no --project=. -e 'using Pkg; Pkg.test()' 2>&1)" || julia_rc=$?
    assert_eq 'sandbox scaffold Julia: Pkg.test rechaza sentinel' 'yes' \
        "$([[ "$julia_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'sandbox scaffold Julia: Pkg.test ejecuta sentinel' \
        'runner Julia no configurado' "$julia_out"
    printf 'using Test\n@test true\n' >"$JLB/test/run_tests.jl"
    julia_rc=0
    julia_out="$(cd "$JLB" && JULIA_PKG_OFFLINE=true julia --startup-file=no --project=. -e 'using Pkg; Pkg.test()' 2>&1)" || julia_rc=$?
    assert_eq 'sandbox scaffold Julia: Pkg.test ejecuta suite conectada' '0' "$julia_rc"
    julia_rc=0
    julia_out="$(cd "$JLB" && julia --startup-file=no --project=. test/run_tests.jl 2>&1)" || julia_rc=$?
    assert_eq 'sandbox scaffold Julia: runner glot ejecuta suite conectada' '0' "$julia_rc"
fi
printf 'authored Julia source\n' >"$JLB/src/naive_sort.jl"
printf 'authored Julia runner\n' >"$JLB/test/run_tests.jl"
printf 'authored Pkg runner\n' >"$JLB/test/runtests.jl"
printf '\n# custom metadata\n' >>"$JLB/Project.toml"
glot_run_sandbox scaffold julia algorithms/naive_sort
assert_eq 'sandbox scaffold Julia repetido: conserva fuente propia' \
    'authored Julia source' "$(cat "$JLB/src/naive_sort.jl")"
assert_eq 'sandbox scaffold Julia repetido: conserva runner glot' \
    'authored Julia runner' "$(cat "$JLB/test/run_tests.jl")"
assert_eq 'sandbox scaffold Julia repetido: conserva runner Pkg' \
    'authored Pkg runner' "$(cat "$JLB/test/runtests.jl")"
assert_contains 'sandbox scaffold Julia repetido: conserva configuración' \
    '# custom metadata' "$(cat "$JLB/Project.toml")"
JLC="$SANDBOX/julia/core/algorithms/custom_julia"
mkdir -p -- "$JLC/src" "$JLC/test"
cat >"$JLC/Project.toml" <<'EOF'
name = "custom_julia"
uuid = "11111111-2222-4333-8444-555555555555"
version = "0.2.0"
authors = ["test"]

[deps]
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
EOF
cat >"$JLC/src/custom_julia.jl" <<'EOF'
module custom_julia

greet() = print("Hello World!")

end # module custom_julia
EOF
custom_project="$(cat "$JLC/Project.toml")"
(cd "$JLC" && bash "$REPO/scripts/data/julia_scaffold.sh" custom_julia CustomJulia)
assert_eq 'sandbox scaffold Julia manifiesto propio: no altera Project.toml' \
    "$custom_project" "$(cat "$JLC/Project.toml")"
assert_eq 'sandbox scaffold Julia manifiesto propio: conserva ruta fuente' 'yes' \
    "$([[ -f "$JLC/src/custom_julia.jl" && ! -e "$JLC/src/CustomJulia.jl" ]] && echo yes || echo no)"
JLS="$SANDBOX/julia/core/algorithms/sibling_module"
mkdir -p -- "$JLS/src" "$JLS/test"
cat >"$JLS/Project.toml" <<'EOF'
name = "SiblingModule"
uuid = "22222222-3333-4444-8555-666666666666"
version = "0.1.0"
authors = ["test"]
EOF
cat >"$JLS/src/sibling_module.jl" <<'EOF'
module sibling_module

greet() = print("Hello World!")

end # module sibling_module
EOF
printf 'module Helper end\n' >"$JLS/src/helper.jl"
(cd "$JLS" && bash "$REPO/scripts/data/julia_scaffold.sh" sibling_module SiblingModule)
assert_eq 'sandbox scaffold Julia fuente compañera: conserva muestra' 'yes' \
    "$([[ -f "$JLS/src/sibling_module.jl" && ! -e "$JLS/src/SiblingModule.jl" ]] && echo yes || echo no)"

PB="$SANDBOX/php/core/algorithms/naive_sort"
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'sandbox use PHP: prepara carpeta' '0' "$rc_last"
glot_run_sandbox new php algorithms/naive_sort
assert_eq 'sandbox new PHP: crea carpeta' '0' "$rc_last"
glot_run_sandbox scaffold php algorithms/naive_sort
assert_eq 'sandbox scaffold PHP: código' '0' "$rc_last"
assert_contains 'sandbox scaffold PHP: configura autoload' '"classmap"' "$(cat "$PB/composer.json")"
assert_contains 'sandbox scaffold PHP: configura composer test' '"test": "phpunit"' "$(cat "$PB/composer.json")"
assert_contains 'sandbox scaffold PHP: configura PHPUnit' '<directory>test</directory>' "$(cat "$PB/phpunit.xml")"
assert_contains 'sandbox scaffold PHP: falla con suite vacía' 'failOnEmptyTestSuite="true"' "$(cat "$PB/phpunit.xml")"
assert_contains 'sandbox scaffold PHP: configura ignore' '/vendor/' "$(cat "$PB/.gitignore")"
assert_eq 'sandbox scaffold PHP: crea fuente' 'si' "$([[ -f "$PB/src/NaiveSort.php" ]] && echo si || echo no)"
printf 'authored composer\n' >"$PB/composer.json"
printf 'authored source\n' >"$PB/src/NaiveSort.php"
glot_run_sandbox scaffold php algorithms/naive_sort
assert_eq 'sandbox scaffold PHP repetido: conserva composer' 'authored composer' "$(cat "$PB/composer.json")"
assert_eq 'sandbox scaffold PHP repetido: conserva source' 'authored source' "$(cat "$PB/src/NaiveSort.php")"

glot_run_sandbox scaffold ruby algorithms/naive_sort
assert_eq 'sandbox scaffold Ruby: código' '0' "$rc_last"
assert_contains 'sandbox scaffold Ruby: añade RSpec' 'gem "rspec"' "$(cat "$RB/Gemfile")"
assert_contains 'sandbox scaffold Ruby: configura descubrimiento' '--pattern "**/*_tests.rb"' "$(cat "$RB/.rspec")"
printf 'authored Gemfile\n' >"$RB/Gemfile"
glot_run_sandbox scaffold ruby algorithms/naive_sort
assert_eq 'sandbox scaffold Ruby repetido: conserva Gemfile' 'authored Gemfile' "$(cat "$RB/Gemfile")"

RSB="$SANDBOX/rescript/core/algorithms/naive_sort"
mkdir -p -- "$SANDBOX/docs/core/algorithms"
if [[ ! -e "$SANDBOX/docs/core/algorithms/05_Naive_Sort.md" ]]; then
    printf '# 05 — Naive Sort\n' >"$SANDBOX/docs/core/algorithms/05_Naive_Sort.md"
fi
mkdir -p -- "$RSB"
glot_run_sandbox scaffold rescript algorithms/naive_sort
assert_eq 'sandbox scaffold ReScript: código' '0' "$rc_last"
assert_eq 'sandbox scaffold ReScript: crea compilador' 'si' "$([[ -f "$RSB/rescript.json" ]] && echo si || echo no)"
assert_eq 'sandbox scaffold ReScript: crea Jest' 'si' "$([[ -f "$RSB/jest.config.js" && -f "$RSB/babel.config.js" ]] && echo si || echo no)"
assert_contains 'sandbox scaffold ReScript: configura test' '"test": "rescript && jest"' "$(cat "$RSB/package.json")"
printf 'authored package\n' >"$RSB/package.json"
glot_run_sandbox scaffold rescript algorithms/naive_sort
assert_eq 'sandbox scaffold ReScript repetido: conserva package' 'authored package' "$(cat "$RSB/package.json")"

# Crystal crea Git en `new`: no debe quedar tras el inicializador.
if command -v crystal >/dev/null 2>&1; then
    CRYSTAL_NEW="$SANDBOX/crystal/core/algorithms/data_structures_basics"
    mkdir -p -- "$CRYSTAL_NEW"
    glot_run_sandbox -n new crystal algorithms/data_structures_basics
    assert_contains 'new Crystal -n: informa limpieza segura' 'remove generated Git if safe' "$out"
    assert_eq 'new Crystal -n: no genera archivos' '' "$(ls -A "$CRYSTAL_NEW")"
    glot_run_sandbox new crystal algorithms/data_structures_basics
    assert_eq 'new Crystal real: código' '0' "$rc_last"
    assert_eq 'new Crystal real: elimina solo Git generado' 'no' "$([[ -e "$CRYSTAL_NEW/.git" ]] && echo yes || echo no)"
    assert_eq 'new Crystal real: preserva fuentes y manifiesto' 'yes' \
        "$([[ -f "$CRYSTAL_NEW/shard.yml" && -d "$CRYSTAL_NEW/src" && -d "$CRYSTAL_NEW/spec" ]] && echo yes || echo no)"
    glot_run_sandbox scaffold crystal algorithms/data_structures_basics
    assert_eq 'scaffold tras new Crystal real: código' '0' "$rc_last"
fi

# No se borra un Git creado por el generador que ya contiene datos no triviales.
GIT_SEQ_DIR="$WORK_DIR/git-sequence-data"
mkdir -p "$GIT_SEQ_DIR"
cp -R "$DATA_DIR/." "$GIT_SEQ_DIR/"
awk -F'\t' 'BEGIN {OFS="\t"} NR == 1 || !($1 == "java" && $2 == "new")' \
    "$DATA_DIR/init_sequences.tsv" >"$GIT_SEQ_DIR/init_sequences.tsv"
printf 'java\tnew\t1\tmodule\trun\tgit init -q && git config user.name authored\t-\t-\t-\n' \
    >>"$GIT_SEQ_DIR/init_sequences.tsv"
GIT_NEW="$SANDBOX/java/core/algorithms/data_structures_basics"
mkdir -p "$GIT_NEW"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_DATA_DIR="$GIT_SEQ_DIR" "$GLOT_SH" new java algorithms/data_structures_basics 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'new con Git personalizado: falla' '4' "$rc_last"
assert_contains 'new con Git personalizado: diagnóstico' 'unrecognized Git configuration' "$err"
assert_eq 'new con Git personalizado: conserva Git' 'yes' "$([[ -d "$GIT_NEW/.git" ]] && echo yes || echo no)"
glot_run_sandbox scaffold java algorithms/data_structures_basics
assert_eq 'scaffold con Git preexistente: falla sin borrarlo' '4' "$rc_last"
assert_contains 'scaffold con Git preexistente: diagnóstico' 'pre-existing nested Git' "$err"
assert_eq 'scaffold con Git preexistente: conserva Git' 'yes' "$([[ -d "$GIT_NEW/.git" ]] && echo yes || echo no)"

# Un gitfile de worktree o submódulo anidado también debe bloquear la escritura.
GIT_FILE_MODULE="$SANDBOX/java/core/algorithms/searching"
mkdir -p -- "$GIT_FILE_MODULE"
printf 'gitdir: ../authored-git\n' >"$GIT_FILE_MODULE/.git"
glot_run_sandbox -n new java algorithms/searching
assert_eq 'new gitfile dry-run: código' '0' "$rc_last"
assert_eq 'new gitfile dry-run: conserva contenido' 'gitdir: ../authored-git' "$(cat -- "$GIT_FILE_MODULE/.git")"
glot_run_sandbox new java algorithms/searching
assert_eq 'new con gitfile preexistente: falla' '4' "$rc_last"
assert_contains 'new con gitfile preexistente: diagnóstico' 'pre-existing nested Git' "$err"
glot_run_sandbox scaffold java algorithms/searching
assert_eq 'scaffold con gitfile preexistente: falla' '4' "$rc_last"
assert_contains 'scaffold con gitfile preexistente: diagnóstico' 'pre-existing nested Git' "$err"
glot_run_sandbox -n scaffold java algorithms/searching
assert_eq 'scaffold gitfile dry-run: bloquea' '4' "$rc_last"
assert_eq 'gitfile preexistente: conserva contenido' 'gitdir: ../authored-git' "$(cat -- "$GIT_FILE_MODULE/.git")"
assert_eq 'gitfile preexistente: no crea scaffold' 'no' "$([[ -e "$GIT_FILE_MODULE/.gitignore" ]] && echo yes || echo no)"

# Racket conserva los auxiliares inofensivos de raco-new en vez de borrarlos recursivamente.
RACKET_BIN="$WORK_DIR/racket-bin"
RACKET_MODULE="$SANDBOX/racket/core/algorithms/naive_sort"
mkdir -p -- "$RACKET_BIN" "$RACKET_MODULE"
printf '[submodule "racket"]\n\tpath = racket\n\turl = ../remote/racket.git\n' >>"$SANDBOX/.gitmodules"
cat >"$RACKET_BIN/raco" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[[ "$#" == 3 && "$1" == "new" && "$2" == "library" ]] || exit 2
mkdir -p "$3/project" "$3/project-lib" "$3/project-test/tests" "$3/project-doc/scribblings" \
    "$3/.github/workflows" "$3/profile"
for file in CONTRIBUTING.rst Makefile README.rst project/info.rkt project-lib/info.rkt \
    project-test/info.rkt project-doc/info.rkt \
    project-test/tests/project.rkt project-doc/scribblings/project.scrbl \
    project-lib/main.rkt .github/workflows/ci.yml pull_request_template.md \
    render-template.sh profile/example.rkt; do
    printf '<project> <username>\n' >"$3/$file"
done
printf 'naive_sort)\n' >"$3/project-test/tests/project.rkt"
EOF
chmod +x -- "$RACKET_BIN/raco"
old_path="$PATH"
PATH="$RACKET_BIN:$PATH"
export PATH
glot_run_sandbox new racket algorithms/naive_sort
assert_eq 'new Racket: código' '0' "$rc_last"
for generated_path in \
    .github/workflows/ci.yml \
    pull_request_template.md \
    render-template.sh \
    profile/example.rkt; do
    assert_eq "new Racket: conserva $generated_path" 'si' \
        "$([[ -f "$RACKET_MODULE/$generated_path" ]] && echo si || echo no)"
done
printf 'authored profile\n' >"$RACKET_MODULE/profile/example.rkt"
glot_run_sandbox new racket algorithms/naive_sort
assert_eq 'new Racket repetido: conserva contenido auxiliar propio' 'authored profile' \
    "$(cat -- "$RACKET_MODULE/profile/example.rkt")"
PATH="$old_path"
export PATH

# Un repositorio anidado no debe ocultar el estado del superproyecto de un submódulo.
NESTED_ROOT="$WORK_DIR/nested-root"
NESTED_MODULE="$NESTED_ROOT/crystal/core/algorithms/naive_sort"
mkdir -p "$NESTED_MODULE/spec" "$NESTED_ROOT/docs/core/algorithms"
printf '# 05 — Naive Sort\n' >"$NESTED_ROOT/docs/core/algorithms/05_Naive_Sort.md"
printf 'name: naive_sort\n' >"$NESTED_MODULE/shard.yml"
git -C "$NESTED_ROOT" init -q
git -C "$NESTED_ROOT/crystal" init -q
printf '[submodule "crystal"]\n\tpath = crystal\n\turl = ../crystal.git\n' >"$NESTED_ROOT/.gitmodules"
git -C "$NESTED_ROOT" add .gitmodules
git -C "$NESTED_ROOT" update-index --add --cacheinfo "160000,$(git -C "$REPO" rev-parse HEAD),crystal"
git -C "$NESTED_MODULE" init -q
NESTED_STATE="$WORK_DIR/nested-state"
mkdir -p "$NESTED_STATE"
(cd "$NESTED_ROOT" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" set lang crystal >/dev/null)
(cd "$NESTED_ROOT" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" set phase algorithms >/dev/null)
(cd "$NESTED_ROOT" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" set module naive_sort >/dev/null)
root_state="$(cd "$NESTED_ROOT" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" path)"
module_state="$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" path)"
assert_eq 'Git anidado: estado coincide con monorepo' "$root_state" "$module_state"
assert_eq 'Git anidado: lee sprint del monorepo' 'crystal' \
    "$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" get lang)"
rc_last=0
out="$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" -n scaffold 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat "$WORK_DIR/stderr")"
assert_eq 'scaffold Git generado -n desde el módulo: código' '0' "$rc_last"
assert_contains 'scaffold Git generado -n: informa limpieza segura' 'remove generated Git if safe' "$err"
assert_eq 'scaffold Git generado -n: conserva Git' 'yes' "$([[ -d "$NESTED_MODULE/.git" ]] && echo yes || echo no)"
assert_eq 'scaffold Git generado -n: no crea .gitignore' 'no' "$([[ -e "$NESTED_MODULE/.gitignore" ]] && echo yes || echo no)"
rc_last=0
out="$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" scaffold 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'scaffold Git generado desde el módulo: código' '0' "$rc_last"
assert_eq 'scaffold Git generado: elimina solo Git vacío' 'no' "$([[ -e "$NESTED_MODULE/.git" ]] && echo yes || echo no)"
assert_eq 'scaffold Git generado: crea .gitignore' 'yes' "$([[ -f "$NESTED_MODULE/.gitignore" ]] && echo yes || echo no)"
rc_last=0
out="$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" scaffold 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'scaffold Git generado: rerun idempotente' '0' "$rc_last"
git -C "$NESTED_MODULE" init -q
git -C "$NESTED_MODULE" config user.name authored
rc_last=0
out="$(cd "$NESTED_MODULE" && env -u GLOT_ROOT -u GLOT_STATE_FILE GLOT_STATE_DIR="$NESTED_STATE" "$GLOT_SH" scaffold 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat "$WORK_DIR/stderr")"
assert_eq 'scaffold Git propio desde el módulo: bloquea sin perder sprint' '4' "$rc_last"
assert_contains 'scaffold Git propio: diagnóstico' 'pre-existing nested Git' "$err"
assert_eq 'scaffold Git propio: conserva Git' 'yes' "$([[ -d "$NESTED_MODULE/.git" ]] && echo yes || echo no)"

# D elimina únicamente el ejemplo nativo conocido y anuncia lo que falta.
DB="$SANDBOX/d/core/algorithms/naive_sort"
mkdir -p "$DB/source"
cp "$TESTS_DIR/../data/scaffold_templates/d.app.d" "$DB/source/app.d"
printf 'name "naive_sort"\ndescription "A minimal D application."\nauthors "test"\nlicense "proprietary"\n' >"$DB/dub.sdl"
glot_run_sandbox -n scaffold d algorithms/naive_sort
assert_eq 'scaffold D -n: código' '0' "$rc_last"
assert_eq 'scaffold D -n: conserva ejemplo' 'yes' "$([[ -f "$DB/source/app.d" ]] && echo yes || echo no)"
assert_eq 'scaffold D -n: no crea fuente ni tests' 'no' "$([[ -e "$DB/source/naive_sort.d" || -e "$DB/test" ]] && echo yes || echo no)"
glot_run_sandbox scaffold d algorithms/naive_sort
assert_eq 'scaffold D: código' '0' "$rc_last"
assert_eq 'scaffold D: retira ejemplo verificado' 'no' "$([[ -e "$DB/source/app.d" ]] && echo yes || echo no)"
assert_eq 'scaffold D: crea .gitignore' 'yes' "$([[ -f "$DB/.gitignore" ]] && echo yes || echo no)"
assert_eq 'scaffold D: crea fuente idiomática' 'module naive_sort;' "$(cat "$DB/source/naive_sort.d")"
assert_eq 'scaffold D: crea test' 'yes' "$([[ -d "$DB/test" ]] && echo yes || echo no)"
assert_contains 'scaffold D: configura los tests' 'sourcePaths "source" "test"' "$(cat "$DB/dub.sdl")"
assert_eq 'scaffold D: excluye artefactos' '4' \
    "$(git -C "$DB" check-ignore .dub/build/file.o libnaive_sort.a naive_sort-test-library file.o | wc -l | tr -d ' ')"
assert_contains 'scaffold D: anuncia análisis' 'glot prompt scaffold d algorithms/naive_sort' "$err"
d_manifest="$(cat "$DB/dub.sdl")"
glot_run_sandbox scaffold d algorithms/naive_sort
assert_eq 'scaffold D: rerun sin duplicar configuraciones' "$d_manifest" "$(cat "$DB/dub.sdl")"
if command -v dub >/dev/null 2>&1 && command -v dmd >/dev/null 2>&1; then
    d_rc=0
    d_out="$(cd "$DB" && dub test --skip-registry=all 2>&1)" || d_rc=$?
    assert_eq 'scaffold D: runner arranca sin casos' '0' "$d_rc"
    printf 'module naive_sort_test;\nunittest { assert(0); }\n' >"$DB/test/naive_sort_test.d"
    d_rc=0
    d_out="$(cd "$DB" && dub test --skip-registry=all 2>&1)" || d_rc=$?
    assert_eq 'scaffold D: propaga un caso fallido' 'yes' "$([[ "$d_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold D: ejecuta el test fallido' 'naive_sort_test.d' "$d_out"
    d_rc=0
    d_out="$(cd "$DB" && dub build --skip-registry=all 2>&1)" || d_rc=$?
    assert_eq 'scaffold D: build normal no incluye tests' '0' "$d_rc"
    d_out="$(cd "$DB" && dub describe --data=source-files --data-list --skip-registry=all)"
    assert_eq 'scaffold D: build normal no compila test/' 'no' "$([[ "$d_out" == *naive_sort_test.d* ]] && echo yes || echo no)"

    (cd "$SANDBOX/d/core/algorithms" && dub init data_structures_basics --format=sdl --non-interactive --skip-registry=all >/dev/null)
    glot_run_sandbox scaffold d algorithms/data_structures_basics
    assert_eq 'scaffold D: acepta salida real de dub init' '0' "$rc_last"
    assert_contains 'scaffold D: configura manifiesto nativo' 'sourcePaths "source" "test"' \
        "$(cat "$SANDBOX/d/core/algorithms/data_structures_basics/dub.sdl")"

    D_BASE="$SANDBOX/d/core/algorithms/data_structures_basics"
    printf 'name "data_structures_basics"\ndescription "Basic linked data structures."\nauthors "test"\ncopyright "Copyright 2026, test"\nlicense "proprietary"\ntargetType "library"\n' \
        >"$D_BASE/dub.sdl"
    printf 'module data_structures_basics;\n' >"$D_BASE/source/data_structures_basics.d"
    mkdir -p "$D_BASE/test"
    printf 'module scaffold_sentinel;\nunittest { assert(0); }\n' >"$D_BASE/test/scaffold_sentinel.d"
    d_rc=0
    (cd "$D_BASE" && dub test --skip-registry=all) >/dev/null 2>&1 || d_rc=$?
    assert_eq 'scaffold D: reproduce test/ omitido por manifiesto base' '0' "$d_rc"
    glot_run_sandbox scaffold d algorithms/data_structures_basics
    assert_eq 'scaffold D: configura manifiesto base reconocido' '0' "$rc_last"
    assert_contains 'scaffold D: activa test/ en unittest' 'sourcePaths "source" "test"' \
        "$(cat "$D_BASE/dub.sdl")"
    d_base_manifest="$(cat "$D_BASE/dub.sdl")"
    glot_run_sandbox scaffold d algorithms/data_structures_basics
    assert_eq 'scaffold D: rerun base no duplica configuración' "$d_base_manifest" \
        "$(cat "$D_BASE/dub.sdl")"
    d_rc=0
    d_out="$(cd "$D_BASE" && dub test --skip-registry=all 2>&1)" || d_rc=$?
    assert_eq 'scaffold D: propaga test fallido en manifiesto base' 'yes' \
        "$([[ "$d_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold D: ejecuta test centinela base' 'FAILED unittests' "$d_out"
fi
printf 'author code\n' >"$DB/source/app.d"
printf 'author module\n' >"$DB/source/naive_sort.d"
printf 'author ignore\n' >"$DB/.gitignore"
printf 'author manifest\n' >"$DB/dub.sdl"
glot_run_sandbox scaffold d algorithms/naive_sort
assert_eq 'scaffold D repetido: código' '0' "$rc_last"
assert_eq 'scaffold D repetido: conserva código propio' 'author code' "$(cat "$DB/source/app.d")"
assert_eq 'scaffold D repetido: conserva módulo' 'author module' "$(cat "$DB/source/naive_sort.d")"
assert_eq 'scaffold D repetido: conserva ignore' 'author ignore' "$(cat "$DB/.gitignore")"
assert_eq 'scaffold D repetido: conserva manifiesto' 'author manifest' "$(cat "$DB/dub.sdl")"
assert_contains 'scaffold D repetido: anuncia análisis' 'glot prompt scaffold d algorithms/naive_sort' "$err"
rm -- "$DB/source/naive_sort.d"
ln -s "$DB/source/app.d" "$DB/source/naive_sort.d"
glot_run_sandbox scaffold d algorithms/naive_sort
assert_eq 'scaffold D symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold D symlink: conserva destino' 'author code' "$(cat "$DB/source/app.d")"

# Forth carga la fuente sin inventar palabras y deja un runner vacío ejecutable.
FB="$SANDBOX/forth/core/algorithms/naive_sort"
mkdir -p "$FB"
glot_run_sandbox -n scaffold forth algorithms/naive_sort
assert_eq 'scaffold Forth -n: código' '0' "$rc_last"
assert_eq 'scaffold Forth -n: no crea fuentes' 'no' "$([[ -e "$FB/src" || -e "$FB/test" ]] && echo yes || echo no)"
glot_run_sandbox scaffold forth algorithms/naive_sort
assert_eq 'scaffold Forth: código' '0' "$rc_last"
assert_eq 'scaffold Forth: crea fuente vacía' 'yes' "$([[ -f "$FB/src/naive_sort.forth" && ! -s "$FB/src/naive_sort.forth" ]] && echo yes || echo no)"
assert_eq 'scaffold Forth: crea runner' 'yes' "$([[ -f "$FB/test/run-tests.forth" ]] && echo yes || echo no)"
assert_eq 'scaffold Forth: crea framework' 'yes' "$([[ -f "$FB/test/test.forth" ]] && echo yes || echo no)"
assert_contains 'scaffold Forth: anuncia trabajo pendiente' 'glot prompt scaffold forth algorithms/naive_sort' "$err"
if command -v gforth >/dev/null 2>&1; then
    forth_rc=0
    forth_out="$(cd "$FB/test" && gforth run-tests.forth 2>&1)" || forth_rc=$?
    assert_eq 'scaffold Forth: runner arranca' '0' "$forth_rc"
    assert_contains 'scaffold Forth: anuncia ausencia de tests' 'Scaffold: no tests configured' "$forth_out"
    printf 'glot-undefined-word\n' >"$FB/src/naive_sort.forth"
    forth_rc=0
    forth_out="$(cd "$FB/test" && gforth run-tests.forth 2>&1)" || forth_rc=$?
    assert_eq 'scaffold Forth: propaga error de la fuente' 'yes' "$([[ "$forth_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold Forth: carga la fuente' 'glot-undefined-word' "$forth_out"
    : >"$FB/src/naive_sort.forth"
    printf 'include ../src/naive_sort.forth\ninclude test.forth\ninit-tests\n0 0 assert-equals\n1 2 assert-equals\ntest-report\nbye\n' >"$FB/test/run-tests.forth"
    forth_rc=0
    forth_out="$(cd "$FB/test" && gforth run-tests.forth 2>&1)" || forth_rc=$?
    assert_eq 'scaffold Forth: propaga aserción fallida' '1' "$forth_rc"
    assert_contains 'scaffold Forth: informa aserción fallida' '[FAIL]' "$forth_out"
    assert_contains 'scaffold Forth: cuenta todas las aserciones' 'tests runned 2' "$forth_out"
fi
printf 'author source\n' >"$FB/src/naive_sort.forth"
printf 'author runner\n' >"$FB/test/run-tests.forth"
printf 'author framework\n' >"$FB/test/test.forth"
printf 'author ignore\n' >"$FB/.gitignore"
glot_run_sandbox scaffold forth algorithms/naive_sort
assert_eq 'scaffold Forth repetido: código' '0' "$rc_last"
assert_eq 'scaffold Forth repetido: conserva fuente' 'author source' "$(cat "$FB/src/naive_sort.forth")"
assert_eq 'scaffold Forth repetido: conserva runner' 'author runner' "$(cat "$FB/test/run-tests.forth")"
assert_eq 'scaffold Forth repetido: conserva framework' 'author framework' "$(cat "$FB/test/test.forth")"
assert_eq 'scaffold Forth repetido: conserva ignore' 'author ignore' "$(cat "$FB/.gitignore")"
rm -- "$FB/test/run-tests.forth"
ln -s "$FB/src/naive_sort.forth" "$FB/test/run-tests.forth"
glot_run_sandbox scaffold forth algorithms/naive_sort
assert_eq 'scaffold Forth symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold Forth symlink: conserva destino' 'author source' "$(cat "$FB/src/naive_sort.forth")"

# COBOL deja un runner enlazable y preserva los archivos existentes.
COB="$SANDBOX/cobol/core/algorithms/data_structures_basics"
mkdir -p "$COB"
glot_run_sandbox -n scaffold cobol algorithms/data_structures_basics
assert_eq 'scaffold COBOL -n: código' '0' "$rc_last"
assert_eq 'scaffold COBOL -n: no crea fuentes' 'no' "$([[ -e "$COB/src" || -e "$COB/test" ]] && echo yes || echo no)"
glot_run_sandbox scaffold cobol algorithms/data_structures_basics
assert_eq 'scaffold COBOL: código' '0' "$rc_last"
assert_eq 'scaffold COBOL: crea estructura y runner' 'yes' \
    "$([[ -d "$COB/src/copybooks" && -f "$COB/src/lib/data_structures_basics.cbl" && -f "$COB/test/RUN-TESTS.cbl" ]] && echo yes || echo no)"
assert_eq 'scaffold COBOL: excluye artefactos' '3' \
    "$(git -C "$COB" check-ignore run_tests test.o build/object | wc -l | tr -d ' ')"
assert_contains 'scaffold COBOL: anuncia trabajo pendiente' 'glot prompt scaffold cobol algorithms/data_structures_basics' "$err"
if command -v cobc >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
    printf 'identification division.\nprogram-id. AAA-TEST.\nprocedure division.\n display "wrong entry".\n goback.\nend program AAA-TEST.\n' >"$COB/test/AAA-TEST.cbl"
    cob_rc=0
    cob_out="$(make -s -C "$COB" test 2>&1)" || cob_rc=$?
    assert_eq 'scaffold COBOL: runner arranca con helpers' '0' "$cob_rc"
    assert_contains 'scaffold COBOL: runner es punto de entrada' 'Scaffold: no tests configured' "$cob_out"
    printf 'identification division.\nprogram-id. RUN-TESTS.\nprocedure division.\n move 1 to return-code\n goback.\nend program RUN-TESTS.\n' >"$COB/test/RUN-TESTS.cbl"
    cob_rc=0
    cob_out="$(make -s -B -C "$COB" test 2>&1)" || cob_rc=$?
    assert_eq 'scaffold COBOL: propaga fallo del runner' 'yes' "$([[ "$cob_rc" != 0 ]] && echo yes || echo no)"
    rm -- "$COB/test/RUN-TESTS.cbl"
    cob_rc=0
    cob_out="$(make -s -C "$COB" test 2>&1)" || cob_rc=$?
    assert_eq 'scaffold COBOL: falla si falta runner aun con ejecutable' 'yes' "$([[ "$cob_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold COBOL: diagnostica runner ausente' 'Test runner is missing' "$cob_out"
fi
printf 'author source\n' >"$COB/src/lib/data_structures_basics.cbl"
printf 'author runner\n' >"$COB/test/RUN-TESTS.cbl"
printf 'author makefile\n' >"$COB/Makefile"
printf 'author ignore\n' >"$COB/.gitignore"
glot_run_sandbox scaffold cobol algorithms/data_structures_basics
assert_eq 'scaffold COBOL repetido: código' '0' "$rc_last"
assert_eq 'scaffold COBOL repetido: conserva fuente' 'author source' "$(cat "$COB/src/lib/data_structures_basics.cbl")"
assert_eq 'scaffold COBOL repetido: conserva runner' 'author runner' "$(cat "$COB/test/RUN-TESTS.cbl")"
assert_eq 'scaffold COBOL repetido: conserva Makefile' 'author makefile' "$(cat "$COB/Makefile")"
assert_eq 'scaffold COBOL repetido: conserva ignore' 'author ignore' "$(cat "$COB/.gitignore")"
rm -- "$COB/Makefile"
ln -s "$COB/src/lib/data_structures_basics.cbl" "$COB/Makefile"
glot_run_sandbox scaffold cobol algorithms/data_structures_basics
assert_eq 'scaffold COBOL symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold COBOL symlink: conserva destino' 'author source' "$(cat "$COB/src/lib/data_structures_basics.cbl")"

# Grain preserva contenido y compila el runner con la fuente real.
GRB="$SANDBOX/grain/core/algorithms/data_structures_basics"
mkdir -p "$GRB"
glot_run_sandbox -n scaffold grain algorithms/data_structures_basics
assert_eq 'scaffold Grain -n: código' '0' "$rc_last"
assert_eq 'scaffold Grain -n: no crea fuentes' 'no' "$([[ -e "$GRB/src" || -e "$GRB/tests" ]] && echo yes || echo no)"
glot_run_sandbox scaffold grain algorithms/data_structures_basics
assert_eq 'scaffold Grain: código' '0' "$rc_last"
assert_eq 'scaffold Grain: crea fuente y runner' 'yes' \
    "$([[ -f "$GRB/src/data_structures_basics.gr" && -f "$GRB/tests/run_tests.gr" ]] && echo yes || echo no)"
assert_eq 'scaffold Grain: crea control de estado' 'yes' "$([[ -f "$GRB/tests/test_status.gr" ]] && echo yes || echo no)"
assert_contains 'scaffold Grain: usa control de estado' 'TestStatus.finish(true)' "$(cat "$GRB/tests/run_tests.gr")"
assert_eq 'scaffold Grain: excluye artefactos' '3' \
    "$(git -C "$GRB" check-ignore target/module.gro tests/run_tests.wasm src/module.gro | wc -l | tr -d ' ')"
assert_contains 'scaffold Grain: anuncia trabajo pendiente' 'glot prompt scaffold grain algorithms/data_structures_basics' "$err"
if command -v grain >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
    grain_rc=0
    grain_out="$(make -s -C "$GRB" test 2>&1)" || grain_rc=$?
    assert_eq 'scaffold Grain: runner arranca' '0' "$grain_rc"
    assert_contains 'scaffold Grain: informa ausencia de tests' 'Scaffold: no tests configured' "$grain_out"
    printf 'module Testing\nprovide let printSummary = () => {\n  print("1 passed, 0 failed")\n  1 == 1\n}\n' >"$GRB/tests/testing.gr"
    printf 'module RunTests\nfrom "./testing.gr" include Testing\nfrom "./test_status.gr" include TestStatus\nTestStatus.finish(Testing.printSummary())\n' >"$GRB/tests/run_tests.gr"
    grain_rc=0
    grain_out="$(make -s -C "$GRB" test 2>&1)" || grain_rc=$?
    assert_eq 'scaffold Grain: acepta suite en verde' '0' "$grain_rc"
    assert_contains 'scaffold Grain: ejecuta suite en verde' '1 passed, 0 failed' "$grain_out"
    printf 'module Testing\nprovide let printSummary = () => {\n  print("0 passed, 1 failed")\n  1 == 2\n}\n' >"$GRB/tests/testing.gr"
    grain_rc=0
    grain_out="$(make -s -C "$GRB" test 2>&1)" || grain_rc=$?
    assert_eq 'scaffold Grain: propaga aserción fallida' 'yes' "$([[ "$grain_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold Grain: ejecuta suite fallida' '0 passed, 1 failed' "$grain_out"
    printf 'module RunTests\nfrom "../src/data_structures_basics.gr" include DataStructuresBasics\nfrom "./test_status.gr" include TestStatus\nTestStatus.finish(true)\n' >"$GRB/tests/run_tests.gr"
    printf 'module DataStructuresBasics\nthis is invalid Grain\n' >"$GRB/src/data_structures_basics.gr"
    grain_rc=0
    grain_out="$(make -s -C "$GRB" test 2>&1)" || grain_rc=$?
    assert_eq 'scaffold Grain: detecta fuente inválida' 'yes' "$([[ "$grain_rc" != 0 ]] && echo yes || echo no)"
fi
printf 'author source\n' >"$GRB/src/data_structures_basics.gr"
printf 'author runner\n' >"$GRB/tests/run_tests.gr"
printf 'author status\n' >"$GRB/tests/test_status.gr"
printf 'author makefile\n' >"$GRB/Makefile"
printf 'author ignore\n' >"$GRB/.gitignore"
glot_run_sandbox scaffold grain algorithms/data_structures_basics
assert_eq 'scaffold Grain repetido: código' '0' "$rc_last"
assert_eq 'scaffold Grain repetido: conserva fuente' 'author source' "$(cat "$GRB/src/data_structures_basics.gr")"
assert_eq 'scaffold Grain repetido: conserva runner' 'author runner' "$(cat "$GRB/tests/run_tests.gr")"
assert_eq 'scaffold Grain repetido: conserva control de estado' 'author status' "$(cat "$GRB/tests/test_status.gr")"
assert_eq 'scaffold Grain repetido: conserva Makefile' 'author makefile' "$(cat "$GRB/Makefile")"
assert_eq 'scaffold Grain repetido: conserva ignore' 'author ignore' "$(cat "$GRB/.gitignore")"
rm -- "$GRB/tests/run_tests.gr"
ln -s "$GRB/src/data_structures_basics.gr" "$GRB/tests/run_tests.gr"
glot_run_sandbox scaffold grain algorithms/data_structures_basics
assert_eq 'scaffold Grain symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold Grain symlink: conserva destino' 'author source' "$(cat "$GRB/src/data_structures_basics.gr")"
GR_OLD="$SANDBOX/grain/core/algorithms/naive_sort"
mkdir -p "$GR_OLD/tests"
printf 'module RunTests\n\nfrom "../src/naive_sort.gr" include NaiveSort\n\nprint("Scaffold: no tests configured")\n' >"$GR_OLD/tests/run_tests.gr"
printf 'author status\n' >"$GR_OLD/tests/test_status.gr"
glot_run_sandbox scaffold grain algorithms/naive_sort
assert_eq 'scaffold Grain anterior con helper propio: bloquea' '4' "$rc_last"
assert_contains 'scaffold Grain anterior con helper propio: diagnóstico' 'custom or unreadable Grain status helper' "$err"
assert_eq 'scaffold Grain anterior con helper propio: conserva runner' 'yes' \
    "$(grep -q 'TestStatus.finish' "$GR_OLD/tests/run_tests.gr" && echo no || echo yes)"
rm -- "$GR_OLD/tests/test_status.gr"
glot_run_sandbox -n scaffold grain algorithms/naive_sort
assert_eq 'scaffold Grain anterior -n: código' '0' "$rc_last"
assert_eq 'scaffold Grain anterior -n: no crea helper' 'no' "$([[ -e "$GR_OLD/tests/test_status.gr" ]] && echo yes || echo no)"
glot_run_sandbox scaffold grain algorithms/naive_sort
assert_eq 'scaffold Grain anterior: código' '0' "$rc_last"
assert_contains 'scaffold Grain anterior: actualiza solo runner conocido' 'TestStatus.finish(true)' "$(cat "$GR_OLD/tests/run_tests.gr")"
glot_run_sandbox scaffold grain algorithms/naive_sort
assert_eq 'scaffold Grain anterior: rerun sin cambios' '0' "$rc_last"

# R prepara un paquete con testthat y conserva configuraciones existentes.
RSC="$SANDBOX/r/core/algorithms/data_structures_basics"
mkdir -p "$RSC"
glot_run_sandbox -n scaffold r algorithms/data_structures_basics
assert_eq 'scaffold R -n: código' '0' "$rc_last"
assert_eq 'scaffold R -n: no crea archivos' 'no' "$([[ -e "$RSC/DESCRIPTION" || -e "$RSC/R" ]] && echo yes || echo no)"
glot_run_sandbox scaffold r algorithms/data_structures_basics
assert_eq 'scaffold R: código' '0' "$rc_last"
assert_contains 'scaffold R: nombre idiomático' 'Package: dataStructuresBasics' "$(cat "$RSC/DESCRIPTION")"
assert_contains 'scaffold R: runner apunta al paquete' 'test_check("dataStructuresBasics")' "$(cat "$RSC/tests/testthat.R")"
assert_eq 'scaffold R: crea fuente y test vacío' 'yes' \
    "$([[ -f "$RSC/R/data_structures_basics.R" && -f "$RSC/tests/testthat/test-scaffold.R" ]] && echo yes || echo no)"
assert_eq 'scaffold R: excluye artefactos' '2' \
    "$(git -C "$RSC" check-ignore .Rhistory package.Rcheck/test | wc -l | tr -d ' ')"
assert_contains 'scaffold R: anuncia revisión' 'glot prompt scaffold r algorithms/data_structures_basics' "$err"
if command -v Rscript >/dev/null 2>&1 && command -v make >/dev/null 2>&1 && Rscript -e 'quit(status = if (requireNamespace("testthat", quietly = TRUE)) 0 else 1)' >/dev/null 2>&1; then
    r_rc=0
    r_out="$(make -s -C "$RSC" test 2>&1)" || r_rc=$?
    assert_eq 'scaffold R: falla sin casos ejecutados' 'yes' "$([[ "$r_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold R: informa cero casos' 'No R test cases executed' "$r_out"
    printf 'test_that("glot pass", { expect_true(TRUE) })\n' >"$RSC/tests/testthat/test-pass.R"
    r_rc=0
    r_out="$(make -s -C "$RSC" test 2>&1)" || r_rc=$?
    assert_eq 'scaffold R: pasa con un caso aprobado' '0' "$r_rc"
    assert_contains 'scaffold R: cuenta un caso aprobado' 'PASS 1' "$r_out"
    printf 'test_that("glot failure", { expect_equal(1, 2) })\n' >"$RSC/tests/testthat/test-failure.R"
    r_rc=0
    r_out="$(make -s -C "$RSC" test 2>&1)" || r_rc=$?
    assert_eq 'scaffold R: propaga aserción fallida' 'yes' "$([[ "$r_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold R: informa test fallido' 'glot failure' "$r_out"
fi
printf 'author source\n' >"$RSC/R/data_structures_basics.R"
printf 'author description\n' >"$RSC/DESCRIPTION"
printf 'author namespace\n' >"$RSC/NAMESPACE"
printf 'author runner\n' >"$RSC/tests/testthat.R"
printf 'author test\n' >"$RSC/tests/testthat/test-scaffold.R"
printf 'author makefile\n' >"$RSC/Makefile"
printf 'author ignore\n' >"$RSC/.gitignore"
glot_run_sandbox scaffold r algorithms/data_structures_basics
assert_eq 'scaffold R repetido: código' '0' "$rc_last"
assert_eq 'scaffold R repetido: conserva fuente' 'author source' "$(cat "$RSC/R/data_structures_basics.R")"
assert_eq 'scaffold R repetido: conserva DESCRIPTION' 'author description' "$(cat "$RSC/DESCRIPTION")"
assert_eq 'scaffold R repetido: conserva NAMESPACE' 'author namespace' "$(cat "$RSC/NAMESPACE")"
assert_eq 'scaffold R repetido: conserva runner' 'author runner' "$(cat "$RSC/tests/testthat.R")"
assert_eq 'scaffold R repetido: conserva test' 'author test' "$(cat "$RSC/tests/testthat/test-scaffold.R")"
assert_eq 'scaffold R repetido: conserva Makefile' 'author makefile' "$(cat "$RSC/Makefile")"
assert_eq 'scaffold R repetido: conserva ignore' 'author ignore' "$(cat "$RSC/.gitignore")"
rm -- "$RSC/NAMESPACE"
ln -s "$RSC/DESCRIPTION" "$RSC/NAMESPACE"
glot_run_sandbox scaffold r algorithms/data_structures_basics
assert_eq 'scaffold R symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold R symlink: conserva destino' 'author description' "$(cat "$RSC/DESCRIPTION")"

# Prolog no impone un módulo exportador que contradiga las bases de consult/1.
PRB="$SANDBOX/prolog/core/algorithms/data_structures_basics"
mkdir -p "$PRB"
glot_run_sandbox -n scaffold prolog algorithms/data_structures_basics
assert_eq 'scaffold Prolog -n: código' '0' "$rc_last"
assert_eq 'scaffold Prolog -n: no crea fuentes' 'no' "$([[ -e "$PRB/src" ]] && echo yes || echo no)"
glot_run_sandbox scaffold prolog algorithms/data_structures_basics
assert_eq 'scaffold Prolog: código' '0' "$rc_last"
assert_eq 'scaffold Prolog: fuente vacía' 'yes' "$([[ -f "$PRB/src/data_structures_basics.pl" && ! -s "$PRB/src/data_structures_basics.pl" ]] && echo yes || echo no)"
assert_eq 'scaffold Prolog: excluye QLF' '1' "$(git -C "$PRB" check-ignore src/module.qlf | wc -l | tr -d ' ')"
assert_contains 'scaffold Prolog: anuncia revisión' 'glot prompt scaffold prolog algorithms/data_structures_basics' "$err"
if command -v swipl >/dev/null 2>&1; then
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: runner arranca sin casos' '0' "$rc_last"
    assert_contains 'scaffold Prolog: informa ausencia de tests' 'Scaffold: no tests configured' "$out"
    printf 'this is not valid prolog.\n' >"$PRB/src/data_structures_basics.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: detecta fuente inválida sin suite' '4' "$rc_last"
    : >"$PRB/src/data_structures_basics.pl"
    printf ':- begin_tests(alpha).\ntest(first) :- assertion(1 = 1).\n:- end_tests(alpha).\n' >"$PRB/test/alpha_test.pl"
    printf ':- begin_tests(beta).\ntest(second) :- assertion(2 = 2).\n:- end_tests(beta).\n' >"$PRB/test/beta_tests.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: ejecuta varias suites' '0' "$rc_last"
    assert_contains 'scaffold Prolog: incluye primera suite' 'alpha:first' "$err"
    assert_contains 'scaffold Prolog: incluye segunda suite' 'beta:second' "$err"
    printf ':- begin_tests(beta).\ntest(second) :- assertion(1 = 2).\n:- end_tests(beta).\n' >"$PRB/test/beta_tests.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: propaga fallo de segunda suite' '4' "$rc_last"
    assert_contains 'scaffold Prolog: identifica test fallido' 'beta:second' "$err"
    printf ':- begin_tests(beta).\nthis is not valid prolog.\n:- end_tests(beta).\n' >"$PRB/test/beta_tests.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: propaga error de sintaxis' '4' "$rc_last"
    assert_contains 'scaffold Prolog: informa error sintáctico' 'Syntax error' "$err"
    rm -- "$PRB/test/alpha_test.pl" "$PRB/test/beta_tests.pl"
    printf '%% empty suite\n' >"$PRB/test/empty_tests.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: rechaza suite sin casos' '4' "$rc_last"
    assert_contains 'scaffold Prolog: diagnostica suite sin casos' 'No Prolog test cases executed' "$err"
    printf ':- begin_tests(blocked).\ntest(skipped, [blocked("not ready")]) :- fail.\n:- end_tests(blocked).\n' >"$PRB/test/empty_tests.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: rechaza suite completamente bloqueada' '4' "$rc_last"
    assert_contains 'scaffold Prolog: informa casos bloqueados' '1 blocked' "$out"
    rm -- "$PRB/test/empty_tests.pl"
    printf '%% helper without suite\n' >"$PRB/test/helper.pl"
    glot_run_sandbox test prolog algorithms/data_structures_basics
    assert_eq 'scaffold Prolog: rechaza nombres no reconocidos' '4' "$rc_last"
    assert_contains 'scaffold Prolog: diagnostica nombres no reconocidos' 'No recognized Prolog test files' "$err"

    PR_CALC="$SANDBOX/prolog/core/foundations/unit_test/calculator"
    mkdir -p "$PR_CALC/src" "$PR_CALC/test"
    printf 'calculate(1).\n' >"$PR_CALC/src/calculator.pl"
    printf ':- consult("../src/calculator.pl").\n:- begin_tests(calculator).\ntest(check) :- calculate(1).\n:- end_tests(calculator).\n' >"$PR_CALC/test/calculator_test.pl"
    glot_run_sandbox test prolog foundations/unit_test
    assert_eq 'test Prolog: calculator usa fuente de la suite' '0' "$rc_last"
    assert_contains 'test Prolog: ejecuta calculator' 'calculator:check' "$err"
fi
printf 'author source\n' >"$PRB/src/data_structures_basics.pl"
printf 'author ignore\n' >"$PRB/.gitignore"
glot_run_sandbox scaffold prolog algorithms/data_structures_basics
assert_eq 'scaffold Prolog repetido: código' '0' "$rc_last"
assert_eq 'scaffold Prolog repetido: conserva fuente' 'author source' "$(cat "$PRB/src/data_structures_basics.pl")"
assert_eq 'scaffold Prolog repetido: conserva ignore' 'author ignore' "$(cat "$PRB/.gitignore")"
rm -- "$PRB/src/data_structures_basics.pl"
ln -s "$PRB/.gitignore" "$PRB/src/data_structures_basics.pl"
glot_run_sandbox scaffold prolog algorithms/data_structures_basics
assert_eq 'scaffold Prolog symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold Prolog symlink: conserva destino' 'author ignore' "$(cat "$PRB/.gitignore")"

PSB="$SANDBOX/purescript/core/algorithms/naive_sort"
# C#: scaffold conserva archivos propios y retira solo ejemplos dotnet new intactos.
CSHARP_SCAFFOLD="$SANDBOX/csharp/core/algorithms/naive_sort"
mkdir -p -- "$CSHARP_SCAFFOLD"
glot_run_sandbox -n scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: dry-run' '0' "$rc_last"
assert_contains 'scaffold C#: dry-run muestra plantilla ignore' 'csharp.gitignore' "$out"
assert_eq 'scaffold C#: dry-run no escribe ignore' 'no' "$([[ -e "$CSHARP_SCAFFOLD/.gitignore" ]] && echo yes || echo no)"
glot_run_sandbox scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: código' '0' "$rc_last"
assert_eq 'scaffold C#: instala plantilla ignore' '0' \
    "$(cmp -s "$CSHARP_SCAFFOLD/.gitignore" "$TESTS_DIR/../data/scaffold_templates/csharp.gitignore"; echo $?)"
mkdir -p "$CSHARP_SCAFFOLD/src/NaiveSort" "$CSHARP_SCAFFOLD/test/NaiveSort.Tests"
for sample in Class1 UnitTest1; do
    if [[ "$sample" == Class1 ]]; then
        target="$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs"
        template="$TESTS_DIR/../data/scaffold_templates/csharp.Class1.cs"
    else
        target="$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs"
        template="$TESTS_DIR/../data/scaffold_templates/csharp.UnitTest1.cs"
    fi
    { printf '\357\273\277'; sed 's/@MODULE@/NaiveSort/g; s/$/\r/' "$template"; } >"$target"
done
glot_run_sandbox scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: retira ejemplos intactos' 'no' \
    "$([[ -e "$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs" || -e "$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs" ]] && echo yes || echo no)"
printf 'namespace NaiveSort;\npublic class Class1 { public int Value => 1; }\n' \
    >"$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs"
printf 'namespace NaiveSort.Tests;\npublic class UnitTest1 { }\n' \
    >"$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs"
glot_run_sandbox scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: conserva ejemplo de producción editado' \
    'namespace NaiveSort;' "$(head -n 1 "$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs")"
assert_eq 'scaffold C#: conserva test editado' \
    'namespace NaiveSort.Tests;' "$(head -n 1 "$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs")"
CSHARP_IGNORE="$WORK_DIR/csharp-ignore"
mkdir -p -- "$CSHARP_IGNORE"
cp -- "$CSHARP_SCAFFOLD/.gitignore" "$CSHARP_IGNORE/.gitignore"
git -C "$CSHARP_IGNORE" init -q
assert_eq 'scaffold C#: excluye bin' '1' \
    "$(git -C "$CSHARP_IGNORE" check-ignore bin/Debug/build.dll | wc -l | tr -d ' ')"
assert_eq 'scaffold C#: excluye obj' '1' \
    "$(git -C "$CSHARP_IGNORE" check-ignore obj/project.assets.json | wc -l | tr -d ' ')"
printf 'author ignore\n' >"$CSHARP_SCAFFOLD/.gitignore"
glot_run_sandbox scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: rerun preserva ignore propio' 'author ignore' "$(cat -- "$CSHARP_SCAFFOLD/.gitignore")"
rm -- "$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs"
ln -s "$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs" "$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs"
glot_run_sandbox scaffold csharp algorithms/naive_sort
assert_eq 'scaffold C#: bloquea muestra symlink' '4' "$rc_last"
assert_eq 'scaffold C#: conserva muestra symlink' 'yes' \
    "$([[ -L "$CSHARP_SCAFFOLD/src/NaiveSort/Class1.cs" ]] && echo yes || echo no)"
assert_eq 'scaffold C#: conserva destino del symlink' \
    'namespace NaiveSort.Tests;' "$(head -n 1 "$CSHARP_SCAFFOLD/test/NaiveSort.Tests/UnitTest1.cs")"

# Zig: preserve main.zig because zig init's generated test target depends on it.
printf '[submodule "zig"]\n\tpath = zig\n\turl = ../remote/zig.git\n' >>"$SANDBOX/.gitmodules"
ZIG_SCAFFOLD="$SANDBOX/zig/core/algorithms/naive_sort"
mkdir -p "$ZIG_SCAFFOLD/src"
printf 'generated main\n' >"$ZIG_SCAFFOLD/src/main.zig"
glot_run_sandbox -n scaffold zig algorithms/naive_sort
assert_eq 'scaffold Zig: dry-run' '0' "$rc_last"
assert_contains 'scaffold Zig: dry-run muestra plantilla ignore' 'zig.gitignore' "$out"
assert_eq 'scaffold Zig: dry-run conserva main' 'generated main' \
    "$(cat "$ZIG_SCAFFOLD/src/main.zig")"
glot_run_sandbox scaffold zig algorithms/naive_sort
assert_eq 'scaffold Zig: código' '0' "$rc_last"
assert_eq 'scaffold Zig: conserva main' 'generated main' \
    "$(cat "$ZIG_SCAFFOLD/src/main.zig")"
assert_eq 'scaffold Zig: instala plantilla ignore' '0' \
    "$(cmp -s "$ZIG_SCAFFOLD/.gitignore" "$TESTS_DIR/../data/scaffold_templates/zig.gitignore"; echo $?)"
ZIG_IGNORE="$WORK_DIR/zig-ignore"
mkdir -p -- "$ZIG_IGNORE"
cp -- "$ZIG_SCAFFOLD/.gitignore" "$ZIG_IGNORE/.gitignore"
git -C "$ZIG_IGNORE" init -q
assert_eq 'scaffold Zig: excluye cache' '1' \
    "$(git -C "$ZIG_IGNORE" check-ignore .zig-cache/o/test | wc -l | tr -d ' ')"
assert_eq 'scaffold Zig: excluye salida' '1' \
    "$(git -C "$ZIG_IGNORE" check-ignore zig-out/lib.a | wc -l | tr -d ' ')"
printf 'author main\n' >"$ZIG_SCAFFOLD/src/main.zig"
printf 'author ignore\n' >"$ZIG_SCAFFOLD/.gitignore"
glot_run_sandbox scaffold zig algorithms/naive_sort
assert_eq 'scaffold Zig: rerun preserva main' 'author main' \
    "$(cat "$ZIG_SCAFFOLD/src/main.zig")"
assert_eq 'scaffold Zig: rerun preserva ignore' 'author ignore' \
    "$(cat "$ZIG_SCAFFOLD/.gitignore")"
sandbox_restore_gitmodules

# Common Lisp: move generated files only when destinations are free; reruns retain files.
printf '[submodule "common-lisp"]\n\tpath = common-lisp\n\turl = ../remote/common-lisp.git\n' \
    >>"$SANDBOX/.gitmodules"
CL_SCAFFOLD="$SANDBOX/common-lisp/core/algorithms/naive_sort"
mkdir -p "$CL_SCAFFOLD/src" "$CL_SCAFFOLD/tests"
printf 'generated source\n' >"$CL_SCAFFOLD/src/main.lisp"
printf 'generated tests\n' >"$CL_SCAFFOLD/tests/main.lisp"
glot_run_sandbox scaffold common-lisp algorithms/naive_sort
assert_eq 'scaffold Common Lisp: código' '0' "$rc_last"
assert_eq 'scaffold Common Lisp: renombra fuente' 'generated source' \
    "$(cat "$CL_SCAFFOLD/src/naive_sort.lisp")"
assert_eq 'scaffold Common Lisp: renombra suite' 'generated tests' \
    "$(cat "$CL_SCAFFOLD/tests/naive_sort-test.lisp")"
assert_eq 'scaffold Common Lisp: crea runner vacío' '0' \
    "$(test -f "$CL_SCAFFOLD/run-tests.lisp" && test ! -s "$CL_SCAFFOLD/run-tests.lisp"; echo $?)"
printf 'authored runner\n' >"$CL_SCAFFOLD/run-tests.lisp"
glot_run_sandbox scaffold common-lisp algorithms/naive_sort
assert_eq 'scaffold Common Lisp: rerun preserva fuente' 'generated source' \
    "$(cat "$CL_SCAFFOLD/src/naive_sort.lisp")"
assert_eq 'scaffold Common Lisp: rerun preserva runner' 'authored runner' \
    "$(cat "$CL_SCAFFOLD/run-tests.lisp")"
printf 'new generated source\n' >"$CL_SCAFFOLD/src/main.lisp"
glot_run_sandbox scaffold common-lisp algorithms/naive_sort
assert_eq 'scaffold Common Lisp: bloquea destino existente' '4' "$rc_last"
assert_eq 'scaffold Common Lisp: conserva origen en conflicto' 'new generated source' \
    "$(cat "$CL_SCAFFOLD/src/main.lisp")"
assert_eq 'scaffold Common Lisp: conserva destino en conflicto' 'generated source' \
    "$(cat "$CL_SCAFFOLD/src/naive_sort.lisp")"
rm -- "$CL_SCAFFOLD/src/main.lisp"
ln -s "$CL_SCAFFOLD/run-tests.lisp" "$CL_SCAFFOLD/src/main.lisp"
glot_run_sandbox scaffold common-lisp algorithms/naive_sort
assert_eq 'scaffold Common Lisp: bloquea origen symlink' '4' "$rc_last"
assert_eq 'scaffold Common Lisp: conserva origen symlink' 'yes' \
    "$([[ -L "$CL_SCAFFOLD/src/main.lisp" ]] && echo yes || echo no)"
sandbox_restore_gitmodules

mkdir -p "$PSB/src"
printf 'author code\n' >"$PSB/src/Main.purs"
printf 'author manifest\n' >"$PSB/spago.yaml"
glot_run_sandbox scaffold purescript algorithms/naive_sort
assert_eq 'scaffold PureScript: código' '0' "$rc_last"
assert_eq 'scaffold PureScript: conserva fuente' 'author code' "$(cat "$PSB/src/Main.purs")"
assert_eq 'scaffold PureScript: crea módulo idiomático' 'module NaiveSort where' "$(cat "$PSB/src/NaiveSort.purs")"
assert_eq 'scaffold PureScript: crea runner vacío' '0' \
    "$(cmp -s "$PSB/test/Test/Main.purs" "$TESTS_DIR/../data/scaffold_templates/purescript.runner.purs"; echo $?)"
assert_contains 'scaffold PureScript: avisa falso verde' 'runner vacío puede devolver éxito' "$err"
assert_contains 'scaffold PureScript: instrucción manual test-unit' 'spago install --test-deps test-unit' "$err"
assert_contains 'scaffold PureScript: avisa warnings de dependencia' '15 warnings de dependencia' "$err"
assert_contains 'scaffold PureScript: anuncia análisis' 'glot prompt scaffold purescript algorithms/naive_sort' "$err"
PS_NATIVE="$SANDBOX/purescript/core/algorithms/data_structures_basics"
mkdir -p "$PS_NATIVE/src" "$PS_NATIVE/test/Test"
printf 'native manifest\n' >"$PS_NATIVE/spago.yaml"
cp "$TESTS_DIR/../data/scaffold_templates/purescript.Main.purs" "$PS_NATIVE/src/Main.purs"
cp "$TESTS_DIR/../data/scaffold_templates/purescript.Test.Main.purs" "$PS_NATIVE/test/Test/Main.purs"
printf '\n' >>"$PS_NATIVE/src/Main.purs"
printf '\n' >>"$PS_NATIVE/test/Test/Main.purs"
glot_run_sandbox -n scaffold purescript algorithms/data_structures_basics
assert_eq 'scaffold PureScript -n: código' '0' "$rc_last"
assert_eq 'scaffold PureScript -n: conserva plantilla' 'yes' "$([[ -f "$PS_NATIVE/src/Main.purs" ]] && echo yes || echo no)"
glot_run_sandbox scaffold purescript algorithms/data_structures_basics
assert_eq 'scaffold PureScript nativo: código' '0' "$rc_last"
assert_eq 'scaffold PureScript nativo: retira ejemplo exacto' 'no' "$([[ -e "$PS_NATIVE/src/Main.purs" ]] && echo yes || echo no)"
assert_eq 'scaffold PureScript nativo: crea módulo' 'module DataStructuresBasics where' "$(cat "$PS_NATIVE/src/DataStructuresBasics.purs")"
assert_eq 'scaffold PureScript nativo: reemplaza runner de ejemplo' '0' \
    "$(cmp -s "$PS_NATIVE/test/Test/Main.purs" "$TESTS_DIR/../data/scaffold_templates/purescript.runner.purs"; echo $?)"
printf 'author library\n' >"$PS_NATIVE/src/DataStructuresBasics.purs"
printf 'author runner\n' >"$PS_NATIVE/test/Test/Main.purs"
glot_run_sandbox scaffold purescript algorithms/data_structures_basics
assert_eq 'scaffold PureScript repetido: código' '0' "$rc_last"
assert_eq 'scaffold PureScript repetido: conserva módulo' 'author library' "$(cat "$PS_NATIVE/src/DataStructuresBasics.purs")"
assert_eq 'scaffold PureScript repetido: conserva runner' 'author runner' "$(cat "$PS_NATIVE/test/Test/Main.purs")"
rm -- "$PS_NATIVE/test/Test/Main.purs"
ln -s "$PS_NATIVE/src/DataStructuresBasics.purs" "$PS_NATIVE/test/Test/Main.purs"
glot_run_sandbox scaffold purescript algorithms/data_structures_basics
assert_eq 'scaffold PureScript runner symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold PureScript runner symlink: conserva destino' 'author library' "$(cat "$PS_NATIVE/src/DataStructuresBasics.purs")"
PS_MISSING="$SANDBOX/purescript/core/algorithms/searching"
mkdir -p "$PS_MISSING"
glot_run_sandbox scaffold purescript algorithms/searching
assert_eq 'scaffold PureScript sin manifiesto: bloquea' '4' "$rc_last"
assert_contains 'scaffold PureScript sin manifiesto: diagnóstico' 'missing regular Spago manifest' "$err"
assert_eq 'scaffold PureScript sin manifiesto: no crea fuentes' 'no' "$([[ -e "$PS_MISSING/src" ]] && echo yes || echo no)"

PS_RUN="$SANDBOX/purescript/core/foundations/unit_test/calculator"
mkdir -p "$PS_RUN/test/Test" "$PS_RUN/bin"
printf 'package: {\\n  name: calculator\\n}' >"$PS_RUN/spago.yaml"
printf 'module Test.Main where\\n' >"$PS_RUN/test/Test/Main.purs"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf '           Src   Lib   All\nWarnings     0     0     0\nRunning tests for package: calculator\n'
exit 0
EOF
chmod +x "$PS_RUN/bin/spago"
cp -- "$DATA_DIR/purescript_test.sh" "$PS_RUN/purescript_test.sh"
ps_rc=0
(
    cd "$PS_RUN"
    PATH="$PWD/bin:$PATH" bash ./purescript_test.sh
) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript cero casos: rechaza' '1' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
cat <<'OUT'
           Src   Lib   All
Warnings     0    15    15
Errors       0     0     0
All 1 tests passed!
OUT
exit 0
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: rechaza warnings de dependencias' '1' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf '           Src   Lib   All\nWarnings     0   0/15  0/15\nErrors       0     0     0\nAll 5 tests passed!\n'
exit 0
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: acepta warnings de dependencia censurados' '0' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf '           Src   Lib   All\nWarnings     0   1/15  1/15\nErrors       0     0     0\nAll 5 tests passed!\n'
exit 0
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: rechaza warnings visibles con censor' '1' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf '           Src   Lib   All\nWarnings     0     0     0\nErrors       0     0     0\nAll 3 tests passed!\n'
exit 0
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: acepta casos sin warnings' '0' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf 'All 3 tests passed!\n'
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: rechaza resumen de warnings ausente' '1' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf '           Src   Lib   All\nWarnings     0     2     0\nAll 3 tests passed!\n'
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: rechaza resumen de warnings inconsistente' '1' "$ps_rc"
cat >"$PS_RUN/bin/spago" <<'EOF'
#!/usr/bin/env bash
printf 'compiler failed\n'
exit 42
EOF
chmod +x "$PS_RUN/bin/spago"
ps_rc=0
(cd "$PS_RUN" && PATH="$PWD/bin:$PATH" bash ./purescript_test.sh) >/dev/null 2>&1 || ps_rc=$?
assert_eq 'test PureScript: propaga fallo de Spago' '42' "$ps_rc"

# Haskell: validar cada resumen y propagar los fallos de Cabal.
HS_FAKE="$WORK_DIR/haskell-fake"
mkdir -p "$HS_FAKE/bin" "$HS_FAKE/dist-newstyle"
HS_FAKE_SHARED_MARKER="$HS_FAKE/dist-newstyle/marker"
export HS_FAKE_SHARED_MARKER
printf 'shared build\n' >"$HS_FAKE_SHARED_MARKER"
cat >"$HS_FAKE/bin/cabal" <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == clean ]]; then
    rm -f -- "$HS_FAKE_SHARED_MARKER"
    exit 0
fi
if [[ "${1:-}" != test ]]; then exit 99; fi
builddir=
for arg in "$@"; do
    case "$arg" in --builddir=*) builddir="${arg#--builddir=}" ;; esac
done
if [[ -z "$builddir" || -e "$builddir" ]]; then exit 98; fi
mkdir -p -- "$builddir"
cat -- "$HS_FAKE_OUTPUT"
exit "${HS_FAKE_RC:-0}"
EOF
chmod +x "$HS_FAKE/bin/cabal"
HS_FAKE_OUTPUT="$HS_FAKE/output"
export HS_FAKE_OUTPUT
cat >"$HS_FAKE_OUTPUT" <<'EOF'
Test suite first: RUNNING...
2 examples, 0 failures
Test suite first: PASS
Test suite second: RUNNING...
1 example, 0 failures
Test suite second: PASS
EOF
hs_rc=0
hs_out="$(cd "$HS_FAKE" && PATH="$HS_FAKE/bin:$PATH" bash "$DATA_DIR/haskell_test.sh" 2>&1)" || hs_rc=$?
assert_eq 'test Haskell: acepta dos suites con casos' '0' "$hs_rc"
assert_eq 'test Haskell: preserva build compartido' 'shared build' \
    "$(cat "$HS_FAKE_SHARED_MARKER")"
sed -i 's/1 example, 0 failures/0 examples, 0 failures/' "$HS_FAKE_OUTPUT"
hs_rc=0
hs_out="$(cd "$HS_FAKE" && PATH="$HS_FAKE/bin:$PATH" bash "$DATA_DIR/haskell_test.sh" 2>&1)" || hs_rc=$?
assert_eq 'test Haskell: rechaza una suite vacía' '1' "$hs_rc"
assert_contains 'test Haskell: identifica suite vacía' 'empty, failing or pending Hspec suite: second' "$hs_out"
sed -i 's/0 examples, 0 failures/1 example, 0 failures, 1 pending/' "$HS_FAKE_OUTPUT"
hs_rc=0
hs_out="$(cd "$HS_FAKE" && PATH="$HS_FAKE/bin:$PATH" bash "$DATA_DIR/haskell_test.sh" 2>&1)" || hs_rc=$?
assert_eq 'test Haskell: rechaza pendientes' '1' "$hs_rc"
sed -i '/1 example, 0 failures, 1 pending/d' "$HS_FAKE_OUTPUT"
hs_rc=0
hs_out="$(cd "$HS_FAKE" && PATH="$HS_FAKE/bin:$PATH" bash "$DATA_DIR/haskell_test.sh" 2>&1)" || hs_rc=$?
assert_eq 'test Haskell: rechaza resumen ausente' '1' "$hs_rc"
assert_contains 'test Haskell: explica resumen ausente' 'missing unambiguous Hspec summary' "$hs_out"
hs_rc=0
hs_out="$(cd "$HS_FAKE" && HS_FAKE_RC=7 PATH="$HS_FAKE/bin:$PATH" bash "$DATA_DIR/haskell_test.sh" 2>&1)" || hs_rc=$?
assert_eq 'test Haskell: propaga código Cabal' '7' "$hs_rc"

# Haskell: los módulos locales importados deben declararse en cada target Cabal.
if command -v cabal >/dev/null 2>&1 && command -v ghc >/dev/null 2>&1; then
    if [[ "$(cabal --numeric-version)" == '3.16.1.0' ]]; then
    HS_GLOT="$SANDBOX/haskell/core/algorithms/data_structures_basics"
    mkdir -p "$HS_GLOT"
    glot_run_sandbox new haskell algorithms/data_structures_basics
    assert_eq 'new Haskell nativo: código' '0' "$rc_last"
    glot_run_sandbox scaffold haskell algorithms/data_structures_basics
    assert_eq 'scaffold Haskell nativo: código' '0' "$rc_last"
    assert_contains 'scaffold Haskell nativo: adapta plantilla' 'Haskell test suite adapted to Hspec' "$err"
    assert_eq 'scaffold Haskell nativo: fuente y runner' 'yes' \
        "$([[ -f "$HS_GLOT/lib/DataStructuresBasics.hs" && -f "$HS_GLOT/test/RunTests.hs" && ! -e "$HS_GLOT/test/Main.hs" ]] && echo yes || echo no)"

    mkdir -p "$HS_GLOT/lib/Nested"
    printf 'module Nested.Helper where\n' >"$HS_GLOT/lib/Nested/Helper.hs"
    printf 'module ExampleSpec where\n' >"$HS_GLOT/test/ExampleSpec.hs"
    hs_manifest="$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox -n sync-build library Nested.Helper haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: plan' '0' "$rc_last"
    assert_contains 'sync-build Haskell: plan muestra módulo' '+    other-modules:     Nested.Helper' "$out"
    assert_eq 'sync-build Haskell: plan no modifica manifiesto' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox sync-build library Nested.Helper haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: declara helper de biblioteca' '0' "$rc_last"
    assert_contains 'sync-build Haskell: helper en biblioteca' 'other-modules:     Nested.Helper' \
        "$(sed -n '/^library$/,/^test-suite /p' "$HS_GLOT/data-structures-basics.cabal")"
    assert_eq 'sync-build Haskell: no declara helper de biblioteca en tests' 'no' \
        "$(sed -n '/^test-suite /,$p' "$HS_GLOT/data-structures-basics.cabal" | grep -q Nested.Helper && echo yes || echo no)"
    hs_manifest="$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox sync-build library Nested.Helper haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: rerun sin cambios' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"
    assert_contains 'sync-build Haskell: rerun informa' 'module already declared' "$err"
    glot_run_sandbox sync-build test ExampleSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: declara grupo de pruebas' '0' "$rc_last"
    assert_contains 'sync-build Haskell: grupo en test-suite' 'other-modules:     ExampleSpec' \
        "$(sed -n '/^test-suite /,$p' "$HS_GLOT/data-structures-basics.cabal")"
    printf 'module SecondSpec where\n' >"$HS_GLOT/test/SecondSpec.hs"
    glot_run_sandbox sync-build test SecondSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: añade segundo grupo' '0' "$rc_last"
    assert_contains 'sync-build Haskell: conserva primer grupo' 'other-modules:     ExampleSpec, SecondSpec' \
        "$(sed -n '/^test-suite /,$p' "$HS_GLOT/data-structures-basics.cabal")"
    hs_manifest="$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox sync-build test ExampleSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: rerun con varios módulos' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"
    hs_manifest="$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox sync-build test MissingSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: rechaza módulo ausente' '1' "$rc_last"
    assert_eq 'sync-build Haskell: ausencia no modifica manifiesto' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"
    ln -s ExampleSpec.hs "$HS_GLOT/test/LinkedSpec.hs"
    glot_run_sandbox sync-build test LinkedSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: rechaza fuente simbólica' '1' "$rc_last"
    assert_eq 'sync-build Haskell: enlace no modifica manifiesto' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"
    printf 'module OtherSpec where\n' >"$HS_GLOT/test/OtherSpec.hs"
    sed -i '/^test-suite /a\    if flag(custom)\n        ghc-options: -O0' "$HS_GLOT/data-structures-basics.cabal"
    hs_manifest="$(cat "$HS_GLOT/data-structures-basics.cabal")"
    glot_run_sandbox sync-build test OtherSpec haskell algorithms/data_structures_basics
    assert_eq 'sync-build Haskell: rechaza condiciones propias' '1' "$rc_last"
    assert_contains 'sync-build Haskell: informa preservación' 'custom Cabal configuration preserved' "$err"
    assert_eq 'sync-build Haskell: preserva configuración propia' "$hs_manifest" "$(cat "$HS_GLOT/data-structures-basics.cabal")"

    HS_NATIVE="$WORK_DIR/haskell-native"
    mkdir -p "$HS_NATIVE"
    (cd "$HS_NATIVE" && cabal init --lib --tests -n --source-dir=lib \
        --package-name=naive-sort --expose-module=NaiveSort >/dev/null 2>&1)
    cp -R "$HS_NATIVE" "$WORK_DIR/haskell-custom"
    HS_CUSTOM="$WORK_DIR/haskell-custom"
    printf 'authored test\n' >>"$HS_CUSTOM/test/Main.hs"
    hs_manifest="$(cat "$HS_CUSTOM/naive-sort.cabal")"
    hs_runner="$(cat "$HS_CUSTOM/test/Main.hs")"
    hs_out="$(cd "$HS_CUSTOM" && bash "$DATA_DIR/haskell_scaffold.sh" naive_sort 2>&1)"
    assert_contains 'Haskell: informa runner propio' 'custom Haskell runner preserved' "$hs_out"
    assert_eq 'Haskell: conserva runner propio' "$hs_runner" "$(cat "$HS_CUSTOM/test/Main.hs")"
    assert_eq 'Haskell: conserva manifiesto junto a runner propio' "$hs_manifest" "$(cat "$HS_CUSTOM/naive-sort.cabal")"
    cp -- "$DATA_DIR/scaffold_templates/haskell.Main.hs" "$HS_CUSTOM/test/Main.hs"
    printf '\n-- authored suite addition\n' >>"$HS_CUSTOM/naive-sort.cabal"
    hs_manifest="$(cat "$HS_CUSTOM/naive-sort.cabal")"
    hs_out="$(cd "$HS_CUSTOM" && bash "$DATA_DIR/haskell_scaffold.sh" naive_sort 2>&1)"
    assert_contains 'Haskell: informa suite propia' 'custom Cabal test suite preserved' "$hs_out"
    assert_eq 'Haskell: conserva suite propia' "$hs_manifest" "$(cat "$HS_CUSTOM/naive-sort.cabal")"
    assert_eq 'Haskell: conserva muestra junto a suite propia' 'yes' "$([[ -f "$HS_CUSTOM/test/Main.hs" && ! -e "$HS_CUSTOM/test/RunTests.hs" ]] && echo yes || echo no)"

    hs_out="$(cd "$HS_NATIVE" && bash "$DATA_DIR/haskell_scaffold.sh" naive_sort 2>&1)"
    assert_contains 'Haskell: adapta plantilla nativa' 'Haskell test suite adapted to Hspec' "$hs_out"
    assert_contains 'Haskell: manifiesto apunta al runner' 'main-is:          RunTests.hs' "$(cat "$HS_NATIVE/naive-sort.cabal")"
    assert_contains 'Haskell: declara Hspec en test-suite' 'hspec ^>=2.11.0' "$(sed -n '/^test-suite /,$p' "$HS_NATIVE/naive-sort.cabal")"
    assert_eq 'Haskell: no añade Hspec a biblioteca' 'no' "$([[ "$(sed -n '/^library$/,/^test-suite /p' "$HS_NATIVE/naive-sort.cabal")" == *hspec* ]] && echo yes || echo no)"
    assert_eq 'Haskell: usa runner Hspec sin conservar muestra' 'yes' "$([[ -f "$HS_NATIVE/test/RunTests.hs" && ! -e "$HS_NATIVE/test/Main.hs" ]] && echo yes || echo no)"
    hs_manifest="$(cat "$HS_NATIVE/naive-sort.cabal")"
    hs_runner="$(cat "$HS_NATIVE/test/RunTests.hs")"
    (cd "$HS_NATIVE" && bash "$DATA_DIR/haskell_scaffold.sh" naive_sort >/dev/null 2>&1)
    assert_eq 'Haskell: rerun conserva manifiesto' "$hs_manifest" "$(cat "$HS_NATIVE/naive-sort.cabal")"
    assert_eq 'Haskell: rerun conserva runner' "$hs_runner" "$(cat "$HS_NATIVE/test/RunTests.hs")"
    ln -s "$HS_CUSTOM/test/Main.hs" "$HS_CUSTOM/test/RunTests.hs"
    hs_rc=0
    (cd "$HS_CUSTOM" && bash "$DATA_DIR/haskell_scaffold.sh" naive_sort >/dev/null 2>&1) || hs_rc=$?
    assert_eq 'Haskell: rechaza runner simbólico' '1' "$hs_rc"
    assert_eq 'Haskell: no altera destino simbólico' 'yes' "$([[ -f "$HS_CUSTOM/test/Main.hs" ]] && echo yes || echo no)"
    fi

    HS_EMPTY="$SANDBOX/haskell/core/algorithms/naive_sort"
    mkdir -p "$HS_EMPTY/lib"
    printf 'packages: .\nactive-repositories: :none\n' >"$HS_EMPTY/cabal.project"
    printf 'cabal-version: 3.0\nname: naive-sort\nversion: 0.1.0.0\nbuild-type: Simple\nlibrary\n    exposed-modules: NaiveSort\n    hs-source-dirs: lib\n    build-depends: base\n    default-language: Haskell2010\n' >"$HS_EMPTY/naive-sort.cabal"
    printf 'module NaiveSort where\n' >"$HS_EMPTY/lib/NaiveSort.hs"
    glot_run_sandbox test haskell algorithms/naive_sort
    assert_eq 'test Haskell: rechaza paquete sin suites' '4' "$rc_last"
    assert_contains 'test Haskell: informa ausencia de suites' 'does not contain any test suites' "$out$err"
    HS_CHECK="$SANDBOX/haskell/core/algorithms/searching"
    mkdir -p "$HS_CHECK/lib" "$HS_CHECK/test" "$HS_CHECK/extra/test"
    cat >"$HS_CHECK/cabal.project" <<'EOF'
packages: . extra
active-repositories: :none
EOF
    cat >"$HS_CHECK/searching.cabal" <<'EOF'
cabal-version: 3.0
name: searching
version: 0.1.0.0
build-type: Simple
library
    exposed-modules: Core
    hs-source-dirs: lib
    build-depends: base
    default-language: Haskell2010
test-suite searching-test
    type: exitcode-stdio-1.0
    main-is: RunTests.hs
    hs-source-dirs: test
    build-depends: base, searching
    default-language: Haskell2010
EOF
    cat >"$HS_CHECK/extra/extra.cabal" <<'EOF'
cabal-version: 3.0
name: extra
version: 0.1.0.0
build-type: Simple
test-suite extra-test
    type: exitcode-stdio-1.0
    main-is: Main.hs
    hs-source-dirs: test
    build-depends: base
    default-language: Haskell2010
EOF
    printf 'module Main (main) where\nmain :: IO ()\nmain = writeFile "extra-ran" "ran"\n' >"$HS_CHECK/extra/test/Main.hs"
    printf 'module Core (answer) where\nimport Helper (value)\nanswer :: Int\nanswer = value\n' >"$HS_CHECK/lib/Core.hs"
    printf 'module Helper (value) where\nvalue :: Int\nvalue = 42\n' >"$HS_CHECK/lib/Helper.hs"
    printf 'module Check (check) where\ncheck :: Int -> Bool\ncheck n = n == 42\n' >"$HS_CHECK/test/Check.hs"
    printf 'module Main (main) where\nimport Check (check)\nimport Core (answer)\nmain :: IO ()\nmain = if check answer then putStrLn "1 example, 0 failures" else fail "unexpected answer"\n' >"$HS_CHECK/test/RunTests.hs"
    glot_run_sandbox test haskell algorithms/searching
    assert_eq 'test Haskell: rechaza helper de producción ausente' '4' "$rc_last"
    assert_contains 'test Haskell: identifica helper de producción' 'Helper' "$out$err"
    assert_contains 'test Haskell: informa diagnóstico de módulos' 'missing-home-modules' "$out$err"
    sed -i '/exposed-modules: Core/a\    other-modules: Helper' "$HS_CHECK/searching.cabal"
    glot_run_sandbox test haskell algorithms/searching
    assert_eq 'test Haskell: rechaza helper de test ausente' '4' "$rc_last"
    assert_contains 'test Haskell: identifica helper de test' 'Check' "$out$err"
    assert_contains 'test Haskell: informa diagnóstico de test' 'missing-home-modules' "$out$err"
    sed -i '/type: exitcode-stdio-1.0/a\    other-modules: Check' "$HS_CHECK/searching.cabal"
    glot_run_sandbox test haskell algorithms/searching
    assert_eq 'test Haskell: ejecuta suite con helpers declarados' '0' "$rc_last"
    assert_contains 'test Haskell: conserva informe Cabal' 'PASS' "$out$err"
    assert_eq 'test Haskell: no ejecuta otro paquete' 'no' "$([[ -e "$HS_CHECK/extra-ran" || -e "$HS_CHECK/extra/extra-ran" ]] && echo yes || echo no)"
    # Separar cambios evita la carrera de marcas de tiempo observada en GHC.
    sleep 2
    printf 'module Check (check) where\ncheck :: Int -> Bool\ncheck n = n == 0\n' >"$HS_CHECK/test/Check.hs"
    glot_run_sandbox test haskell algorithms/searching
    assert_eq 'test Haskell: propaga fallo de la suite' '4' "$rc_last"
    assert_contains 'test Haskell: informa fallo de la suite' 'FAIL' "$out$err"
fi

# scaffold: las acciones repetibles preparan Assembly antes del paso 4c.
AB="$SANDBOX/assembly/core/algorithms/naive_sort"
mkdir -p -- "$AB"
glot_run_sandbox -n scaffold assembly algorithms/naive_sort
assert_eq 'sandbox scaffold assembly -n: código' '0' "$rc_last"
assert_contains 'sandbox scaffold assembly -n: planifica Makefile' \
    'scaffold_templates/assembly.Makefile' "$out"
assert_eq 'sandbox scaffold assembly -n: no muta' '0' \
    "$(find "$AB" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')"
glot_run_sandbox scaffold assembly algorithms/naive_sort
assert_eq 'sandbox scaffold assembly: código' '0' "$rc_last"
assert_eq 'sandbox scaffold assembly: crea Makefile' 'si' "$([[ -f "$AB/Makefile" ]] && echo si || echo no)"
assert_eq 'sandbox scaffold assembly: copia plantilla' '0' \
    "$(cmp -s "$AB/Makefile" "$TESTS_DIR/../data/scaffold_templates/assembly.Makefile"; echo $?)"
assert_eq 'sandbox scaffold assembly: garantiza .gitignore' 'si' \
    "$([[ -f "$AB/.gitignore" ]] && echo si || echo no)"
assert_contains 'sandbox scaffold assembly: avisa del delegate' \
    'glot prompt scaffold assembly algorithms/naive_sort' "$err"
assert_eq 'sandbox scaffold assembly: declaración NASM válida' 'section .text' "$(cat "$AB/src/naive_sort.asm")"
assert_eq 'sandbox scaffold assembly: crea runner mínimo' '0' \
    "$(cmp -s "$AB/test/run_tests.asm" "$TESTS_DIR/../data/scaffold_templates/assembly.runner.asm"; echo $?)"
assert_eq 'sandbox scaffold assembly: excluye objetos y ejecutable' '2' \
    "$(git -C "$AB" check-ignore obj/example.o test/run_tests | wc -l | tr -d ' ')"
if command -v nasm >/dev/null 2>&1 && command -v ld >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
    assembly_rc=0
    assembly_out="$(make -s -C "$AB" run 2>&1)" || assembly_rc=$?
    assert_eq 'sandbox scaffold assembly: runner compila y ejecuta' '0' "$assembly_rc"
    assert_contains 'sandbox scaffold assembly: runner declara ausencia de pruebas' 'Scaffold: no tests configured' "$assembly_out"
fi

# Repetir scaffold no reemplaza los artefactos declarados como preservables.
printf 'custom-pattern\n' >"$AB/.gitignore"
printf 'custom-makefile\n' >"$AB/Makefile"
printf 'custom source\n' >"$AB/src/naive_sort.asm"
printf 'custom runner\n' >"$AB/test/run_tests.asm"
glot_run_sandbox scaffold assembly algorithms/naive_sort
assert_eq 'sandbox scaffold repetido: código' '0' "$rc_last"
assert_eq 'sandbox scaffold repetido: conserva .gitignore' 'custom-pattern' \
    "$(cat -- "$AB/.gitignore")"
assert_eq 'sandbox scaffold repetido: conserva Makefile' 'custom-makefile' \
    "$(cat -- "$AB/Makefile")"
assert_eq 'sandbox scaffold assembly repetido: conserva fuente' 'custom source' "$(cat "$AB/src/naive_sort.asm")"
assert_eq 'sandbox scaffold assembly repetido: conserva runner' 'custom runner' "$(cat "$AB/test/run_tests.asm")"

AB_SAFE="$SANDBOX/assembly/core/algorithms/data_structures_basics"
mkdir -p "$AB_SAFE/src" "$AB_SAFE/test"
touch "$AB_SAFE/test/run_tests.asm"
glot_run_sandbox scaffold assembly algorithms/data_structures_basics
assert_eq 'assembly runner vacío anterior: completa andamiaje' '0' "$rc_last"
assert_eq 'assembly runner vacío anterior: usa runner mínimo' '0' \
    "$(cmp -s "$AB_SAFE/test/run_tests.asm" "$TESTS_DIR/../data/scaffold_templates/assembly.runner.asm"; echo $?)"
rm -- "$AB_SAFE/test/run_tests.asm"
ln -s "$AB_SAFE/src/data_structures_basics.asm" "$AB_SAFE/test/run_tests.asm"
glot_run_sandbox scaffold assembly algorithms/data_structures_basics
assert_eq 'assembly runner symlink: bloquea' '4' "$rc_last"
assert_eq 'assembly runner symlink: conserva destino' 'section .text' "$(cat "$AB_SAFE/src/data_structures_basics.asm")"
rm -- "$AB_SAFE/test/run_tests.asm" "$AB_SAFE/Makefile"
ln -s "$AB_SAFE/src/data_structures_basics.asm" "$AB_SAFE/Makefile"
glot_run_sandbox scaffold assembly algorithms/data_structures_basics
assert_eq 'assembly Makefile symlink: bloquea' '4' "$rc_last"
assert_eq 'assembly Makefile symlink: conserva destino' 'section .text' "$(cat "$AB_SAFE/src/data_structures_basics.asm")"

# C preserva los archivos del autor y usa el runner propio de Criterion.
CB="$SANDBOX/c/core/algorithms/data_structures_basics"
mkdir -p "$CB"
glot_run_sandbox -n scaffold c algorithms/data_structures_basics
assert_eq 'scaffold C -n: código' '0' "$rc_last"
assert_eq 'scaffold C -n: no crea fuentes' 'no' "$([[ -e "$CB/src" ]] && echo yes || echo no)"
glot_run_sandbox scaffold c algorithms/data_structures_basics
assert_eq 'scaffold C: código' '0' "$rc_last"
assert_eq 'scaffold C: crea cabecera y fuente' 'yes' \
    "$([[ -f "$CB/include/data_structures_basics.h" && -f "$CB/src/data_structures_basics.c" ]] && echo yes || echo no)"
assert_eq 'scaffold C: excluye objetos y ejecutables' '2' \
    "$(git -C "$CB" check-ignore obj/example.o bin/run_tests | wc -l | tr -d ' ')"
if command -v pkg-config >/dev/null 2>&1 && pkg-config --exists criterion && command -v cc >/dev/null 2>&1 && command -v make >/dev/null 2>&1; then
    c_rc=0
    c_out="$(make -s -C "$CB" test 2>&1)" || c_rc=$?
    assert_eq 'scaffold C: Criterion arranca sin casos' '0' "$c_rc"
    assert_contains 'scaffold C: informa cero casos' 'Tested: 0' "$c_out"
    printf '#include <criterion/criterion.h>\nTest(scaffold, failure) { cr_assert(0); }\n' >"$CB/test/scaffold_test.c"
    c_rc=0
    c_out="$(make -s -C "$CB" test 2>&1)" || c_rc=$?
    assert_eq 'scaffold C: propaga un caso fallido' 'yes' "$([[ "$c_rc" != 0 ]] && echo yes || echo no)"
    assert_contains 'scaffold C: ejecuta el caso fallido' 'Failing: 1' "$c_out"
fi
printf 'author header\n' >"$CB/include/data_structures_basics.h"
printf 'author source\n' >"$CB/src/data_structures_basics.c"
printf 'author makefile\n' >"$CB/Makefile"
printf 'author ignore\n' >"$CB/.gitignore"
glot_run_sandbox scaffold c algorithms/data_structures_basics
assert_eq 'scaffold C repetido: código' '0' "$rc_last"
assert_eq 'scaffold C repetido: conserva cabecera' 'author header' "$(cat "$CB/include/data_structures_basics.h")"
assert_eq 'scaffold C repetido: conserva fuente' 'author source' "$(cat "$CB/src/data_structures_basics.c")"
assert_eq 'scaffold C repetido: conserva Makefile' 'author makefile' "$(cat "$CB/Makefile")"
assert_eq 'scaffold C repetido: conserva ignore' 'author ignore' "$(cat "$CB/.gitignore")"
rm -- "$CB/src/data_structures_basics.c"
ln -s "$CB/include/data_structures_basics.h" "$CB/src/data_structures_basics.c"
glot_run_sandbox scaffold c algorithms/data_structures_basics
assert_eq 'scaffold C symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold C symlink: conserva destino' 'author header' "$(cat "$CB/include/data_structures_basics.h")"

# Groovy: retirar solo la pareja exacta sin tocar contenido propio.
GR="$SANDBOX/groovy/core/algorithms/naive_sort"
mkdir -p "$GR/lib/src/main/groovy/naive_sort" "$GR/lib/src/test/groovy/naive_sort"
mkdir -p "$GR/lib/other"
printf 'author library\n' >"$GR/lib/other/LibraryNotes.groovy"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/groovy.Library.groovy" >"$GR/lib/src/main/groovy/naive_sort/Library.groovy"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/groovy.LibraryTest.groovy" >"$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
glot_run_sandbox -n scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Groovy dry-run: conserva muestra' 'si' "$([[ -f "$GR/lib/src/main/groovy/naive_sort/Library.groovy" ]] && echo si || echo no)"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy: código' '0' "$rc_last"
assert_eq 'scaffold Groovy: retira fuente de muestra' 'no' "$([[ -e "$GR/lib/src/main/groovy/naive_sort/Library.groovy" ]] && echo si || echo no)"
assert_eq 'scaffold Groovy: retira test de muestra' 'no' "$([[ -e "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy" ]] && echo si || echo no)"
assert_eq 'scaffold Groovy: conserva Library fuera del source root' 'author library' "$(cat -- "$GR/lib/other/LibraryNotes.groovy")"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy repetido: código' '0' "$rc_last"
assert_contains 'scaffold Groovy: anuncia revisión' 'revisar muestras Groovy' "$err"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/groovy.Library.groovy" >"$GR/lib/src/main/groovy/naive_sort/Library.groovy"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/groovy.LibraryTest.groovy" >"$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
printf 'author helper\n' >"$GR/lib/src/main/groovy/naive_sort/LibraryHelper.groovy"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy con helper: código' '0' "$rc_last"
assert_eq 'scaffold Groovy con helper: conserva helper' 'author helper' "$(cat -- "$GR/lib/src/main/groovy/naive_sort/LibraryHelper.groovy")"
assert_eq 'scaffold Groovy con helper: conserva muestras' 'si' "$([[ -f "$GR/lib/src/main/groovy/naive_sort/Library.groovy" && -f "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy" ]] && echo si || echo no)"
rm -- "$GR/lib/src/main/groovy/naive_sort/LibraryHelper.groovy"
printf 'authored test\n' >"$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy test propio: código' '0' "$rc_last"
assert_eq 'scaffold Groovy test propio: conserva test' 'authored test' "$(cat -- "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy")"
assert_eq 'scaffold Groovy test propio: conserva fuente' 'si' "$([[ -f "$GR/lib/src/main/groovy/naive_sort/Library.groovy" ]] && echo si || echo no)"
rm -- "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
ln -s "$GR/lib/src/main/groovy/naive_sort/Library.groovy" "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy enlace: rechaza' '4' "$rc_last"
assert_eq 'scaffold Groovy enlace: conserva destino' 'si' "$([[ -f "$GR/lib/src/main/groovy/naive_sort/Library.groovy" ]] && echo si || echo no)"
rm -- "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/groovy.LibraryTest.groovy" >"$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy"
mv -- "$SANDBOX/scripts/data/scaffold_templates/groovy.LibraryTest.groovy" "$SANDBOX/scripts/data/scaffold_templates/groovy.LibraryTest.saved"
glot_run_sandbox scaffold groovy algorithms/naive_sort
assert_eq 'scaffold Groovy plantilla ausente: rechaza' '4' "$rc_last"
assert_eq 'scaffold Groovy plantilla ausente: conserva pareja' 'si' "$([[ -f "$GR/lib/src/main/groovy/naive_sort/Library.groovy" && -f "$GR/lib/src/test/groovy/naive_sort/LibraryTest.groovy" ]] && echo si || echo no)"
mv -- "$SANDBOX/scripts/data/scaffold_templates/groovy.LibraryTest.saved" "$SANDBOX/scripts/data/scaffold_templates/groovy.LibraryTest.groovy"

# Kotlin: el mismo mecanismo protege la pareja y los archivos propios.
KT="$SANDBOX/kotlin/core/algorithms/naive_sort"
mkdir -p "$KT/lib/src/main/kotlin/naive_sort" "$KT/lib/src/test/kotlin/naive_sort" "$KT/notes"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/kotlin.Library.kt" >"$KT/lib/src/main/kotlin/naive_sort/Library.kt"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/kotlin.LibraryTest.kt" >"$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
printf 'author library\n' >"$KT/notes/LibraryNotes.kt"
glot_run_sandbox -n scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Kotlin dry-run: conserva muestra' 'si' "$([[ -f "$KT/lib/src/main/kotlin/naive_sort/Library.kt" ]] && echo si || echo no)"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin: código' '0' "$rc_last"
assert_eq 'scaffold Kotlin: retira pareja exacta' 'no' "$([[ -e "$KT/lib/src/main/kotlin/naive_sort/Library.kt" || -e "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt" ]] && echo si || echo no)"
assert_eq 'scaffold Kotlin: conserva Library fuera del source root' 'author library' "$(cat -- "$KT/notes/LibraryNotes.kt")"
assert_contains 'scaffold Kotlin: anuncia revisión' 'revisar muestras Kotlin' "$err"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin repetido: código' '0' "$rc_last"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/kotlin.Library.kt" >"$KT/lib/src/main/kotlin/naive_sort/Library.kt"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/kotlin.LibraryTest.kt" >"$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
printf 'author helper\n' >"$KT/lib/src/main/kotlin/naive_sort/LibraryHelper.kt"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin con helper: código' '0' "$rc_last"
assert_eq 'scaffold Kotlin con helper: conserva pareja' 'si' "$([[ -f "$KT/lib/src/main/kotlin/naive_sort/Library.kt" && -f "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt" ]] && echo si || echo no)"
assert_eq 'scaffold Kotlin con helper: conserva helper' 'author helper' "$(cat -- "$KT/lib/src/main/kotlin/naive_sort/LibraryHelper.kt")"
rm -- "$KT/lib/src/main/kotlin/naive_sort/LibraryHelper.kt"
printf 'author test\n' >"$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin test propio: código' '0' "$rc_last"
assert_eq 'scaffold Kotlin test propio: conserva pareja' 'si' "$([[ -f "$KT/lib/src/main/kotlin/naive_sort/Library.kt" && "$(cat -- "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt")" == 'author test' ]] && echo si || echo no)"
rm -- "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
ln -s "$KT/lib/src/main/kotlin/naive_sort/Library.kt" "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin enlace: rechaza' '4' "$rc_last"
assert_eq 'scaffold Kotlin enlace: conserva destino' 'si' "$([[ -f "$KT/lib/src/main/kotlin/naive_sort/Library.kt" ]] && echo si || echo no)"
rm -- "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/kotlin.LibraryTest.kt" >"$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt"
mv -- "$SANDBOX/scripts/data/scaffold_templates/kotlin.LibraryTest.kt" "$SANDBOX/scripts/data/scaffold_templates/kotlin.LibraryTest.saved"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin plantilla ausente: rechaza' '4' "$rc_last"
assert_eq 'scaffold Kotlin plantilla ausente: conserva pareja' 'si' "$([[ -f "$KT/lib/src/main/kotlin/naive_sort/Library.kt" && -f "$KT/lib/src/test/kotlin/naive_sort/LibraryTest.kt" ]] && echo si || echo no)"
mv -- "$SANDBOX/scripts/data/scaffold_templates/kotlin.LibraryTest.saved" "$SANDBOX/scripts/data/scaffold_templates/kotlin.LibraryTest.kt"
mv -- "$KT/lib/src" "$KT/lib/src.saved"
glot_run_sandbox scaffold kotlin algorithms/naive_sort
assert_eq 'scaffold Kotlin layout distinto: rechaza' '4' "$rc_last"
assert_eq 'scaffold Kotlin layout distinto: conserva pareja' 'si' "$([[ -f "$KT/lib/src.saved/main/kotlin/naive_sort/Library.kt" && -f "$KT/lib/src.saved/test/kotlin/naive_sort/LibraryTest.kt" ]] && echo si || echo no)"
mv -- "$KT/lib/src.saved" "$KT/lib/src"

# Gradle: rechazar NO-SOURCE mediante el runner compartido.
GR_RUN="$SANDBOX/groovy/core/algorithms/naive_sort"
mkdir -p "$GR_RUN"
cat >"$GR_RUN/gradlew" <<'EOF'
#!/usr/bin/env bash
echo '> Task :lib:test NO-SOURCE'
echo 'BUILD SUCCESSFUL'
EOF
chmod +x "$GR_RUN/gradlew"
cp -- "$DATA_DIR/gradle_test.sh" "$GR_RUN/gradle_test.sh"
gr_rc=0
(
    cd "$GR_RUN"
    bash ./gradle_test.sh
) >/dev/null 2>&1 || gr_rc=$?
assert_eq 'test Gradle NO-SOURCE: rechaza' '1' "$gr_rc"
cat >"$GR_RUN/gradlew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
echo '> Task :lib:compileTestJava NO-SOURCE'
echo '> Task :lib:test'
mkdir -p lib/build/test-results/test
printf '<testsuite tests="1" failures="0" errors="0" skipped="0"></testsuite>\n' >lib/build/test-results/test/TEST-passing.xml
EOF
chmod +x "$GR_RUN/gradlew"
gr_rc=0
(
    cd "$GR_RUN"
    bash ./gradle_test.sh
) >/dev/null 2>&1 || gr_rc=$?
assert_eq 'test Gradle NO-SOURCE en tarea auxiliar: acepta casos aprobados' '0' "$gr_rc"
cat >"$GR_RUN/gradlew" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
mkdir -p lib/build/test-results/test
printf '<testsuite tests="1" failures="0" errors="0" skipped="0"></testsuite>\n' >lib/build/test-results/test/TEST-passing.xml
printf '<testsuite' >lib/build/test-results/test/TEST-corrupt.xml
EOF
chmod +x "$GR_RUN/gradlew"
gr_rc=0
(
    cd "$GR_RUN"
    bash ./gradle_test.sh
) >/dev/null 2>"$WORK_DIR/gradle-corrupt.err" || gr_rc=$?
assert_eq 'test Gradle XML ilegible: rechaza' '1' "$gr_rc"
assert_contains 'test Gradle XML ilegible: diagnóstico' 'unreadable Gradle XML report' \
    "$(cat -- "$WORK_DIR/gradle-corrupt.err")"

# Nim: retirar solo muestras exactas y no duplicar la task.
NM="$SANDBOX/nim/core/algorithms/naive_sort"
mkdir -p "$NM/src/naive_sort" "$NM/tests"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/nim.main.nim" >"$NM/src/naive_sort.nim"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/nim.submodule.nim" >"$NM/src/naive_sort/submodule.nim"
sed 's/@MODULE@/naive_sort/g' "$DATA_DIR/scaffold_templates/nim.test1.nim" >"$NM/tests/test1.nim"
printf 'requires "nim >= 2.0.0"\n' >"$NM/naive_sort.nimble"
glot_run_sandbox -n scaffold nim algorithms/naive_sort
assert_eq 'scaffold Nim dry-run: código' '0' "$rc_last"
glot_run_sandbox scaffold nim algorithms/naive_sort
assert_eq 'scaffold Nim: código' '0' "$rc_last"
assert_eq 'scaffold Nim: retira muestras' 'no' "$([[ -e "$NM/src/naive_sort.nim" || -e "$NM/src/naive_sort/submodule.nim" || -e "$NM/tests/test1.nim" ]] && echo si || echo no)"
assert_eq 'scaffold Nim: añade task una vez' '1' "$(grep -Fc 'nim c -r tests/naive_sort_tests.nim' "$NM/naive_sort.nimble")"
glot_run_sandbox scaffold nim algorithms/naive_sort
assert_eq 'scaffold Nim repetido: no duplica task' '1' "$(grep -Fc 'nim c -r tests/naive_sort_tests.nim' "$NM/naive_sort.nimble")"
mkdir -p "$NM/src"
printf 'proc add*(x, y: int): int = x + y\n' >"$NM/src/naive_sort.nim"
cat >"$NM/tests/naive_sort_tests.nim" <<'EOF'
import unittest
import naive_sort
suite "naive_sort":
  test "addition":
    check add(5, 5) == 10
EOF
cp -- "$DATA_DIR/nim_test.sh" "$NM/nim_test.sh"
(
    cd "$NM"
    bash ./nim_test.sh
) >/dev/null 2>&1
assert_eq 'test Nim caso aprobado: código' '0' "$?"

# V: rechaza un resumen con cero casos.
VB="$SANDBOX/v/core/algorithms/naive_sort"
mkdir -p "$VB/tests"
printf "Module {\\n name: 'naive_sort'\\n version: '0.1.0'\\n license: 'MIT'\\n}\n" >"$VB/v.mod"
cp -- "$DATA_DIR/v_test.sh" "$VB/v_test.sh"
v_rc=0
(
    cd "$VB"
    bash ./v_test.sh
) >/dev/null 2>&1 || v_rc=$?
assert_eq 'test V cero casos: rechaza' '1' "${v_rc:-0}"

# Ballerina: el informe JSON rechaza cero casos.
BB_RUN="$SANDBOX/ballerina/core/foundations/unit_test/calculator"
mkdir -p "$BB_RUN/tests"
printf '[package]\nname = "naive_sort"\nversion = "0.1.0"\n' >"$BB_RUN/Ballerina.toml"
: >"$BB_RUN/naive_sort.bal"
cp -- "$DATA_DIR/ballerina_test.sh" "$BB_RUN/ballerina_test.sh"
ba_rc=0
(
    cd "$BB_RUN"
    bash ./ballerina_test.sh
) >/dev/null 2>&1 || ba_rc=$?
assert_eq 'test Ballerina cero casos: rechaza' '1' "$ba_rc"

# Ballerina: consume solo el informe de esta ejecución, no uno antiguo.
BB_REPORT="$SANDBOX/ballerina/report_cases"
mkdir -p "$BB_REPORT/tests" "$BB_REPORT/bin" "$BB_REPORT/target/report/previous"
printf '[package]\nname = "report_cases"\nversion = "0.1.0"\n' >"$BB_REPORT/Ballerina.toml"
printf '{"totalTests":1,"passed":1,"failed":0,"skipped":0}\n' >"$BB_REPORT/target/report/previous/old_test_results.json"
cp -- "$DATA_DIR/ballerina_test.sh" "$BB_REPORT/ballerina_test.sh"
cat >"$BB_REPORT/bin/bal" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
report_dir=''
for arg in "$@"; do
    case "$arg" in
        --test-report-dir=*) report_dir="${arg#*=}" ;;
    esac
done
mode="${FAKE_BAL_MODE:-pass}"
if [[ "$mode" == pass || "$mode" == incomplete ]]; then
    [[ -n "$report_dir" ]]
    mkdir -p -- "$report_dir"
    if [[ "$mode" == incomplete ]]; then
        printf '{"totalTests":1}\n' >"$report_dir/current_test_results.json"
    else
        printf '{"totalTests":1,"passed":1,"failed":0,"skipped":0}\n' >"$report_dir/current_test_results.json"
    fi
fi
EOF
chmod +x "$BB_REPORT/bin/bal"
ba_report_rc=0
(
    cd "$BB_REPORT"
    PATH="$BB_REPORT/bin:$PATH" FAKE_BAL_MODE=pass bash ./ballerina_test.sh
) >/dev/null 2>"$WORK_DIR/ballerina-report-pass.err" || ba_report_rc=$?
assert_eq 'test Ballerina informe actual: acepta' '0' "$ba_report_rc"
assert_eq 'test Ballerina informe actual: directorio aislado' 'si' "$(find "$BB_REPORT/target/report" -type f -name '*test_results.json' -path '*/glot-run.*/*' -print -quit | grep -q . && echo si || echo no)"
ba_stale_rc=0
(
    cd "$BB_REPORT"
    PATH="$BB_REPORT/bin:$PATH" FAKE_BAL_MODE=no-report bash ./ballerina_test.sh
) >/dev/null 2>"$WORK_DIR/ballerina-report-stale.err" || ba_stale_rc=$?
ba_stale_err="$(cat -- "$WORK_DIR/ballerina-report-stale.err")"
assert_eq 'test Ballerina informe antiguo: rechaza' '1' "$ba_stale_rc"
assert_contains 'test Ballerina informe antiguo: diagnóstico' 'missing or ambiguous Ballerina JSON test report' "$ba_stale_err"
ba_incomplete_rc=0
(
    cd "$BB_REPORT"
    PATH="$BB_REPORT/bin:$PATH" FAKE_BAL_MODE=incomplete bash ./ballerina_test.sh
) >/dev/null 2>"$WORK_DIR/ballerina-report-incomplete.err" || ba_incomplete_rc=$?
ba_incomplete_err="$(cat -- "$WORK_DIR/ballerina-report-incomplete.err")"
assert_eq 'test Ballerina informe incompleto: rechaza' '1' "$ba_incomplete_rc"
assert_contains 'test Ballerina informe incompleto: diagnóstico' 'incomplete Ballerina JSON report' "$ba_incomplete_err"

# v2.1.0 continúa con los comandos manuales de la siguiente revisión.
# v2.1.0: el nombre del fuente y el archivo vacío de pruebas son comandos del catálogo.
BB="$SANDBOX/ballerina/core/algorithms/naive_sort"
mkdir -p -- "$BB"
cp -- "$TESTS_DIR/../data/scaffold_templates/ballerina.main.bal" "$BB/main.bal"
printf 'gitdir: external-repository\n' >"$BB/.git"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina gitfile previo: bloquea' '4' "$rc_last"
assert_eq 'scaffold Ballerina gitfile previo: conserva gitfile' 'gitdir: external-repository' "$(cat -- "$BB/.git")"
rm -- "$BB/.git"
glot_run_sandbox -n scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina -n: código' '0' "$rc_last"
assert_eq 'scaffold Ballerina -n: conserva main' 'si' "$([[ -f "$BB/main.bal" ]] && echo si || echo no)"
assert_eq 'scaffold Ballerina -n: no crea tests' 'no' "$([[ -e "$BB/tests" ]] && echo si || echo no)"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina: código' '0' "$rc_last"
assert_eq 'scaffold Ballerina: renombra main' 'no' "$([[ -e "$BB/main.bal" ]] && echo si || echo no)"
assert_eq 'scaffold Ballerina: biblioteca sin ejemplo' 'si' "$([[ -f "$BB/naive_sort.bal" && ! -s "$BB/naive_sort.bal" ]] && echo si || echo no)"
assert_eq 'scaffold Ballerina: archivo de tests vacío' 'si' "$([[ -f "$BB/tests/lib_test.bal" && ! -s "$BB/tests/lib_test.bal" ]] && echo si || echo no)"
assert_contains 'scaffold Ballerina: avisa falso verde' 'bal test puede devolver éxito sin casos' "$err"
printf 'public function custom() {}\n' >"$BB/naive_sort.bal"
printf '// authored tests\n' >"$BB/tests/lib_test.bal"
printf 'custom-ignore\n' >"$BB/.gitignore"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina repetido: código' '0' "$rc_last"
assert_eq 'scaffold Ballerina repetido: conserva fuente' 'public function custom() {}' "$(cat -- "$BB/naive_sort.bal")"
assert_eq 'scaffold Ballerina repetido: conserva tests' '// authored tests' "$(cat -- "$BB/tests/lib_test.bal")"
assert_eq 'scaffold Ballerina repetido: conserva ignore' 'custom-ignore' "$(cat -- "$BB/.gitignore")"
printf 'custom main\n' >"$BB/main.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina conflicto: código' '4' "$rc_last"
assert_contains 'scaffold Ballerina conflicto: diagnóstico' 'ambiguous rename' "$err"
assert_eq 'scaffold Ballerina conflicto: conserva main' 'custom main' "$(cat -- "$BB/main.bal")"
rm -- "$BB/main.bal" "$BB/naive_sort.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina sin fuentes: código' '4' "$rc_last"
printf 'authored main\n' >"$BB/main.bal"
ln -s "$BB/main.bal" "$BB/naive_sort.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina destino symlink: código' '4' "$rc_last"
rm -- "$BB/naive_sort.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina fuente propia: código' '0' "$rc_last"
assert_eq 'scaffold Ballerina fuente propia: no borra contenido' 'authored main' "$(cat -- "$BB/naive_sort.bal")"
rm -- "$BB/tests/lib_test.bal"
ln -s "$BB/naive_sort.bal" "$BB/tests/lib_test.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina tests symlink: código' '4' "$rc_last"
assert_eq 'scaffold Ballerina tests symlink: no modifica destino' 'authored main' "$(cat -- "$BB/naive_sort.bal")"
rm -- "$BB/tests/lib_test.bal"
mkdir -- "$BB/tests/lib_test.bal"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold Ballerina tests directorio: código' '4' "$rc_last"
rmdir -- "$BB/tests/lib_test.bal"

BB_MISSING="$SANDBOX/ballerina/core/algorithms/data_structures_basics"
mkdir -p -- "$BB_MISSING"
glot_run_sandbox scaffold ballerina algorithms/data_structures_basics
assert_eq 'scaffold Ballerina fallo inicial: código' '4' "$rc_last"
assert_eq 'scaffold Ballerina fallo inicial: detiene creación de tests' 'no' "$([[ -e "$BB_MISSING/tests" ]] && echo si || echo no)"
mkdir -- "$BB_MISSING/data_structures_basics.bal"
printf 'main propio\n' >"$BB_MISSING/main.bal"
glot_run_sandbox scaffold ballerina algorithms/data_structures_basics
assert_eq 'scaffold Ballerina destino directorio: código' '4' "$rc_last"
assert_eq 'scaffold Ballerina destino directorio: no mueve dentro' 'no' "$([[ -e "$BB_MISSING/data_structures_basics.bal/main.bal" ]] && echo si || echo no)"
rmdir -- "$BB_MISSING/data_structures_basics.bal"
rm -- "$BB_MISSING/main.bal"
ln -s "$BB/naive_sort.bal" "$BB_MISSING/main.bal"
glot_run_sandbox scaffold ballerina algorithms/data_structures_basics
assert_eq 'scaffold Ballerina origen symlink: código' '4' "$rc_last"
assert_eq 'scaffold Ballerina origen symlink: no modifica destino' 'authored main' "$(cat -- "$BB/naive_sort.bal")"

PB="$SANDBOX/perl/core/algorithms/naive_sort"
mkdir -p -- "$PB"
glot_run_sandbox scaffold perl algorithms/naive_sort
assert_eq 'scaffold Perl: código' '0' "$rc_last"
assert_contains 'scaffold Perl: fuente bajo lib' 'package NaiveSort;' "$(cat -- "$PB/lib/naive_sort.pl")"
assert_eq 'scaffold Perl: no crea src' 'no' "$([[ -e "$PB/src" ]] && echo si || echo no)"
printf 'authored Perl\n' >"$PB/lib/naive_sort.pl"
glot_run_sandbox scaffold perl algorithms/naive_sort
assert_eq 'scaffold Perl repetido: código' '0' "$rc_last"
assert_eq 'scaffold Perl repetido: conserva fuente' 'authored Perl' "$(cat -- "$PB/lib/naive_sort.pl")"
rm -- "$PB/lib/naive_sort.pl"
ln -s "$BB/naive_sort.bal" "$PB/lib/naive_sort.pl"
glot_run_sandbox scaffold perl algorithms/naive_sort
assert_eq 'scaffold Perl symlink: código' '4' "$rc_last"
assert_eq 'scaffold Perl symlink: conserva destino' 'authored main' "$(cat -- "$BB/naive_sort.bal")"

# Perl: prove selecciona suites TAP pero no considera NOTESTS un error.
PT="$SANDBOX/perl/core/algorithms/data_structures_basics"
mkdir -p -- "$PT"
glot_run_sandbox scaffold perl algorithms/data_structures_basics
assert_eq 'scaffold Perl runner: código' '0' "$rc_last"
if command -v perl >/dev/null 2>&1 && perl -MApp::Prove::State -MTAP::Harness::Env -e 1; then
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: scaffold sin suites falla' '4' "$rc_last"
    assert_contains 'test Perl: explica ausencia de suites' 'No Perl test files configured' "$err"
    printf 'print "1..1\\nok 1 - first\\n";\n' >"$PT/test/first.pl"
    printf 'print "1..1\\nok 1 - second\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: ejecuta dos suites' '0' "$rc_last"
    assert_contains 'test Perl: primera suite' 'first.pl' "$out"
    assert_contains 'test Perl: segunda suite' 'second.pl' "$out"
    printf 'print "1..1\\nnot ok 1 - second\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: propaga fallo' '4' "$rc_last"
    printf 'print "not TAP\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: rechaza TAP inválido' '4' "$rc_last"
    rm -- "$PT/test/first.pl"
    printf 'print "1..0 # SKIP not ready\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: rechaza suite skip_all' '4' "$rc_last"
    assert_contains 'test Perl: explica suite skip_all' 'No Perl test cases executed' "$err"
    printf 'print "1..2\\nok 1 # SKIP one\\nok 2 # SKIP two\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: rechaza todos los casos omitidos' '4' "$rc_last"
    printf 'print "1..2\\nok 1 # SKIP one\\nok 2 - executed\\n";\n' >"$PT/test/second.pl"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: acepta omisiones con casos ejecutados' '0' "$rc_last"
    rm -- "$PT/test/second.pl"
    rmdir -- "$PT/test"
    glot_run_sandbox test perl algorithms/data_structures_basics
    assert_eq 'test Perl: rechaza directorio de pruebas ausente' '4' "$rc_last"
fi

# Raku: conservar fuentes existentes y proteger las rutas del scaffold.
RK="$SANDBOX/raku/core/algorithms/data_structures_basics"
mkdir -p -- "$RK"
glot_run_sandbox scaffold raku algorithms/data_structures_basics
assert_eq 'scaffold Raku: código' '0' "$rc_last"
assert_eq 'scaffold Raku: fuente idiomática' 'unit module DataStructuresBasics;' "$(cat -- "$RK/lib/DataStructuresBasics.rakumod")"
assert_contains 'scaffold Raku: excluye precompilación' '.precomp/' "$(cat -- "$RK/.gitignore")"
assert_eq 'scaffold Raku: ignora precompilación' '1' "$(git -C "$RK" check-ignore lib/.precomp/artifact | wc -l | tr -d ' ')"
if command -v raku >/dev/null 2>&1 && command -v prove6 >/dev/null 2>&1; then
    raku_rc=0
    raku_out="$(cd "$RK" && raku -c lib/DataStructuresBasics.rakumod 2>&1)" || raku_rc=$?
    assert_eq 'scaffold Raku: fuente compilable' '0' "$raku_rc"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: scaffold sin suites falla' '4' "$rc_last"
    assert_contains 'test Raku: explica ausencia de suites' 'No Raku test files configured' "$err"
    printf 'use Test;\nplan 2;\nskip "not ready", 2;\n' >"$RK/t/module.rakutest"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: rechaza todos los casos omitidos' '4' "$rc_last"
    assert_contains 'test Raku: explica casos omitidos' 'No Raku test cases executed' "$err"
    printf 'say "1..0 # SKIP not ready";\n' >"$RK/t/empty.t"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: rechaza varias suites sin casos' '4' "$rc_last"
    printf 'use Test;\nplan 2;\nskip "not ready";\nok True, "executed";\n' >"$RK/t/module.rakutest"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: acepta omisiones con casos ejecutados' '0' "$rc_last"
    printf 'use Test;\nuse DataStructuresBasics;\nok True, "module loads";\ndone-testing;\n' >"$RK/t/module.rakutest"
    mkdir -- "$RK/t/nested"
    printf 'use Test;\nok True, "nested";\ndone-testing;\n' >"$RK/t/nested/nested.t6"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'scaffold Raku: runner descubre suites' '0' "$rc_last"
    assert_contains 'scaffold Raku: ejecuta suite' 'module.rakutest' "$out"
    assert_contains 'scaffold Raku: descubre suite anidada' 'nested.t6' "$out"
    printf 'use Test;\nok False, "failure";\ndone-testing;\n' >"$RK/t/module.rakutest"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'scaffold Raku: propaga fallo' '4' "$rc_last"
    printf 'this is not valid raku ;\n' >"$RK/t/module.rakutest"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: propaga error de sintaxis' '4' "$rc_last"
    printf 'use Test;\nbail-out "blocked";\n' >"$RK/t/module.rakutest"
    glot_run_sandbox test raku algorithms/data_structures_basics
    assert_eq 'test Raku: rechaza bailout' '4' "$rc_last"
    assert_contains 'test Raku: explica bailout' 'Bailed out' "$err"
fi
printf 'author Raku\n' >"$RK/lib/DataStructuresBasics.rakumod"
printf 'author ignore\n' >"$RK/.gitignore"
glot_run_sandbox scaffold raku algorithms/data_structures_basics
assert_eq 'scaffold Raku repetido: código' '0' "$rc_last"
assert_eq 'scaffold Raku repetido: conserva fuente' 'author Raku' "$(cat -- "$RK/lib/DataStructuresBasics.rakumod")"
assert_eq 'scaffold Raku repetido: conserva ignore' 'author ignore' "$(cat -- "$RK/.gitignore")"
rm -- "$RK/lib/DataStructuresBasics.rakumod"
ln -s "$RK/.gitignore" "$RK/lib/DataStructuresBasics.rakumod"
glot_run_sandbox scaffold raku algorithms/data_structures_basics
assert_eq 'scaffold Raku symlink: código' '4' "$rc_last"
assert_eq 'scaffold Raku symlink: conserva destino' 'author ignore' "$(cat -- "$RK/.gitignore")"
rm -- "$RK/lib/DataStructuresBasics.rakumod"
mkdir -- "$RK/lib/DataStructuresBasics.rakumod"
glot_run_sandbox scaffold raku algorithms/data_structures_basics
assert_eq 'scaffold Raku destino directorio: código' '4' "$rc_last"
rmdir -- "$RK/lib/DataStructuresBasics.rakumod"
rm -- "$RK/.gitignore"
printf 'author suite\n' >"$RK/t/module.rakutest"
ln -s "$RK/t/module.rakutest" "$RK/.gitignore"
glot_run_sandbox scaffold raku algorithms/data_structures_basics
assert_eq 'scaffold Raku ignore symlink: código' '4' "$rc_last"
assert_eq 'scaffold Raku ignore symlink: conserva destino' 'author suite' "$(cat -- "$RK/t/module.rakutest")"
RK_DRY="$SANDBOX/raku/core/algorithms/naive_sort"
mkdir -p -- "$RK_DRY"
glot_run_sandbox -n scaffold raku algorithms/naive_sort
assert_eq 'scaffold Raku dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Raku dry-run: no crea archivos' '0' "$(find "$RK_DRY" -mindepth 1 | wc -l | tr -d ' ')"

# Rexx: preservar la fuente y avisar de los límites del runner.
RX="$SANDBOX/rexx/core/algorithms/data_structures_basics"
mkdir -p -- "$RX"
glot_run_sandbox scaffold rexx algorithms/data_structures_basics
assert_eq 'scaffold Rexx: código' '0' "$rc_last"
assert_eq 'scaffold Rexx: fuente vacía' 'yes' "$([[ -f "$RX/src/data_structures_basics.rexx" && ! -s "$RX/src/data_structures_basics.rexx" ]] && echo yes || echo no)"
assert_contains 'scaffold Rexx: avisa del runner pendiente' 'runner ooRexxUnit' "$err"
printf 'author source\n' >"$RX/src/data_structures_basics.rexx"
glot_run_sandbox scaffold rexx algorithms/data_structures_basics
assert_eq 'scaffold Rexx repetido: código' '0' "$rc_last"
assert_eq 'scaffold Rexx repetido: conserva fuente' 'author source' "$(cat -- "$RX/src/data_structures_basics.rexx")"
printf 'author target\n' >"$RX/target"
rm -- "$RX/src/data_structures_basics.rexx"
ln -s "$RX/target" "$RX/src/data_structures_basics.rexx"
glot_run_sandbox scaffold rexx algorithms/data_structures_basics
assert_eq 'scaffold Rexx symlink: código' '4' "$rc_last"
assert_eq 'scaffold Rexx symlink: conserva destino' 'author target' "$(cat -- "$RX/target")"
rm -- "$RX/src/data_structures_basics.rexx"
mkdir -- "$RX/src/data_structures_basics.rexx"
glot_run_sandbox scaffold rexx algorithms/data_structures_basics
assert_eq 'scaffold Rexx destino directorio: código' '4' "$rc_last"
RX_DRY="$SANDBOX/rexx/core/algorithms/naive_sort"
mkdir -p -- "$RX_DRY"
glot_run_sandbox -n scaffold rexx algorithms/naive_sort
assert_eq 'scaffold Rexx dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Rexx dry-run: no crea archivos' '0' "$(find "$RX_DRY" -mindepth 1 | wc -l | tr -d ' ')"
RX_RUN="$SANDBOX/rexx/core/foundations/unit_test/calculator"
mkdir -p "$RX_RUN/test"
cp -- "$DATA_DIR/rexx_test.sh" "$RX_RUN/rexx_test.sh"
rx_rc=0
(
    cd "$RX_RUN"
    bash ./rexx_test.sh
) >/dev/null 2>&1 || rx_rc=$?
assert_eq 'test Rexx sin suites: rechaza' '1' "$rx_rc"

# Scala: build homologado y conservación de archivos existentes.
SCALA="$SANDBOX/scala/core/algorithms/data_structures_basics"
mkdir -p -- "$SCALA"
glot_run_sandbox -n scaffold scala algorithms/data_structures_basics
assert_eq 'scaffold Scala dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Scala dry-run: no crea archivos' '0' "$(find "$SCALA" -mindepth 1 | wc -l | tr -d ' ')"
glot_run_sandbox scaffold scala algorithms/data_structures_basics
assert_eq 'scaffold Scala: código' '0' "$rc_last"
assert_eq 'scaffold Scala: fuente mínima' 'object DataStructuresBasics' "$(cat -- "$SCALA/src/main/scala/DataStructuresBasics.scala")"
assert_contains 'scaffold Scala: dependencia ScalaTest' 'libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.19" % Test' "$(cat -- "$SCALA/build.sbt")"
assert_eq 'scaffold Scala: versión sbt' 'sbt.version=1.10.1' "$(cat -- "$SCALA/project/build.properties")"
assert_contains 'scaffold Scala: avisa revisión' 'revisar archivos previos' "$err"
assert_eq 'scaffold Scala: ignora compilados' '1' "$(git -C "$SCALA" check-ignore target/test.class | wc -l | tr -d ' ')"
if command -v sbt >/dev/null 2>&1; then
    glot_run_sandbox test scala algorithms/data_structures_basics
    assert_eq 'test Scala: rechaza scaffold sin casos' '4' "$rc_last"
    assert_contains 'test Scala: explica ausencia de casos' 'No Scala test cases passed' "$out$err"
    printf 'import org.scalatest.funsuite.AnyFunSuite\nclass ScaffoldTest extends AnyFunSuite {\n  test("runs") { java.nio.file.Files.writeString(java.nio.file.Path.of("runs.txt"), "run\\n", java.nio.file.StandardOpenOption.CREATE, java.nio.file.StandardOpenOption.APPEND); assert(1 == 1) }\n}\n' >"$SCALA/src/test/scala/ScaffoldTest.scala"
    glot_run_sandbox test scala algorithms/data_structures_basics
    assert_eq 'test Scala: suite aprobada' '0' "$rc_last"
    assert_eq 'test Scala: ejecuta una sola vez' '1' "$(wc -l <"$SCALA/runs.txt" | tr -d ' ')"
    assert_contains 'test Scala: conserva informe nativo' 'All tests passed' "$out"
    printf 'import org.scalatest.funsuite.AnyFunSuite\nclass ScaffoldTest extends AnyFunSuite {\n  test("fails") { assert(1 == 2) }\n}\n' >"$SCALA/src/test/scala/ScaffoldTest.scala"
    glot_run_sandbox test scala algorithms/data_structures_basics
    assert_eq 'test Scala: propaga fallo' '4' "$rc_last"
    assert_contains 'test Scala: informa fallo' 'TEST FAILED' "$out$err"
    printf 'import org.scalatest.funsuite.AnyFunSuite\nclass ScaffoldTest extends AnyFunSuite {\n  ignore("skipped") { assert(1 == 1) }\n}\n' >"$SCALA/src/test/scala/ScaffoldTest.scala"
    glot_run_sandbox test scala algorithms/data_structures_basics
    assert_eq 'test Scala: rechaza todos omitidos' '4' "$rc_last"
    assert_contains 'test Scala: explica todos omitidos' 'No Scala test cases passed' "$out$err"
    printf 'import org.scalatest.funsuite.AnyFunSuite\nclass ScaffoldTest extends AnyFunSuite {\n  ignore("skipped") { assert(1 == 1) }\n  test("runs") { assert(1 == 1) }\n}\n' >"$SCALA/src/test/scala/ScaffoldTest.scala"
    glot_run_sandbox test scala algorithms/data_structures_basics
    assert_eq 'test Scala: acepta aprobados con omitidos' '0' "$rc_last"
fi
printf 'author source\n' >"$SCALA/src/main/scala/DataStructuresBasics.scala"
printf 'author build\n' >"$SCALA/build.sbt"
printf 'author sbt\n' >"$SCALA/project/build.properties"
printf 'author ignore\n' >"$SCALA/.gitignore"
glot_run_sandbox scaffold scala algorithms/data_structures_basics
assert_eq 'scaffold Scala repetido: código' '0' "$rc_last"
assert_eq 'scaffold Scala repetido: conserva fuente' 'author source' "$(cat -- "$SCALA/src/main/scala/DataStructuresBasics.scala")"
assert_eq 'scaffold Scala repetido: conserva build' 'author build' "$(cat -- "$SCALA/build.sbt")"
assert_eq 'scaffold Scala repetido: conserva versión' 'author sbt' "$(cat -- "$SCALA/project/build.properties")"
assert_eq 'scaffold Scala repetido: conserva ignore' 'author ignore' "$(cat -- "$SCALA/.gitignore")"
printf 'author target\n' >"$SCALA/target-file"
rm -- "$SCALA/src/main/scala/DataStructuresBasics.scala"
ln -s "$SCALA/target-file" "$SCALA/src/main/scala/DataStructuresBasics.scala"
glot_run_sandbox scaffold scala algorithms/data_structures_basics
assert_eq 'scaffold Scala symlink: código' '4' "$rc_last"
assert_eq 'scaffold Scala symlink: conserva destino' 'author target' "$(cat -- "$SCALA/target-file")"
SCALA_EMPTY="$SANDBOX/scala/core/algorithms/searching"
mkdir -p -- "$SCALA_EMPTY"
: >"$SCALA_EMPTY/build.sbt"
glot_run_sandbox scaffold scala algorithms/searching
assert_eq 'scaffold Scala build vacío: código' '0' "$rc_last"
assert_eq 'scaffold Scala build vacío: no reemplaza' 'yes' "$([[ -f "$SCALA_EMPTY/build.sbt" && ! -s "$SCALA_EMPTY/build.sbt" ]] && echo yes || echo no)"
SCALA_LINK="$SANDBOX/scala/core/algorithms/naive_sort"
mkdir -p -- "$SCALA_LINK" "$WORK_DIR/scala-project-target"
ln -s "$WORK_DIR/scala-project-target" "$SCALA_LINK/project"
glot_run_sandbox scaffold scala algorithms/naive_sort
assert_eq 'scaffold Scala proyecto symlink: código' '4' "$rc_last"
assert_eq 'scaffold Scala proyecto symlink: no crea archivos' '0' "$(find "$WORK_DIR/scala-project-target" -mindepth 1 | wc -l | tr -d ' ')"

# Scheme: módulo Guile seguro y comprobación del runner.
SC="$SANDBOX/scheme/core/algorithms/data_structures_basics"
mkdir -p -- "$SC"
glot_run_sandbox scaffold scheme algorithms/data_structures_basics
assert_eq 'scaffold Scheme: código' '0' "$rc_last"
assert_eq 'scaffold Scheme: módulo Guile' '(define-module (data_structures_basics))' "$(cat -- "$SC/src/data_structures_basics.scm")"
assert_eq 'scaffold Scheme: ignora logs' '1' "$(git -C "$SC" check-ignore test/suite.log | wc -l | tr -d ' ')"
if command -v guile >/dev/null 2>&1; then
    scheme_rc=0
    scheme_out="$(cd "$SC" && guile --no-auto-compile -c '(load "src/data_structures_basics.scm") (use-modules (data_structures_basics))' 2>&1)" || scheme_rc=$?
    assert_eq 'scaffold Scheme: módulo cargable' '0' "$scheme_rc"
    assert_eq 'scaffold Scheme: carga sin diagnósticos' '' "$scheme_out"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza scaffold sin suites' '4' "$rc_last"
    assert_contains 'test Scheme: explica ausencia de suites' 'No Scheme test files configured' "$err"
    printf '(use-modules (srfi srfi-64))\n(test-begin "first")\n(test-equal 1 1)\n(test-end "first")\n' >"$SC/test/first_guile.scm"
    printf '(use-modules (srfi srfi-64))\n(test-begin "second")\n(test-equal 2 2)\n(test-end "second")\n' >"$SC/test/second_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: ejecuta varias suites' '0' "$rc_last"
    assert_contains 'test Scheme: incluye primera suite' 'Starting test first' "$out"
    assert_contains 'test Scheme: incluye segunda suite' 'Starting test second' "$out"
    printf '(use-modules (srfi srfi-64))\n(test-begin "first")\n(test-equal 1 2)\n(test-end "first")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: propaga aserción fallida' '4' "$rc_last"
    assert_contains 'test Scheme: ejecuta segunda tras fallo' 'Starting test second' "$out"
    printf '(exit 0)\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza salida anticipada' '4' "$rc_last"
    assert_contains 'test Scheme: explica salida anticipada' 'Scheme suite exited before validation' "$err"
    printf '(use-modules (srfi srfi-64))\n(test-begin "bad" 2)\n(test-equal 1 1)\n(test-end "bad")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza plan incorrecto' '4' "$rc_last"
    printf '(use-modules (srfi srfi-64))\n(test-begin "empty")\n(test-end "empty")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza suite vacía' '4' "$rc_last"
    assert_contains 'test Scheme: explica ausencia de casos' 'No Scheme test cases executed' "$err"
    printf '(use-modules (srfi srfi-64))\n(test-begin "skipped")\n(test-skip 1)\n(test-equal 1 1)\n(test-end "skipped")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza suite totalmente omitida' '4' "$rc_last"
    printf '(use-modules (srfi srfi-64))\n(test-begin "unclosed")\n(test-equal 1 1)\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza grupo sin cerrar' '4' "$rc_last"
    printf '(use-modules (srfi srfi-64))\n(test-begin "xfail")\n(test-expect-fail 1)\n(test-equal 1 2)\n(test-end "xfail")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: admite fallo esperado' '0' "$rc_last"
    printf '(use-modules (srfi srfi-64))\n(test-begin "xpass")\n(test-expect-fail 1)\n(test-equal 1 1)\n(test-end "xpass")\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: rechaza éxito inesperado' '4' "$rc_last"
    printf '(\n' >"$SC/test/first_guile.scm"
    glot_run_sandbox test scheme algorithms/data_structures_basics
    assert_eq 'test Scheme: propaga error de sintaxis' '4' "$rc_last"
fi
printf 'author Scheme\n' >"$SC/src/data_structures_basics.scm"
printf 'author ignore\n' >"$SC/.gitignore"
glot_run_sandbox scaffold scheme algorithms/data_structures_basics
assert_eq 'scaffold Scheme repetido: código' '0' "$rc_last"
assert_eq 'scaffold Scheme repetido: conserva fuente' 'author Scheme' "$(cat -- "$SC/src/data_structures_basics.scm")"
assert_eq 'scaffold Scheme repetido: conserva ignore' 'author ignore' "$(cat -- "$SC/.gitignore")"
rm -- "$SC/src/data_structures_basics.scm"
ln -s "$SC/.gitignore" "$SC/src/data_structures_basics.scm"
glot_run_sandbox scaffold scheme algorithms/data_structures_basics
assert_eq 'scaffold Scheme symlink: código' '4' "$rc_last"
assert_eq 'scaffold Scheme symlink: conserva destino' 'author ignore' "$(cat -- "$SC/.gitignore")"
rm -- "$SC/src/data_structures_basics.scm"
mkdir -- "$SC/src/data_structures_basics.scm"
glot_run_sandbox scaffold scheme algorithms/data_structures_basics
assert_eq 'scaffold Scheme destino directorio: código' '4' "$rc_last"
rmdir -- "$SC/src/data_structures_basics.scm"
rm -- "$SC/.gitignore"
printf 'author suite\n' >"$SC/test/suite_guile.scm"
ln -s "$SC/test/suite_guile.scm" "$SC/.gitignore"
glot_run_sandbox scaffold scheme algorithms/data_structures_basics
assert_eq 'scaffold Scheme ignore symlink: código' '4' "$rc_last"
assert_eq 'scaffold Scheme ignore symlink: conserva destino' 'author suite' "$(cat -- "$SC/test/suite_guile.scm")"
SC_DRY="$SANDBOX/scheme/core/algorithms/naive_sort"
mkdir -p -- "$SC_DRY"
glot_run_sandbox -n scaffold scheme algorithms/naive_sort
assert_eq 'scaffold Scheme dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Scheme dry-run: no crea archivos' '0' "$(find "$SC_DRY" -mindepth 1 | wc -l | tr -d ' ')"

# Tcl: paquete cargable y conservación de archivos existentes.
TC="$SANDBOX/tcl-tk/core/algorithms/data_structures_basics"
mkdir -p -- "$TC"
glot_run_sandbox scaffold tcl-tk algorithms/data_structures_basics
assert_eq 'scaffold Tcl: código' '0' "$rc_last"
assert_contains 'scaffold Tcl: declara paquete' 'package provide data_structures_basics 1.0' "$(cat -- "$TC/src/data_structures_basics.tcl")"
assert_contains 'scaffold Tcl: índice nativo' 'package ifneeded data_structures_basics 1.0' "$(cat -- "$TC/src/pkgIndex.tcl")"
assert_eq 'scaffold Tcl: ignora logs' '1' "$(git -C "$TC" check-ignore test/suite.log | wc -l | tr -d ' ')"
assert_contains 'scaffold Tcl: anuncia revisión' 'revisar archivos previos' "$err"
if command -v tclsh9.0 >/dev/null 2>&1; then
    tcl_rc=0
    tcl_out="$(cd "$TC" && printf 'lappend auto_path [file normalize src]\nputs [package require data_structures_basics 1.0]\nputs [namespace exists ::DataStructuresBasics]\n' | tclsh9.0 2>&1)" || tcl_rc=$?
    assert_eq 'scaffold Tcl: paquete cargable' '0' "$tcl_rc"
    assert_eq 'scaffold Tcl: versión y namespace' "$(printf '1.0\n1')" "$tcl_out"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: rechaza scaffold sin suites' '4' "$rc_last"
    assert_contains 'test Tcl: explica ausencia de suites' 'No Tcl test files configured' "$err"
    printf 'package require tcltest\npackage require data_structures_basics 1.0\nnamespace import ::tcltest::*\ntest first {first} -body {return 1} -result 1\ncleanupTests\n' >"$TC/test/first.test"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest second {second} -body {return 2} -result 2\ncleanupTests\n' >"$TC/test/second.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: ejecuta varias suites' '0' "$rc_last"
    assert_contains 'test Tcl: incluye primera suite' 'first.test:' "$out"
    assert_contains 'test Tcl: incluye segunda suite' 'second.test:' "$out"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest first {failed} -body {return 1} -result 2\ncleanupTests\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: propaga aserción fallida' '4' "$rc_last"
    assert_contains 'test Tcl: ejecuta segunda tras fallo' 'second.test:' "$out"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest omitted {skipped} -constraints missing -body {return 1} -result 1\ncleanupTests\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: rechaza suite totalmente omitida' '4' "$rc_last"
    assert_contains 'test Tcl: explica ausencia de casos' 'No Tcl test cases executed' "$err"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest omitted {skipped} -constraints missing -body {return 1} -result 1\ntest passed {passed} -body {return 1} -result 1\ncleanupTests\ntest later {later} -body {return 2} -result 2\ncleanupTests\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: acepta omisiones y múltiples limpiezas' '0' "$rc_last"
    printf 'exit 0\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: rechaza salida anticipada' '4' "$rc_last"
    assert_contains 'test Tcl: explica salida anticipada' 'Tcl test suite exited before validation' "$err"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest first {first} -body {return 1} -result 1\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: requiere limpieza' '4' "$rc_last"
    assert_contains 'test Tcl: explica limpieza ausente' 'did not call cleanupTests' "$err"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest first {first} -body {return 1} -result 1\ncleanupTests\ntest late {late} -body {return 1} -result 2\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: rechaza casos sin finalizar' '4' "$rc_last"
    assert_contains 'test Tcl: explica casos sin finalizar' 'Tcl test cases not finalized' "$err"
    printf 'package require tcltest\nnamespace import ::tcltest::*\ntest first {first} -body {return 1} -result 1\ncleanupTests\nproc ::tcltest::cleanupTestsHook {} {}\ntest failed {failed} -body {return 1} -result 2\ncleanupTests\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: rechaza sustitución del hook' '4' "$rc_last"
    assert_contains 'test Tcl: explica hook sustituido' 'Tcl cleanup hook changed' "$err"
    printf 'if {1} {\n' >"$TC/test/first.test"
    glot_run_sandbox test tcl-tk algorithms/data_structures_basics
    assert_eq 'test Tcl: propaga error de suite' '4' "$rc_last"
fi
printf 'author source\n' >"$TC/src/data_structures_basics.tcl"
printf 'author index\n' >"$TC/src/pkgIndex.tcl"
printf 'author ignore\n' >"$TC/.gitignore"
glot_run_sandbox scaffold tcl-tk algorithms/data_structures_basics
assert_eq 'scaffold Tcl repetido: código' '0' "$rc_last"
assert_eq 'scaffold Tcl repetido: conserva fuente' 'author source' "$(cat -- "$TC/src/data_structures_basics.tcl")"
assert_eq 'scaffold Tcl repetido: conserva índice' 'author index' "$(cat -- "$TC/src/pkgIndex.tcl")"
assert_eq 'scaffold Tcl repetido: conserva ignore' 'author ignore' "$(cat -- "$TC/.gitignore")"
rm -- "$TC/src/pkgIndex.tcl"
ln -s "$TC/src/data_structures_basics.tcl" "$TC/src/pkgIndex.tcl"
glot_run_sandbox scaffold tcl-tk algorithms/data_structures_basics
assert_eq 'scaffold Tcl symlink: código' '4' "$rc_last"
assert_eq 'scaffold Tcl symlink: conserva destino' 'author source' "$(cat -- "$TC/src/data_structures_basics.tcl")"
rm -- "$TC/src/pkgIndex.tcl"
mkdir -- "$TC/src/pkgIndex.tcl"
glot_run_sandbox scaffold tcl-tk algorithms/data_structures_basics
assert_eq 'scaffold Tcl destino directorio: código' '4' "$rc_last"
rmdir -- "$TC/src/pkgIndex.tcl"
rm -- "$TC/.gitignore"
ln -s "$TC/src/data_structures_basics.tcl" "$TC/.gitignore"
glot_run_sandbox scaffold tcl-tk algorithms/data_structures_basics
assert_eq 'scaffold Tcl ignore symlink: código' '4' "$rc_last"
assert_eq 'scaffold Tcl ignore symlink: conserva destino' 'author source' "$(cat -- "$TC/src/data_structures_basics.tcl")"
TC_DRY="$SANDBOX/tcl-tk/core/algorithms/naive_sort"
mkdir -p -- "$TC_DRY"
glot_run_sandbox -n scaffold tcl-tk algorithms/naive_sort
assert_eq 'scaffold Tcl dry-run: código' '0' "$rc_last"
assert_eq 'scaffold Tcl dry-run: no crea archivos' '0' "$(find "$TC_DRY" -mindepth 1 | wc -l | tr -d ' ')"
mkdir -p -- "$TC_DRY/src" "$TC_DRY/test"
: >"$TC_DRY/src/naive_sort.tcl"
: >"$TC_DRY/src/pkgIndex.tcl"
glot_run_sandbox scaffold tcl-tk algorithms/naive_sort
assert_eq 'scaffold Tcl previo: código' '0' "$rc_last"
assert_eq 'scaffold Tcl previo: conserva índice vacío' 'yes' "$([[ ! -s "$TC_DRY/src/pkgIndex.tcl" ]] && echo yes || echo no)"
assert_contains 'scaffold Tcl previo: anuncia revisión' 'revisar archivos previos' "$err"

# Swift: retirar solo la muestra comprobada y conservar suites propias.
SW="$SANDBOX/swift/core/algorithms/data_structures_basics"
mkdir -p -- "$SW/Tests/data_structures_basicsTests"
printf 'author manifest\n' >"$SW/Package.swift"
sed 's/@MODULE@/data_structures_basics/g' "$DATA_DIR/scaffold_templates/swift.Test.swift" \
    >"$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift"
glot_run_sandbox -n scaffold swift algorithms/data_structures_basics
assert_eq 'scaffold Swift dry-run: código' '0' "$rc_last"
assert_contains 'scaffold Swift dry-run: conserva muestra' '@Test func example()' "$(cat -- "$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift")"
glot_run_sandbox scaffold swift algorithms/data_structures_basics
assert_eq 'scaffold Swift: código' '0' "$rc_last"
assert_eq 'scaffold Swift: reemplaza muestra' "$(printf 'import Testing\n@testable import data_structures_basics')" "$(cat -- "$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift")"
assert_eq 'scaffold Swift: conserva manifiesto' 'author manifest' "$(cat -- "$SW/Package.swift")"
assert_eq 'scaffold Swift: ignora compilados' '1' "$(git -C "$SW" check-ignore .build/artifact | wc -l | tr -d ' ')"
assert_contains 'scaffold Swift: avisa runner' 'runner Swift' "$err"
printf 'author test\n' >"$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift"
printf 'author ignore\n' >"$SW/.gitignore"
glot_run_sandbox scaffold swift algorithms/data_structures_basics
assert_eq 'scaffold Swift repetido: código' '0' "$rc_last"
assert_eq 'scaffold Swift repetido: conserva suite' 'author test' "$(cat -- "$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift")"
assert_eq 'scaffold Swift repetido: conserva ignore' 'author ignore' "$(cat -- "$SW/.gitignore")"
printf 'author target\n' >"$SW/target-file"
rm -- "$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift"
ln -s "$SW/target-file" "$SW/Tests/data_structures_basicsTests/data_structures_basicsTests.swift"
glot_run_sandbox scaffold swift algorithms/data_structures_basics
assert_eq 'scaffold Swift symlink: código' '4' "$rc_last"
assert_eq 'scaffold Swift symlink: conserva destino' 'author target' "$(cat -- "$SW/target-file")"
SW_EMPTY="$SANDBOX/swift/core/algorithms/naive_sort"
mkdir -p -- "$SW_EMPTY"
glot_run_sandbox scaffold swift algorithms/naive_sort
assert_eq 'scaffold Swift sin manifiesto: falla' '4' "$rc_last"
assert_contains 'scaffold Swift sin manifiesto: diagnóstico' 'missing manifest' "$err"
assert_eq 'scaffold Swift sin manifiesto: no escribe' '0' "$(find "$SW_EMPTY" -mindepth 1 | wc -l | tr -d ' ')"
SW_MISSING="$SANDBOX/swift/core/algorithms/searching"
mkdir -p -- "$SW_MISSING/Tests/searchingTests"
printf 'author manifest\n' >"$SW_MISSING/Package.swift"
sed 's/@MODULE@/searching/g' "$DATA_DIR/scaffold_templates/swift.Test.swift" >"$SW_MISSING/Tests/searchingTests/searchingTests.swift"
mv -- "$SANDBOX/scripts/data/scaffold_templates/swift.Test.swift" "$SANDBOX/scripts/data/scaffold_templates/swift.Test.saved"
glot_run_sandbox scaffold swift algorithms/searching
assert_eq 'scaffold Swift plantilla ausente: falla' '4' "$rc_last"
assert_contains 'scaffold Swift plantilla ausente: conserva muestra' '@Test func example()' "$(cat -- "$SW_MISSING/Tests/searchingTests/searchingTests.swift")"
mv -- "$SANDBOX/scripts/data/scaffold_templates/swift.Test.saved" "$SANDBOX/scripts/data/scaffold_templates/swift.Test.swift"

SW_RUN="$SANDBOX/swift/core/foundations/unit_test/calculator"
mkdir -p "$SW_RUN/Sources/calculator" "$SW_RUN/Tests/calculatorTests"
cat >"$SW_RUN/Package.swift" <<'EOF'
// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "calculator",
    targets: [
        .executableTarget(name: "calculator"),
        .testTarget(name: "calculatorTests", dependencies: ["calculator"])
    ]
)
EOF
printf 'public func add(_ a: Int, _ b: Int) -> Int { a + b }\n' >"$SW_RUN/Sources/calculator/calculator.swift"
cat >"$SW_RUN/Tests/calculatorTests/CalculatorTests.swift" <<'EOF'
import XCTest
@testable import calculator

final class CalculatorTests: XCTestCase {
    func testAdd() { XCTAssertEqual(add(1, 2), 3) }
}
EOF
cp -- "$DATA_DIR/swift_test.sh" "$SW_RUN/swift_test.sh"
(
    cd "$SW_RUN"
    bash ./swift_test.sh
) >/dev/null 2>&1
assert_eq 'test Swift caso aprobado: código' '0' "$?"

TS_RUN="$SANDBOX/typescript/core/foundations/unit_test/calculator"
mkdir -p "$TS_RUN/node_modules/.bin" "$TS_RUN/test"
printf '{}\n' >"$TS_RUN/package.json"
cat >"$TS_RUN/node_modules/.bin/jest" <<'EOF'
#!/usr/bin/env bash
output=""
for arg in "$@"; do
  case "$arg" in
    --outputFile=*) output="${arg#*=}" ;;
  esac
done
printf '{"success":true,"numTotalTests":1,"numPassedTests":1,"numFailedTests":0,"numPendingTests":0}\n' >"$output"
EOF
chmod +x "$TS_RUN/node_modules/.bin/jest"
cp -- "$DATA_DIR/typescript_test.sh" "$TS_RUN/typescript_test.sh"
ts_rc=0
(
    cd "$TS_RUN"
    bash ./typescript_test.sh
) >/dev/null 2>&1 || ts_rc=$?
assert_eq 'test TypeScript caso aprobado: código' '0' "$ts_rc"
cat >"$TS_RUN/node_modules/.bin/jest" <<'EOF'
#!/usr/bin/env bash
output=""
for arg in "$@"; do
  case "$arg" in
    --outputFile=*) output="${arg#*=}" ;;
  esac
done
printf '{"success":true,"numTotalTests":0,"numPassedTests":0,"numFailedTests":0,"numPendingTests":0}\n' >"$output"
EOF
chmod +x "$TS_RUN/node_modules/.bin/jest"
ts_rc=0
(
    cd "$TS_RUN"
    bash ./typescript_test.sh
) >/dev/null 2>&1 || ts_rc=$?
assert_eq 'test TypeScript cero casos: rechaza' '1' "$ts_rc"

JS_RUN="$SANDBOX/javascript/core/foundations/unit_test/calculator"
mkdir -p "$JS_RUN/node_modules/.bin"
printf '{}\n' >"$JS_RUN/package.json"
cat >"$JS_RUN/node_modules/.bin/jest" <<'EOF'
#!/usr/bin/env bash
output=""
for arg in "$@"; do
  case "$arg" in
    --outputFile=*) output="${arg#*=}" ;;
  esac
done
printf '{"success":true,"numTotalTests":1,"numPassedTests":1,"numFailedTests":0,"numPendingTests":0}\n' >"$output"
EOF
chmod +x "$JS_RUN/node_modules/.bin/jest"
cp -- "$DATA_DIR/typescript_test.sh" "$JS_RUN/typescript_test.sh"
js_rc=0
(
    cd "$JS_RUN"
    bash ./typescript_test.sh
) >/dev/null 2>&1 || js_rc=$?
assert_eq 'test JavaScript caso aprobado: código' '0' "$js_rc"

DART_COMMAND="$(awk -F '\t' '$1 == "dart" { print $3 }' "$DATA_DIR/languages.tsv")"
assert_eq 'catálogo Dart: runner estricto' \
    'bash {root}/scripts/data/dart_test.sh' "$DART_COMMAND"
DART_RUN="$WORK_DIR/dart-runner"
mkdir -p -- "$DART_RUN/bin"
cat >"$DART_RUN/bin/dart" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == "test --reporter expanded --no-color" ]] || exit 2
cat -- "$DART_FAKE_OUTPUT"
exit "${DART_FAKE_RC:-0}"
EOF
chmod +x -- "$DART_RUN/bin/dart"
cp -- "$DATA_DIR/dart_test.sh" "$DART_RUN/dart_test.sh"
dart_runner_run() {
    local rc=0
    out="$(cd -- "$DART_RUN" && DART_FAKE_OUTPUT="$DART_FAKE_OUTPUT" \
        DART_FAKE_RC="${1:-0}" PATH="$DART_RUN/bin:$PATH" \
        bash ./dart_test.sh 2>"$WORK_DIR/dart-runner.err")" || rc=$?
    err="$(cat -- "$WORK_DIR/dart-runner.err")"
    rc_last="$rc"
}
DART_FAKE_OUTPUT="$DART_RUN/output"
printf '00:00 +1: All tests passed!\n' >"$DART_FAKE_OUTPUT"
dart_runner_run
assert_eq 'test Dart: acepta caso aprobado' '0' "$rc_last"
printf '00:00 +1 ~1: All tests passed!\n' >"$DART_FAKE_OUTPUT"
dart_runner_run
assert_eq 'test Dart: acepta aprobados con omitidos' '0' "$rc_last"
printf '00:00 +0 ~1: All tests passed!\n' >"$DART_FAKE_OUTPUT"
dart_runner_run
assert_eq 'test Dart: rechaza solo omitidos' '1' "$rc_last"
assert_contains 'test Dart: explica cero casos aprobados' 'sin casos aprobados' "$err"
printf 'No tests ran.\n' >"$DART_FAKE_OUTPUT"
dart_runner_run
assert_eq 'test Dart: rechaza resumen ausente' '1' "$rc_last"
printf '00:00 +1: All tests passed!\n00:00 +2: All tests passed!\n' >"$DART_FAKE_OUTPUT"
dart_runner_run
assert_eq 'test Dart: rechaza resumen ambiguo' '1' "$rc_last"
printf '00:00 +1: All tests passed!\n' >"$DART_FAKE_OUTPUT"
dart_runner_run 7
assert_eq 'test Dart: propaga fallo del proceso' '7' "$rc_last"

RUSTB="$SANDBOX/rust/core/algorithms/naive_sort"
mkdir -p -- "$RUSTB/src"
printf '[package]\nname = "naive_sort"\n' >"$RUSTB/Cargo.toml"
printf '// authored Rust\n' >"$RUSTB/src/lib.rs"
glot_run_sandbox scaffold rust algorithms/naive_sort
assert_eq 'scaffold Rust: código' '0' "$rc_last"
assert_eq 'scaffold Rust: conserva entrada Cargo' '// authored Rust' "$(cat -- "$RUSTB/src/lib.rs")"
glot_run_sandbox scaffold rust algorithms/naive_sort
assert_eq 'scaffold Rust repetido: código' '0' "$rc_last"
assert_eq 'scaffold Rust: no inventa otra entrada' 'no' "$([[ -e "$RUSTB/src/naive_sort.rs" ]] && echo si || echo no)"
rm -- "$RUSTB/src/lib.rs"
glot_run_sandbox scaffold rust algorithms/naive_sort
assert_eq 'scaffold Rust sin entrada: código' '4' "$rc_last"

RUST_FIXTURE="$WORK_DIR/rust-fixture"
mkdir -p "$RUST_FIXTURE/src"
printf '[package]\nname = "fixture"\n' >"$RUST_FIXTURE/Cargo.toml"
cp -- "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/src/lib.rs"
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh")
assert_eq 'scaffold Rust: retira solo muestra exacta' 'yes' \
    "$([[ -f "$RUST_FIXTURE/src/lib.rs" && ! -s "$RUST_FIXTURE/src/lib.rs" && -d "$RUST_FIXTURE/tests" ]] && echo yes || echo no)"
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh")
printf '// authored Rust\n' >"$RUST_FIXTURE/src/lib.rs"
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh")
assert_eq 'scaffold Rust: rerun conserva fuente propia' '// authored Rust' \
    "$(cat "$RUST_FIXTURE/src/lib.rs")"
cp -- "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/src/lib.rs"
printf '// authored test\n' >"$RUST_FIXTURE/tests/authored.rs"
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh")
assert_eq 'scaffold Rust: conserva muestra con test propio' '0' \
    "$(cmp -s "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/src/lib.rs"; echo $?)"
rm -- "$RUST_FIXTURE/tests/authored.rs" "$RUST_FIXTURE/src/lib.rs"
cp -- "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/source-original"
ln -- "$RUST_FIXTURE/source-original" "$RUST_FIXTURE/src/lib.rs"
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh")
assert_eq 'scaffold Rust: conserva archivo enlazado por hardlink' '0' \
    "$(cmp -s "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/source-original"; echo $?)"
rm -- "$RUST_FIXTURE/src/lib.rs"
ln -s -- "$DATA_DIR/scaffold_templates/rust.lib.rs" "$RUST_FIXTURE/src/lib.rs"
rust_rc=0
(cd "$RUST_FIXTURE" && bash "$DATA_DIR/rust_scaffold.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'scaffold Rust: rechaza entrada simbólica' '1' "$rust_rc"

RUST_FAKE="$WORK_DIR/rust-fake"
mkdir -p "$RUST_FAKE/bin"
cat >"$RUST_FAKE/bin/cargo" <<'EOF'
#!/usr/bin/env bash
cat -- "$RUST_FAKE_OUTPUT"
exit "${RUST_FAKE_RC:-0}"
EOF
chmod +x "$RUST_FAKE/bin/cargo"
RUST_FAKE_OUTPUT="$RUST_FAKE/output"
export RUST_FAKE_OUTPUT
cat >"$RUST_FAKE_OUTPUT" <<'EOF'
     Running unittests src/lib.rs (target/debug/deps/example)
running 2 tests
test result: ok. 1 passed; 0 failed; 1 ignored; 0 measured; 0 filtered out; finished in 0.00s
   Doc-tests example
running 0 tests
test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s
EOF
rust_rc=0
(cd "$RUST_FAKE" && PATH="$RUST_FAKE/bin:$PATH" bash "$DATA_DIR/rust_test.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'test Rust: acepta caso aprobado con omitido y doc-tests vacíos' '0' "$rust_rc"
sed -i 's/1 passed; 0 failed; 1 ignored/0 passed; 0 failed; 2 ignored/' "$RUST_FAKE_OUTPUT"
rust_rc=0
(cd "$RUST_FAKE" && PATH="$RUST_FAKE/bin:$PATH" bash "$DATA_DIR/rust_test.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'test Rust: rechaza todos omitidos' '1' "$rust_rc"
sed -i 's/0 passed; 0 failed; 2 ignored/1 passed; 0 failed; 1 ignored/' "$RUST_FAKE_OUTPUT"
printf '     Running tests/silent.rs (target/debug/deps/silent)\n' >>"$RUST_FAKE_OUTPUT"
rust_rc=0
(cd "$RUST_FAKE" && PATH="$RUST_FAKE/bin:$PATH" bash "$DATA_DIR/rust_test.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'test Rust: rechaza harness silencioso junto a suite aprobada' '1' "$rust_rc"
sed -i '$d; s/running 2 tests/running 3 tests/' "$RUST_FAKE_OUTPUT"
rust_rc=0
(cd "$RUST_FAKE" && PATH="$RUST_FAKE/bin:$PATH" bash "$DATA_DIR/rust_test.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'test Rust: rechaza contadores inconsistentes' '1' "$rust_rc"
rust_rc=0
(cd "$RUST_FAKE" && RUST_FAKE_RC=7 PATH="$RUST_FAKE/bin:$PATH" bash "$DATA_DIR/rust_test.sh") >/dev/null 2>&1 || rust_rc=$?
assert_eq 'test Rust: propaga fallo Cargo' '7' "$rust_rc"

for layout_lang in cpp crystal fsharp go haskell v; do
    layout_dir="$SANDBOX/$layout_lang/core/algorithms/naive_sort"
    mkdir -p "$layout_dir"
    printf 'authored ignore\n' >"$layout_dir/.gitignore"
    case "$layout_lang" in
        crystal)
            mkdir -p "$layout_dir/spec" "$layout_dir/src"
            printf 'name: naive_sort\n' >"$layout_dir/shard.yml"
            printf 'authored Crystal\n' >"$layout_dir/src/naive_sort.cr" ;;
        fsharp)
            mkdir -p "$layout_dir/src/NaiveSort" "$layout_dir/test/NaiveSort.Tests"
            printf '<Project><Compile Include="Library.fs"/></Project>\n' >"$layout_dir/src/NaiveSort/NaiveSort.fsproj"
            printf '<Project><ProjectReference Include="../../src/NaiveSort/NaiveSort.fsproj"/></Project>\n' >"$layout_dir/test/NaiveSort.Tests/NaiveSort.Tests.fsproj"
            printf 'authored FSharp\n' >"$layout_dir/src/NaiveSort/Library.fs" ;;
        haskell)
            mkdir -p "$layout_dir/lib" "$layout_dir/test"
            printf 'module NaiveSort where\n' >"$layout_dir/lib/NaiveSort.hs"
            printf 'authored cabal manifest\n' >"$layout_dir/naive-sort.cabal"
            printf 'authored runner\n' >"$layout_dir/test/Main.hs" ;;
        v)
            mkdir -p "$layout_dir/tests"
            printf "Module {\nversion: '0.0.0'\n}\n" >"$layout_dir/v.mod"
            printf 'authored test\n' >"$layout_dir/tests/square_test.v"
            printf 'authored V\n' >"$layout_dir/naive_sort.v" ;;
    esac
    glot_run_sandbox scaffold "$layout_lang" algorithms/naive_sort
    assert_eq "scaffold $layout_lang: código" '0' "$rc_last"
    glot_run_sandbox scaffold "$layout_lang" algorithms/naive_sort
    assert_eq "scaffold $layout_lang: rerun" '0' "$rc_last"
    assert_eq "scaffold $layout_lang: conserva ignore" 'authored ignore' "$(cat "$layout_dir/.gitignore")"
    case "$layout_lang" in
        cpp)
            assert_contains 'C++ scaffold: módulo Bazel' 'name = "cpp_naive_sort"' "$(cat "$layout_dir/MODULE.bazel")"
            assert_contains 'C++ scaffold: dependencia Google Test' 'version = "1.15.2"' "$(cat "$layout_dir/MODULE.bazel")"
            assert_contains 'C++ scaffold: target library' 'name = "naive_sort_lib"' "$(cat "$layout_dir/BUILD")"
            assert_contains 'C++ scaffold: target tests' 'srcs = ["tests/naive_sort_test.cpp"]' "$(cat "$layout_dir/BUILD")"
            assert_eq 'C++ scaffold: versión Bazel' '7.1.1' "$(cat "$layout_dir/.bazelversion")"
            printf 'authored Bazel module\n' >"$layout_dir/MODULE.bazel"
            glot_run_sandbox scaffold cpp algorithms/naive_sort
            assert_eq 'C++ scaffold: conserva configuración propia' 'authored Bazel module' \
                "$(cat "$layout_dir/MODULE.bazel")"
            rm -- "$layout_dir/BUILD"
            ln -s .bazelversion "$layout_dir/BUILD"
            glot_run_sandbox scaffold cpp algorithms/naive_sort
            assert_eq 'C++ scaffold: rechaza BUILD simbólico' '4' "$rc_last"
            assert_contains 'C++ scaffold: informa BUILD simbólico' \
                'unsafe C++ file: BUILD' "$err"
            rm -- "$layout_dir/BUILD"
            ;;
        go)
            assert_eq 'scaffold go: tests no test' 'yes' "$([[ -d "$layout_dir/tests" && ! -e "$layout_dir/test" ]] && echo yes || echo no)"
            assert_contains 'scaffold go: advierte sobre suites vacías u omitidas' 'go test puede aprobar sin casos o con todos omitidos' "$err" ;;
        v)
            assert_eq "scaffold $layout_lang: tests no test" 'yes' "$([[ -d "$layout_dir/tests" && ! -e "$layout_dir/test" ]] && echo yes || echo no)" ;;
        crystal)
            assert_eq 'Crystal: no inventa test/' 'no' "$([[ -e "$layout_dir/test" ]] && echo yes || echo no)"
            assert_eq 'Crystal: conserva fuente' 'authored Crystal' "$(cat "$layout_dir/src/naive_sort.cr")" ;;
        fsharp)
            assert_eq 'FSharp: no aplana proyecto' 'no' "$([[ -e "$layout_dir/src/NaiveSort.fsproj" ]] && echo yes || echo no)"
            assert_eq 'FSharp: conserva fuente' 'authored FSharp' "$(cat "$layout_dir/src/NaiveSort/Library.fs")" ;;
        haskell)
            assert_eq 'Haskell: no impone src/' 'no' "$([[ -e "$layout_dir/src" ]] && echo yes || echo no)"
            assert_eq 'Haskell: conserva declaración' 'module NaiveSort where' "$(cat "$layout_dir/lib/NaiveSort.hs")"
            assert_eq 'Haskell: conserva manifiesto propio' 'authored cabal manifest' "$(cat "$layout_dir/naive-sort.cabal")"
            assert_eq 'Haskell: conserva runner propio' 'authored runner' "$(cat "$layout_dir/test/Main.hs")"
            assert_contains 'Haskell: anuncia revisión' 'revisar manifiestos y runners Haskell conservados' "$err" ;;
    esac
done
GO_LINK_TARGET="$WORK_DIR/go-scaffold-target"
GO_LINK_MODULE="$SANDBOX/go/core/algorithms/data_structures_basics"
mkdir -p -- "$GO_LINK_TARGET" "$GO_LINK_MODULE"
printf 'authored marker\n' >"$GO_LINK_TARGET/marker"
ln -s -- "$GO_LINK_TARGET" "$GO_LINK_MODULE/src"
glot_run_sandbox scaffold go algorithms/data_structures_basics
assert_eq 'scaffold Go src symlink: bloquea' '4' "$rc_last"
assert_contains 'scaffold Go src symlink: diagnóstico' 'unsafe Go path' "$err"
assert_eq 'scaffold Go src symlink: preserva destino' 'authored marker' "$(cat -- "$GO_LINK_TARGET/marker")"
assert_eq 'scaffold Go src symlink: no crea tests' 'no' "$([[ -e "$GO_LINK_MODULE/tests" ]] && echo yes || echo no)"
rm -- "$GO_LINK_MODULE/src"
ln -s -- "$GO_LINK_TARGET" "$GO_LINK_MODULE/tests"
glot_run_sandbox scaffold go algorithms/data_structures_basics
assert_eq 'scaffold Go tests symlink: bloquea' '4' "$rc_last"
assert_eq 'scaffold Go tests symlink: no crea src' 'no' "$([[ -e "$GO_LINK_MODULE/src" ]] && echo yes || echo no)"
rm -- "$GO_LINK_MODULE/tests"
printf 'authored tests file\n' >"$GO_LINK_MODULE/tests"
glot_run_sandbox scaffold go algorithms/data_structures_basics
assert_eq 'scaffold Go tests archivo: bloquea' '4' "$rc_last"
assert_eq 'scaffold Go tests archivo: conserva contenido' 'authored tests file' "$(cat -- "$GO_LINK_MODULE/tests")"
assert_eq 'scaffold Go tests archivo: no crea src' 'no' "$([[ -e "$GO_LINK_MODULE/src" ]] && echo yes || echo no)"

if command -v go >/dev/null 2>&1; then
    GO_RUNNER_BIN="$WORK_DIR/go-test-runner"
    GO_FAKE_BIN="$WORK_DIR/go-fake-bin"
    GO_EVENTS="$WORK_DIR/go-events.json"
    mkdir -p -- "$GO_FAKE_BIN"
    go build -o "$GO_RUNNER_BIN" "$DATA_DIR/go_test_runner.go"
    cat >"$GO_FAKE_BIN/go" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == "test -count=1 -json ./..." ]] || exit 2
cat -- "$GO_EVENTS"
exit "${GO_FAKE_STATUS:-0}"
EOF
    chmod +x -- "$GO_FAKE_BIN/go"
    go_runner_run() {
        local rc=0
        out="$(GO_EVENTS="$GO_EVENTS" GO_FAKE_STATUS="${1:-0}" PATH="$GO_FAKE_BIN:$PATH" \
            "$GO_RUNNER_BIN" 2>"$WORK_DIR/stderr")" || rc=$?
        err="$(cat -- "$WORK_DIR/stderr")"
        rc_last="$rc"
    }

    cat >"$GO_EVENTS" <<'EOF'
{"Action":"start","Package":"example/test"}
{"Action":"run","Package":"example/test","Test":"TestParent"}
{"Action":"run","Package":"example/test","Test":"TestParent/child"}
{"Action":"skip","Package":"example/test","Test":"TestParent/child"}
{"Action":"pass","Package":"example/test","Test":"TestParent"}
{"Action":"pass","Package":"example/test"}
EOF
    go_runner_run
    assert_eq 'test Go: padre verde con hijos omitidos falla' '1' "$rc_last"
    assert_contains 'test Go: informa cero casos aprobados' 'no Go test cases passed' "$err"
    cat >>"$GO_EVENTS" <<'EOF'
{"Action":"start","Package":"example/other"}
{"Action":"run","Package":"example/other","Test":"TestPass"}
{"Action":"output","Package":"example/other","Test":"TestPass","Output":"native output\n"}
{"Action":"pass","Package":"example/other","Test":"TestPass"}
{"Action":"pass","Package":"example/other"}
EOF
    go_runner_run
    assert_eq 'test Go: mezcla de aprobado y omitido' '0' "$rc_last"
    assert_contains 'test Go: conserva salida nativa' 'native output' "$out"
    assert_contains 'test Go: cuenta solo hojas' '1 passed, 1 skipped' "$out"
    go_runner_run 7
    assert_eq 'test Go: propaga fallo del proceso' '1' "$rc_last"
    assert_contains 'test Go: informa fallo del proceso' 'Go failed' "$err"
    printf '%s\n' '{"Action":"start","Package":"example/src"}' \
        '{"Action":"output","Package":"example/src","Output":"[no test files]\n"}' \
        '{"Action":"skip","Package":"example/src"}' >"$GO_EVENTS"
    go_runner_run
    assert_eq 'test Go: paquete sin casos falla' '1' "$rc_last"
    assert_contains 'test Go: conserva salida de paquete sin casos' '[no test files]' "$out"
    printf '%s\n' '{"Action":"start","Package":"example/test"}' \
        '{"Action":"run","Package":"example/test","Test":"TestIncomplete"}' \
        '{"Action":"pass","Package":"example/test"}' >"$GO_EVENTS"
    go_runner_run
    assert_eq 'test Go: prueba incompleta falla' '1' "$rc_last"
    assert_contains 'test Go: diagnóstico de prueba incompleta' 'incomplete or failed Go test' "$err"
    printf '%s\n' '{"Action":"start","Package":"example/test"}' '{invalid' >"$GO_EVENTS"
    go_runner_run
    assert_eq 'test Go: JSON inválido falla' '1' "$rc_last"
    assert_contains 'test Go: diagnóstico de JSON inválido' 'invalid Go JSON report' "$err"
    printf '%s\n' '{"Action":"build-fail","ImportPath":"example/test"}' >"$GO_EVENTS"
    go_runner_run
    assert_eq 'test Go: construcción fallida no da falso verde' '1' "$rc_last"
    assert_contains 'test Go: diagnóstico de construcción fallida' 'Go build failed' "$err"
fi

assert_contains 'FSharp new: referencia declarada con herramienta' \
    'dotnet add test/{Module}.Tests/{Module}.Tests.fsproj reference src/{Module}/{Module}.fsproj' \
    "$(awk -F'\t' '$1=="fsharp" && $2=="new" && $3==5 {print $6}' "$TESTS_DIR/../data/init_sequences.tsv")"

rm -- "$BB/.gitignore"
ln -s "$BB/naive_sort.bal" "$BB/.gitignore"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold ignore symlink: código' '4' "$rc_last"
assert_contains 'scaffold ignore symlink: diagnóstico' 'unsafe .gitignore' "$err"
assert_eq 'scaffold ignore symlink: no modifica destino' 'authored main' "$(cat -- "$BB/naive_sort.bal")"
rm -- "$BB/.gitignore"
mkdir -- "$BB/.gitignore"
glot_run_sandbox scaffold ballerina algorithms/naive_sort
assert_eq 'scaffold ignore directorio: código' '4' "$rc_last"
rmdir -- "$BB/.gitignore"

# Los otros Makefiles declarados también se copian desde el catálogo sin toolchains externos.
local_scaffold_lang=""
for local_scaffold_lang in c cobol grain r; do
    local_scaffold_dir="$SANDBOX/$local_scaffold_lang/core/algorithms/naive_sort"
    mkdir -p -- "$local_scaffold_dir"
    glot_run_sandbox scaffold "$local_scaffold_lang" algorithms/naive_sort
    assert_eq "sandbox scaffold $local_scaffold_lang: código" '0' "$rc_last"
    assert_eq "sandbox scaffold $local_scaffold_lang: crea Makefile" 'si' \
        "$([[ -f "$local_scaffold_dir/Makefile" ]] && echo si || echo no)"
    assert_eq "sandbox scaffold $local_scaffold_lang: copia plantilla" '0' \
        "$(cmp -s "$local_scaffold_dir/Makefile" \
            "$TESTS_DIR/../data/scaffold_templates/$local_scaffold_lang.Makefile"; echo $?)"
    assert_eq "sandbox scaffold $local_scaffold_lang: garantiza .gitignore" 'si' \
        "$([[ -f "$local_scaffold_dir/.gitignore" ]] && echo si || echo no)"
done

# `{root}` se expande como una ruta segura incluso cuando el monorepo contiene espacios.
SPACED_SANDBOX="$WORK_DIR/sandbox with spaces"
rm -rf -- "$SPACED_SANDBOX"
cp -R -- "$SANDBOX" "$SPACED_SANDBOX"
mkdir -p -- "$SPACED_SANDBOX/assembly/core/algorithms/naive_sort"
local_spaced_rc=0
out="$(GLOT_ROOT="$SPACED_SANDBOX" "$GLOT_SH" scaffold assembly algorithms/naive_sort \
    2>"$WORK_DIR/stderr")" || local_spaced_rc=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'sandbox scaffold con espacios: código' '0' "$local_spaced_rc"
assert_eq 'sandbox scaffold con espacios: copia Makefile' 'si' \
    "$([[ -f "$SPACED_SANDBOX/assembly/core/algorithms/naive_sort/Makefile" ]] && echo si || echo no)"
rm -- "$SPACED_SANDBOX/ballerina/core/algorithms/naive_sort/naive_sort.bal"
cp -- "$TESTS_DIR/../data/scaffold_templates/ballerina.main.bal" \
    "$SPACED_SANDBOX/ballerina/core/algorithms/naive_sort/main.bal"
local_spaced_rc=0
out="$(GLOT_ROOT="$SPACED_SANDBOX" "$GLOT_SH" scaffold ballerina algorithms/naive_sort \
    2>"$WORK_DIR/stderr")" || local_spaced_rc=$?
assert_eq 'scaffold Ballerina con espacios: código' '0' "$local_spaced_rc"
assert_eq 'scaffold Ballerina con espacios: retira ejemplo' 'si' \
    "$([[ -f "$SPACED_SANDBOX/ballerina/core/algorithms/naive_sort/naive_sort.bal" && ! -s "$SPACED_SANDBOX/ballerina/core/algorithms/naive_sort/naive_sort.bal" ]] && echo si || echo no)"

# con contenido, el esqueleto ya está hecho: no se pisa nada
glot_run_sandbox new java algorithms/naive_sort
assert_eq 'sandbox new repetido: código' '0' "$rc_last"
assert_eq 'sandbox new repetido: dato = ruta del módulo' "$JB" "$out"
assert_contains 'sandbox new repetido: avisa' 'no scaffolding' "$err"

# el sprint escribe el código del módulo; `save` necesita contenido en ruby
mkdir -p -- "$RB/src"

# save: mensaje del catálogo, índice completo y confirmación en el submódulo
printf 'x\n' >"$RB/src/x.rb"
glot_run_sandbox -n save 4a ruby algorithms/naive_sort
assert_eq 'save -n: código' '0' "$rc_last"
assert_contains 'save -n: añade el submódulo' "git -C $SANDBOX/ruby add -A" "$out"
assert_contains 'save -n: mensaje de la tabla' "commit -m 'chore(algorithms): scaffold naive_sort'" "$out"
assert_eq 'save -n: no confirma nada' '' "$(git -C "$SANDBOX/ruby" log --oneline main..HEAD 2>/dev/null)"

glot_run_sandbox save 4a ruby algorithms/naive_sort
assert_eq 'save: código' '0' "$rc_last"
assert_eq 'save: dato = SHA corto' '7' "${#out}"
assert_eq 'save: asunto del commit' 'chore(algorithms): scaffold naive_sort' \
    "$(git -C "$SANDBOX/ruby" log -1 --format=%s)"
assert_eq 'save: confirma en el submódulo' 'si' \
    "$(git -C "$SANDBOX/ruby" log -1 --format=%s | grep -q '^chore' && echo si || echo no)"
assert_eq 'save: no hace push' 'no' \
    "$([[ "$(git -C "$SANDBOX/remote/ruby.git" rev-parse feat/algorithms/naive-sort)" == "$(git -C "$SANDBOX/ruby" rev-parse HEAD)" ]] && echo si || echo no)"

# save: el alias del encargo es el mismo paso
glot_run_sandbox save suite ruby algorithms/naive_sort
assert_eq 'save con alias y nada que confirmar: código' '0' "$rc_last"
assert_eq 'save con alias y nada que confirmar: dato' 'nothing' "$out"

# save: el contrato es el paso 4b (alias `contract_stub`) y su mensaje sale del catálogo
printf 'y\n' >"$RB/src/y.rb"
glot_run_sandbox -n save contract_stub ruby algorithms/naive_sort
assert_eq 'save -n contrato: código' '0' "$rc_last"
assert_contains 'save -n contrato: mensaje del catálogo' "commit -m 'chore(algorithms): define naive_sort contract'" "$out"
# v1.3.0: el mismo flag, detrás del verbo (antes tomaba `-n` por el paso)
glot_run_sandbox save -n contract_stub ruby algorithms/naive_sort
assert_eq 'save -n detrás del verbo: código' '0' "$rc_last"
assert_contains 'save -n detrás del verbo: mensaje del catálogo' "commit -m 'chore(algorithms): define naive_sort contract'" "$out"
# v1.5.0: el alias viejo `contract` ya no resuelve; el ordinal `4b` sigue siendo la forma estable
glot_run_sandbox -n save contract ruby algorithms/naive_sort
assert_eq 'save con el alias viejo: código' '2' "$rc_last"
assert_contains 'save con el alias viejo: lo explica' 'paso desconocido' "$err"
glot_run_sandbox -n save 4b ruby algorithms/naive_sort
assert_eq 'save 4b sigue valiendo: código' '0' "$rc_last"
rm -f -- "$RB/src/y.rb"

# v1.3.0: la corrección es paso propio (`4d`, alias `fix`) y **exige la causa**, que va como
# segundo `-m` del commit: es el registro del retrabajo. Medido el 2026-09-26: en Ada hubo
# que corregir el contrato (4b) y la suite (4c) después de confirmarlos, y `save` los habría
# metido en un solo commit sin decir por qué.
glot_run_sandbox -n save 4e ruby algorithms/naive_sort
assert_eq 'save 4e sin causa: código' '2' "$rc_last"
assert_contains 'save 4e sin causa: lo explica' 'necesita su causa' "$err"
printf 'z\n' >"$RB/src/z.rb"
glot_run_sandbox -n save 4e --cause 'la suite no cubría el caso vacío' ruby algorithms/naive_sort
assert_eq 'save 4e con causa: código' '0' "$rc_last"
assert_contains 'save 4e: el mensaje sale del catálogo' "commit -m 'fix(algorithms): correct naive_sort'" "$out"
assert_contains 'save 4e: la causa va al cuerpo del commit' "-m 'la suite no cubría el caso vacío'" "$out"
# v1.5.0: la opción va en inglés, como el resto del CLI; `--causa` se acepta como alias
glot_run_sandbox -n save 4e --causa 'la causa en español sigue valiendo' ruby algorithms/naive_sort
assert_eq 'save 4e con --causa (alias): código' '0' "$rc_last"
assert_contains 'save 4e con --causa: la causa llega' "-m 'la causa en español sigue valiendo'" "$out"
glot_run_sandbox -n save 4e --cause='la causa con igual' ruby algorithms/naive_sort
assert_eq 'save 4e con --cause= (pegado): código' '0' "$rc_last"
assert_contains 'save 4e con --cause=: la causa llega' "-m 'la causa con igual'" "$out"
glot_run_sandbox -n save 4e --cause
assert_eq 'save 4e con --cause sin texto: código' '2' "$rc_last"
assert_contains 'save 4e con --cause sin texto: lo explica' 'falta el texto de --cause' "$err"
glot_run_sandbox -n save fix --cause 'la causa' ruby algorithms/naive_sort
assert_eq 'save con el alias fix: código' '0' "$rc_last"
assert_contains 'save con el alias fix: el mismo mensaje' "commit -m 'fix(algorithms): fix naive_sort'" "$out"
rm -f -- "$RB/src/z.rb"

# El ordinal 4e retira la causa; 4d build no la consume.
glot_run_sandbox set cause 'integración de los grupos del runner'
printf 'runner\n' >"$RB/src/runner.rb"
glot_run_sandbox save 4d ruby algorithms/naive_sort
assert_eq 'save build: confirma sin consumir causa' '0' "$rc_last"
glot_run_sandbox get cause
assert_eq 'save build: conserva causa pendiente' 'integración de los grupos del runner' "$out"
printf 'runner corregido\n' >"$RB/src/runner.rb"
glot_run_sandbox save 4e ruby algorithms/naive_sort
assert_eq 'save correct ordinal: confirma con causa' '0' "$rc_last"
assert_contains 'save correct ordinal: causa registrada' 'integración de los grupos del runner' \
    "$(git -C "$SANDBOX/ruby" log -1 --format=%B)"
glot_run_sandbox get cause
assert_eq 'save correct ordinal: causa consumida' '1' "$rc_last"

# save -n con el árbol ya limpio: no hay plan que enseñar, y lo dice como la ejecución real
glot_run_sandbox -n save 4c ruby algorithms/naive_sort
assert_eq 'save -n con árbol limpio: código' '0' "$rc_last"
assert_eq 'save -n con árbol limpio: dato' 'nothing' "$out"
assert_contains 'save -n con árbol limpio: avisa' 'nothing to commit' "$err"

# save: los pasos del monorepo (9 y 10) se comprueban en la fixture de L7, que tiene
# submódulos de verdad: el sandbox no registra gitlinks.

glot_run_sandbox save nope ruby algorithms/naive_sort
assert_eq 'save con paso desconocido: código' '2' "$rc_last"
glot_run_sandbox save
assert_eq 'save sin paso: código' '2' "$rc_last"

# doctor informa del catálogo de inicialización y del de commits
glot_run doctor
assert_contains 'doctor: cobertura de inicializadores' 'new_commands: ' "$out"
assert_contains 'doctor: inicializadores verificados' 'new_commands: 50 de / of 50' "$out"
assert_contains 'doctor: catálogo de commits' 'commits_file: ' "$out"
assert_contains 'doctor: pasos de commit' 'commit_steps: 13 de / of which 11 son del submódulo' "$out"

# --- casos de la especificación v0.10.0 (L6, evidencia y cierre) -------------

# el lenguaje se deduce del directorio cuando no lo traen ni los argumentos ni el
# estado: dentro de un submódulo es evidente, igual que en `use`
sandbox_make
mkdir -p -- "$SANDBOX/php/core/algorithms/naive_sort"
glot_run_sandbox unset lang
glot_run_sandbox unset phase
glot_run_sandbox unset module
glot_run_from "$SANDBOX/php" -n test algorithms/naive_sort
assert_eq 'lenguaje desde el directorio: código' '0' "$rc_last"
assert_contains 'lenguaje desde el directorio: usa el del submódulo actual' '/php/core/algorithms/naive_sort && ' "$out"

glot_run_from "$SANDBOX/docs" -n test algorithms/naive_sort
assert_eq 'fuera de un submódulo: sigue faltando el lenguaje' '1' "$rc_last"
assert_contains 'fuera de un submódulo: sugiere use' 'glot use' "$err"

# el estado del sprint manda sobre el directorio: el argumento siempre gana
glot_run_sandbox use ruby algorithms/naive_sort
assert_eq 'estado del sprint preparado: código' '0' "$rc_last"
glot_run_from "$SANDBOX/php" -n test algorithms/naive_sort
assert_contains 'el estado manda sobre el directorio' 'ruby/core/algorithms/naive_sort' "$out"

glot_run_from "$SANDBOX/php" -n test php algorithms/naive_sort
assert_contains 'el argumento manda sobre el estado' 'php/core/algorithms/naive_sort' "$out"

# evidence: el acta con la salida real, escrita también cuando la suite está en rojo.
# Los comandos del lenguaje se sustituyen por dos dobles en el PATH, así que el caso
# es determinista y no depende de ninguna toolchain.
sandbox_make
mkdir -p -- "$SANDBOX/ruby/core/algorithms/naive_sort/src" "$SANDBOX/stub"

cat >"$SANDBOX/stub/bundle" <<'STUB'
#!/usr/bin/env bash
printf 'stub bundle: %s\n' "$*"
exit "${STUB_TEST_EXIT:-0}"
STUB
cat >"$SANDBOX/stub/ruby" <<'STUB'
#!/usr/bin/env bash
printf 'stub ruby: %s\n' "$*"
exit "${STUB_VERIFY_EXIT:-0}"
STUB
chmod +x -- "$SANDBOX/stub/bundle" "$SANDBOX/stub/ruby"

# glot_run_evidence [-n|...] [args...] — ejecuta `evidence` con los dobles por delante
# en el PATH; los flags globales se colocan antes del verbo, como manda el contrato.
glot_run_evidence() {
    local -a flags=()
    local rc=0

    while [[ "${1:-}" == -* ]]; do
        flags+=("$1")
        shift
    done

    out="$(GLOT_ROOT="$SANDBOX" PATH="$SANDBOX/stub:$PATH" "$GLOT_SH" "${flags[@]}" evidence "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

ACTA="$SANDBOX/docs/evidence/algorithms/naive_sort/ruby.md"

# en verde: el acta queda con la salida real, el commit y el veredicto
glot_run_evidence ruby algorithms/naive_sort
assert_eq 'evidence en verde: código' '0' "$rc_last"
assert_eq 'evidence en verde: dato = ruta del acta' "$ACTA" "$out"
assert_eq 'evidence en verde: el acta está escrita' 'si' "$([[ -f "$ACTA" ]] && echo si || echo no)"
assert_contains 'evidence: bloque de máquina con el veredicto' 'verdict=green' "$(cat -- "$ACTA")"
assert_contains 'evidence: código de la suite' 'test_exit=0' "$(cat -- "$ACTA")"
assert_contains 'evidence: código del verificador' 'verify_exit=0' "$(cat -- "$ACTA")"
assert_contains 'evidence: salida real de la suite' 'stub bundle: exec rspec' "$(cat -- "$ACTA")"
assert_contains 'evidence: salida real del verificador' 'stub ruby: -c src/naive_sort.rb' "$(cat -- "$ACTA")"
assert_contains 'evidence: apunta al commit del submódulo' 'commit=' "$(cat -- "$ACTA")"
assert_contains 'evidence: árbol limpio' 'dirty=no' "$(cat -- "$ACTA")"
assert_contains 'evidence: el bloque de máquina se cierra' "$(printf '%s\n' '-->')" "$(cat -- "$ACTA")"

# en rojo: el acta se escribe igual y el verbo devuelve 4
STUB_TEST_EXIT=1 glot_run_evidence ruby algorithms/naive_sort
assert_eq 'evidence en rojo: código' '4' "$rc_last"
assert_eq 'evidence en rojo: dato = ruta del acta' "$ACTA" "$out"
assert_contains 'evidence en rojo: veredicto' 'verdict=red' "$(cat -- "$ACTA")"
assert_contains 'evidence en rojo: código de la suite' 'test_exit=1' "$(cat -- "$ACTA")"
assert_contains 'evidence en rojo: el verificador sigue verde' 'verify_exit=0' "$(cat -- "$ACTA")"
assert_contains 'evidence en rojo: avisa' 'the suite is red' "$err"

# con el árbol sucio el acta lo dice, porque la evidencia apunta al commit
printf 'x\n' >"$SANDBOX/ruby/core/algorithms/naive_sort/src/x.rb"
glot_run_evidence ruby algorithms/naive_sort
assert_contains 'evidence con árbol sucio: lo marca' 'dirty=yes' "$(cat -- "$ACTA")"
assert_contains 'evidence con árbol sucio: avisa' 'sucio' "$err"

# sin verificador en el catálogo, solo se ejecuta la suite
sandbox_make
mkdir -p -- "$SANDBOX/stub"
glot_run -n evidence java algorithms/naive_sort
assert_eq 'evidence -n sin verificador: solo la suite' '1' "$(printf '%s\n' "$out" | grep -c '^cd ')"
glot_run -n evidence php algorithms/naive_sort
assert_eq 'evidence -n con verificador: suite y verificador' '2' "$(printf '%s\n' "$out" | grep -c '^cd ')"
assert_contains 'evidence -n: enseña dónde queda el acta' '/docs/evidence/algorithms/naive_sort/php.md' "$out"

# -n no ejecuta ni escribe el acta
sandbox_make
mkdir -p -- "$SANDBOX/ruby/core/algorithms/naive_sort/src" "$SANDBOX/stub"
glot_run_evidence -n ruby algorithms/naive_sort
assert_eq 'evidence -n: código' '0' "$rc_last"
assert_contains 'evidence -n: enseña el acta' '/docs/evidence/algorithms/naive_sort/ruby.md' "$out"
assert_eq 'evidence -n: no escribe' 'no' "$([[ -f "$SANDBOX/docs/evidence/algorithms/naive_sort/ruby.md" ]] && echo si || echo no)"

# errores del objetivo y de los argumentos
glot_run_evidence ruby algorithms/nope
assert_eq 'evidence con módulo desconocido: código' '1' "$rc_last"
glot_run_evidence nope algorithms/naive_sort
assert_eq 'evidence con lenguaje fuera de .gitmodules: código' '1' "$rc_last"
glot_run_evidence ruby algorithms/naive_sort extra
assert_eq 'evidence con demasiados argumentos: código' '2' "$rc_last"

# la tabla de nombres de presentación: es la que fija el nombre y el orden de las listas
# del roadmap, así que la deriva se comprueba en los dos sentidos
assert_eq 'display: 2 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 2' "$DATA_DIR/display.tsv" | wc -l | tr -d ' ')"
assert_eq 'display: un nombre por lenguaje registrado' '0' \
    "$(diff <(cut -f1 "$DATA_DIR/display.tsv" | LC_ALL=C sort) \
        <(git config --file "$REPO/.gitmodules" --get-regexp '\.path$' | awk '{print $NF}' | LC_ALL=C sort) | wc -l | tr -d ' ')"
display_names="$(cut -f2 "$DATA_DIR/display.tsv" | LC_ALL=C sort)"
roadmap_names="$(grep -m1 '50/50 (' "$REPO/docs/ROADMAP.md" | sed 's/.*(//; s/)$//' |
    tr ',' '\n' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' | LC_ALL=C sort)"
assert_eq 'display: 50 nombres' '50' "$(printf '%s\n' "$display_names" | wc -l | tr -d ' ')"
assert_eq 'display: los nombres son los del roadmap' "$roadmap_names" "$display_names"

# close: cierre del módulo. Se monta un roadmap y un checklist de mentira en el
# sandbox, con el módulo a medio cerrar, y se comprueban la línea nueva, la entrada
# del checklist, la idempotencia y las negativas. La marca inicial es texto ASCII a
# propósito: el análisis no depende de que el emoji sobreviva al editor, y así el
# fixture tampoco.
sandbox_make
mkdir -p -- "$SANDBOX/ruby/core/algorithms/naive_sort/src" "$SANDBOX/stub"

cat >"$SANDBOX/stub/bundle" <<'STUB'
#!/usr/bin/env bash
printf 'stub bundle: %s\n' "$*"
exit "${STUB_TEST_EXIT:-0}"
STUB
cat >"$SANDBOX/stub/ruby" <<'STUB'
#!/usr/bin/env bash
printf 'stub ruby: %s\n' "$*"
exit "${STUB_VERIFY_EXIT:-0}"
STUB
chmod +x -- "$SANDBOX/stub/bundle" "$SANDBOX/stub/ruby"

# close_fixture [contador] — deja la línea del módulo a medio cerrar.
close_fixture() {
    printf 'core.algorithms.naive_sort            pending %s (Ada)\n' "${1:-1/50}" >"$SANDBOX/docs/ROADMAP.md"
    printf '# Registro de cierre\n' >"$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md"
}

RB="$SANDBOX/ruby/core/algorithms/naive_sort"
printf '# naive sort (ruby)\n' >"$RB/README.md"
printf '# algorithms (ruby)\n' >"$SANDBOX/ruby/core/algorithms/README.md"
close_fixture

# sin evidencia, el cierre no pasa
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close sin evidencia: código' '1' "$rc_last"
assert_contains 'close sin evidencia: remite a evidence' 'glot evidence' "$err"

# con la evidencia en rojo tampoco
STUB_TEST_EXIT=1 glot_run_evidence ruby algorithms/naive_sort
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close con evidencia roja: código' '4' "$rc_last"
assert_contains 'close con evidencia roja: lo dice' 'not green' "$err"

# en verde: se registra el cierre
glot_run_evidence ruby algorithms/naive_sort
glot_run_sandbox -n close ruby algorithms/naive_sort
assert_eq 'close -n: código' '0' "$rc_last"
assert_contains 'close -n: la línea vieja' '-core.algorithms.naive_sort' "$out"
assert_contains 'close -n: la línea nueva' '+core.algorithms.naive_sort' "$out"
assert_contains 'close -n: el contador y la lista' '2/50 (Ada, Ruby)' "$out"
assert_contains 'close -n: el roadmap no se toca' '1/50 (Ada)' "$(cat -- "$SANDBOX/docs/ROADMAP.md")"

glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close: código' '0' "$rc_last"
assert_contains 'close: dato = la línea nueva' '2/50 (Ada, Ruby)' "$out"
assert_contains 'close: el roadmap queda actualizado' '2/50 (Ada, Ruby)' "$(cat -- "$SANDBOX/docs/ROADMAP.md")"
assert_eq 'close: la marca pasa a en curso' 'si' \
    "$(grep -q $'\xf0\x9f\x94\x84' "$SANDBOX/docs/ROADMAP.md" && echo si || echo no)"
assert_contains 'close: la entrada del checklist' 'Lenguaje(s) / Language(s): ruby' "$(cat -- "$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md")"
assert_contains 'close: la entrada cita la evidencia' 'acta de evidencia' "$(cat -- "$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md")"
assert_contains 'close: la entrada cita el cambio del roadmap' '2/50 (Ada, Ruby)' "$(cat -- "$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md")"
assert_contains 'close: no confirma' 'the commit is yours' "$err"

# idempotente: repetirlo no suma dos veces ni vuelve a pedir la evidencia
entries_before="$(grep -c 'Fecha / Date:' "$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md")"
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close repetido: código' '0' "$rc_last"
assert_contains 'close repetido: avisa' 'already counts' "$err"
assert_contains 'close repetido: la línea no cambia' '2/50 (Ada, Ruby)' "$out"
assert_eq 'close repetido: sin segunda entrada' "$entries_before" \
    "$(grep -c 'Fecha / Date:' "$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md")"

# al llegar al total, la línea queda marcada como hecha
close_fixture '1/2'
glot_run_evidence ruby algorithms/naive_sort
glot_run_sandbox close ruby algorithms/naive_sort
assert_contains 'close: al llegar al total' '2/2 (Ada, Ruby)' "$out"
assert_eq 'close: la marca es la de hecho' 'si' \
    "$(printf '%s' "$out" | grep -q $'\xe2\x9c\x85' && echo si || echo no)"

# negativas de documentación y de roadmap
close_fixture
rm -f -- "$RB/README.md"
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close sin README del módulo: código' '4' "$rc_last"
assert_contains 'close sin README del módulo: remite al paso 7' 'docs-module' "$err"
printf '# naive sort (ruby)\n' >"$RB/README.md"

rm -f -- "$SANDBOX/ruby/core/algorithms/README.md"
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close sin README de la fase: código' '4' "$rc_last"
assert_contains 'close sin README de la fase: remite al paso 8' 'docs-language' "$err"
printf '# algorithms (ruby)\n' >"$SANDBOX/ruby/core/algorithms/README.md"

printf '# sin el módulo\n' >"$SANDBOX/docs/ROADMAP.md"
glot_run_sandbox close ruby algorithms/naive_sort
assert_eq 'close sin la línea del roadmap: código' '1' "$rc_last"
assert_contains 'close sin la línea del roadmap: lo dice' 'missing from the roadmap' "$err"

close_fixture
glot_run_sandbox close ruby algorithms/nope
assert_eq 'close con módulo desconocido: código' '1' "$rc_last"
glot_run_sandbox close ruby algorithms/naive_sort extra
assert_eq 'close con demasiados argumentos: código' '2' "$rc_last"

# validate: el validador es enchufable y opcional. El sustituto lee el encargo por
# stdin y emite el veredicto que la plantilla exige, así que el caso no depende de
# Copilot ni gasta créditos.
sandbox_make
mkdir -p -- "$SANDBOX/php/core/algorithms/naive_sort" "$SANDBOX/stub"

cat >"$SANDBOX/stub/validador" <<'STUB'
#!/usr/bin/env bash
cat >"${VALIDATOR_INBOX:-/dev/null}"
if [[ -n "${VALIDATOR_BREAK:-}" ]]; then
    exit "${VALIDATOR_EXIT:-1}"
fi
if [[ -z "${VALIDATOR_SILENT:-}" ]]; then
    case "${VALIDATOR_VERDICT:-clean}" in
        clean) printf 'Sin hallazgos.\nglot:validate verdict=clean findings=0\n' ;;
        findings) printf -- '- [media] src/x.php:3 — falta el caso nulo\nglot:validate verdict=findings findings=1\n' ;;
        *) printf 'algo raro\nglot:validate verdict=no-se\n' ;;
    esac
fi
STUB
chmod +x -- "$SANDBOX/stub/validador"

# glot_run_validate [-n|...] [args...] — ejecuta `validate` con ese validador; los
# flags globales van antes del verbo, como manda el contrato.
glot_run_validate() {
    local -a flags=()
    local rc=0

    while [[ "${1:-}" == -* ]]; do
        flags+=("$1")
        shift
    done

    out="$(GLOT_ROOT="$SANDBOX" GLOT_VALIDATOR="$SANDBOX/stub/validador" "$GLOT_SH" "${flags[@]}" validate "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

RECORD="$SANDBOX/docs/evidence/algorithms/naive_sort/php.validate.md"

# sin hallazgos: cero, informe por stdout y registro con bloque de máquina
VALIDATOR_INBOX="$SANDBOX/encargo.txt" glot_run_validate php algorithms/naive_sort
assert_eq 'validate limpio: código' '0' "$rc_last"
assert_contains 'validate: el informe va a stdout' 'verdict=clean' "$out"
assert_eq 'validate limpio: el registro está' 'si' "$([[ -f "$RECORD" ]] && echo si || echo no)"
assert_contains 'validate: el registro lleva el bloque de máquina' 'verdict=clean' "$(cat -- "$RECORD")"
assert_contains 'validate: el registro guarda el informe' 'Sin hallazgos.' "$(cat -- "$RECORD")"
assert_contains 'validate: el registro dice quién validó' 'validator=' "$(cat -- "$RECORD")"
assert_contains 'validate: el encargo llega por stdin' '# Encargo `validate`' "$(cat -- "$SANDBOX/encargo.txt")"
assert_contains 'validate: el encargo trae el estado del sprint' '| module | naive_sort |' "$(cat -- "$SANDBOX/encargo.txt")"
assert_contains 'validate: recibe la política compartida' '# Política compartida de delegación' "$(cat -- "$SANDBOX/encargo.txt")"
assert_contains 'validate: recibe agrupación por contrato' 'No multipliques todos los casos por todas las' "$(cat -- "$SANDBOX/encargo.txt")"

# con hallazgos: cuatro y el registro lo dice
VALIDATOR_VERDICT=findings glot_run_validate php algorithms/naive_sort
assert_eq 'validate con hallazgos: código' '4' "$rc_last"
assert_contains 'validate con hallazgos: el registro' 'verdict=findings' "$(cat -- "$RECORD")"
assert_contains 'validate con hallazgos: avisa' 'has findings' "$err"

# el veredicto se lee; no se adivina
VALIDATOR_VERDICT=raro glot_run_validate php algorithms/naive_sort
assert_eq 'validate con veredicto inesperado: código' '3' "$rc_last"
assert_contains 'validate con veredicto inesperado: lo dice' 'unexpected verdict' "$err"

VALIDATOR_SILENT=1 glot_run_validate php algorithms/naive_sort
assert_eq 'validate sin línea de veredicto: código' '3' "$rc_last"
assert_contains 'validate sin línea de veredicto: la exige' 'glot:validate verdict=clean findings=0' "$err"

VALIDATOR_BREAK=1 glot_run_validate php algorithms/naive_sort
assert_eq 'validate con validador que falla: código' '3' "$rc_last"
assert_contains 'validate con validador que falla: lo dice' 'the validator failed' "$err"

# sin validador configurado y sin Copilot en el PATH: opcional, devuelve 1
rc_last=0
out="$(cd -- "$SANDBOX/php" && GLOT_ROOT="$SANDBOX" PATH="/usr/bin:/bin" "$GLOT_SH" validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'validate sin validador: código' '1' "$rc_last"
assert_contains 'validate sin validador: lo dice' 'no validator configured' "$err"
assert_contains 'validate sin validador: es opcional' 'optional' "$err"

# -n: el plan (el comando y dónde queda el registro) sin ejecutar ni escribir
rm -f -- "$RECORD"
glot_run_validate -n php algorithms/naive_sort
assert_eq 'validate -n: código' '0' "$rc_last"
assert_contains 'validate -n: el comando del validador' "$SANDBOX/stub/validador" "$out"
assert_contains 'validate -n: el registro' '/docs/evidence/algorithms/naive_sort/php.validate.md' "$out"
assert_eq 'validate -n: no escribe' 'no' "$([[ -f "$RECORD" ]] && echo si || echo no)"

# la invocación por defecto: sin GLOT_VALIDATOR se usa Copilot CLI. Con un `copilot` de
# mentira en el PATH se comprueba la composición entera —el encargo por `-p`, el
# directorio del módulo y el modo solo lectura— sin depender del CLI real
cat >"$SANDBOX/stub/copilot" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >"${COPILOT_ARGS:-/dev/null}"
printf 'Sin hallazgos.\nglot:validate verdict=clean findings=0\n'
STUB
chmod +x -- "$SANDBOX/stub/copilot"

out="$(GLOT_ROOT="$SANDBOX" PATH="$SANDBOX/stub:$PATH" "$GLOT_SH" -n validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'validate sin GLOT_VALIDATOR -n: código' '0' "$rc_last"
assert_contains 'validate -n: el CLI por defecto' 'copilot -C ' "$out"
assert_contains 'validate -n: el encargo en lugar del prompt' '<encargo>' "$out"

rm -f -- "$RECORD"
out="$(GLOT_ROOT="$SANDBOX" PATH="$SANDBOX/stub:$PATH" COPILOT_ARGS="$SANDBOX/copilot-args.txt" "$GLOT_SH" validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'validate por defecto: código' '0' "$rc_last"
assert_contains 'validate por defecto: el registro' 'verdict=clean' "$(cat -- "$RECORD")"
copilot_args="$(cat -- "$SANDBOX/copilot-args.txt")"
assert_contains 'validate por defecto: el directorio del módulo' "-C $SANDBOX/php/core/algorithms/naive_sort" "$copilot_args"
assert_contains 'validate por defecto: el encargo por -p' '# Encargo `validate`' "$copilot_args"
assert_contains 'validate por defecto: modo solo lectura' '--deny-tool write' "$copilot_args"
# v1.6.3: la revisión necesita leer **fuera del submódulo** —la especificación, la plantilla y
# el acta viven en el monorepo—, así que la orden lleva la raíz en `--add-dir`. Medido el
# 2026-10-01: sin él, el validador de `crystal algorithms/data_structures_basics` no pudo
# comprobar la especificación ni el acta y las dejó como dos notas en vez de revisarlas.
assert_contains 'validate por defecto: la raíz del monorepo' "--add-dir $SANDBOX" "$copilot_args"
assert_contains 'validate por defecto: tope de créditos' '--max-ai-credits 30' "$copilot_args"
assert_contains 'validate por defecto: el modelo del perfil' '--model gemini-3.8-flash' "$copilot_args"
assert_contains 'validate por defecto: el esfuerzo del perfil' '--reasoning-effort low' "$copilot_args"

# errores de objetivo y de argumentos
glot_run_validate php algorithms/nope
assert_eq 'validate con módulo desconocido: código' '1' "$rc_last"
glot_run_validate php algorithms/naive_sort extra
assert_eq 'validate con demasiados argumentos: código' '2' "$rc_last"

# v1.6.3: un validador propio cita las rutas con los **mismos marcadores** que el delegado de
# `ask` (`{root}`, `{module_dir}`, `{model}`, `{effort}`), que glot resuelve antes de lanzarlo;
# y un marcador que no exista detiene el verbo en vez de lanzar una orden incompleta.
# (`rc_last` se pone a cero antes: el patrón `|| rc_last=$?` solo asigna cuando falla, y aquí
# se espera un cero después de un caso que terminó en `2`)
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_VALIDATOR="$SANDBOX/stub/validador -C {module_dir} --add-dir {root} --model {model}" \
    "$GLOT_SH" -n validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'validate con marcadores: código' '0' "$rc_last"
assert_contains 'validate con marcadores: el módulo resuelto' "-C $SANDBOX/php/core/algorithms/naive_sort" "$out"
assert_contains 'validate con marcadores: la raíz resuelta' "--add-dir $SANDBOX" "$out"
assert_contains 'validate con marcadores: el modelo del perfil' '--model gemini-3.8-flash' "$out"

out="$(GLOT_ROOT="$SANDBOX" GLOT_VALIDATOR="$SANDBOX/stub/validador --model {inexistente}" \
    "$GLOT_SH" -n validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'validate con marcador desconocido: código' '1' "$rc_last"
assert_contains 'validate con marcador desconocido: lo dice' 'marcador sin resolver' "$err"

route_run validate --delegate antigravity php algorithms/naive_sort
assert_eq 'validate: AGY sin permiso readonly equivalente bloquea' '2' "$rc_last"
route_run -n validate --delegate open-router --model qwen php algorithms/naive_sort
assert_eq 'validate OR: resolutor compartido' '0' "$rc_last"
assert_contains 'validate OR: modelo autorizado en orden' '--model qwen/qwen3.8-max-0902' "$out"
assert_contains 'validate OR: denegación write conservada' '--deny-tool write' "$out"
assert_eq 'validate OR: no usa AI credits como presupuesto BYOK' 'no' \
    "$([[ "$out" == *--max-ai-credits* ]] && echo yes || echo no)"
route_run -n validate --delegate open-router --model argon php algorithms/naive_sort
assert_eq 'validate: Argon respeta la misma categoría docs que ask' '2' "$rc_last"

# doctor informa del validador configurado y del CLI disponible
glot_run doctor
assert_contains 'doctor: validador' 'validator: ' "$out"
assert_contains 'doctor: el CLI del validador' 'copilot: ' "$out"

# --- casos de la especificación v0.11.0 (L6.5, perfiles de modelo) ------------

MODELS_TSV="$TESTS_DIR/../data/models.tsv"

# el catálogo: una fila por perfil, con el modelo como clave
assert_eq 'modelos: el catálogo existe' 'si' "$([[ -f "$MODELS_TSV" ]] && echo si || echo no)"
assert_eq 'modelos: siete columnas por fila' '' "$(awk -F'\t' 'NF!=7' "$MODELS_TSV")"
assert_eq 'modelos: perfiles únicos' '3' "$(cut -f1 -- "$MODELS_TSV" | sort -u | wc -l | tr -d ' ')"
assert_eq 'modelos: modelos únicos (el modelo es la clave)' '3' "$(cut -f2 -- "$MODELS_TSV" | sort -u | wc -l | tr -d ' ')"
assert_eq 'modelos: esfuerzo válido para el CLI' '' \
    "$(awk -F'\t' '$3 !~ /^(none|minimal|low|medium|high|xhigh|max)$/' "$MODELS_TSV")"
# 30 es el mínimo que acepta `--max-ai-credits`: un tope menor no es un ahorro, es un error
assert_eq 'modelos: tope de créditos numérico y sobre el mínimo del CLI' '' \
    "$(awk -F'\t' '$4 !~ /^[0-9]+$/ || $4 < 30' "$MODELS_TSV")"
assert_eq 'modelos: tier de auto válido' '' \
    "$(awk -F'\t' '$5 !~ /^(-|efficiency|balance|intelligence|fast)$/' "$MODELS_TSV")"

# cada plantilla declara su modelo en el frontmatter y el catálogo lo reconoce
missing_model=""
unknown_model=""
for prompt_file in "$PROMPTS_DIR"/*.prompt.md; do
    prompt_name="$(sed -n 's/^name: \(.*\)$/\1/p' "$prompt_file")"
    prompt_model="$(sed -n 's/^profile: \(.*\)$/\1/p' "$prompt_file")"
    if [[ -z "$prompt_model" ]]; then
        missing_model+="$prompt_name "
        continue
    fi
    cut -f1 -- "$MODELS_TSV" | grep -qxF -- "$prompt_model" || unknown_model+="$prompt_name "
done
assert_eq 'modelos: toda plantilla declara su modelo' '' "$missing_model"
assert_eq 'modelos: el modelo declarado está en el catálogo' '' "$unknown_model"

# deriva en los dos sentidos: la columna de encargos de cada perfil tiene que ser
# exactamente el conjunto de plantillas que declaran ese modelo
models_drift=""
while IFS=$'\t' read -r profile model effort credits tier requests pagy_model; do
    declared="$(for prompt_file in "$PROMPTS_DIR"/*.prompt.md; do
        if [[ "$(sed -n 's/^profile: \(.*\)$/\1/p' "$prompt_file")" == "$profile" ]]; then
            sed -n 's/^name: \(.*\)$/\1/p' "$prompt_file"
        fi
    done | sort | tr '\n' ' ')"
    listed="$(printf '%s\n' "$requests" | tr -d ' ' | tr ',' '\n' | sort | tr '\n' ' ')"
    [[ "$declared" == "$listed" ]] || models_drift+="$profile "
done <"$MODELS_TSV"
assert_eq 'modelos: deriva entre el catálogo y las plantillas' '' "$models_drift"

# el modelo viaja por entorno al delegado: es lo único que una orden cualquiera puede
# leer sin que haya que inyectarle flags
glot_run_delegate 'cat >/dev/null; printf "%s\n" "$COPILOT_MODEL"' ask implement php algorithms/naive_sort
assert_eq 'ask: código con delegado' '0' "$rc_last"
assert_eq 'ask: el modelo del perfil llega por entorno' 'claude-sonnet-5.5' "$out"
assert_contains 'ask: anuncia el perfil' 'profile: deep' "$err"

glot_run_delegate 'cat >/dev/null' -n ask validate php algorithms/naive_sort
assert_eq 'ask -n: código' '0' "$rc_last"
assert_contains 'ask -n: el modelo en el plan' 'COPILOT_MODEL=gemini-3.8-flash' "$out"

# sin modelo en la plantilla y con un modelo que el catálogo no conoce: los dos son un
# dato que falta (1), y en ningún caso se inventan esfuerzo ni créditos
fake_glot="$WORK_DIR/glot-sin-perfil"
mkdir -p -- "$fake_glot/prompts"
cp -- "$GLOT_SH" "$fake_glot/glot.sh"
cp -R -- "$TESTS_DIR/../data" "$fake_glot/data"
cp -R -- "$PROMPTS_DIR/." "$fake_glot/prompts/"

sed -i '/^profile: /d' "$fake_glot/prompts/suite.prompt.md"
out="$(GLOT_ROOT="$SANDBOX" GLOT_DELEGATE='cat >/dev/null' "$fake_glot/glot.sh" ask suite php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'plantilla sin modelo: código' '1' "$rc_last"
assert_contains 'plantilla sin modelo: lo dice' 'no declara perfil' "$(cat -- "$WORK_DIR/stderr")"

sed -i '/^step: /a profile: modelo-que-no-existe' "$fake_glot/prompts/suite.prompt.md"
out="$(GLOT_ROOT="$SANDBOX" GLOT_DELEGATE='cat >/dev/null' "$fake_glot/glot.sh" ask suite php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'modelo fuera del catálogo: código' '1' "$rc_last"
assert_contains 'modelo fuera del catálogo: lo dice' 'sin perfil en el catálogo' "$(cat -- "$WORK_DIR/stderr")"

sed -i 's/^profile: .*/profile: deep/' "$fake_glot/prompts/suite.prompt.md"
printf 'malformed\n' >>"$fake_glot/data/model_options.tsv"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_DELEGATE=cat "$fake_glot/glot.sh" -n ask suite php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'adaptador malformado: no se delega' '1' "$rc_last"
assert_contains 'adaptador malformado: diagnóstico explícito' 'invalid model adapters' "$(cat -- "$WORK_DIR/stderr")"

# doctor informa de la cobertura del catálogo y del envejecimiento contra el CLI
glot_run doctor
assert_contains 'doctor: catálogo de modelos' 'models_file: ' "$out"
assert_contains 'doctor: cobertura de perfiles' 'model_profiles: 11 de / of 11' "$out"
if command -v copilot >/dev/null 2>&1; then
    cli_models="$(copilot help config 2>/dev/null || true)"
    available=0
    while IFS=$'\t' read -r _ model _rest; do
        # los ids de OpenRouter no están en el catálogo del CLI: los sirve el proveedor propio
        [[ "$model" == */* ]] && continue
        [[ "$cli_models" == *"\"$model\""* ]] && available=$((available + 1))
    done <"$MODELS_TSV"
    assert_contains 'doctor: informa disponibilidad real sin confundir IDE y CLI' \
        "model_available: $available de / of 3" "$out"
fi

# --- casos de la especificación v0.12.0 (L7, higiene y punteros) --------------

# El sandbox nace sin monorepo: hasta L7 ningún verbo necesitaba un gitlink. Aquí se
# crea el commit base con `.gitmodules` y el puntero de `php` (un gitlink de verdad), la
# rama `main` y un remoto, que es lo que `pointer` publica.
git -C "$SANDBOX" config user.email 'glot@test'
git -C "$SANDBOX" config user.name 'glot test'
printf 'remote/\n' >"$SANDBOX/.gitignore"
git -C "$SANDBOX" add -A 2>/dev/null
git -C "$SANDBOX" update-index --add --cacheinfo "160000,$(git -C "$SANDBOX/php" rev-parse HEAD),php"
git -C "$SANDBOX" commit -q -m 'chore: monorepo base'
git -C "$SANDBOX" branch -M main
git init -q --bare "$SANDBOX/remote/repo.git"
git -C "$SANDBOX/remote/repo.git" symbolic-ref HEAD refs/heads/main
git -C "$SANDBOX" remote add origin "$SANDBOX/remote/repo.git"
git -C "$SANDBOX" push -q -u origin main

# status: una línea por lenguaje registrado, solo lectura
glot_run_sandbox status
assert_eq 'status: código' '0' "$rc_last"
assert_eq 'status: cuatro columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=4')"
assert_eq 'status: un lenguaje limpio está `ok` y `clean`' 'php main ok clean' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$1 == "php" {print $1, $2, $3, $4}')"

# un commit en el submódulo que el monorepo todavía no apunta, y un fichero sin confirmar
printf '# work\n' >"$SANDBOX/php/core/algorithms/notas.md"
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'feat(algorithms): add notes'
glot_run_sandbox status php
assert_contains 'status: el puntero que no coincide se ve' "$(printf 'php\tmain\tdiffers\tclean')" "$out"

# con el árbol del submódulo sucio, además se ve
printf '# wip\n' >"$SANDBOX/php/core/algorithms/wip.md"
glot_run_sandbox status php
assert_contains 'status: el árbol sucio se ve' "$(printf 'differs\tdirty')" "$out"
rm -f -- "$SANDBOX/php/core/algorithms/wip.md"

# el submódulo apunta a un commit que el monorepo ya registra: `ok`
git -C "$SANDBOX" add -- php
git -C "$SANDBOX" commit -q -m 'chore(submodule): update php pointer'
glot_run_sandbox status php
assert_contains 'status: puntero al día' "$(printf 'ok\t')" "$out"

# submódulo registrado sin clonar: no hay rama ni árbol que mirar
printf '[submodule "zig"]\n\tpath = zig\n\turl = ../remote/zig.git\n' >>"$SANDBOX/.gitmodules"
glot_run_sandbox status zig
assert_contains 'status: submódulo sin inicializar' "$(printf 'zig\t-\tuninitialised\t-')" "$out"
git -C "$SANDBOX" checkout -q -- .gitmodules

glot_run_sandbox status nope
assert_eq 'status de un lenguaje no registrado: código' '1' "$rc_last"

# status no muta nada: ni el gitlink, ni la rama, ni el árbol
before="$(git -C "$SANDBOX/php" rev-parse HEAD)$(git -C "$SANDBOX" symbolic-ref --short HEAD)"
glot_run_sandbox status
after="$(git -C "$SANDBOX/php" rev-parse HEAD)$(git -C "$SANDBOX" symbolic-ref --short HEAD)"
assert_eq 'status: no muta nada' "$before" "$after"

# clean: borra lo que el propio .gitignore declara y nada más
mkdir -p -- "$SANDBOX/php/core/algorithms/naive_sort/vendor"
printf 'vendor/\n' >"$SANDBOX/php/core/algorithms/naive_sort/.gitignore"
printf 'x\n' >"$SANDBOX/php/core/algorithms/naive_sort/vendor/lib.txt"
printf 'sin ignorar\n' >"$SANDBOX/php/core/algorithms/naive_sort/nota.txt"
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'chore(algorithms): add module skeleton'

glot_run_sandbox -n clean php algorithms/naive_sort
assert_eq 'clean -n: código' '0' "$rc_last"
assert_contains 'clean -n: el borrado' 'clean -Xfd' "$out"
assert_contains 'clean -n: la sincronización' 'submodule sync' "$out"
assert_eq 'clean -n: no borra nada' 'si' "$([[ -f "$SANDBOX/php/core/algorithms/naive_sort/vendor/lib.txt" ]] && echo si || echo no)"

glot_run_sandbox clean php algorithms/naive_sort
assert_eq 'clean: código' '0' "$rc_last"
assert_eq 'clean: borra lo ignorado' 'no' "$([[ -e "$SANDBOX/php/core/algorithms/naive_sort/vendor" ]] && echo si || echo no)"
assert_eq 'clean: respeta lo no ignorado' 'si' "$([[ -f "$SANDBOX/php/core/algorithms/naive_sort/nota.txt" ]] && echo si || echo no)"
assert_contains 'clean: stdout lleva lo borrado' 'vendor' "$out"

glot_run_sandbox clean php algorithms/naive_sort
assert_eq 'clean sin artefactos: dato' 'nothing' "$out"
assert_eq 'clean sin artefactos: código' '0' "$rc_last"

# pointer: la regla de CONTRIBUTING.md como comprobación, no como prosa
git -C "$SANDBOX/php" switch -q -c feat/algorithms/pointer-test
printf '# branch\n' >>"$SANDBOX/php/README.md"
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'feat: branch work'
glot_run_sandbox pointer php algorithms/naive_sort
assert_eq 'pointer con rama de trabajo: código' '1' "$rc_last"
assert_contains 'pointer con rama de trabajo: lo dice' 'no se apunta a una rama de trabajo' "$err"

# integrado pero sin publicar: el HEAD no es el de origin/main
git -C "$SANDBOX/php" switch -q main
glot_run_sandbox pointer php algorithms/naive_sort
assert_eq 'pointer sin publicar: código' '1' "$rc_last"
assert_contains 'pointer sin publicar: lo dice' 'no es el de origin/main' "$err"

# v1.3.0: `pointer` añade el gitlink **en la rama activa**, sin abrir ni publicar rama
# propia: el puntero pertenece al cierre en curso (medido el 2026-09-26: el paso 8 abría
# otra rama con el sprint a medias)
git -C "$SANDBOX/php" push -q origin main
monorepo_before="$(git -C "$SANDBOX" rev-parse HEAD)"
monorepo_branch_before="$(git -C "$SANDBOX" symbolic-ref --short HEAD)"
glot_run_sandbox pointer php algorithms/naive_sort
assert_eq 'pointer: código' '0' "$rc_last"
assert_eq 'pointer: stdout es el SHA corto del submódulo' "$(git -C "$SANDBOX/php" rev-parse --short HEAD)" "$out"
assert_eq 'pointer: no cambia la rama del monorepo' "$monorepo_branch_before" "$(git -C "$SANDBOX" symbolic-ref --short HEAD)"
assert_eq 'pointer: no publica rama propia' 'no' \
    "$(git -C "$SANDBOX/remote/repo.git" show-ref --verify --quiet refs/heads/chore/algorithms/naive-sort-pointer && echo si || echo no)"
assert_eq 'pointer: deja el gitlink preparado' 'si' \
    "$(git -C "$SANDBOX" diff --cached --name-only | grep -qx 'php' && echo si || echo no)"
assert_contains 'pointer: el gitlink queda añadido' 'php' "$(git -C "$SANDBOX" diff --cached --name-only)"
assert_eq 'pointer: no confirma el monorepo' "$monorepo_before" "$(git -C "$SANDBOX" rev-parse HEAD)"
assert_contains 'pointer: dice el siguiente paso' 'glot save 9' "$err"

# pointer -n no toca nada
git -C "$SANDBOX" reset -q
monorepo_before="$(git -C "$SANDBOX" rev-parse HEAD)"
glot_run_sandbox -n pointer php algorithms/naive_sort
assert_eq 'pointer -n: código' '0' "$rc_last"
assert_eq 'pointer -n: no toca el monorepo' "$monorepo_before" "$(git -C "$SANDBOX" rev-parse HEAD)"

# save 9: el commit del monorepo lo confirma `save`, con el mensaje del catálogo
git -C "$SANDBOX" add -- php
glot_run_sandbox save 9 php algorithms/naive_sort
assert_eq 'save 9: código' '0' "$rc_last"
assert_eq 'save 9: asunto del commit' 'chore(submodule): update php pointer' \
    "$(git -C "$SANDBOX" log -1 --pretty=%s)"
assert_eq 'save 9: solo el submódulo en el commit' 'php' "$(git -C "$SANDBOX" show --pretty=format: --name-only HEAD)"
assert_contains 'save 9: sin push' 'no push' "$err"

# v1.3.0: `pointer` no cambia de rama, así que **no** bloquea por trabajo sin confirmar:
# prepara el gitlink en la rama activa y `save 9` decide qué entra (antes sí bloqueaba,
# porque abría rama propia). Aquí el puntero ya apunta al commit, así que es idempotente.
git -C "$SANDBOX" reset -q
printf 'nota\n' >"$SANDBOX/docs/nota-suelta.md"
monorepo_before="$(git -C "$SANDBOX" rev-parse HEAD)"
glot_run_sandbox pointer php algorithms/naive_sort
assert_eq 'pointer con trabajo sin confirmar: no bloquea' '0' "$rc_last"
assert_eq 'pointer con trabajo sin confirmar: idempotente' 'nothing' "$out"
assert_eq 'pointer con trabajo sin confirmar: no toca el monorepo' "$monorepo_before" "$(git -C "$SANDBOX" rev-parse HEAD)"
rm -f -- "$SANDBOX/docs/nota-suelta.md"

# save 10: el cierre añade el roadmap, el checklist y la evidencia de ese módulo
rm -rf -- "$SANDBOX/docs/evidence/algorithms/naive_sort"
mkdir -p -- "$SANDBOX/docs/evidence/algorithms/naive_sort"
printf '# evidencia\n' >"$SANDBOX/docs/evidence/algorithms/naive_sort/ruby.md"
printf '# roadmap\n' >"$SANDBOX/docs/ROADMAP.md"
printf '# checklist\n' >"$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md"
glot_run_sandbox save 10 ruby algorithms/naive_sort
assert_eq 'save 10: código' '0' "$rc_last"
assert_eq 'save 10: asunto del commit' 'docs(roadmap): close algorithms/naive_sort for ruby' \
    "$(git -C "$SANDBOX" log -1 --pretty=%s)"
staged="$(git -C "$SANDBOX" show --pretty=format: --name-only HEAD)"
assert_contains 'save 10: el roadmap entra' 'docs/ROADMAP.md' "$staged"
assert_contains 'save 10: el checklist entra' 'docs/ROADMAP_UPDATE_CHECKLIST.md' "$staged"
assert_contains 'save 10: la evidencia del módulo entra' 'docs/evidence/algorithms/naive_sort/ruby.md' "$staged"
assert_contains 'save 10: nada de fuera del cierre' 'no' "$(case "$staged" in *php/core/*) echo si ;; *) echo no ;; esac)"

glot_run_sandbox save 10 ruby algorithms/naive_sort
assert_eq 'save 10 sin cambios: dato' 'nothing' "$out"
assert_eq 'save 10 sin cambios: código' '0' "$rc_last"

# v1.6.2/v1.7.0: `finish` limpia el estado del sprint al terminar (salvo las dos claves de
# modelo del delegado), y en ensayo solo lo anuncia. Se prepara php para el cierre —módulo y
# fase documentados, evidencia en verde y su línea en el roadmap— y el almacén va aparte para
# no alterar el del resto de los casos.
FINISH_STATE="$WORK_DIR/state-finish"
glot_run_finish() {
    local rc=0
    out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}
cat >"$SANDBOX/stub/composer" <<'STUB'
#!/usr/bin/env bash
printf 'stub composer: %s\n' "$*"
exit "${STUB_TEST_EXIT:-0}"
STUB
cat >"$SANDBOX/stub/php" <<'STUB'
#!/usr/bin/env bash
printf 'stub php: %s\n' "$*"
exit "${STUB_VERIFY_EXIT:-0}"
STUB
chmod +x -- "$SANDBOX/stub/composer" "$SANDBOX/stub/php"
printf '# naive sort (php)\n' >"$SANDBOX/php/core/algorithms/naive_sort/README.md"
printf '# algorithms (php)\n' >"$SANDBOX/php/core/algorithms/README.md"
printf 'core.algorithms.naive_sort            pending 1/50 (Ada)\n' >"$SANDBOX/docs/ROADMAP.md"
printf '# Registro de cierre\n' >"$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md"
# los README van confirmados y publicados dentro del submódulo: `pointer` solo apunta a un
# commit que está en `origin/main`, y con el submódulo sucio `save 9` no tendría nada que
# confirmar y el cierre se quedaría a medias
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'docs(algorithms): add module README'
git -C "$SANDBOX/php" push -q origin main
glot_run_evidence php algorithms/naive_sort
assert_eq 'finish: la evidencia de php sale en verde' '0' "$rc_last"

glot_run_finish set lang php
glot_run_finish set phase algorithms
glot_run_finish set module naive_sort
glot_run_finish set branch main
assert_eq 'finish: el sprint está asignado' 'php' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" get lang)"
glot_run_finish set antigravity-model gemini
glot_run_finish set copilot-model default

glot_run_finish finish php algorithms/naive_sort
assert_eq 'finish: código' '0' "$rc_last"
assert_contains 'finish: lo dice' 'estado del sprint limpiado' "$err"
assert_eq 'finish: el sprint se ha ido' '1' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" get lang >/dev/null 2>&1; echo $?)"
assert_eq 'finish: el modelo de AGY se queda' 'gemini' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" get antigravity-model)"
assert_eq 'finish: el modelo de Copilot se queda' 'gemini-3.8-flash' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" get copilot-model)"
glot_run_finish save 4a
assert_eq 'finish sin estado: hay que asignarlo otra vez' '1' "$rc_last"
assert_contains 'finish sin estado: lo dice' 'glot use' "$err"

# en ensayo se anuncia la limpieza sin hacerla. Con el puntero ya al día y el módulo cerrado,
# los cuatro pasos pasan en ensayo y el estado sigue ahí (si el puntero tuviera que moverse,
# `close` no podría validarlo: el ensayo no lo prepara de verdad)
glot_run_finish set lang php
glot_run_finish set phase algorithms
glot_run_finish set module naive_sort
glot_run_finish -n finish php algorithms/naive_sort
assert_eq 'finish -n: código' '0' "$rc_last"
assert_contains 'finish -n: anuncia la limpieza' 'estado del sprint limpiado' "$out"
assert_eq 'finish -n: no limpia' 'php' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$FINISH_STATE" "$GLOT_SH" get lang)"

# v1.5.0: `pointer` no puede tapar que la rama del sprint **no** está integrada. Se monta el
# caso peligroso —volver a `main` sin fusionar, que es lo que decía el mensaje viejo— y se
# comprueba que frena en vez de responder `nothing`. Medido el 2026-09-28 en el laboratorio:
# seguir aquel mensaje al pie de la letra dejaba los seis commits del módulo fuera del
# puntero, en silencio, porque `main` seguía siendo el de `origin/main`.
state_branch_before="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" get branch 2>/dev/null || true)"
state_lang_before="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" get lang 2>/dev/null || true)"
state_phase_before="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" get phase 2>/dev/null || true)"
state_module_before="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" get module 2>/dev/null || true)"
git -C "$SANDBOX/php" switch -q -c feat/algorithms/sprint-lost main
printf '# trabajo del sprint\n' >>"$SANDBOX/php/README.md"
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'feat(algorithms): sprint work'
git -C "$SANDBOX/php" switch -q main
glot_run_sandbox set lang php
glot_run_sandbox set phase algorithms
glot_run_sandbox set module naive_sort
glot_run_sandbox set branch feat/algorithms/sprint-lost
glot_run_sandbox pointer php algorithms/naive_sort
assert_eq 'pointer con la rama del sprint sin integrar: código' '1' "$rc_last"
assert_contains 'pointer con la rama del sprint sin integrar: lo dice' 'tiene trabajo que main no tiene' "$err"
assert_contains 'pointer con la rama del sprint sin integrar: da el merge' 'merge --no-ff feat/algorithms/sprint-lost' "$err"
glot_run_sandbox set branch "${state_branch_before:-main}"
if [[ -n "$state_lang_before" ]]; then glot_run_sandbox set lang "$state_lang_before"; fi
if [[ -n "$state_phase_before" ]]; then glot_run_sandbox set phase "$state_phase_before"; fi
if [[ -n "$state_module_before" ]]; then glot_run_sandbox set module "$state_module_before"; fi
git -C "$SANDBOX/php" branch -q -D feat/algorithms/sprint-lost

# v1.5.0: `close` exige que el puntero del monorepo apunte al commit **integrado** del
# submódulo. El paso 8 (índices del lenguaje) se confirma **dentro** del submódulo y puede ir
# después del `pointer`: entonces el puntero se queda atrás y cerrar registraría un commit
# que no es el apuntado (medido el 2026-09-28 en el laboratorio: `status` decía `differs` y
# `close` cerraba igual, con el módulo «cerrado» apuntando a un commit anterior).
printf 'core.algorithms.naive_sort            pending 1/2 (Ada)\n' >"$SANDBOX/docs/ROADMAP.md"
printf '# Registro de cierre\n' >"$SANDBOX/docs/ROADMAP_UPDATE_CHECKLIST.md"
printf '# índices del lenguaje\n' >>"$SANDBOX/php/README.md"
git -C "$SANDBOX/php" add -A
git -C "$SANDBOX/php" commit -q -m 'docs: add README for algorithms and update indexes'
glot_run_sandbox close php algorithms/naive_sort
assert_eq 'close con el puntero obsoleto: código' '1' "$rc_last"
assert_contains 'close con el puntero obsoleto: lo dice' 'no apunta al submódulo' "$err"
assert_contains 'close con el puntero obsoleto: nombra los dos commits' 'y el puntero en ' "$err"
assert_contains 'close con el puntero obsoleto: da el remedio' 'glot pointer php algorithms/naive_sort' "$err"
assert_contains 'close con el puntero obsoleto: no toca el roadmap' 'pending 1/2 (Ada)' "$(cat -- "$SANDBOX/docs/ROADMAP.md")"

# v1.3.0: una línea del bloque de contadores con el id **pegado** a la marca desaparecía del
# catálogo **en silencio**. Medido el 2026-09-27: `core.algorithms.data_structures_basics🔄 3/50`
# en el roadmap real hizo que `glot modules`, `glot use` y `progress` dejasen de ofrecer el
# módulo, sin un solo aviso. El catálogo ahora nombra la línea que no entiende.
sandbox_make
mkdir -p -- "$SANDBOX/docs"
printf 'core.algorithms.naive_sort \xe2\x9c\x85 1/50 (Ada)\n' >"$SANDBOX/docs/ROADMAP.md"
printf 'core.algorithms.data_structures_basics\xf0\x9f\x94\x84 3/50 (Ada, Assembly)\n' >>"$SANDBOX/docs/ROADMAP.md"
glot_run_sandbox modules
assert_contains 'roadmap: avisa de la línea con el id pegado a la marca' 'unreadable roadmap line' "$err"
assert_eq 'roadmap: el módulo ilegible no se inventa' 'no' \
    "$([[ "$out" == *'data_structures_basics'* ]] && echo si || echo no)"
assert_contains 'roadmap: el módulo legible sí entra' 'naive_sort' "$out"
printf 'core.algorithms.data_structures_basics \xf0\x9f\x94\x84 3/50 (Ada, Assembly)\n' >"$SANDBOX/docs/ROADMAP.md.tmp"
head -1 "$SANDBOX/docs/ROADMAP.md" >"$SANDBOX/docs/ROADMAP.md"
cat "$SANDBOX/docs/ROADMAP.md.tmp" >>"$SANDBOX/docs/ROADMAP.md"
rm -f -- "$SANDBOX/docs/ROADMAP.md.tmp"
glot_run_sandbox modules
assert_contains 'roadmap: con el espacio, el módulo vuelve al catálogo' 'data_structures_basics' "$out"
assert_eq 'roadmap: y ya no avisa' 'no' "$([[ "$err" == *'unreadable'* ]] && echo si || echo no)"

# y `close` no puede volver a pegar la marca: el separador va **dentro** del relleno, porque
# con un id de 38 caracteres o más (`core.algorithms.data_structures_basics` mide 38 exactos)
# `%-38s` no añade nada y la marca quedaba pegada al id
assert_eq 'close: el id y la marca nunca se pegan' '0' \
    "$(grep -c "printf '%-38s%s'" "$GLOT_SH" | tr -d ' ')"

# la ayuda: los tres verbos nuevos están en el listado y tienen ayuda propia
glot_run help
assert_eq 'help: los tres verbos de L7 en el listado general' '3' \
    "$(printf '%s\n' "$out" | grep -cE '^  (status|pointer|clean)')"
for l7_verb in status pointer clean; do
    glot_run help "$l7_verb"
    assert_eq "help $l7_verb: código" '0' "$rc_last"
    assert_contains "help $l7_verb: se describe" "$l7_verb" "$out"
done

# --- casos de la especificación v1.0.0 (L8, capa cargable) --------------------

# glot_loaded <snippet> — ejecuta el snippet en un bash limpio, con el script en `$1` y la
# raíz del sandbox en `$2`, para probar el modo cargado sin depender de la shell del harness.
glot_loaded() {
    local rc=0
    out="$(env -u GLOT_ROOT "$BASH" -c "$1" _ "$GLOT_SH" "$SANDBOX" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

glot_loaded 'source "$1"'
assert_eq 'cargado: no ejecuta nada' '' "$out"
assert_eq 'cargado: código' '0' "$rc_last"

glot_loaded 'source "$1"; type -t glot'
assert_eq 'cargado: define la función glot' 'function' "$out"

glot_loaded 'before="$(set -o | tr -d " \t")"; source "$1"; after="$(set -o | tr -d " \t")"; [[ "$before" == "$after" ]] && echo igual || echo distinto'
assert_eq 'cargado: no toca las opciones del shell' 'igual' "$out"

glot_loaded 'source "$1"; echo vivo'
assert_contains 'cargado: no llama a exit' 'vivo' "$out"

glot_loaded 'source "$1"; glot version'
assert_eq 'cargado: version' "glot $LIVE_VERSION" "$out"

out_program="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" langs)"
glot_loaded 'source "$1"; GLOT_ROOT="$2" glot langs'
assert_eq 'cargado: los otros verbos pasan igual que el programa' "$out_program" "$out"

# los `cd` reales son el único comportamiento que cambia al cargar el archivo: el ciclo
# **te lleva donde toca** (v1.6.2) —`use` a la fase, `new` al módulo y `save 7`/`8` a la
# raíz del lenguaje, porque la carpeta del módulo no existe en el `main` del submódulo—
printf '# 06 — Data Structures Basics\n' >"$SANDBOX/docs/core/algorithms/06_Data_Structures_Basics.md"
glot_loaded 'source "$1"; cd /tmp; GLOT_ROOT="$2" glot use php algorithms/data_structures_basics >/dev/null; pwd'
assert_eq 'cargado: use deja en la carpeta de la fase' "$SANDBOX/php/core/algorithms" "$out"
assert_eq 'cargado: sin recordatorio de cd, que ya lo hizo la función' 'no' \
    "$([[ "$err" == *'recuerda / remember'* ]] && echo si || echo no)"

glot_loaded 'source "$1"; cd /tmp; GLOT_ROOT="$2" glot use java algorithms/naive_sort >/dev/null; GLOT_ROOT="$2" glot new java algorithms/naive_sort >/dev/null; pwd'
assert_eq 'cargado: new baja al directorio del módulo' "$SANDBOX/java/core/algorithms/naive_sort" "$out"

printf 'x\n' >"$SANDBOX/php/core/algorithms/data_structures_basics/README.md"
glot_loaded 'source "$1"; cd "$2/php/core/algorithms/data_structures_basics"; GLOT_ROOT="$2" glot save 7 php algorithms/data_structures_basics >/dev/null; pwd'
assert_eq 'cargado: save 7 deja en la raíz del lenguaje' "$SANDBOX/php" "$out"

glot_loaded 'source "$1"; cd /tmp; GLOT_ROOT="$2" glot -n use php algorithms/data_structures_basics >/dev/null; pwd'
assert_eq 'cargado: use -n no cambia de directorio' '/tmp' "$out"

glot_loaded 'source "$1"; cd "$2/php/core/algorithms"; GLOT_ROOT="$2" glot -n new php algorithms/data_structures_basics >/dev/null; pwd'
assert_eq 'cargado: new -n no cambia de directorio' "$SANDBOX/php/core/algorithms" "$out"

glot_loaded 'source "$1"; cd "$2/php/core/algorithms/data_structures_basics"; GLOT_ROOT="$2" glot -n save 7 php algorithms/data_structures_basics >/dev/null; pwd'
assert_eq 'cargado: save -n 7 no cambia de directorio' "$SANDBOX/php/core/algorithms/data_structures_basics" "$out"

glot_loaded 'source "$1"; cd /tmp; GLOT_ROOT="$2" glot use 2>/dev/null; echo "vivo"'
assert_contains 'cargado: un use fallido no deja la shell rota' 'vivo' "$out"

# v1.6.2/v1.7.0: `glot finish` limpia el estado del sprint al terminar, para no seguir trabajando
# sobre una rama y un directorio finalizados (el `finish` completo va más abajo, con el
# sandbox). Aquí se prueba la limpieza sola, con un almacén propio para no alterar el del
# resto de los casos: se van las claves del sprint —y no otras— y las claves de modelo del
# delegado se quedan.
STATE_CLEAR="$WORK_DIR/state-clear"
for kv in lang=php phase=algorithms module=naive_sort branch=feat/algorithms/x \
    spec=spec.md target=monorepo cause=fix antigravity-model=gemini copilot-model=default open-router-model=default zap=1; do
    GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" set "${kv%%=*}" "${kv#*=}" >/dev/null 2>&1
done
assert_eq 'estado del sprint: el almacén de prueba está montado' 'php' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get lang)"

glot_loaded "source \"\$1\"; GLOT_STATE_FILE='$STATE_CLEAR'; _glot_sprint_clear"
assert_eq 'finish: la limpieza no falla' '0' "$rc_last"
assert_eq 'finish: el sprint se ha ido' 'si' \
    "$(grep -qE '^(lang|phase|module|branch|spec|repo|target|cause)=' "$STATE_CLEAR" && echo no || echo si)"
assert_eq 'finish: el modelo de AGY se queda' 'gemini' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get antigravity-model)"
assert_eq 'finish: el modelo de Copilot se queda' 'gemini-3.8-flash' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get copilot-model)"
assert_eq 'finish: las claves del autor se quedan' '1' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get zap)"

# el cierre se puede reejecutar: limpiar dos veces no falla
glot_loaded "source \"\$1\"; GLOT_STATE_FILE='$STATE_CLEAR'; _glot_sprint_clear"
assert_eq 'finish: repetir la limpieza' '0' "$rc_last"

# el modo programa sí recuerda el `cd`: es el único caso en que hace falta
out="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" use php algorithms/data_structures_basics 2>"$WORK_DIR/stderr")" || true
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'programa: el recordatorio del cd menciona glot install' 'glot install' "$err"

# estado por raíz de monorepo (v1.0.0): dos repos no comparten `lang/phase/module`
STATE_DIR_V1="$WORK_DIR/state-v1"
mkdir -p -- "$STATE_DIR_V1"
mkdir -p -- "$WORK_DIR/otro"
git -C "$WORK_DIR/otro" init -q

# glot_run_state <raíz> [args...] — ejecuta glot sin GLOT_STATE_FILE, con estado por raíz
glot_run_state() {
    local rc=0
    out="$(env -u GLOT_STATE_FILE -u GLOT_ROOT GLOT_ROOT="$1" GLOT_STATE_DIR="$STATE_DIR_V1" "$GLOT_SH" "${@:2}" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

glot_run_state "$SANDBOX" path
assert_eq 'estado por raíz: código' '0' "$rc_last"
assert_eq 'estado por raíz: el fichero lleva la raíz en el nombre' "$STATE_DIR_V1/glot/state.$(printf '%s' "$SANDBOX" | cksum | awk '{printf "%08d", $1}')-sandbox" "$out"
assert_eq 'estado por raíz: no es el global' 'no' "$(case "$out" in */glot/state) echo si ;; *) echo no ;; esac)"

glot_run_state "$SANDBOX" path
same="$out"
glot_run_state "$SANDBOX" path
assert_eq 'estado por raíz: la misma raíz da el mismo fichero' "$same" "$out"

glot_run_state "$WORK_DIR/otro" path
other="$out"
glot_run_state "$SANDBOX" path
assert_eq 'estado por raíz: dos raíces, dos ficheros' 'distintos' \
    "$([[ "$other" != "$out" ]] && echo distintos || echo iguales)"

# el aislamiento de verdad: lo que se guarda en un monorepo no se ve en el otro
glot_run_state "$SANDBOX" set lang php
assert_eq 'estado por raíz: set en la raíz A' '0' "$rc_last"
glot_run_state "$SANDBOX" get lang
assert_eq 'estado por raíz: get en la raíz A' 'php' "$out"
glot_run_state "$WORK_DIR/otro" get lang
assert_eq 'estado por raíz: la raíz B no ve el sprint de A' '1' "$rc_last"

# GLOT_STATE_FILE sigue mandando sobre todo lo anterior
out="$(GLOT_STATE_FILE="$WORK_DIR/state" "$GLOT_SH" path)"
assert_eq 'estado: GLOT_STATE_FILE manda' "$WORK_DIR/state" "$out"

# sin raíz (fuera de un repositorio) se conserva el fichero global de antes
out="$(cd -- "$WORK_DIR" && env -u GLOT_STATE_FILE -u GLOT_ROOT GLOT_STATE_DIR="$STATE_DIR_V1" "$GLOT_SH" path)"
assert_eq 'estado: fuera de un repositorio, el global' "$STATE_DIR_V1/glot/state" "$out"

# el `state` global viejo se avisa una vez y no se migra
mkdir -p -- "$STATE_DIR_V1/glot"
printf 'lang=php\n' >"$STATE_DIR_V1/glot/state"
glot_run_state "$SANDBOX" path
assert_contains 'estado viejo: avisa la primera vez' 'no se migra' "$err"
glot_run_state "$SANDBOX" path
assert_eq 'estado viejo: la segunda vez ya no avisa' '' "$err"

glot_run_state "$SANDBOX" doctor
assert_contains 'doctor: la raíz del estado' 'state_root: ' "$out"
assert_contains 'doctor: el estado viejo se nombra' 'state_legacy: ' "$out"

# instalación y capa cargable (v1.0.0): copia estable, enlace, completados y rc.
# Todo ocurre en un HOME desechable: la instalación real del usuario no se toca.
INSTALL_HOME="$WORK_DIR/home-install"
mkdir -p -- "$INSTALL_HOME"
INSTALL_DIR="$INSTALL_HOME/.local/share/glot"

# glot_install [args...] — ejecuta glot con HOME desechable, sin estado ni raíz
glot_install() {
    local rc=0
    out="$(env -u GLOT_STATE_FILE -u GLOT_ROOT GLOT_ROOT= HOME="$INSTALL_HOME" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# glot_in_home <código> — ejecuta código en un bash real con ese HOME desechable
glot_in_home() {
    local rc=0
    # El HOME desechable se aísla también del PATH del usuario: con una instalación
    # real de `glot` en el PATH, `type -t glot` encontraría su ejecutable en vez de
    # decir que ya no queda la función tras el desinstalado.
    out="$(HOME="$INSTALL_HOME" PATH="/usr/local/bin:/usr/bin:/bin" bash -c "$1" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

glot_install -n install
assert_eq 'install -n: código' '0' "$rc_last"
assert_contains 'install -n: enseña el plan' 'cp ' "$out"
assert_contains 'install -n: enseña la copia estable' "$INSTALL_DIR" "$out"
assert_contains 'install -n: enseña el bloque del rc' '.bashrc' "$out"
assert_eq 'install -n: no crea nada' 'no' "$([[ -e "$INSTALL_DIR" ]] && echo si || echo no)"

glot_install install
assert_eq 'install: código' '0' "$rc_last"
assert_eq 'install: stdout con una sola línea' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'install: la copia estable es la ruta que sale' "$INSTALL_DIR" "$out"
assert_eq 'install: el script copiado existe' 'si' "$([[ -x "$INSTALL_DIR/glot.sh" ]] && echo si || echo no)"
assert_eq 'install: los datos viajan con el script' 'si' "$([[ -d "$INSTALL_DIR/data" ]] && echo si || echo no)"
assert_eq 'install: la política viaja con el script' 'si' "$([[ -s "$INSTALL_DIR/prompts/Delegation_Policy.md" ]] && echo si || echo no)"
glot_in_home '"$HOME/.local/bin/glot" prompt suite php algorithms/naive_sort'
assert_eq 'install: encargo con política funciona' '0' "$rc_last"
assert_contains 'install: encargo incluye política' '# Política compartida de delegación' "$out"
assert_eq 'install: el enlace del PATH apunta a la copia' "$INSTALL_DIR/glot.sh" "$(readlink -- "$INSTALL_HOME/.local/bin/glot")"
assert_eq 'install: los metadatos traen la versión' "version=$LIVE_VERSION" \
    "$(sed -n 's/^version=/version=/p' "$INSTALL_DIR/install.meta")"
assert_contains 'install: los metadatos traen el origen' 'source=' "$(cat -- "$INSTALL_DIR/install.meta")"
assert_contains 'install: el bloque del rc lleva marca de inicio' '# >>> glot (install) >>>' "$(cat -- "$INSTALL_HOME/.bashrc")"
assert_contains 'install: el bloque del rc lleva marca de fin' '# <<< glot (install) <<<' "$(cat -- "$INSTALL_HOME/.bashrc")"
assert_eq 'install: el completado de bash queda instalado' 'si' \
    "$([[ -r "$INSTALL_HOME/.local/share/bash-completion/completions/glot" ]] && echo si || echo no)"
assert_eq 'install: el completado de zsh queda instalado' 'si' \
    "$([[ -r "$INSTALL_HOME/.zsh/completions/_glot" ]] && echo si || echo no)"

# idempotente: repetirlo deja lo mismo, con un solo bloque
glot_install install
assert_eq 'install: repetido, código' '0' "$rc_last"
assert_eq 'install: repetido, un solo bloque' '1' "$(grep -c '# >>> glot (install) >>>' "$INSTALL_HOME/.bashrc")"

# instalar desde la copia instalada no es una actualización: se dice de dónde va
# (la trampa que aparece al querer actualizar la copia desde el propio `glot` instalado)
glot_in_home '"$HOME/.local/share/glot/glot.sh" install; echo "rc=$?"'
assert_eq 'install desde la copia: código' 'rc=1' "$out"
assert_contains 'install desde la copia: dice desde dónde' 'lanza install desde el clon' "$err"

# la copia estable funciona sola, aunque el clon se mueva o desaparezca
glot_in_home '"$HOME/.local/bin/glot" version'
assert_eq 'install: la copia del PATH funciona sola' "glot $LIVE_VERSION" "$out"

# el bloque del rc carga la capa en un bash real: hay función y el cd de use llega
glot_in_home 'source "$HOME/.bashrc"; echo "tipo=$(type -t glot)"; glot version'
assert_contains 'install: el rc deja la función cargada' 'tipo=function' "$out"
assert_contains 'install: la capa cargada responde version' "glot $LIVE_VERSION" "$out"
glot_in_home 'source "$HOME/.bashrc"; glot doctor 2>/dev/null | grep "^shell_loaded"'
assert_contains 'install: la capa cargada se anuncia a doctor' 'shell_loaded: yes' "$out"

# doctor desde el programa: dice dónde está la copia, si es vieja y qué shells hay
glot_install doctor
assert_contains 'doctor: la instalación' "install: yes ($INSTALL_DIR)" "$out"
assert_contains 'doctor: la versión instalada' "install_version: $LIVE_VERSION" "$out"
assert_contains 'doctor: la copia no está vieja' 'install_stale: no' "$out"
assert_contains 'doctor: el bloque del rc está' 'install_rc: bash:yes' "$out"
assert_contains 'doctor: las shells se listan' 'shell: ' "$out"
assert_contains 'doctor: sin capa cargada lo dice' 'shell_loaded: no' "$out"

# la copia retocada a mano cuenta como vieja, y reinstalar la deja buena
printf '\n# retoque local / local tweak\n' >>"$INSTALL_DIR/glot.sh"
glot_install doctor
assert_contains 'doctor: una copia retocada se marca vieja' 'install_stale: yes' "$out"
glot_install install >/dev/null
glot_install doctor
assert_contains 'doctor: reinstalar deja la copia buena' 'install_stale: no' "$out"

# v1.1.0: la huella cubre lo que viaja con la copia, no solo `glot.sh`. Una copia con el
# catálogo retocado es vieja aunque el script esté intacto, y la deriva de datos se informa
# aparte: es la parte que se olvida al actualizar el tooling sin reinstalar (medido el
# 2026-09-25: la copia seguía diciendo `install_stale: no` con el comando de Ada anterior)
assert_contains 'install: los metadatos cubren los datos' 'data_sha=' "$(cat -- "$INSTALL_DIR/install.meta")"
assert_contains 'doctor: los datos están al día' 'install_data: ok' "$out"
printf '\n# retoque en los datos / data tweak\n' >>"$INSTALL_DIR/data/languages.tsv"
glot_install doctor
assert_contains 'doctor: datos retocados marcan la copia vieja' 'install_stale: yes' "$out"
assert_contains 'doctor: la deriva de datos se informa' 'install_data: stale' "$out"
glot_install install >/dev/null
glot_install doctor
assert_contains 'doctor: reinstalar deja los datos buenos' 'install_data: ok' "$out"
printf '\nPolicy tweak\n' >>"$INSTALL_DIR/prompts/Delegation_Policy.md"
glot_install doctor
assert_contains 'doctor: política retocada detectada' 'install_data: stale' "$out"
glot_install install >/dev/null
glot_install doctor
assert_contains 'doctor: reinstalar restaura política' 'install_data: ok' "$out"

# v1.4.0: la deriva se mide en las **dos orillas**. Los casos de arriba tocan la copia (el
# retoque a mano, que es el caso raro); falta la otra: que el clon del que se instaló haya
# avanzado. Se instala desde una fuente desechable —lo que viaja con la copia, nada más— y
# se mide cada orilla por separado: fuente tocada (`install_source_state: stale`), copia
# tocada (`install_copy: tweaked`) y origen movido (`moved`), que **no** convierte en vieja
# a una copia intacta: lo que falta entonces es el clon, no la copia.
SRC_HOME="$WORK_DIR/home-source"
SRC_DIR="$WORK_DIR/src-source"
mkdir -p -- "$SRC_HOME" "$SRC_DIR"
cp -- "$GLOT_SH" "$SRC_DIR/glot.sh"
cp -R -- "$TESTS_DIR/../data" "$TESTS_DIR/../prompts" "$TESTS_DIR/../completions" "$SRC_DIR/"

# src_install [args...] — glot desde la fuente desechable, con HOME desechable
src_install() {
    local rc=0
    out="$(env -u GLOT_STATE_FILE -u GLOT_ROOT GLOT_ROOT= HOME="$SRC_HOME" "$SRC_DIR/glot.sh" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

# src_copy_doctor — doctor desde la **copia**, para cuando el origen ya no está
src_copy_doctor() {
    local rc=0
    out="$(env -u GLOT_STATE_FILE -u GLOT_ROOT GLOT_ROOT= HOME="$SRC_HOME" "$SRC_HOME/.local/bin/glot" doctor 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

src_install install >/dev/null
src_install doctor
assert_contains 'doctor: la orilla de la copia está al día' 'install_copy: ok' "$out"
assert_contains 'doctor: la orilla de la fuente está al día' 'install_source_state: ok' "$out"
assert_contains 'doctor: sin deriva no hay porqué' 'install_stale: no' "$out"

# orilla de la fuente: el clon avanza (el catálogo cambia en la fuente, no en la copia)
printf '\n# retoque en la fuente / source tweak\n' >>"$SRC_DIR/data/commits.tsv"
src_install doctor
assert_contains 'doctor: la fuente avanzada marca deriva' 'install_stale: yes' "$out"
assert_contains 'doctor: la deriva se atribuye a la fuente' 'install_source_state: stale' "$out"
assert_contains 'doctor: la copia sigue siendo la instalada' 'install_copy: ok' "$out"
assert_contains 'doctor: la deriva trae el remedio' 'glot install' "$err"
src_install install >/dev/null
src_install doctor
assert_contains 'doctor: reinstalar desde la fuente la pone al día' 'install_source_state: ok' "$out"
assert_contains 'doctor: tras reinstalar no queda deriva' 'install_stale: no' "$out"

# 2026-10-17: `cp -R` no borra. Un fichero que el clon retiró se quedaba en la copia para
# siempre, así que la huella no volvía a cuadrar y `doctor` decía `install_stale: yes` **justo
# después de instalar**, anunciando como remedio el `install` que se acababa de ejecutar
# (medido en la copia del autor: tres ficheros de `data/` de una versión anterior). Instalar
# tiene que retirar de la copia lo que el clon ya no trae.
: >"$SRC_HOME/.local/share/glot/data/fantasma.tsv"
src_install doctor
assert_contains 'doctor: un fichero que sobra en la copia marca deriva' 'install_stale: yes' "$out"
src_install install >/dev/null
assert_contains 'install: dice cuántos ficheros retira' 'retirados de la copia' "$err"
assert_eq 'install: el fichero que sobra ya no está' 'no' \
    "$([[ -e "$SRC_HOME/.local/share/glot/data/fantasma.tsv" ]] && echo si || echo no)"
src_install doctor
assert_contains 'doctor: tras instalar, el que sobraba ya no da deriva' 'install_stale: no' "$out"

# orilla de la copia: el retoque está en la copia y la fuente sigue igual
printf '\n# retoque en la copia / copy tweak\n' >>"$SRC_HOME/.local/share/glot/data/commits.tsv"
src_install doctor
assert_contains 'doctor: la copia retocada marca deriva' 'install_stale: yes' "$out"
assert_contains 'doctor: la deriva se atribuye a la copia' 'install_copy: tweaked' "$out"
assert_contains 'doctor: la fuente sigue al día' 'install_source_state: ok' "$out"
src_install install >/dev/null

# el origen movido no es deriva de la copia: se nombra y la copia intacta no se marca vieja
mv -- "$SRC_DIR" "$SRC_DIR-moved"
src_copy_doctor
assert_contains 'doctor: copia intacta sin origen no es deriva' 'install_stale: no' "$out"
assert_contains 'doctor: el origen que ya no está se nombra' 'install_source_state: moved' "$out"
assert_contains 'doctor: la copia intacta se declara' 'install_copy: ok' "$out"
mv -- "$SRC_DIR-moved" "$SRC_DIR"
src_install doctor
assert_contains 'doctor: vuelto el origen, todo vuelve a estar al día' 'install_source_state: ok' "$out"

# lo ajeno no se pisa: ni un enlace de otro, ni un fichero
rm -rf -- "$INSTALL_HOME/.local/bin"
mkdir -p -- "$INSTALL_HOME/.local/bin"
ln -s /bin/true "$INSTALL_HOME/.local/bin/glot"
glot_install install
assert_eq 'install: un enlace ajeno da código 1' '1' "$rc_last"
assert_contains 'install: un enlace ajeno se explica' 'de otro' "$err"
rm -f -- "$INSTALL_HOME/.local/bin/glot"
printf '#!/bin/sh\n' >"$INSTALL_HOME/.local/bin/glot"
chmod +x -- "$INSTALL_HOME/.local/bin/glot"
glot_install install
assert_eq 'install: un fichero ajeno da código 1' '1' "$rc_last"
glot_install uninstall
assert_eq 'uninstall: un fichero ajeno se respeta' 'si' \
    "$([[ -x "$INSTALL_HOME/.local/bin/glot" ]] && echo si || echo no)"
rm -f -- "$INSTALL_HOME/.local/bin/glot"

glot_install install ahora
assert_eq 'install: con argumentos da código 2' '2' "$rc_last"

# help y completado conocen los verbos nuevos
glot_run help
assert_contains 'help: install aparece en la lista' 'install' "$out"
glot_run help install
assert_eq 'help install: código' '0' "$rc_last"
assert_contains 'help install: explica la copia estable' 'copia estable' "$out"
glot_run help uninstall
assert_contains 'help uninstall: explica que deshace' 'deshace' "$out"

# v1.4.0: la ayuda del verbo es la única documentación que se lee con el verbo delante, así
# que ahí viven las dos notas nuevas: el `cd` de la capa no cruza una tubería, y `doctor`
# mide la deriva en dos orillas (la copia y la fuente)
glot_run help use
assert_eq 'help use: código' '0' "$rc_last"
assert_contains 'help use: el cd de la capa solo llega en tu shell' 'subshell' "$out"
assert_contains 'help use: lo explica en inglés' 'pipeline' "$out"
assert_contains 'help use: sin capa el cd lo hace tu shell' 'cd "$(glot use' "$out"
glot_run help doctor
assert_eq 'help doctor: código' '0' "$rc_last"
assert_contains 'help doctor: la deriva se mide en dos orillas' 'install_copy:' "$out"
assert_contains 'help doctor: la orilla de la fuente se nombra' 'install_source_state:' "$out"

# v1.5.0: `save` documenta la opción en inglés y `pointer` deja de anunciar una rama propia
# (eso se decidió en la v1.3.0 y la ayuda del listado se quedó atrás)
glot_run help save
assert_eq 'help save: código' '0' "$rc_last"
assert_contains 'help save: documenta --cause' '--cause' "$out"
assert_contains 'help save: --causa queda como alias' '--causa' "$out"
glot_run help pointer
assert_eq 'help pointer: código' '0' "$rc_last"
assert_contains 'help pointer: el gitlink va en la rama activa' 'rama activa' "$out"
assert_eq 'help pointer: ya no anuncia rama propia' '0' \
    "$(printf '%s\n' "$out" | grep -c -- '-pointer' || true)"
assert_contains 'completado bash: conoce install' 'install uninstall' "$(cat -- "$TESTS_DIR/../completions/glot.bash")"
assert_contains 'completado zsh: conoce install' "'install:" "$(cat -- "$TESTS_DIR/../completions/glot.zsh")"

# desinstalar deja el HOME como estaba: ni copia, ni enlace, ni completados, ni bloque
# (se reinstala antes porque el caso del fichero ajeno ya retiró lo instalado)
glot_install install >/dev/null
glot_install uninstall
assert_eq 'uninstall: código' '0' "$rc_last"
assert_contains 'uninstall: dice qué retiró' 'instalación retirada' "$err"
assert_eq 'uninstall: la copia desaparece' 'no' "$([[ -e "$INSTALL_DIR" ]] && echo si || echo no)"
assert_eq 'uninstall: el enlace desaparece' 'no' "$([[ -e "$INSTALL_HOME/.local/bin/glot" ]] && echo si || echo no)"
assert_eq 'uninstall: el completado de bash desaparece' 'no' \
    "$([[ -e "$INSTALL_HOME/.local/share/bash-completion/completions/glot" ]] && echo si || echo no)"
assert_eq 'uninstall: el de zsh también' 'no' "$([[ -e "$INSTALL_HOME/.zsh/completions/_glot" ]] && echo si || echo no)"
assert_eq 'uninstall: el bloque del rc se va' '0' "$(grep -c 'glot (install)' "$INSTALL_HOME/.bashrc")"
glot_in_home 'source "$HOME/.bashrc"; type -t glot || echo sin-funcion'
assert_eq 'uninstall: ya no queda la función' 'sin-funcion' "$out"

# idempotente al revés: sin nada instalado, avisa y devuelve 0
glot_install uninstall
assert_eq 'uninstall: repetido, código' '0' "$rc_last"
assert_eq 'uninstall: repetido, dice que no había nada' 'nothing' "$out"
glot_install doctor
assert_contains 'doctor: sin instalación lo dice' 'install: no' "$out"
assert_contains 'doctor: sin instalación, el bloque no está' 'install_rc: bash:no' "$out"

# toolchains (v1.0.0): el dato declara una serie verificada por lenguaje y `doctor` informa
# de la cobertura y de la presencia, y comprueba la serie del lenguaje del sprint en curso.
TOOLCHAINS="$TESTS_DIR/../data/toolchains.tsv"
INJECTED="$WORK_DIR/toolchains"
mkdir -p -- "$INJECTED"

assert_eq 'toolchains: el fichero de datos existe' 'si' "$([[ -r "$TOOLCHAINS" ]] && echo si || echo no)"
assert_eq 'toolchains: tres columnas separadas por tabulador' 'ok' \
    "$(awk -F'\t' 'NF != 3 { bad = 1 } END { print (bad ? "mal" : "ok") }' "$TOOLCHAINS")"
assert_eq 'toolchains: la primera columna está ordenada' 'ok' \
    "$(cut -f1 -- "$TOOLCHAINS" | LC_ALL=C sort -c >/dev/null 2>&1 && echo ok || echo mal)"
assert_eq 'toolchains: sin lenguajes repetidos' \
    "$(cut -f1 -- "$TOOLCHAINS" | wc -l | tr -d ' ')" \
    "$(cut -f1 -- "$TOOLCHAINS" | LC_ALL=C sort -u | wc -l | tr -d ' ')"
assert_eq 'toolchains: ninguna serie vacía' 'ok' \
    "$(awk -F'\t' '$3 == "" { bad = 1 } END { print (bad ? "mal" : "ok") }' "$TOOLCHAINS")"

git -C "$REPO" config --file "$REPO/.gitmodules" --get-regexp '\.path$' 2>/dev/null |
    awk '{print $NF}' | LC_ALL=C sort >"$WORK_DIR/gitmodules-paths"
unknown_rows=""
while IFS=$'\t' read -r tc_lang _ _; do
    [[ -n "$tc_lang" ]] || continue
    grep -qx -- "$tc_lang" "$WORK_DIR/gitmodules-paths" || unknown_rows+="$tc_lang "
done <"$TOOLCHAINS"
assert_eq 'toolchains: ninguna fila fuera de .gitmodules' '' "$unknown_rows"

# glot_run_tc <catálogo> [args...] — ejecuta glot con un catálogo de toolchains inyectado
glot_run_tc() {
    local file="$1"
    shift
    local rc=0
    out="$(GLOT_TOOLCHAINS_FILE="$file" "$GLOT_SH" "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

glot_run doctor
assert_contains 'doctor: el fichero de toolchains' 'toolchains_file: ' "$out"
assert_contains 'doctor: la cobertura del catálogo' "toolchains: $(wc -l <"$TOOLCHAINS" | tr -d ' ') de / of " "$out"
assert_contains 'doctor: la presencia de las declaradas' 'toolchains_present: ' "$out"

# sin sprint no hay serie que comprobar: se dice con un estado que no existe
out="$(GLOT_STATE_FILE="$WORK_DIR/state-sin-sprint" "$GLOT_SH" doctor 2>/dev/null || true)"
assert_contains 'doctor: sin sprint no hay serie que comprobar' 'toolchain_sprint: -' "$out"

# con sprint, se comprueba la serie de ese lenguaje: cualquiera de los tres estados vale,
# porque una versión que avanza es información y no un fallo del entorno
glot_run set lang ruby
glot_run doctor
assert_contains 'doctor: la serie del lenguaje del sprint' 'toolchain_ruby: ' "$out"
assert_eq 'doctor: un sprint sin fila declarada no rompe' '0' "$rc_last"
# inyectando el catálogo se prueban los tres estados sin tocar el dato del repositorio
cp -f -- "$TOOLCHAINS" "$INJECTED/differs.tsv"
sed -i 's/^ruby\truby --version\t.*/ruby\truby --version\t9.9/' "$INJECTED/differs.tsv"
glot_run set lang ruby
glot_run_tc "$INJECTED/differs.tsv" doctor
assert_eq 'toolchains: una serie que no coincide no cambia el código' '0' "$rc_last"
assert_contains 'toolchains: la serie que no coincide se informa' 'toolchain_ruby: differs (3.4.3 ≠ / vs 9.9)' "$out"

cp -f -- "$TOOLCHAINS" "$INJECTED/missing.tsv"
sed -i 's/^ruby\truby --version\t.*/ruby\tglot-no-existe --version\t3.4/' "$INJECTED/missing.tsv"
glot_run_tc "$INJECTED/missing.tsv" doctor
assert_eq 'toolchains: una herramienta que falta cambia el código' '1' "$rc_last"
assert_contains 'toolchains: la herramienta que falta se nombra' 'toolchain_ruby: missing (no encontrado / not found: glot-no-existe)' "$out"

cp -f -- "$TOOLCHAINS" "$INJECTED/unknown.tsv"
printf 'klingon\tglot-no-existe --version\t1.0\n' >>"$INJECTED/unknown.tsv"
glot_run_tc "$INJECTED/unknown.tsv" doctor
assert_eq 'toolchains: una fila fuera de .gitmodules cambia el código' '1' "$rc_last"
assert_contains 'toolchains: la fila fuera de .gitmodules se nombra' 'toolchain_klingon: unknown' "$out"

# Desde el 2026-10-13 los **50** lenguajes tienen serie declarada, así que el caso «sprint sin
# serie» se prueba quitándole la fila a `rescript` en el catálogo inyectado.
cp -f -- "$TOOLCHAINS" "$INJECTED/sin-serie.tsv"
sed -i '/^rescript\t/d' "$INJECTED/sin-serie.tsv"
glot_run set lang rescript
glot_run_tc "$INJECTED/sin-serie.tsv" doctor
assert_eq 'doctor: sin serie declarada, código' '0' "$rc_last"
assert_contains 'doctor: sin serie declarada, se dice' 'toolchain_rescript: - (sin serie declarada' "$out"

glot_run_tc "$WORK_DIR/no-existe.tsv" doctor
assert_eq 'toolchains: sin fichero de datos no es un fallo' '0' "$rc_last"
assert_contains 'toolchains: sin fichero de datos se dice' 'toolchains_file: (no encontrado / not found)' "$out"

# encargos (v1.0.0): las plantillas declaran sus fuentes y ya no nombran el monorepo
PROMPTS="$TESTS_DIR/../prompts"
assert_eq 'prompt: ninguna plantilla nombra el monorepo' '' \
    "$(grep -l 'yorche3\|programming_languages' "$PROMPTS"/*.prompt.md 2>/dev/null | tr '\n' ' ')"
assert_eq 'prompt: ninguna plantilla usa rutas que salen del monorepo' '' \
    "$(grep -l '\.\./\.\.' "$PROMPTS"/*.prompt.md 2>/dev/null | tr '\n' ' ')"
assert_eq 'prompt: todas las plantillas declaran sources' \
    "$(ls -1 "$PROMPTS"/*.prompt.md | wc -l | tr -d ' ')" \
    "$(grep -l '^sources: ' "$PROMPTS"/*.prompt.md | wc -l | tr -d ' ')"

missing_sources=""
for template in "$PROMPTS"/*.prompt.md; do
    sources="$(sed -n 's/^sources: //p' "$template" | head -1)"
    [[ -n "$sources" ]] || continue
    IFS=',' read -r -a declared <<<"$sources"
    for path in "${declared[@]}"; do
        path="${path#"${path%%[![:space:]]*}"}"
        path="${path%"${path##*[![:space:]]}"}"
        [[ -e "$REPO/$path" ]] || missing_sources+="$(basename -- "$template"):$path "
    done
    unset IFS
done
assert_eq 'prompt: toda fuente declarada existe en el monorepo' '' "$missing_sources"

# la cabecera del encargo lleva la raíz y las fuentes que faltan se avisan por stderr
glot_run set lang php
glot_run prompt suite
assert_eq 'prompt: código' '0' "$rc_last"
assert_contains 'prompt: la cabecera lleva la raíz del monorepo' "| root | $REPO |" "$out"
assert_eq 'prompt: sin fuentes ausentes no avisa' 'no' "$([[ "$err" == *'fuente ausente'* ]] && echo si || echo no)"

# v1.6.0: las plantillas **solo** mandan versionadas. El aviso de fuentes se prueba
# inyectando la plantilla en la carpeta del clon, que es la única fuente que existe.
fuentes_glot="$WORK_DIR/glot-fuentes"
mkdir -p -- "$fuentes_glot/prompts"
cp -- "$GLOT_SH" "$fuentes_glot/glot.sh"
cp -R -- "$TESTS_DIR/../data" "$fuentes_glot/data"
cp -R -- "$PROMPTS_DIR/." "$fuentes_glot/prompts/"
cat >"$fuentes_glot/prompts/fuentes-check.prompt.md" <<'EOF'
---
name: fuentes-check
step: 4b
profile: balanced
description: prueba del aviso de fuentes
sources: docs/core, docs/no-existe.md
mode: agent
---

Cuerpo de prueba para {module}.
EOF
out="$(GLOT_ROOT="$SANDBOX" "$fuentes_glot/glot.sh" prompt fuentes-check php algorithms/data_structures_basics 2>"$WORK_DIR/stderr")" || true
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'prompt: avisa de la fuente que falta' 'fuente ausente / missing source: docs/no-existe.md' "$err"
assert_eq 'prompt: no avisa de la que sí está' 'no' "$([[ "$err" == *'missing source: docs/core'* ]] && echo si || echo no)"
assert_eq 'prompt: el encargo se imprime igual' 'si' \
    "$([[ "$out" == *'Cuerpo de prueba para data_structures_basics'* ]] && echo si || echo no)"
assert_contains 'prompt: fuentes declaradas se entregan al agente' "- $SANDBOX/docs/no-existe.md" "$out"

mv -- "$fuentes_glot/prompts/Delegation_Policy.md" "$fuentes_glot/policy.saved"
for policy_state in missing empty unresolved; do
    case "$policy_state" in
        empty) : >"$fuentes_glot/prompts/Delegation_Policy.md" ;;
        unresolved) printf 'Unknown {not_a_placeholder}\n' >"$fuentes_glot/prompts/Delegation_Policy.md" ;;
    esac
    rc_last=0
    out="$(GLOT_ROOT="$SANDBOX" "$fuentes_glot/glot.sh" prompt fuentes-check php algorithms/data_structures_basics 2>"$WORK_DIR/stderr")" || rc_last=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    assert_eq "política $policy_state: error explícito" '1' "$rc_last"
    assert_eq "política $policy_state: no emite encargo incompleto" '' "$out"
    if [[ "$policy_state" == unresolved ]]; then
        assert_contains 'política: marcador inválido diagnosticado' 'unresolved placeholder' "$err"
    else
        assert_contains "política $policy_state: diagnóstico" 'delegation policy' "$err"
    fi
done
mv -- "$fuentes_glot/policy.saved" "$fuentes_glot/prompts/Delegation_Policy.md"

# v1.6.0: el banco local ya **no** es respaldo: una plantilla fuera de `scripts/prompts/`
# no se lee, aunque exista en el clon.
mkdir -p -- "$SANDBOX/.github/prompts"
cp -- "$PROMPTS_DIR/suite.prompt.md" "$SANDBOX/.github/prompts/local-only.prompt.md"
sed -i 's/^name: suite/name: local-only/' "$SANDBOX/.github/prompts/local-only.prompt.md"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" "$GLOT_SH" prompt local-only php algorithms/data_structures_basics 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'prompt: el banco local ya no se lee' '1' "$rc_last"
assert_contains 'prompt: lo dice' 'encargo desconocido' "$(cat -- "$WORK_DIR/stderr")"
rm -rf -- "$SANDBOX/.github"

# --- casos de la especificación v1.2.0 (delegados COP y AGY) -----------------

# La orden del delegado usa el mismo vocabulario de marcadores que el resto del tooling,
# y se resuelve con el módulo del **encargo**: la ruta esperada se lee del propio encargo
# (su cabecera), no se escribe en el caso.
glot_run prompt implement php algorithms/naive_sort
expected_root="$(printf '%s\n' "$out" | awk -F'|' '$2 ~ /^ root / {gsub(/^ +| +$/, "", $3); print $3}')"
expected_dir="$(printf '%s\n' "$out" | awk -F'|' '$2 ~ /^ module_dir / {gsub(/^ +| +$/, "", $3); print $3}')"
assert_eq 'delegado: el encargo trae root y module_dir' 'si' \
    "$([[ -n "$expected_root" && -n "$expected_dir" ]] && echo si || echo no)"

glot_run_delegates 'echo ROOT={root} DIR={module_dir}; cat >/dev/null' '' \
    ask implement php algorithms/naive_sort
assert_eq 'delegado COP: código' '0' "$rc_last"
assert_eq 'delegado COP: resuelve {root} y {module_dir}' "ROOT=$expected_root DIR=$expected_dir" "$out"

glot_run_delegates 'printf "%s\n" "${GLOT_ROOT}"; cat >/dev/null' '' \
    ask implement php algorithms/naive_sort
assert_eq 'delegado: GLOT_ROOT exportado al delegado' "$expected_root" "$out"

glot_run_delegates 'printf "%s\n" "${GLOT_MODULE_DIR}"; cat >/dev/null' '' \
    ask implement php algorithms/naive_sort
assert_eq 'delegado: GLOT_MODULE_DIR exportado al delegado' "$expected_dir" "$out"

glot_run_delegates 'echo {root}; cat >/dev/null' '' -n ask implement php algorithms/naive_sort
assert_eq 'delegado -n: el plan trae la orden ya expandida' 'si' \
    "$([[ "$out" == *"echo $expected_root"* ]] && echo si || echo no)"

# Elección: con los dos configurados y sin `--delegate`, no se adivina
glot_run_delegates 'cat >/dev/null' 'cat >/dev/null' ask implement php algorithms/naive_sort
assert_eq 'dos delegados sin --delegate: código' '2' "$rc_last"
assert_contains 'dos delegados sin --delegate: pide elegir' '--delegate' "$err"

glot_run_delegates 'cat >/dev/null' '' ask --delegate antigravity implement php algorithms/naive_sort
assert_eq '--delegate antigravity sin AGY: código' '1' "$rc_last"
assert_contains '--delegate antigravity sin AGY: nombra la variable' 'GLOT_DELEGATE_AGY' "$err"

glot_run_delegates 'cat >/dev/null' 'echo ALIAS; cat >/dev/null' ask --delegate antigravity docs-module php algorithms/naive_sort
assert_eq '--delegate antigravity elige el suyo' 'ALIAS' "$out"

glot_run_delegates 'cat >/dev/null' '' ask --delegate gemini implement php algorithms/naive_sort
assert_eq '--delegate desconocido: código' '2' "$rc_last"
assert_contains '--delegate desconocido: lista los válidos' 'copilot, antigravity' "$err"

glot_run_delegates 'echo {foo}; cat >/dev/null' '' ask implement php algorithms/naive_sort
assert_eq 'delegado: marcador sin resolver' '1' "$rc_last"
assert_contains 'delegado: marcador sin resolver lo nombra' '{foo}' "$err"

# `GLOT_DELEGATE` sigue valiendo como alias del de Copilot: es lo ya documentado
out="$(env -u GLOT_DELEGATE_COP -u GLOT_DELEGATE_AGY -u GLOT_DELEGATE_AIDER GLOT_DELEGATE='echo ALIAS; cat >/dev/null' \
    "$GLOT_SH" ask --delegate copilot implement php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || true
assert_eq 'GLOT_DELEGATE es el alias de COP' 'ALIAS' "$out"

# Y `doctor` informa de los dos
out="$(env -u GLOT_DELEGATE -u GLOT_DELEGATE_AIDER GLOT_DELEGATE_COP='cat' GLOT_DELEGATE_AGY='cat' "$GLOT_SH" doctor 2>/dev/null)" || true
assert_contains 'doctor: delegado COP configurado' 'delegate_cop: (configurado / configured)' "$out"
assert_contains 'doctor: delegado AGY configurado' 'delegate_agy: (configurado / configured)' "$out"
out="$(env -u GLOT_DELEGATE -u GLOT_DELEGATE_COP -u GLOT_DELEGATE_AGY GLOT_DELEGATE_AIDER='cat' "$GLOT_SH" doctor 2>/dev/null)" || true
assert_eq 'doctor: GLOT_DELEGATE_AIDER se ignora (v1.7.2)' 'no' \
    "$([[ "$out" == *delegate_aider* ]] && echo si || echo no)"

# --- casos de la especificación v1.4.0 (alcance de la verificación) -----------

# El alcance del paso 6 está escrito: `verify` es lint idiomático, la suite entera es de
# `test`, el *hardcode* es de `validate` y el análisis estático de seguridad es un
# no-objetivo explícito (medido el 2026-09-26 al revisar el sprint de Ada).
glot_run help verify
assert_eq 'help verify: código' '0' "$rc_last"
assert_contains 'help verify: es un lint' 'lint' "$out"
assert_contains 'help verify: no comprueba la suite' 'eso es `test`' "$out"
assert_contains 'help verify: no busca valores codificados' 'no busca valores codificados' "$out"
assert_contains 'help verify: el SAST queda fuera' 'fuera de alcance' "$out"

validate_prompt="$(cat -- "$PROMPTS_DIR/validate.prompt.md")"
assert_contains 'validate: el hardcode es de este paso' 'valores codificados' "$validate_prompt"
assert_contains 'validate: lo nombra' 'hardcode' "$validate_prompt"

assert_contains 'contrato: el SAST es no-objetivo' 'análisis estático de seguridad (SAST) es un no-objetivo' "$(cat -- "$TESTS_DIR/../docs/CONTRACT.md")"
assert_contains 'contrato: el reparto del paso 6' 'Alcance de la capa' "$(cat -- "$TESTS_DIR/../docs/CONTRACT.md")"
assert_contains 'sprint: el reparto del paso 6' 'Reparto del paso 6' "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"
assert_contains 'data/README: la columna 5 es lint' 'lint idiomático' "$(cat -- "$DATA_DIR/README.md")"

# --- casos de la especificación v1.4.0 (política de CI) ----------------------
#
# La política de CI es **documentación**: dice que el comando sale del catálogo en vez de
# copiarse, que la CI comprueba y no firma el acta y que el SAST no es el verbo `verify`.
# La comprueba `docs/tests/docs_check.sh`; aquí solo queda el dato, no el documento.

# Punto 5 del plan: las filas de `toolchains.tsv` que se pueden medir en este entorno ya
# están (`ada`, `common-lisp`, `rexx`, `scala`), y `rescript` queda como excepción
# declarada porque su toolchain no está instalada aquí. La fila solo se añade con la serie
# **verificada**: la deuda era no poder medirlas, y estas cuatro se midieron el 2026-09-27.
assert_contains 'toolchains: ada con su serie medida' "$(printf 'ada\talr --version\t2.1')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: common-lisp con su serie medida' "$(printf 'common-lisp\tros run -- --version\t2.6')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: rexx con su serie medida' "$(printf 'rexx\trexx -v\t5.2')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: scala con su serie medida' "$(printf 'scala\tscalac -version\t3.9')" "$(cat -- "$TOOLCHAINS")"
# rescript: su compilador se midió primero dentro del `node_modules` del módulo (11.1.4) y el
# 2026-10-13 se instaló en global (`npm i -g rescript`), así que ya declara fila propia.
assert_contains 'toolchains: rescript con su serie medida' "$(printf 'rescript\trescript --version\t12.3')" "$(cat -- "$TOOLCHAINS")"

# Punto 6 del plan: la tabla de módulos del roadmap es una **vista manual** y no lleva
# contador —así ningún número puede quedarse atrás en silencio—; el recuento de verdad vive
# en el bloque de contadores, que es el que lee `glot progress`.
ROADMAP_DOC="$REPO/docs/ROADMAP.md"
assert_eq 'roadmap: ninguna tabla de módulos lleva contador' '0' \
    "$(grep -cE '^\| `core\.[a-z_0-9.]+` \| [^|]*\| *[0-9]+/50 *\|' "$ROADMAP_DOC" || true)"
assert_contains 'roadmap: la tabla se declara vista manual' 'vista manual' "$(cat -- "$ROADMAP_DOC")"
assert_contains 'roadmap: el contador de verdad se nombra' 'bloque de contadores' "$(cat -- "$ROADMAP_DOC")"

# Punto 7 del plan: la suite deja de dar un falso positivo cuando el lenguaje necesita el
# cuerpo para enlazar. El contrato **inválido** detiene el paso; que **aún no enlace** no lo
# detiene: se comprueba sin enlace y la ejecución se traslada al acta del paso 6.
SUITE_PROMPT="$TESTS_DIR/../prompts/suite.prompt.md"
assert_contains 'suite: distingue el contrato inválido' 'contrato **inválido**' "$(cat -- "$SUITE_PROMPT")"
assert_contains 'suite: admite la compilación sin enlace' 'compilación sin enlace' "$(cat -- "$SUITE_PROMPT")"
assert_contains 'suite: nombra el comando sin enlace de Ada' 'gnatc' "$(cat -- "$SUITE_PROMPT")"
assert_contains 'suite: traslada la ejecución al acta' 'acta del paso' "$(cat -- "$SUITE_PROMPT")"
assert_contains 'SPRINT: el paso 4c recoge la compilación sin enlace' 'compilación sin enlace' \
    "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"

# --- casos de la especificación v1.4.2 (el delegado en el autocompletado) -----
#
# `ask` tiene una opción propia —`--delegate copilot|antigravity`— y el completado no la
# ofrecía: `glot ask <TAB>` listaba los encargos y nada más, así que la opción había que
# recordarla de memoria. Ahora se completa la opción, sus dos valores y el posicional sigue
# funcionando aunque la opción vaya delante. Se prueba **funcionando** —se carga el guion y
# se llama a `_glot_complete`—, no solo mirando el texto.

# completion_probe <palabras...> — qué ofrecería el completado de bash para esa línea
completion_probe() {
    local rc=0
    out="$(GLOT_CMD="$GLOT_SH" "$BASH" -c '
        source <(GLOT_CMD="$GLOT_CMD" "$GLOT_CMD" completion bash)
        COMP_WORDS=(glot "$@")
        COMP_CWORD=$(( ${#COMP_WORDS[@]} - 1 ))
        _glot_complete
        printf "%s\n" "${COMPREPLY[@]}"
    ' glot "$@" 2>"$WORK_DIR/stderr")" || rc=$?
    err="$(cat -- "$WORK_DIR/stderr")"
    rc_last="$rc"
}

completion_probe ask ""
assert_eq 'completado ask: código' '0' "$rc_last"
assert_contains 'completado ask: sigue ofreciendo los encargos' 'scaffold' "$out"
assert_contains 'completado ask: ofrece la opción del delegado' '--delegate' "$out"

completion_probe ask --delegate ""
assert_eq 'completado --delegate: las tres rutas' 'antigravity copilot open-router' \
    "$(printf '%s\n' "$out" | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')"

completion_probe ask --delegate=c
assert_contains 'completado --delegate=c: completa el valor pegado' '--delegate=copilot' "$out"
assert_eq 'completado --delegate=c: filtra por la letra' 'no' \
    "$([[ "$out" == *--delegate=antigravity* ]] && echo si || echo no)"

completion_probe ask --delegate=
assert_eq 'completado --delegate=: las tres rutas' '--delegate=antigravity --delegate=copilot --delegate=open-router' \
    "$(printf '%s\n' "$out" | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')"

completion_probe ask --delegate copilot ""
assert_contains 'completado tras el delegado: vuelve a los encargos' 'scaffold' "$out"
assert_contains 'completado tras el delegado: el posicional no se desplaza' '--delegate' "$out"

completion_probe ask --delegate copilot suite ""
assert_contains 'completado tras el encargo: el lenguaje' 'assembly' "$out"

completion_probe prompt ""
assert_eq 'completado prompt: sin delegado (no lo tiene)' 'no' \
    "$([[ "$out" == *--delegate* ]] && echo si || echo no)"

# zsh no se puede ejecutar como un guion suelto (necesita `compinit` y el contexto del
# completado), así que ahí se comprueba el guion: la opción, sus valores y que `ask` dejó de
# compartir rama con `prompt`, que es de donde venía la carencia.
ZSH_COMP="$(cat -- "$TESTS_DIR/../completions/glot.zsh")"
# La línea que lee los ids de AGY del catálogo se comprueba por su forma —zsh no se ejecuta como
# guion suelto: necesita `compinit` y el contexto del shell—; el comportamiento se prueba en el
# completado de bash, que sí se puede cargar y llamar.
ZSH_COMP_AGY='delegates agy 2>/dev/null | cut -f2'
ZSH_COMP_COP='delegates copilot 2>/dev/null | cut -f2'
assert_contains 'completado zsh: los dos valores del delegado' 'compadd -- copilot antigravity' "$ZSH_COMP"
assert_contains 'completado zsh: la forma --delegate=' 'compadd -- --delegate=copilot --delegate=antigravity' "$ZSH_COMP"
assert_contains 'completado zsh: ask y validate comparten las opciones' '        ask | validate)' "$ZSH_COMP"
assert_contains 'completado zsh: `set` tiene su rama' '        set)' "$ZSH_COMP"
assert_contains 'completado zsh: los alias de AGY tras `antigravity-model`' "$ZSH_COMP_AGY" "$ZSH_COMP"
assert_contains 'completado zsh: los alias de Copilot tras `copilot-model`' "$ZSH_COMP_COP" "$ZSH_COMP"
assert_contains 'completado zsh: los dos delegados del catálogo' "_values 'delegado' agy copilot" "$ZSH_COMP"
assert_contains 'completado zsh: el verbo del catálogo de modelos' 'models:catálogo de perfiles y modelos' "$ZSH_COMP"
assert_contains 'completado zsh: el verbo del catálogo de delegados' 'delegates:catálogo de alias de modelo por delegado' "$ZSH_COMP"
assert_contains 'completado zsh: el verbo finish' 'finish:cierre del monorepo' "$ZSH_COMP"

# --- puerta de entrada al archivo de versiones -------------------------------

# La versión viva no puede arrancar sin el snapshot de la anterior ya archivado:
# es la regla que evita que una versión se cierre sin dejar su foto congelada.
live_version="$LIVE_VERSION"
assert_eq 'puerta de entrada: la versión viva se lee del script' 'si' "$([[ -n "$live_version" ]] && echo si || echo no)"

# La puerta se comprueba también hacia atrás: toda versión que el log marca como
# cerrada tiene que tener su snapshot, y ningún snapshot puede sobrar. Así el olvido
# se ve al confirmar el cierre, no al arrancar la versión siguiente, que es como se
# detectó en las v0.5.0 y v0.6.0.
closed_versions="$(awk -F'|' '/^\| [0-9]+\.[0-9]+\.[0-9]+ / {v = $2; gsub(/[ \t]/, "", v); s = $(NF - 1); if (s ~ /cerrada/) print v}' "$TESTS_DIR/../docs/VERSIONS.md")"
assert_eq 'archivado: el log de versiones se lee' 'si' "$([[ -n "$closed_versions" ]] && echo si || echo no)"

# La versión anterior a la viva es la **última cerrada** del log, no la anterior aritmética:
# un `fix` o un `refactor` cierran como parche, y desde la v1.6.1 su rama lleva el número de la
# entrega que cierra, así que calcularla restando uno al parche daría un falso verde y saltaría
# la puerta equivocada.
previous="$(printf '%s\n' "$closed_versions" | tail -1)"
if [[ -n "$previous" ]]; then
    assert_eq 'puerta de entrada: el snapshot de la versión anterior está archivado' \
        'si' "$([[ -f "$TESTS_DIR/../versions/glot_$previous.sh" ]] && echo si || echo no)"
    assert_eq 'puerta de entrada: la viva es posterior a la última cerrada' "$live_version" \
        "$(printf '%s\n%s\n' "$previous" "$live_version" | LC_ALL=C sort -V | tail -1)"
fi

missing_snapshots=""
while IFS= read -r v; do
    [[ -n "$v" ]] || continue
    [[ -f "$TESTS_DIR/../versions/glot_$v.sh" ]] || missing_snapshots+="$v "
done <<<"$closed_versions"
assert_eq 'archivado: cada versión cerrada tiene su snapshot' '' "$missing_snapshots"
assert_eq 'archivado: el log y la carpeta cuadran' \
    "$(printf '%s\n' "$closed_versions" | wc -l | tr -d ' ')" \
    "$(ls -1 "$TESTS_DIR/../versions"/glot_*.sh | wc -l | tr -d ' ')"

# --- resumen -----------------------------------------------------------------

printf '\nglot tests: %d passed, %d failed\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
