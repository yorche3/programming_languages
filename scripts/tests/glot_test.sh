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
GUIDE="$REPO/docs/core/00_Project_Initialization_Guide.md"
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
[submodule "python"]
        path = python
        url = ../remote/python.git
[submodule "java"]
        path = java
        url = ../remote/java.git
EOF
    git -C "$SANDBOX" init -q
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
    for extra in ruby python java; do
        mkdir -p -- "$SANDBOX/$extra/core/algorithms"
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
assert_eq 'models: ningún perfil sin modelo de AGY' '' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$7=="" || $7=="-"')"
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
assert_eq 'delegates: los dos delegados del catálogo' 'agy
copilot' \
    "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"

glot_run delegates agy
assert_eq 'delegates agy: código' '0' "$rc_last"
assert_eq 'delegates agy: solo sus dos filas' '2' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'delegates agy: la primera columna, el delegado' 'agy' "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"

# v1.7.3: las filas de Copilot llevan ids de OpenRouter (`vendedor/modelo`), y esa barra es la
# que distingue el modelo que viaja al proveedor propio del que viaja a GitHub
glot_run delegates copilot
assert_eq 'delegates copilot: código' '0' "$rc_last"
assert_eq 'delegates copilot: sus cuatro filas' '4' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'delegates copilot: la primera columna, el delegado' 'copilot' "$(printf '%s\n' "$out" | cut -f1 | LC_ALL=C sort -u)"
assert_eq 'delegates copilot: todos sus modelos son ids de OpenRouter' '4' \
    "$(printf '%s\n' "$out" | awk -F'\t' '$3 ~ /\//' | wc -l | tr -d ' ')"
assert_eq 'delegates copilot: el alias `default` es el modelo de la documentación' 'qwen/qwen3.7-plus' \
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

# el catálogo de datos y la guía de inicialización no se pueden separar
guide_langs="$(awk -F'|' '/^\| \*\*[a-z]/ {gsub(/\*/,"",$2); gsub(/[ \t]/,"",$2); print $2}' "$GUIDE")"
data_langs="$(cut -f1 "$REPO/scripts/data/languages.tsv")"
assert_eq 'catálogo y guía: mismos lenguajes' "$guide_langs" "$data_langs"

guide_tests="$(awk -F'|' '/^\| \*\*[a-z]/ {print $5}' "$GUIDE" |
    LC_ALL=C sed 's/`//g; s/  */ /g; s/^ //; s/ $//; s/\xef\xb8\x8f//g; s/\xe2\x9c\x85//g; s/\xf0\x9f\x94\xa7//g; s/\xe2\x9c\x8d//g; s/  */ /g; s/^ //; s/ $//')"
data_tests="$(cut -f4 "$REPO/scripts/data/languages.tsv")"
assert_eq 'catálogo y guía: mismos comandos de pruebas' "$guide_tests" "$data_tests"

# deriva: la sección «Secuencias de varios pasos» no la comparaba nadie, y ahí vivió una
# secuencia imposible sin aviso (medido el 2026-09-26). Son tres vistas del mismo conjunto:
# la sección, el marcador de secuencia de la tabla maestra y el dato de secuencias.
CHAIN_MARK="$(printf '\xe2\x9b\x93')"
data_seq="$(cut -f1 "$REPO/scripts/data/init_sequences.tsv" | LC_ALL=C sort -u)"
guide_seq="$(awk '/^## .*Multi-step sequences/,/^## .*Reference structures/' "$GUIDE" |
    awk -F'|' '/^\| `/ {gsub(/[` ]/, "", $2); print $2}' | LC_ALL=C sort -u)"
guide_chain="$(awk -F'|' -v chain="$CHAIN_MARK" '/^\| \*\*/ && index($3, chain) > 0 {gsub(/[* ]/, "", $2); print $2}' "$GUIDE" | LC_ALL=C sort -u)"
assert_eq 'secuencias y guía: el dato trae los 18 lenguajes' '18' "$(printf '%s\n' "$data_seq" | wc -l | tr -d ' ')"
assert_eq 'secuencias y guía: la sección lista el mismo conjunto' '' \
    "$(comm -3 <(printf '%s\n' "$guide_seq") <(printf '%s\n' "$data_seq") | tr -d '\t' | tr -d ' ' | tr '\n' ' ')"
assert_eq 'secuencias y guía: el marcador de secuencia coincide' '' \
    "$(comm -3 <(printf '%s\n' "$guide_chain") <(printf '%s\n' "$data_seq") | tr -d '\t' | tr -d ' ' | tr '\n' ' ')"

# la regla del directorio de trabajo: solo los generadores que crean la carpeta salen de
# `module`, y la guía tiene que nombrarlos a los cuatro. La sección se lee una vez: con
# `pipefail`, un `awk | grep -q` muere por SIGPIPE cuando `grep` acierta y sale antes.
data_phase="$(awk -F'\t' '$3 == "phase" {print $1}' "$REPO/scripts/data/init_sequences.tsv" | LC_ALL=C sort -u | tr '\n' ' ')"
assert_eq 'secuencias: los que crean la carpeta' 'clojure common-lisp julia racket ' "$data_phase"
guide_seq_body="$(awk '/^## .*Multi-step sequences/,/^## .*Reference structures/' "$GUIDE")"
missing_phase=""
for lang in $data_phase; do
    grep -q -- "$lang" <<<"$guide_seq_body" || missing_phase+="$lang "
done
assert_eq 'secuencias y guía: nombra los que crean la carpeta' '' "$missing_phase"

# la referencia entre proyectos de C# es un paso del dato, no una nota (medido el
# 2026-10-02: sin ella el proyecto de producción no se compila y `dotnet test` pasa
# en verde con un caso de plantilla).
assert_eq 'secuencias: C# enlaza el proyecto de pruebas' '1' \
    "$(awk -F'\t' '$1 == "csharp" && $5 ~ /reference/ {n++} END {print n+0}' "$REPO/scripts/data/init_sequences.tsv")"

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
assert_contains 'test -n: {suite} del sufijo del patrón' 'naive_sort_tests.pl' "$out"
assert_contains 'test -n: respeta el cd del comando' '&& cd test && ' "$out"

glot_run -n test scheme algorithms/naive_sort
assert_contains 'test -n: sufijo fijo tras {suite}' 'naive_sort_tests_guile.scm' "$out"

glot_run -n test vala algorithms/naive_sort
assert_contains 'test -n: {suite} dentro de una ruta' 'test/naive_sort_tests.vala' "$out"
assert_contains 'test -n: {module} en el binario' '/tmp/naive_sort-tests' "$out"

glot_run -n test tcl-tk algorithms/naive_sort
assert_contains 'test -n: suite con extensión .test' 'naive_sort.test' "$out"

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
assert_eq 'prompt: diez encargos' '10' "$(printf '%s\n' "$out" | wc -l | tr -d ' ')"
assert_eq 'prompt: cuatro columnas por línea' '' "$(printf '%s\n' "$out" | awk -F'\t' 'NF!=4')"
assert_contains 'prompt: scaffold en el paso 4' "$(printf 'scaffold\t4')" "$out"
assert_contains 'prompt: contract_stub en el paso 4b' "$(printf 'contract_stub\t4b')" "$out"
assert_contains 'prompt: suite después del contrato' "$(printf 'suite\t4c')" "$out"
assert_contains 'prompt: docs-language en el paso 8' "$(printf 'docs-language\t8')" "$out"
assert_contains 'prompt: el modelo sale del catálogo' "$(printf 'validate\t6\tqwen/qwen3.7-plus')" "$out"

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

# ...y en **los diez** encargos, no solo en uno: cualquiera de ellos cita documentos del
# monorepo, y basta una plantilla que se quede atrás para volver a gastar créditos en rutas
# que el delegado no puede resolver.
for req in scaffold contract_stub suite correct implement fix refactor validate docs-module docs-language; do
    glot_run prompt "$req" php algorithms/naive_sort
    assert_eq "prompt $req: ninguna ruta relativa a la raíz del monorepo" '' \
        "$(printf '%s\n' "$out" | grep -nE '(^|[^/[:alnum:]_.-])(AGENTS\.md|docs/|scripts/)' | grep -vF -- "$REPO" | head -5)"
done
assert_contains 'prompt scaffold: marcadores expandidos' 'php/core/algorithms/naive_sort' "$out"
assert_eq 'prompt scaffold: sin frontmatter de VS Code' 'no' "$(case "$out" in *'mode: agent'*) echo si ;; *) echo no ;; esac)"
assert_eq 'prompt scaffold: sin marcadores sin resolver' '' "$(printf '%s\n' "$out" | grep -oE '\{[a-zA-Z_]+\}' | sort -u)"

glot_run prompt implement php algorithms/naive_sort
assert_contains 'prompt implement: encargo del paso 5' 'Implementación del módulo' "$out"

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
assert_contains 'help ask: la línea de Copilot lleva el esfuerzo del perfil' '--reasoning-effort {effort}' "$out"
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
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set antigravity-model sonnet >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" \
    "$GLOT_SH" ask -n --delegate antigravity implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'set antigravity-model: el alias llega resuelto a la orden de AGY' 'agy --model claude-sonnet-5-5-low' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" GLOT_MODEL_AGY=gemini-3.7-flash-high \
    "$GLOT_SH" ask -n --delegate antigravity implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'set antigravity-model: el entorno del delegado gana al estado' 'agy --model gemini-3.7-flash-high' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_AGY="$AGY_LINE" \
    GLOT_DELEGATE_COP='copilot -C {module_dir} -p "$(cat)" --add-dir {root}' \
    "$GLOT_SH" ask -n --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'set antigravity-model: el de Copilot sigue saliendo del perfil' 'COPILOT_MODEL=claude-sonnet-5' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" doctor 2>/dev/null || true)"
assert_contains 'set antigravity-model: doctor informa del alias fijado' 'antigravity_model_state: sonnet' "$out"

# v1.7.3: el delegado de Copilot tiene su propia clave, `copilot-model`, y sus alias son ids de
# **OpenRouter**: es la vía de los encargos que no son de contrato, suite ni implementación
# (andamiaje, corrección y documentación). El alias **solo** sustituye a los modelos que ya son de
# OpenRouter: `gpt-5.6-terra` y `claude-sonnet-5` no llevan `/` y no se tocan.
COP_LINE='printf "P=%s|M=%s\n" "${COPILOT_PROVIDER_BASE_URL:-vacio}" "$COPILOT_MODEL"; cat >/dev/null'
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model default >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: el alias `default` resuelve al modelo de OpenRouter' 'P=https://openrouter.ai/api/v1|M=qwen/qwen3.7-plus' "$out"
# el alias no toca lo que ya estaba: terra (contrato y suite) ni sonnet (implementación)
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot contract_stub php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: no cambia el modelo del contrato (terra)' 'P=vacio|M=gpt-5.6-terra' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test \
    "$GLOT_SH" ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: no cambia el modelo de la implementación (sonnet)' 'P=vacio|M=claude-sonnet-5' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" COPILOT_PROVIDER_API_KEY=sk-or-test COPILOT_PROVIDER_BASE_URL=https://otro.example/v1 \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model: el endpoint del autor manda sobre el de OpenRouter' 'P=https://otro.example/v1|M=qwen/qwen3.7-plus' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>"$WORK_DIR/stderr" || true)"
assert_eq 'copilot-model: sin clave sigue delegando' 'P=https://openrouter.ai/api/v1|M=qwen/qwen3.7-plus' "$out"
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'copilot-model: sin clave lo avisa por stderr' 'COPILOT_PROVIDER_API_KEY' "$err"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model kimi >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" -n ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'copilot-model: el alias llega resuelto a COPILOT_MODEL' 'COPILOT_MODEL=moonshotai/kimi-k3' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" doctor 2>/dev/null || true)"
assert_contains 'copilot-model: doctor informa del alias fijado' 'copilot_model_state: kimi' "$out"
# el esfuerzo del perfil viaja en la orden publicada, que es lo que lo hace efectivo: `low` en los
# encargos de OpenRouter y en el contrato, `high` en la implementación
COP_PUB='copilot -C {module_dir} -p "$(cat)" --add-dir {root} --allow-all-tools --reasoning-effort {effort}'
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_PUB" \
    "$GLOT_SH" -n ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'el esfuerzo de OpenRouter llega a la orden' '--reasoning-effort low' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_PUB" \
    "$GLOT_SH" -n ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_contains 'el esfuerzo de la implementación llega a la orden' '--reasoning-effort high' "$out"
# sin clave de estado, el encargo de OpenRouter usa el modelo del perfil (y su proveedor)
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" unset copilot-model >/dev/null 2>&1
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" ask --delegate copilot docs-module php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'copilot-model sin fijar: manda el modelo del perfil' 'P=https://openrouter.ai/api/v1|M=qwen/qwen3.7-plus' "$out"
out="$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" GLOT_DELEGATE_COP="$COP_LINE" \
    "$GLOT_SH" ask --delegate copilot implement php algorithms/naive_sort 2>/dev/null || true)"
assert_eq 'un perfil de Copilot no toca el proveedor' 'P=vacio|M=claude-sonnet-5' "$out"
rc_bad=0
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model nope >/dev/null 2>&1 || rc_bad=$?
assert_eq 'set copilot-model con alias inválido: código' '2' "$rc_bad"
GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_MODEL" "$GLOT_SH" set copilot-model nope 2>"$WORK_DIR/stderr" >/dev/null || true
err="$(cat -- "$WORK_DIR/stderr")"
assert_contains 'set copilot-model con alias inválido: lista los válidos' 'default gemini qwen kimi' "$err"

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
assert_contains 'doctor: registro de encargos' 'prompts_ok: 10 encargos / requests' "$out"
assert_contains 'doctor: catálogo de delegados' 'delegates_file: ' "$out"
assert_contains 'doctor: alias por delegado' 'delegate_aliases: 6 alias / aliases (2 de AGY, 4 de Copilot)' "$out"
assert_contains 'doctor: delegado COP sin configurar' 'delegate_cop: (sin configurar / not configured)' "$out"
assert_contains 'doctor: delegado AGY sin configurar' 'delegate_agy: (sin configurar / not configured)' "$out"
assert_eq 'doctor: ya no informa de un delegado aider (v1.7.2)' 'no' \
    "$([[ "$out" == *delegate_aider* ]] && echo si || echo no)"

# --- casos de la especificación v0.9.0 (L5, creación y registro) -------------

DATA_DIR="$TESTS_DIR/../data"

# el catálogo de inicialización es dato, y el dato tiene que cuadrar
assert_eq 'catálogo de inicialización: 8 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 8' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: tipos válidos' '0' \
    "$(awk -F'\t' '$6 != "tool" && $6 != "manual" && $6 != "deferred"' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: deferred sin comando' '0' \
    "$(awk -F'\t' '$6 == "deferred" && $7 != "-"' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: los demás con comando o secuencia' '0' \
    "$(comm -23 <(awk -F'\t' '$6 != "deferred" && $7 == "-" {print $1}' "$DATA_DIR/languages.tsv" | sort) \
                  <(cut -f1 "$DATA_DIR/init_sequences.tsv" | sort -u) | wc -l | tr -d ' ')"
assert_eq 'catálogo de inicialización: la secuencia es de lenguajes del catálogo' '0' \
    "$(comm -13 <(cut -f1 "$DATA_DIR/languages.tsv" | sort) \
                  <(cut -f1 "$DATA_DIR/init_sequences.tsv" | sort -u) | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: 8 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 8' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: directorios de trabajo válidos' '0' \
    "$(awk -F'\t' '$3 != "module" && $3 != "phase"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: modos válidos' '0' \
    "$(awk -F'\t' '$4 != "run" && $4 != "expect"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias de inicialización: modo expect con requisito expect' '0' \
    "$(awk -F'\t' '$4 == "expect" && $6 != "expect"' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
# v1.3.0: el orden tiene que ser 1..n por lenguaje. Un hueco o un repetido rompe el plan
# sin que nadie lo note (el `read` de `new` se queda con una línea de menos).
assert_eq 'secuencias de inicialización: órdenes contiguos por lenguaje' '0' \
    "$(awk -F'\t' '{rows[$1]++; if ($2 > top[$1]) top[$1] = $2} END {for (k in rows) if (rows[k] != top[k]) bad++; print bad + 0}' "$DATA_DIR/init_sequences.tsv")"
# la columna 8 no puede quedar vacía: una fila de 7 campos manda el completado a
# «respuestas» y lo silencia (medido el 2026-09-26: 3 filas de Ada con 7 campos)
assert_eq 'secuencias de inicialización: la columna 8 nunca queda vacía' '0' \
    "$(awk -F'\t' '$8 == ""' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
# El generador **plano** de Common Lisp quedó fuera del dato (v1.6.1): `cl-project` es el
# de la comunidad y deja `src/` y `tests/`, pero **exige un *pathname*** —con una cadena
# abre el depurador—, así que el `#p` no es opcional (medido el 2026-09-29 y el 2026-09-30).
assert_eq 'secuencias: common-lisp genera con cl-project y con pathname' '1' \
    "$(awk -F'\t' '$1 == "common-lisp" && index($5, "cl-project:make-project") > 0 && index($5, "#p") > 0 {print "1"}' "$DATA_DIR/init_sequences.tsv" | wc -l | tr -d ' ')"
assert_eq 'secuencias: sin el generador plano de common-lisp' '' \
    "$(awk -F'\t' 'index($5, "quickproject") > 0 {print $1}' "$DATA_DIR/init_sequences.tsv")"
assert_eq 'catálogo de inicialización: operaciones conocidas' '0' \
    "$(awk -F'\t' '{n = split($8, ops, ";"); for (i = 1; i <= n; i++) if (ops[i] != "-" && ops[i] !~ /^(flat|rm):[^:]+$/) print $1}' "$DATA_DIR/languages.tsv" | wc -l | tr -d ' ')"

# el catálogo de commits: paso, alias, ámbito y mensaje
assert_eq 'catálogo de commits: 4 columnas por fila' '0' \
    "$(awk -F'\t' 'NF != 4' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de commits: ámbitos válidos' '0' \
    "$(awk -F'\t' '$3 != "submodule" && $3 != "monorepo"' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"
assert_eq 'catálogo de commits: mensajes en Conventional Commits' '0' \
    "$(awk -F'\t' '$4 !~ /^(feat|fix|docs|chore|refactor|test)\(/ && $4 !~ /^(feat|fix|docs|chore|refactor|test):/' "$DATA_DIR/commits.tsv" | wc -l | tr -d ' ')"

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
assert_contains 'scaffold: el runner es de este paso' 'el **runner es de este paso**' "$scaffold_prompt"
assert_contains 'scaffold: exige que arranque sin casos' 'arranca sin casos' "$scaffold_prompt"
assert_contains 'scaffold: lo escribe si el framework no lo trae' 'escríbelo aquí' "$scaffold_prompt"
assert_eq 'suite: ya no dice que crea el runner' 'no' \
    "$([[ "$suite_prompt" == *'Si el framework no incluye runner propio'* ]] && echo si || echo no)"
assert_contains 'suite: el runner es del paso 4a' 'runner es del paso 4a' "$suite_prompt"
assert_contains 'suite: si falta el runner, se detiene' 'detente y avísalo' "$suite_prompt"
assert_contains 'SPRINT: el 4a deja el runner arrancando' 'runner arrancando sin casos' "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"
assert_contains 'SPRINT: el 4c no crea el runner' 'sin crear el runner' "$(cat -- "$TESTS_DIR/../docs/SPRINT.md")"

# v1.1.0: el encargo del README remite a la plantilla en vez de copiar su lista de secciones.
# Una lista copiada se queda atrás en cuanto la plantilla crece (pasó: la plantilla llegó a
# 13 secciones y el encargo seguía enumerando seis)
docs_module_prompt="$(cat -- "$PROMPTS_DIR/docs-module.prompt.md")"
assert_contains 'docs-module: remite a la plantilla' 'todas las secciones obligatorias de `docs/README_Template.md`' "$docs_module_prompt"
sections_named=0
while IFS= read -r title; do
    [[ -n "$title" ]] || continue
    grep -qF -- "$title" <<<"$docs_module_prompt" && sections_named=$((sections_named + 1))
done < <(sed -n 's/^## [^ ]* \(.*\) \/ .*$/\1/p' "$REPO/docs/README_Template.md")
assert_eq 'docs-module: no vuelve a enumerar las secciones' 'si' \
    "$([[ "$sections_named" -le 2 ]] && echo si || echo no)"

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
assert_eq 'completion bash: un candidato por línea' '22' "$(printf '%s\n' "$save_comp" | wc -l | tr -d ' ')"

# v1.6.2: `get`/`set`/`unset` complean **todas** las claves reservadas. La lista vive en tres
# sitios —el completado de bash, el de zsh y la ayuda del verbo— y estos casos la mantienen
# alineada: una clave nueva con un sitio olvidado es el fallo que dejó `target`, `cause` y
# `model` fuera del completado.
keys_comp="$(GLOT_CMD="$GLOT_SH" bash -c 'source <('"$GLOT_SH"' completion bash); COMP_WORDS=(glot get ""); COMP_CWORD=2; _glot_complete; printf "%s\n" "${COMPREPLY[@]}"')"
assert_eq 'completion bash: las diez claves reservadas' \
    'antigravity-model branch cause copilot-model lang module phase repo spec target' \
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
    'lang phase module branch spec repo target cause antigravity-model copilot-model' \
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
assert_eq 'completion bash: los dos delegados del catálogo' 'agy copilot' \
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
assert_contains 'new tool -n: comando del catálogo' 'mkdir -p src test && composer require --dev phpunit/phpunit' "$out"
assert_contains 'new tool -n: en el directorio del módulo' '/php/core/algorithms/naive_sort && ' "$out"
assert_contains 'new tool -n: imprime la ruta como dato' '/php/core/algorithms/naive_sort' "$out"

# new: la normalización declarada se enseña en el plan
glot_run -n new crystal algorithms/naive_sort
assert_contains 'new -n: normalización en el plan' 'rm:naive_sort/.git;flat:naive_sort' "$out"
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
# catálogo real ya no tiene lenguajes `deferred` (R1/R6: todos traen herramienta o
# estructura manual), así que el caso se prueba con un catálogo inyectado.
sandbox_make
glot_run_sandbox use python algorithms/naive_sort
assert_eq 'new deferred: use deja el módulo' '0' "$rc_last"

DEF_DIR="$WORK_DIR/deferred-data"
mkdir -p "$DEF_DIR"
awk -F'\t' 'BEGIN {OFS="\t"} {if ($1 == "python") {$6 = "deferred"; $7 = "-"; $8 = "-"}; print}' \
    "$DATA_DIR/languages.tsv" >"$DEF_DIR/languages.tsv"
rc_last=0
out="$(GLOT_ROOT="$SANDBOX" GLOT_DATA_DIR="$DEF_DIR" "$GLOT_SH" new python algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'new deferred: código' '0' "$rc_last"
assert_eq 'new deferred: dato' 'skipped' "$out"
assert_contains 'new deferred: lo escribe el agente' 'no verified initializer' "$err"
assert_contains 'new deferred: encargo sugerido' 'glot prompt scaffold' "$err"

# v1.3.0: el completado del dato (columna 8) tiene que llegar al autor. Antes se imprimía
# dentro del bucle de pasos y la salida de los propios comandos se lo comía; medido el
# 2026-09-26, el `tests/alire.toml` de Ada quedó sin `[[depends-on]]`, `[[pins]]` ni `aunit`
# hasta aplicarlo a mano. Ahora va en un bloque al final, y este caso lo comprueba con un
# dato inyectado (el comando es `mkdir`, así que no depende de la red).
SEQ_DIR="$WORK_DIR/sequence-data"
mkdir -p "$SEQ_DIR"
cp -R "$DATA_DIR/." "$SEQ_DIR/"
printf 'java\t1\tmodule\trun\tmkdir -p src test\t-\t-\tnota-de-completado-de-prueba\n' \
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

# new: ejecución real en el sandbox, en modo manual (crea carpetas, no suite).
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
assert_eq 'sandbox new manual: código' '0' "$rc_last"
assert_eq 'sandbox new manual: dato = ruta del módulo' "$JB" "$out"
assert_eq 'sandbox new manual: crea src/main/java' 'si' "$([[ -d "$JB/src/main/java" ]] && echo si || echo no)"
assert_eq 'sandbox new manual: crea src/test/java' 'si' "$([[ -d "$JB/src/test/java" ]] && echo si || echo no)"
assert_eq 'sandbox new manual: no escribe la suite' '0' "$(find "$JB/src/test/java" -type f | wc -l | tr -d ' ')"
assert_contains 'sandbox new manual: remite al encargo' 'glot prompt scaffold' "$err"

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
assert_contains 'save -n: mensaje de la tabla' "commit -m 'chore(algorithms): add scaffold for naive_sort'" "$out"
assert_eq 'save -n: no confirma nada' '' "$(git -C "$SANDBOX/ruby" log --oneline main..HEAD 2>/dev/null)"

glot_run_sandbox save 4a ruby algorithms/naive_sort
assert_eq 'save: código' '0' "$rc_last"
assert_eq 'save: dato = SHA corto' '7' "${#out}"
assert_eq 'save: asunto del commit' 'chore(algorithms): add scaffold for naive_sort' \
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
assert_contains 'save -n contrato: mensaje del catálogo' "commit -m 'chore(algorithms): add contract for naive_sort'" "$out"
# v1.3.0: el mismo flag, detrás del verbo (antes tomaba `-n` por el paso)
glot_run_sandbox save -n contract_stub ruby algorithms/naive_sort
assert_eq 'save -n detrás del verbo: código' '0' "$rc_last"
assert_contains 'save -n detrás del verbo: mensaje del catálogo' "commit -m 'chore(algorithms): add contract for naive_sort'" "$out"
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
glot_run_sandbox -n save 4d ruby algorithms/naive_sort
assert_eq 'save 4d sin causa: código' '2' "$rc_last"
assert_contains 'save 4d sin causa: lo explica' 'necesita su causa' "$err"
printf 'z\n' >"$RB/src/z.rb"
glot_run_sandbox -n save 4d --cause 'la suite no cubría el caso vacío' ruby algorithms/naive_sort
assert_eq 'save 4d con causa: código' '0' "$rc_last"
assert_contains 'save 4d: el mensaje sale del catálogo' "commit -m 'chore(algorithms): correct naive_sort'" "$out"
assert_contains 'save 4d: la causa va al cuerpo del commit' "-m 'la suite no cubría el caso vacío'" "$out"
# v1.5.0: la opción va en inglés, como el resto del CLI; `--causa` se acepta como alias
glot_run_sandbox -n save 4d --causa 'la causa en español sigue valiendo' ruby algorithms/naive_sort
assert_eq 'save 4d con --causa (alias): código' '0' "$rc_last"
assert_contains 'save 4d con --causa: la causa llega' "-m 'la causa en español sigue valiendo'" "$out"
glot_run_sandbox -n save 4d --cause='la causa con igual' ruby algorithms/naive_sort
assert_eq 'save 4d con --cause= (pegado): código' '0' "$rc_last"
assert_contains 'save 4d con --cause=: la causa llega' "-m 'la causa con igual'" "$out"
glot_run_sandbox -n save 4d --cause
assert_eq 'save 4d con --cause sin texto: código' '2' "$rc_last"
assert_contains 'save 4d con --cause sin texto: lo explica' 'falta el texto de --cause' "$err"
glot_run_sandbox -n save fix --cause 'la causa' ruby algorithms/naive_sort
assert_eq 'save con el alias fix: código' '0' "$rc_last"
assert_contains 'save con el alias fix: el mismo mensaje' "commit -m 'fix(algorithms): correct naive_sort'" "$out"
rm -f -- "$RB/src/z.rb"

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
assert_contains 'doctor: ya no hay aplazadas' '(deferred: 0)' "$out"
assert_contains 'doctor: catálogo de commits' 'commits_file: ' "$out"
assert_contains 'doctor: pasos de commit' 'commit_steps: 11 de / of which 9 son del submódulo' "$out"

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
assert_contains 'validate por defecto: el modelo del perfil' '--model qwen/qwen3.7-plus' "$copilot_args"
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
assert_contains 'validate con marcadores: el modelo del perfil' '--model qwen/qwen3.7-plus' "$out"

out="$(GLOT_ROOT="$SANDBOX" GLOT_VALIDATOR="$SANDBOX/stub/validador --model {inexistente}" \
    "$GLOT_SH" -n validate php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
err="$(cat -- "$WORK_DIR/stderr")"
assert_eq 'validate con marcador desconocido: código' '1' "$rc_last"
assert_contains 'validate con marcador desconocido: lo dice' 'marcador sin resolver' "$err"

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
    prompt_model="$(sed -n 's/^model: \(.*\)$/\1/p' "$prompt_file")"
    if [[ -z "$prompt_model" ]]; then
        missing_model+="$prompt_name "
        continue
    fi
    cut -f2 -- "$MODELS_TSV" | grep -qxF -- "$prompt_model" || unknown_model+="$prompt_name "
done
assert_eq 'modelos: toda plantilla declara su modelo' '' "$missing_model"
assert_eq 'modelos: el modelo declarado está en el catálogo' '' "$unknown_model"

# deriva en los dos sentidos: la columna de encargos de cada perfil tiene que ser
# exactamente el conjunto de plantillas que declaran ese modelo
models_drift=""
while IFS=$'\t' read -r profile model effort credits tier requests pagy_model; do
    declared="$(for prompt_file in "$PROMPTS_DIR"/*.prompt.md; do
        if [[ "$(sed -n 's/^model: \(.*\)$/\1/p' "$prompt_file")" == "$model" ]]; then
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
assert_eq 'ask: el modelo del perfil llega por entorno' 'claude-sonnet-5' "$out"
assert_contains 'ask: anuncia el perfil' 'profile: deep' "$err"

glot_run_delegate 'cat >/dev/null' -n ask validate php algorithms/naive_sort
assert_eq 'ask -n: código' '0' "$rc_last"
assert_contains 'ask -n: el modelo en el plan' 'COPILOT_MODEL=qwen/qwen3.7-plus' "$out"

# sin modelo en la plantilla y con un modelo que el catálogo no conoce: los dos son un
# dato que falta (1), y en ningún caso se inventan esfuerzo ni créditos
fake_glot="$WORK_DIR/glot-sin-perfil"
mkdir -p -- "$fake_glot/prompts"
cp -- "$GLOT_SH" "$fake_glot/glot.sh"
cp -R -- "$TESTS_DIR/../data" "$fake_glot/data"
cp -R -- "$PROMPTS_DIR/." "$fake_glot/prompts/"

sed -i '/^model: /d' "$fake_glot/prompts/suite.prompt.md"
out="$(GLOT_ROOT="$SANDBOX" GLOT_DELEGATE='cat >/dev/null' "$fake_glot/glot.sh" ask suite php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'plantilla sin modelo: código' '1' "$rc_last"
assert_contains 'plantilla sin modelo: lo dice' 'no declara modelo' "$(cat -- "$WORK_DIR/stderr")"

sed -i '/^step: /a model: modelo-que-no-existe' "$fake_glot/prompts/suite.prompt.md"
out="$(GLOT_ROOT="$SANDBOX" GLOT_DELEGATE='cat >/dev/null' "$fake_glot/glot.sh" ask suite php algorithms/naive_sort 2>"$WORK_DIR/stderr")" || rc_last=$?
assert_eq 'modelo fuera del catálogo: código' '1' "$rc_last"
assert_contains 'modelo fuera del catálogo: lo dice' 'sin perfil en el catálogo' "$(cat -- "$WORK_DIR/stderr")"

# doctor informa de la cobertura del catálogo y del envejecimiento contra el CLI
glot_run doctor
assert_contains 'doctor: catálogo de modelos' 'models_file: ' "$out"
assert_contains 'doctor: cobertura de perfiles' 'model_profiles: 10 de / of 10' "$out"
if command -v copilot >/dev/null 2>&1; then
    assert_contains 'doctor: los modelos siguen en el CLI' 'model_available: 2 de / of 2' "$out"
    cli_models="$(copilot help config 2>/dev/null || true)"
    available=0
    while IFS=$'\t' read -r _ model _rest; do
        # los ids de OpenRouter no están en el catálogo del CLI: los sirve el proveedor propio
        [[ "$model" == */* ]] && continue
        [[ "$cli_models" == *"\"$model\""* ]] && available=$((available + 1))
    done <"$MODELS_TSV"
    assert_eq 'modelos: los de Copilot están en la lista del CLI instalado' '2' "$available"
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
assert_eq 'finish: el modelo de Copilot se queda' 'default' \
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
    spec=spec.md target=monorepo cause=fix antigravity-model=sonnet copilot-model=default zap=1; do
    GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" set "${kv%%=*}" "${kv#*=}" >/dev/null 2>&1
done
assert_eq 'estado del sprint: el almacén de prueba está montado' 'php' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get lang)"

glot_loaded "source \"\$1\"; GLOT_STATE_FILE='$STATE_CLEAR'; _glot_sprint_clear"
assert_eq 'finish: la limpieza no falla' '0' "$rc_last"
assert_eq 'finish: el sprint se ha ido' 'si' \
    "$(grep -qE '^(lang|phase|module|branch|spec|repo|target|cause)=' "$STATE_CLEAR" && echo no || echo si)"
assert_eq 'finish: el modelo de AGY se queda' 'sonnet' \
    "$(GLOT_ROOT="$SANDBOX" GLOT_STATE_FILE="$STATE_CLEAR" "$GLOT_SH" get antigravity-model)"
assert_eq 'finish: el modelo de Copilot se queda' 'default' \
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
# `rescript` es el lenguaje que sigue **sin fila** (su toolchain no está instalada aquí):
# con él se prueba que un sprint sin serie declarada se dice y no rompe nada. Antes este
# caso usaba `ada`, hasta que su fila se midió el 2026-09-27.
glot_run set lang rescript
glot_run doctor
assert_eq 'doctor: sin serie declarada, código' '0' "$rc_last"
assert_contains 'doctor: sin serie declarada, se dice' 'toolchain_rescript: - (sin serie declarada' "$out"

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
model: gpt-5.6-terra
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

glot_run_delegates 'cat >/dev/null' 'echo ALIAS; cat >/dev/null' ask --delegate antigravity implement php algorithms/naive_sort
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
assert_contains 'doctor: delegado COP configurado' 'delegate_cop: cat' "$out"
assert_contains 'doctor: delegado AGY configurado' 'delegate_agy: cat' "$out"
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
# La política de CI está escrita **antes** de añadir workflows (v1.4.0), y lo que decide es
# comprobable: el comando sale del catálogo en vez de copiarse, la CI comprueba y **no**
# firma el acta de `docs/evidence/`, y el SAST del repositorio no es el verbo `verify`.
CI_POLICY="$REPO/docs/WORKFLOW.md"
assert_contains 'CI: la política vive donde vive el ciclo' 'CI por submódulo' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el comando no se copia del catálogo' 'no se copia del catálogo, se le pide al catálogo' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: llama a los verbos del catálogo' '`glot test`' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la CI comprueba y no firma' 'la CI comprueba y no firma' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la CI no escribe el acta' 'no escribe' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el SAST del repositorio no es verify' 'no el verbo `verify`' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: el workflow que copia queda como excepción' 'excepción declarada' "$(cat -- "$CI_POLICY")"
assert_contains 'CI: la excepción se nombra' 'ada/.github/workflows/tests.yml' "$(cat -- "$CI_POLICY")"

# Punto 5 del plan: las filas de `toolchains.tsv` que se pueden medir en este entorno ya
# están (`ada`, `common-lisp`, `rexx`, `scala`), y `rescript` queda como excepción
# declarada porque su toolchain no está instalada aquí. La fila solo se añade con la serie
# **verificada**: la deuda era no poder medirlas, y estas cuatro se midieron el 2026-09-27.
assert_contains 'toolchains: ada con su serie medida' "$(printf 'ada\talr --version\t2.1')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: common-lisp con su serie medida' "$(printf 'common-lisp\tros run -- --version\t2.6')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: rexx con su serie medida' "$(printf 'rexx\trexx -v\t5.2')" "$(cat -- "$TOOLCHAINS")"
assert_contains 'toolchains: scala con su serie medida' "$(printf 'scala\tscalac -version\t3.9')" "$(cat -- "$TOOLCHAINS")"
assert_eq 'toolchains: rescript sigue sin fila (no medible aquí)' '0' \
    "$(grep -c '^rescript' "$TOOLCHAINS" || true)"

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
assert_eq 'completado --delegate: los dos valores, ni uno más' 'antigravity copilot' \
    "$(printf '%s\n' "$out" | LC_ALL=C sort | tr '\n' ' ' | sed 's/ $//')"

completion_probe ask --delegate=c
assert_contains 'completado --delegate=c: completa el valor pegado' '--delegate=copilot' "$out"
assert_eq 'completado --delegate=c: filtra por la letra' 'no' \
    "$([[ "$out" == *--delegate=antigravity* ]] && echo si || echo no)"

completion_probe ask --delegate=
assert_eq 'completado --delegate=: los dos valores' '--delegate=antigravity --delegate=copilot' \
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
assert_contains 'completado zsh: ask tiene su propia rama' '        ask)' "$ZSH_COMP"
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
