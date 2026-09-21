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
WORK_DIR="$(mktemp -d)"
trap 'rm -rf -- "$WORK_DIR"' EXIT

# Estado aislado: ningún caso toca el estado real del usuario.
export GLOT_STATE_FILE="$WORK_DIR/state"

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
assert_eq 'version: salida' 'glot 0.4.0' "$out"
assert_eq 'version: código' '0' "$rc_last"
assert_eq 'version: stdout con una sola línea' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"

# --version
glot_run --version
assert_eq '--version: salida' 'glot 0.4.0' "$out"
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

# compatibilidad v0.2.0: verbo hello
glot_run hello Ada
assert_eq 'compatibilidad hello: salida' 'Hello, Ada!' "$out"
assert_eq 'compatibilidad hello: código' '0' "$rc_last"

# un nombre suelto ya no es un nombre: falla rápido y sugiere el verbo
glot_run Ada
assert_eq 'nombre suelto: código' '2' "$rc_last"
assert_eq 'nombre suelto: stdout vacío' '' "$out"
assert_contains 'nombre suelto: sugiere greet' 'glot greet Ada' "$err"

# doctor dentro del monorepo
glot_run doctor
assert_eq 'doctor dentro: código' '0' "$rc_last"
assert_contains 'doctor dentro: versión' 'version: 0.4.0' "$out"
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

# --- resumen -----------------------------------------------------------------

printf '\nglot tests: %d passed, %d failed\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
