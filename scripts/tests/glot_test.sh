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
assert_eq 'version: salida' 'glot 0.5.0' "$out"
assert_eq 'version: código' '0' "$rc_last"
assert_eq 'version: stdout con una sola línea' '1' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"

# --version
glot_run --version
assert_eq '--version: salida' 'glot 0.5.0' "$out"
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
assert_contains 'doctor dentro: versión' 'version: 0.5.0' "$out"
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
    mkdir -p -- "$SANDBOX/docs/core/algorithms" "$SANDBOX/remote"
    printf '# 05 — Naive Sort\n' >"$SANDBOX/docs/core/algorithms/05_Naive_Sort.md"

    cat >"$SANDBOX/.gitmodules" <<'EOF'
[submodule "php"]
	path = php
	url = ../remote/php.git
EOF

    git -C "$SANDBOX" init -q
    git init -q --bare "$SANDBOX/remote/php.git"
    git -C "$SANDBOX/remote/php.git" symbolic-ref HEAD refs/heads/main

    mkdir -p -- "$SANDBOX/php/core/algorithms"
    git -C "$SANDBOX/php" init -q -b main
    git -C "$SANDBOX/php" config user.email 'glot@test'
    git -C "$SANDBOX/php" config user.name 'glot test'
    printf '# php\n' >"$SANDBOX/php/README.md"
    printf '# algorithms\n' >"$SANDBOX/php/core/algorithms/README.md"
    git -C "$SANDBOX/php" add -A
    git -C "$SANDBOX/php" commit -q -m 'chore: base'
    git -C "$SANDBOX/php" remote add origin "$SANDBOX/remote/php.git"
    git -C "$SANDBOX/php" push -q -u origin main
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

sandbox_make

# módulo nuevo: crea la rama desde main, la publica con -u y crea su carpeta
glot_run_sandbox use php algorithms/naive_sort
assert_eq 'use: código' '0' "$rc_last"
assert_eq 'use: ruta del módulo en stdout' "$SANDBOX/php/core/algorithms/naive_sort" "$out"
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
assert_eq 'use repetido: ruta' "$SANDBOX/php/core/algorithms/naive_sort" "$out"
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

# --- resumen -----------------------------------------------------------------

printf '\nglot tests: %d passed, %d failed\n' "$passed" "$failed"
[[ "$failed" -eq 0 ]]
