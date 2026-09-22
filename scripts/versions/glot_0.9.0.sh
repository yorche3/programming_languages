#!/usr/bin/env bash
# glot 0.9.0 — contrato, dispatcher, almacén de estado (L1), asignación (L2),
# catálogo (L2.5), ejecución (L3), delegación (L4) y creación (L5): `new` y `save`.
#
# Snapshot archivado: versión cerrada el 2026-09-22. No se edita; el código es
# el mismo que tenía la versión viva en su cierre.
# No asume rutas del usuario: el script se localiza con BASH_SOURCE y la raíz del
# monorepo se resuelve con GLOT_ROOT, el superproyecto o la raíz de git.
# El estado vive fuera del repositorio (XDG) y se puede redirigir con GLOT_STATE_FILE.
#
# Uso / Usage:
#   ./versions/glot_0.9.0.sh help
#   ./scripts/glot.sh doctor
#   ./scripts/glot.sh langs
#   ./scripts/glot.sh modules algorithms
#   ./scripts/glot.sh progress
#   ./scripts/glot.sh use php algorithms/naive_sort
#   ./scripts/glot.sh new
#   ./scripts/glot.sh save 4a
#   ./scripts/glot.sh set lang php
#   ./scripts/glot.sh get lang
#   ./scripts/glot.sh list
#   ./scripts/glot.sh unset lang

set -euo pipefail

GLOT_VERSION="0.9.0"

# Contrato L0: stdout solo dato, stderr solo diagnóstico.
# Códigos: 0 correcto · 1 error de entorno · 2 uso incorrecto · 3 estado ilegible
# · 4 lo ejecutado falló (la suite en rojo, el verificador con hallazgos o el
#   inicializador sin poder crear el esqueleto).

_glot_error() { printf 'glot: error: %s\n' "$*" >&2; }
_glot_warn() { printf 'glot: aviso / warning: %s\n' "$*" >&2; }

_glot_quiet=0
_glot_dry_run=0
_glot_info() { ((_glot_quiet)) || printf '%s\n' "$*" >&2; }

# _glot_script_dir — carpeta real del propio script, sin rutas del usuario.
_glot_script_dir() {
    local path="${BASH_SOURCE[0]}"
    while [[ -L "$path" ]]; do
        path="$(readlink -- "$path")"
    done
    (cd -- "$(dirname -- "$path")" && pwd -P)
}
GLOT_SCRIPT_DIR="$(_glot_script_dir)"

# _glot_repo_root — raíz del monorepo: GLOT_ROOT > superproyecto > raíz git.
_glot_repo_root() {
    local root=""

    if [[ -n "${GLOT_ROOT:-}" ]]; then
        printf '%s\n' "$GLOT_ROOT"
        return 0
    fi

    root="$(git rev-parse --show-superproject-working-tree 2>/dev/null || true)"
    if [[ -z "$root" ]]; then
        root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
    fi

    [[ -n "$root" ]] || return 1
    printf '%s\n' "$root"
}

# --- almacén de estado (L1) --------------------------------------------------

# _glot_state_dir — directorio del estado: GLOT_STATE_DIR > XDG_STATE_HOME > ~/.local/state.
# Si no hay ninguna de las tres fuentes (HOME sin definir, contexto de cron o
# systemd), falla con un mensaje propio en vez de abortar por `set -u`.
_glot_state_dir() {
    local base=""

    base="${GLOT_STATE_DIR:-${XDG_STATE_HOME:-}}"
    if [[ -z "$base" ]]; then
        if [[ -z "${HOME:-}" ]]; then
            _glot_error 'sin HOME ni XDG_STATE_HOME: define GLOT_STATE_DIR / no HOME or XDG_STATE_HOME: set GLOT_STATE_DIR'
            return 1
        fi
        base="$HOME/.local/state"
    fi

    printf '%s\n' "$base/glot"
}

# _glot_state_file — archivo del estado: GLOT_STATE_FILE > <dir>/state.
_glot_state_file() {
    local dir=""

    if [[ -n "${GLOT_STATE_FILE:-}" ]]; then
        printf '%s\n' "$GLOT_STATE_FILE"
        return 0
    fi

    dir="$(_glot_state_dir)" || return 1
    printf '%s\n' "$dir/state"
}

# _glot_key_valid — las claves solo admiten letras, dígitos, punto, guion y guion bajo.
_glot_key_valid() {
    [[ "$1" =~ ^[A-Za-z0-9_.-]+$ ]]
}

# _glot_value_valid — un valor no puede traer saltos de línea: partiría el archivo.
_glot_value_valid() {
    [[ "$1" != *$'\n'* && "$1" != *$'\r'* ]]
}

# _glot_state_get <clave> — imprime el valor; 1 si la clave no existe.
_glot_state_get() {
    local key="$1"
    local file=""
    local line=""

    file="$(_glot_state_file)" || return 3
    [[ -r "$file" ]] || return 1

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        if [[ "$line" == "$key"=* ]]; then
            printf '%s\n' "${line#"$key"=}"
            return 0
        fi
    done <"$file"

    return 1
}

# _glot_state_list — imprime el estado como clave=valor, ordenado por clave.
_glot_state_list() {
    local file=""
    local line=""

    file="$(_glot_state_file)" || return 3
    [[ -r "$file" ]] || return 0

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        printf '%s\n' "$line"
    done <"$file" | LC_ALL=C sort -t= -k1,1
}

# _glot_state_keys — imprime solo las claves, ordenadas.
_glot_state_keys() {
    local line=""

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        printf '%s\n' "${line%%=*}"
    done < <(_glot_state_list)
}

# _glot_state_rewrite set|unset <clave> [valor] — reescribe el archivo del estado
# con la clave actualizada o eliminada. Escritura atómica (temporal + mv) bajo un
# lock (flock) para que dos terminales no se pisen, y permisos 600/700.
_glot_state_rewrite() {
    local mode="$1"
    local key="$2"
    local value="${3:-}"
    local file=""
    local dir=""
    local rc=0

    file="$(_glot_state_file)" || return 3
    dir="$(dirname -- "$file")"

    if ! mkdir -p -- "$dir"; then
        _glot_error "no se pudo crear el directorio del estado / cannot create state directory: $dir"
        return 3
    fi
    chmod 700 -- "$dir" 2>/dev/null || true

    (
        flock 9 || exit 3

        local tmp=""
        local line=""
        local found=0

        tmp="$(mktemp --tmpdir="$dir" state.XXXXXX)" || exit 3

        if [[ -r "$file" ]]; then
            while IFS= read -r line || [[ -n "$line" ]]; do
                [[ -z "$line" ]] && continue
                if [[ "$line" == "$key"=* ]]; then
                    if [[ "$mode" == "set" ]]; then
                        printf '%s=%s\n' "$key" "$value" >>"$tmp"
                    fi
                    found=1
                else
                    printf '%s\n' "$line" >>"$tmp"
                fi
            done <"$file"
        fi

        if ((found == 0)) && [[ "$mode" == "set" ]]; then
            printf '%s=%s\n' "$key" "$value" >>"$tmp"
        fi

        chmod 600 -- "$tmp" 2>/dev/null || true

        if ! mv -f -- "$tmp" "$file"; then
            rm -f -- "$tmp"
            exit 3
        fi
    ) 9>"$file.lock" || rc=$?

    if ((rc != 0)); then
        _glot_error "no se pudo escribir el estado / cannot write state: $file"
        return 3
    fi

    return 0
}

_glot_hint() { printf 'glot: prueba / try: glot help\n' >&2; }

# --- verbos ------------------------------------------------------------------

_glot_cmd_version() {
    printf 'glot %s\n' "$GLOT_VERSION"
}

_glot_cmd_greet() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        if [[ -t 0 ]]; then
            _glot_error 'falta el nombre / missing name (glot greet <nombre>)'
            return 2
        fi
        IFS= read -r name || true
    fi

    name="${name%$'\r'}"

    if [[ -z "$name" ]]; then
        _glot_error 'falta el nombre / missing name (glot greet <nombre>)'
        return 2
    fi

    printf 'Hello, %s!\n' "$name"
}

_glot_cmd_doctor() {
    local status=0
    local root=""
    local state_dir=""
    local state_file=""

    _glot_info 'glot doctor — diagnóstico / diagnostics'

    printf 'version: %s\n' "$GLOT_VERSION"
    printf 'script_dir: %s\n' "$GLOT_SCRIPT_DIR"
    printf 'bash: %s\n' "$BASH_VERSION"

    if ((BASH_VERSINFO[0] < 4)); then
        printf 'bash_ok: no (se requiere bash 4 o superior / bash 4+ required)\n'
        status=1
    else
        printf 'bash_ok: yes\n'
    fi

    if command -v git >/dev/null 2>&1; then
        printf 'git: %s\n' "$(git --version)"
    else
        printf 'git: (no encontrado / not found)\n'
        status=1
    fi

    local tool=""
    for tool in flock mktemp sort awk cat; do
        if command -v "$tool" >/dev/null 2>&1; then
            printf '%s: %s\n' "$tool" "$(command -v "$tool")"
        else
            printf '%s: (no encontrado / not found)\n' "$tool"
            status=1
        fi
    done

    if root="$(_glot_repo_root)"; then
        printf 'root: %s\n' "$root"
    else
        printf 'root: (no detectado / not detected)\n'
        _glot_warn 'define GLOT_ROOT o ejecuta dentro del monorepo / set GLOT_ROOT or run inside the monorepo'
        status=1
    fi

    if state_dir="$(_glot_state_dir)"; then
        if [[ -d "$state_dir" ]]; then
            printf 'state_dir: %s (existe / exists)\n' "$state_dir"
        else
            printf 'state_dir: %s (aún no existe / not created yet)\n' "$state_dir"
        fi
    else
        printf 'state_dir: (no resoluble / unresolvable)\n'
        status=1
    fi

    if state_file="$(_glot_state_file)"; then
        printf 'state_file: %s\n' "$state_file"
        if [[ -f "$state_file" ]]; then
            if [[ -r "$state_file" ]]; then
                printf 'state_file_ok: yes (%s claves / keys)\n' "$(_glot_state_keys | wc -l | tr -d ' ')"
            else
                printf 'state_file_ok: no (ilegible / unreadable)\n'
                status=1
            fi
        else
            printf 'state_file_ok: no (todavía sin crear / not created yet)\n'
        fi
    else
        printf 'state_file: (no resoluble / unresolvable)\n'
        status=1
    fi

    local registered=0
    local covered=0
    local verifiers=0
    local runnable=0
    local deferred=0
    local commits=""
    local prompts=""
    local data=""
    if root="$(_glot_repo_root)"; then
        registered="$(_glot_langs | wc -l | tr -d ' ')"
        if data="$(_glot_data_file)"; then
            printf 'data_file: %s\n' "$data"
            covered="$(awk -F'\t' 'END {print NR}' "$data")"
            printf 'native_commands: %s de / of %s\n' "$covered" "$registered"
            verifiers="$(awk -F'\t' '$5 != "-"' "$data" | wc -l | tr -d ' ')"
            printf 'verify_commands: %s de / of %s\n' "$verifiers" "$registered"
            runnable="$(awk -F'\t' '$6 == "tool" || $6 == "manual"' "$data" | wc -l | tr -d ' ')"
            deferred="$(awk -F'\t' '$6 == "deferred"' "$data" | wc -l | tr -d ' ')"
            printf 'new_commands: %s de / of %s (deferred: %s)\n' "$runnable" "$registered" "$deferred"
            if ((covered != registered)); then
                _glot_warn 'el catálogo de datos no cubre los lenguajes registrados / the data catalogue does not cover the registered languages'
                status=1
            fi
        else
            printf 'data_file: (no encontrado / not found)\n'
            status=1
        fi

        if commits="$(_glot_commits_file)"; then
            printf 'commits_file: %s\n' "$commits"
            printf 'commit_steps: %s de / of which %s son del submódulo / are submodule ones\n' \
                "$(_glot_commits_list | wc -l | tr -d ' ')" \
                "$(_glot_commits_list | awk -F'\t' '$3 == "submodule"' | wc -l | tr -d ' ')"
        else
            printf 'commits_file: (no encontrado / not found)\n'
            status=1
        fi

        if prompts="$(_glot_prompts_dir)"; then
            printf 'prompts: %s\n' "$prompts"
            printf 'prompts_ok: %s encargos / requests\n' "$(_glot_prompts_list | wc -l | tr -d ' ')"
        else
            printf 'prompts: (no encontrado / not found)\n'
            status=1
        fi

        if [[ -n "${GLOT_DELEGATE:-}" ]]; then
            printf 'delegate: %s\n' "$GLOT_DELEGATE"
        else
            printf 'delegate: (sin configurar / not configured)\n'
        fi

        local shell=""
        for shell in bash zsh; do
            if _glot_completion_file "$shell" >/dev/null; then
                printf 'completion_%s: yes\n' "$shell"
            else
                printf 'completion_%s: no (no encontrado / not found)\n' "$shell"
                status=1
            fi
        done

        if data="$(_glot_roadmap_modules)"; then
            printf 'roadmap_modules: %s\n' "$(printf '%s\n' "$data" | wc -l | tr -d ' ')"
        else
            printf 'roadmap_modules: (no reconocido / not recognised)\n'
            status=1
        fi
    fi

    return "$status"
}

# --- verbos del almacén ------------------------------------------------------

_glot_cmd_set() {
    local key="${1:-}"
    local value="${2:-}"

    if [[ $# -lt 2 ]]; then
        _glot_error 'faltan argumentos / missing arguments (glot set <clave> <valor>)'
        return 2
    fi
    if ! _glot_key_valid "$key"; then
        _glot_error "clave inválida / invalid key: $key (admite / allows [A-Za-z0-9_.-])"
        return 2
    fi
    if ! _glot_value_valid "$value"; then
        _glot_error 'el valor no admite saltos de línea / value does not accept line breaks'
        return 2
    fi

    if ((_glot_dry_run)); then
        printf '%s=%s\n' "$key" "$value"
        return 0
    fi

    _glot_state_rewrite set "$key" "$value" || return $?
    _glot_info "set: $key"
    return 0
}

_glot_cmd_get() {
    local key="${1:-}"
    local value=""

    if [[ -z "$key" ]]; then
        _glot_error 'falta la clave / missing key (glot get <clave>)'
        return 2
    fi
    if ! _glot_key_valid "$key"; then
        _glot_error "clave inválida / invalid key: $key"
        return 2
    fi

    local rc=0
    value="$(_glot_state_get "$key")" || rc=$?
    if ((rc == 0)); then
        printf '%s\n' "$value"
        return 0
    fi
    if ((rc == 3)); then
        return 3
    fi

    _glot_error "clave no encontrada / key not found: $key"
    return 1
}

_glot_cmd_unset() {
    local key="${1:-}"

    if [[ -z "$key" ]]; then
        _glot_error 'falta la clave / missing key (glot unset <clave>)'
        return 2
    fi
    if ! _glot_key_valid "$key"; then
        _glot_error "clave inválida / invalid key: $key"
        return 2
    fi

    if ((_glot_dry_run)); then
        printf 'unset %s\n' "$key"
        return 0
    fi

    if ! _glot_state_get "$key" >/dev/null; then
        _glot_info "unset: $key (no estaba / was not set)"
        return 0
    fi

    _glot_state_rewrite unset "$key" || return $?
    _glot_info "unset: $key"
    return 0
}

_glot_cmd_list() {
    _glot_state_list
}

_glot_cmd_path() {
    local file=""

    file="$(_glot_state_file)" || {
        _glot_error 'no se pudo resolver la ruta del estado / cannot resolve the state path'
        return 1
    }

    printf '%s\n' "$file"
}

# --- verbos del catálogo ------------------------------------------------------

# _glot_cmd_langs — catálogo de lenguajes: lenguaje<TAB>comando nativo de pruebas.
_glot_cmd_langs() {
    local data=""
    local lang=""
    local test_cmd=""

    data="$(_glot_langs)" || {
        _glot_error 'no se pudo leer .gitmodules / cannot read .gitmodules'
        return 1
    }
    if [[ -z "$data" ]]; then
        _glot_error 'no hay lenguajes registrados en .gitmodules / no languages registered in .gitmodules'
        return 1
    fi

    while IFS= read -r lang; do
        test_cmd="$(_glot_native_test "$lang")" || test_cmd="-"
        printf '%s\t%s\n' "$lang" "$test_cmd"
    done <<<"$data"
}

# _glot_cmd_modules [fase] — catálogo de módulos:
#   id<TAB>fase<TAB>modulo<TAB>especificacion
_glot_cmd_modules() {
    local phase="${1:-}"
    local root=""
    local data=""
    local p=""
    local m=""
    local spec=""
    local found=0

    if [[ $# -gt 1 ]]; then
        _glot_error 'uso / usage: glot modules [fase]'
        _glot_hint
        return 2
    fi

    root="$(_glot_repo_root)" || {
        _glot_error 'no se detectó la raíz del monorepo / monorepo root not detected'
        return 1
    }
    data="$(_glot_roadmap_modules)" || return 1

    while IFS=$'\t' read -r p m _ _ _ _; do
        [[ -z "$phase" || "$p" == "$phase" ]] || continue
        spec="$(_glot_spec_path "$root" "$p" "$m")" || spec="-"
        printf '%s\t%s\t%s\t%s\n' "core.$p.$m" "$p" "$m" "$spec"
        found=1
    done <<<"$data"

    if ((found == 0)); then
        _glot_error "fase sin módulos / phase with no modules: $phase"
        return 1
    fi
}

# _glot_cmd_progress [fase] — estado del roadmap. Sin fase imprime los contadores
# globales en clave=valor; con fase, una línea por módulo:
#   modulo<TAB>estado<TAB>hechos<TAB>total
_glot_cmd_progress() {
    local phase="${1:-}"
    local data=""
    local p=""
    local m=""
    local status=""
    local done=0
    local total=0
    local listados="-"
    local registrados=0
    local modulos=0
    local homologados=0
    local pares_hechos=0
    local pares_total=0
    local found=0

    if [[ $# -gt 1 ]]; then
        _glot_error 'uso / usage: glot progress [fase]'
        _glot_hint
        return 2
    fi

    registrados="$(_glot_langs | wc -l | tr -d ' ')"
    data="$(_glot_roadmap_modules)" || return 1

    if [[ -n "$phase" ]]; then
        while IFS=$'\t' read -r p m status done total _; do
            [[ "$p" == "$phase" ]] || continue
            # El denominador es siempre el de lenguajes registrados: los módulos sin
            # contador en el roadmap no lo traen.
            ((total > 0)) || total="$registrados"
            printf '%s\t%s\t%s\t%s\n' "$m" "$status" "$done" "$total"
            found=1
        done <<<"$data"

        if ((found == 0)); then
            _glot_error "fase sin módulos / phase with no modules: $phase"
            return 1
        fi
        return 0
    fi

    while IFS=$'\t' read -r p m status done total listados; do
        modulos=$((modulos + 1))
        pares_hechos=$((pares_hechos + done))
        if ((total > 0)) && ((done == total)); then
            homologados=$((homologados + 1))
        fi
        # El contador del roadmap no debería contradecir su propia lista de lenguajes
        # ni el número de lenguajes registrados.
        if [[ "$listados" != "-" ]] && ((listados != done)); then
            _glot_warn "contador y lista no cuadran / counter and list disagree: core.$p.$m ($done/$total frente a / versus $listados lenguajes)"
        fi
        if ((total > 0)) && ((total != registrados)); then
            _glot_warn "denominador del roadmap distinto de los registrados / roadmap denominator differs from the registered ones: core.$p.$m ($total frente a / versus $registrados)"
        fi
    done <<<"$data"

    pares_total=$((modulos * registrados))

    printf 'registrados=%s\n' "$registrados"
    printf 'homologados=%s\n' "$homologados"
    printf 'modulos=%s\n' "$modulos"
    printf 'pares_hechos=%s\n' "$pares_hechos"
    printf 'pares_total=%s\n' "$pares_total"
}

# _glot_cmd_completion <shell> — imprime el guion de autocompletado en stdout. No lo
# instala: eso es cosa de `install` (v1.0.0), que es quien toca el shell del usuario.
_glot_cmd_completion() {
    local shell="${1:-bash}"
    local file=""

    if [[ $# -gt 1 ]]; then
        _glot_error 'uso / usage: glot completion [bash|zsh]'
        _glot_hint
        return 2
    fi

    case "$shell" in
        bash | zsh) ;;
        *)
            _glot_error "shell no soportado / unsupported shell: $shell"
            _glot_info 'soportados / supported: bash, zsh'
            return 2
            ;;
    esac

    if ! file="$(_glot_completion_file "$shell")"; then
        _glot_error "autocompletado no encontrado / completion not found: glot.$shell"
        return 1
    fi

    cat -- "$file"
}

# --- ejecución (L3) ----------------------------------------------------------

# _glot_exec_target <args...> — resuelve lenguaje, fase y módulo para `test`/`verify`:
# los argumentos mandan y el estado completa lo que falte. Imprime
# `lenguaje<TAB>fase<TAB>módulo` y devuelve 1 si falta un dato o 3 si el estado no se
# puede leer.
_glot_exec_target() {
    local -a pos=()
    local arg=""
    local lang=""
    local target=""
    local phase=""
    local module=""
    local root=""
    local rc=0

    for arg in "$@"; do
        case "$arg" in
            -*)
                _glot_error "opción desconocida / unknown option: $arg"
                _glot_hint
                return 2
                ;;
        esac
        pos+=("$arg")
    done

    case "${#pos[@]}" in
        0) ;;
        1)
            if [[ "${pos[0]}" == */* ]]; then
                target="${pos[0]}"
            else
                lang="${pos[0]}"
            fi
            ;;
        2)
            lang="${pos[0]}"
            target="${pos[1]}"
            ;;
        *)
            _glot_error 'uso / usage: glot <test|verify> [lenguaje] [fase/módulo]'
            _glot_hint
            return 2
            ;;
    esac

    if [[ -z "$lang" ]]; then
        lang="$(_glot_state_get lang)" || rc=$?
        if ((rc == 3)); then
            return 3
        fi
    fi

    if [[ -z "$target" ]]; then
        phase="$(_glot_state_get phase 2>/dev/null || true)"
        module="$(_glot_state_get module 2>/dev/null || true)"
        if [[ -n "$phase" && -n "$module" ]]; then
            target="$phase/$module"
        fi
    fi

    if [[ -z "$lang" || -z "$target" ]]; then
        _glot_error 'faltan datos del sprint / missing sprint data'
        _glot_info 'sitúa el trabajo primero / place the work first: glot use <lenguaje> <fase>/<módulo>'
        return 1
    fi

    phase="${target%%/*}"
    module="${target#*/}"
    if [[ -z "$phase" || -z "$module" || "$phase" == "$target" ]]; then
        _glot_error "fase/módulo mal formados / malformed phase/module: $target"
        return 2
    fi

    if ! _glot_langs | grep -qx -- "$lang"; then
        _glot_error "lenguaje no registrado en .gitmodules / language not in .gitmodules: $lang"
        return 1
    fi

    root="$(_glot_repo_root)" || {
        _glot_error 'no se detectó la raíz del monorepo / monorepo root not detected'
        return 1
    }

    if [[ ! -d "$root/$lang/core/$phase" ]]; then
        _glot_error "fase inexistente / missing phase: $phase"
        return 1
    fi

    if ! module="$(_glot_canon_module "$root" "$phase" "$module")"; then
        _glot_error "módulo desconocido / unknown module: $phase/$module"
        _glot_info "mira el catálogo / check the catalogue: glot modules $phase"
        return 1
    fi

    printf '%s\t%s\t%s\n' "$lang" "$phase" "$module"
}

# _glot_cmd_run test|verify [args...] — cuerpo común de la capa de ejecución: resuelve
# el objetivo, lee la plantilla del catálogo de datos, resuelve sus marcadores y la
# ejecuta en el directorio del módulo. La salida del runner va a stdout tal cual: es el
# dato. Códigos: 0 correcto · 4 la verificación falló.
_glot_cmd_run() {
    local kind="$1"
    local field=""
    local root=""
    local target=""
    local lang=""
    local phase=""
    local module=""
    local dir=""
    local template=""
    local cmd=""
    local rc=0

    shift

    case "$kind" in
        test) field=4 ;;
        verify) field=5 ;;
        *)
            _glot_error "verbo de ejecución desconocido / unknown execution verb: $kind"
            return 2
            ;;
    esac

    target="$(_glot_exec_target "$@")" || return $?

    IFS=$'\t' read -r lang phase module <<<"$target"

    root="$(_glot_repo_root)" || {
        _glot_error 'no se detectó la raíz del monorepo / monorepo root not detected'
        return 1
    }

    template="$(_glot_lang_field "$lang" "$field")" || {
        _glot_error "lenguaje fuera del catálogo de datos / language missing from the data catalogue: $lang"
        _glot_info "revisa / check: glot doctor"
        return 1
    }

    if [[ "$template" == "-" ]]; then
        _glot_info "sin verificador para $lang: se omite / no verifier for $lang: skipped"
        printf 'skipped\n'
        return 0
    fi

    dir="$(_glot_module_dir "$root" "$lang" "$phase" "$module")"
    if [[ ! -d "$dir" ]]; then
        _glot_error "el módulo no existe / module not found: $dir"
        _glot_info "sitúalo primero / place it first: glot use $lang $phase/$module"
        return 1
    fi

    if ! cmd="$(_glot_expand_command "$dir" "$module" "$template")"; then
        return 1
    fi

    if ((_glot_dry_run)); then
        printf 'cd %s && %s\n' "$dir" "$cmd"
        return 0
    fi

    _glot_info "$kind: $cmd"

    (cd -- "$dir" && eval "$cmd") || rc=$?

    if ((rc != 0)); then
        _glot_warn "$kind falló / failed: $lang $phase/$module (código / code $rc)"
        return 4
    fi

    _glot_info "$kind: en verde / green"
    return 0
}

_glot_cmd_test() {
    _glot_cmd_run test "$@"
}

_glot_cmd_verify() {
    _glot_cmd_run verify "$@"
}

# --- delegación (L4) ---------------------------------------------------------

# _glot_prompts_dir — carpeta de las plantillas versionadas del tooling.
_glot_prompts_dir() {
    local dir=""

    for dir in "$GLOT_SCRIPT_DIR/prompts" "$GLOT_SCRIPT_DIR/../prompts"; do
        if [[ -d "$dir" ]]; then
            printf '%s\n' "$dir"
            return 0
        fi
    done

    return 1
}

# _glot_prompt_file <encargo> — plantilla del encargo. Manda la versionada y, si no
# está, se acepta la del banco local con un aviso: esa no viaja en el repositorio.
_glot_prompt_file() {
    local name="$1"
    local dir=""
    local local_dir=""

    if dir="$(_glot_prompts_dir)" && [[ -r "$dir/$name.prompt.md" ]]; then
        printf '%s\n' "$dir/$name.prompt.md"
        return 0
    fi

    local_dir="$(_glot_repo_root 2>/dev/null || true)/.github/prompts"
    if [[ -r "$local_dir/$name.prompt.md" ]]; then
        _glot_warn "plantilla local y no versionada / local, unversioned template: $local_dir/$name.prompt.md"
        printf '%s\n' "$local_dir/$name.prompt.md"
        return 0
    fi

    return 1
}

# _glot_prompt_field <archivo> <campo> — campo del frontmatter de la plantilla.
_glot_prompt_field() {
    local file="$1"
    local field="$2"
    local line=""
    local seen=0

    while IFS= read -r line; do
        if ((seen < 2)) && [[ "$line" == "---" ]]; then
            seen=$((seen + 1))
            continue
        fi
        ((seen >= 2)) && break
        if [[ "$line" == "$field: "* ]]; then
            printf '%s\n' "${line#"$field: "}"
            return 0
        fi
    done <"$file"

    return 1
}

# _glot_prompt_body <archivo> — la plantilla sin el frontmatter de VS Code, que al
# pegar el encargo solo estorba.
_glot_prompt_body() {
    local file="$1"
    local line=""
    local seen=0

    while IFS= read -r line; do
        if ((seen < 2)) && [[ "$line" == "---" ]]; then
            seen=$((seen + 1))
            continue
        fi
        ((seen >= 2)) && printf '%s\n' "$line"
    done <"$file"
}

# _glot_prompts_list — registro de encargos: nombre<TAB>paso<TAB>descripción.
_glot_prompts_list() {
    local dir=""
    local file=""
    local name=""
    local step=""
    local desc=""

    dir="$(_glot_prompts_dir)" || {
        _glot_error "no hay carpeta de plantillas / no prompts directory"
        return 1
    }

    for file in "$dir/"*.prompt.md; do
        [[ -e "$file" ]] || continue
        name="$(_glot_prompt_field "$file" name)" || name="$(basename -- "$file" .prompt.md)"
        step="$(_glot_prompt_field "$file" step)" || step="-"
        desc="$(_glot_prompt_field "$file" description)" || desc="-"
        printf '%s\t%s\t%s\n' "$name" "$step" "$desc"
    done
}

# _glot_expand_state <lenguaje> <fase> <módulo> <texto> — resuelve los marcadores con
# las claves del estado del sprint, más `{Module}` (PascalCase) y `{module_dir}`.
# Un marcador que no se pueda resolver es un error: nunca texto literal escondido.
_glot_expand_state() {
    local lang="$1"
    local phase="$2"
    local module="$3"
    local text="$4"
    local root=""
    local spec=""
    local branch=""
    local marker=""

    root="$(_glot_repo_root)" || return 1
    spec="$(_glot_spec_path "$root" "$phase" "$module" || true)"
    branch="$(git -C "$root/$lang" symbolic-ref --short -q HEAD || true)"

    text="${text//\{lang\}/$lang}"
    text="${text//\{phase\}/$phase}"
    text="${text//\{module\}/$module}"
    text="${text//\{Module\}/$(_glot_pascal "$module")}"
    text="${text//\{repo\}/$lang}"
    text="${text//\{branch\}/$branch}"
    text="${text//\{spec\}/$spec}"
    text="${text//\{module_dir\}/$(_glot_module_dir "$root" "$lang" "$phase" "$module")}"

    if [[ "$text" =~ \{[A-Za-z_][A-Za-z_0-9]*\} ]]; then
        marker="${BASH_REMATCH[0]}"
        _glot_error "marcador sin resolver / unresolved placeholder: $marker"
        _glot_info "en la plantilla solo valen lang, phase, module, Module, repo, branch, spec y module_dir"
        _glot_info "only lang, phase, module, Module, repo, branch, spec and module_dir are valid in a template"
        return 1
    fi

    printf '%s\n' "$text"
}

# _glot_prompt_build <encargo> [lenguaje] [fase/módulo] — encargo completo: cabecera
# con el estado del sprint y la plantilla expandida. Es el dato de `prompt`.
_glot_prompt_build() {
    local name="$1"
    local file=""
    local target=""
    local lang=""
    local phase=""
    local module=""
    local body=""
    local root=""
    local branch=""
    local spec=""

    shift

    if ! file="$(_glot_prompt_file "$name")"; then
        _glot_error "encargo desconocido / unknown request: $name"
        _glot_info "disponibles / available: glot prompt"
        return 1
    fi

    target="$(_glot_exec_target "$@")" || return $?
    IFS=$'\t' read -r lang phase module <<<"$target"

    root="$(_glot_repo_root)" || return 1
    branch="$(git -C "$root/$lang" symbolic-ref --short -q HEAD || true)"
    spec="$(_glot_spec_path "$root" "$phase" "$module" || true)"

    if ! body="$(_glot_prompt_body "$file")"; then
        _glot_error "no se pudo leer la plantilla / cannot read the template: $file"
        return 1
    fi
    if ! body="$(_glot_expand_state "$lang" "$phase" "$module" "$body")"; then
        return 1
    fi

    printf '# Encargo `%s` — %s %s/%s\n\n' "$name" "$lang" "$phase" "$module"
    printf '| Clave | Valor |\n|-------|-------|\n'
    printf '| lang | %s |\n' "$lang"
    printf '| phase | %s |\n' "$phase"
    printf '| module | %s |\n' "$module"
    printf '| branch | %s |\n' "${branch:-detached}"
    printf '| spec | %s |\n' "${spec:--}"
    printf '| repo | %s |\n' "$lang"
    printf '| module_dir | %s |\n' "$(_glot_module_dir "$root" "$lang" "$phase" "$module")"
    printf '\n---\n\n%s\n' "$body"
}

# _glot_cmd_prompt [encargo] [lenguaje] [fase/módulo] — sin encargo, lista el
# registro; con encargo, imprime el encargo armado en stdout. No muta nada.
_glot_cmd_prompt() {
    local name="${1:-}"

    if [[ -z "$name" ]]; then
        _glot_prompts_list
        return $?
    fi

    _glot_prompt_build "$name" "${@:2}"
}

# _glot_cmd_ask <encargo> [lenguaje] [fase/módulo] — arma el mismo encargo y lo envía
# a `GLOT_DELEGATE` por stdin. Sin delegado configurado no hay nada que hacer: 1.
_glot_cmd_ask() {
    local name="${1:-}"
    local request=""
    local rc=0

    if [[ -z "$name" ]]; then
        _glot_error 'falta el encargo / missing request'
        _glot_error 'uso / usage: glot ask <encargo> [lenguaje] [fase/módulo]'
        _glot_info 'disponibles / available: glot prompt'
        return 2
    fi

    request="$(_glot_prompt_build "$name" "${@:2}")" || return $?

    if [[ -z "${GLOT_DELEGATE:-}" ]]; then
        _glot_error 'no hay delegado configurado / no delegate configured'
        _glot_info 'define GLOT_DELEGATE o imprime el encargo / set GLOT_DELEGATE or print it: glot prompt '"$name"
        return 1
    fi

    if ((_glot_dry_run)); then
        printf '<encargo de %s> | %s\n' "$name" "$GLOT_DELEGATE"
        return 0
    fi

    _glot_info "delegado / delegate: $GLOT_DELEGATE"
    printf '%s\n' "$request" | eval "$GLOT_DELEGATE" || rc=$?

    if ((rc != 0)); then
        _glot_error "el delegado falló / the delegate failed: código / code $rc"
        return 1
    fi

    return 0
}

# --- creación y registro (L5) ------------------------------------------------

# _glot_init_flat <directorio> <sub> — sube al directorio del módulo el contenido de
# `<sub>` (incluidos los archivos ocultos) y borra `<sub>`. Es la normalización de los
# inicializadores que crean el proyecto como hijo del directorio donde se ejecutan
# (`crystal init lib {module}` dentro de `{module}/` anida dos veces).
_glot_init_flat() {
    local dir="$1"
    local sub="$2"
    local entry=""
    local rc=0

    [[ -d "$dir/$sub" ]] || return 0

    shopt -s dotglob nullglob
    for entry in "$dir/$sub"/*; do
        if ! mv -f -- "$entry" "$dir/"; then
            rc=1
            break
        fi
    done
    shopt -u dotglob nullglob

    ((rc == 0)) || return 1
    rmdir -- "$dir/$sub" 2>/dev/null || true
    return 0
}

# _glot_init_normalise <directorio> <módulo> <operaciones> — aplica la normalización
# declarada en el catálogo, en orden. Cada operación admite `{module}` y `{Module}`.
# Ninguna adivina: si el catálogo no la trae, no se toca nada.
_glot_init_normalise() {
    local dir="$1"
    local module="$2"
    local ops="$3"
    local op=""
    local path=""
    local sub=""
    local IFS=';'

    for op in $ops; do
        [[ -n "$op" ]] || continue
        op="$(_glot_expand_command "$dir" "$module" "$op")" || return 1

        case "$op" in
            flat:*)
                sub="${op#flat:}"
                _glot_info "normalizar / normalise: flat $sub"
                _glot_init_flat "$dir" "$sub" || {
                    _glot_error "no se pudo aplanar / cannot flatten: $dir/$sub"
                    return 1
                }
                ;;
            rm:*)
                path="${op#rm:}"
                _glot_info "normalizar / normalise: rm $path"
                rm -rf -- "$dir/$path" 2>/dev/null || true
                ;;
            *)
                _glot_error "operación de normalización desconocida / unknown normalisation operation: $op"
                _glot_info 'solo valen flat:<sub> y rm:<ruta> / only flat:<sub> and rm:<path> are valid'
                return 1
                ;;
        esac
    done

    return 0
}

# _glot_cmd_new [lenguaje] [fase/módulo] — inicializador y esqueleto mecánico del
# módulo. Ejecuta el comando del catálogo en el directorio del módulo cuando el
# lenguaje tiene herramienta (`tool`), crea la estructura de carpetas cuando el
# esqueleto es manual (`manual`) y normaliza lo que deja la herramienta (aplanar el
# nido, quitar el `.git` anidado, descartar el vendoring que el repositorio rechaza).
# No escribe la suite —eso es el encargo `suite`— y no confirma nada: eso es `save`.
# El directorio del módulo lo prepara `use`; si no está, `new` no lo inventa.
# Códigos: 0 correcto (o `skipped`) · 1 entorno · 2 uso · 4 el inicializador falló.
_glot_cmd_new() {
    local target=""
    local lang=""
    local phase=""
    local module=""
    local root=""
    local dir=""
    local kind=""
    local run=""
    local fix=""
    local cmd=""
    local rc=0

    target="$(_glot_exec_target "$@")" || return $?
    IFS=$'\t' read -r lang phase module <<<"$target"

    root="$(_glot_repo_root)" || {
        _glot_error 'no se detectó la raíz del monorepo / monorepo root not detected'
        return 1
    }

    kind="$(_glot_init_kind "$lang")" || {
        _glot_error "lenguaje fuera del catálogo de datos / language missing from the data catalogue: $lang"
        _glot_info 'revisa / check: glot doctor'
        return 1
    }

    dir="$(_glot_module_dir "$root" "$lang" "$phase" "$module")"
    if [[ ! -d "$dir" ]]; then
        _glot_error "el módulo no existe / module not found: $dir"
        _glot_info "sitúalo primero / place it first: glot use $lang $phase/$module"
        return 1
    fi

    # El tipo manda: sin inicializador validado no se adivina nada.
    case "$kind" in
        tool | manual) ;;
        deferred)
            _glot_info "sin inicializador validado para $lang / no verified initializer for $lang"
            _glot_info "lo escribe el agente / the agent writes it: glot prompt scaffold $lang $phase/$module"
            printf 'skipped\n'
            return 0
            ;;
        *)
            _glot_error "tipo de inicialización desconocido / unknown initialisation kind: $kind ($lang)"
            return 1
            ;;
    esac

    run="$(_glot_init_run "$lang")" || run="-"
    fix="$(_glot_init_fix "$lang")" || fix="-"
    if [[ "$run" == "-" || -z "$run" ]]; then
        _glot_error "el catálogo no trae comando de inicialización / no initialisation command in the catalogue: $lang"
        _glot_info 'revisa / check: scripts/data/languages.tsv'
        return 1
    fi

    cmd="$(_glot_expand_command "$dir" "$module" "$run")" || return 1

    # Ensayo: el plan, sin tocar el disco.
    if ((_glot_dry_run)); then
        printf 'cd %s && %s\n' "$dir" "$cmd"
        [[ "$fix" != "-" ]] && printf '# normalizar / normalise: %s\n' "$(_glot_expand_command "$dir" "$module" "$fix")"
        [[ "$kind" == "manual" ]] && printf '# el manifiesto y la suite son del encargo / manifest and suite belong to the request\n'
        printf '%s\n' "$dir"
        return 0
    fi

    # El directorio del módulo lo deja vacío `use`. Con contenido, el esqueleto ya
    # está hecho: no se pisa nada (misma política que `use` con un módulo existente).
    if [[ -n "$(ls -A -- "$dir" 2>/dev/null)" ]]; then
        _glot_warn "el módulo ya tiene contenido, no se genera esqueleto / module already has content, no scaffolding: $dir"
        printf '%s\n' "$dir"
        return 0
    fi

    _glot_info "new: $cmd"
    (cd -- "$dir" && eval "$cmd") </dev/null || rc=$?

    if ((rc != 0)); then
        _glot_warn "new falló / failed: $lang $phase/$module (código / code $rc)"
        _glot_info "el directorio queda como está / the directory is left as it is: $dir"
        return 4
    fi

    if [[ "$fix" != "-" && -n "$fix" ]]; then
        if ! _glot_init_normalise "$dir" "$module" "$fix"; then
            _glot_warn "new falló al normalizar / failed while normalising: $lang $phase/$module"
            return 4
        fi
    fi

    if [[ "$kind" == "manual" ]]; then
        _glot_info "estructura manual creada / manual layout created: $dir"
        _glot_info "el manifiesto y la suite son del encargo / manifest and suite belong to the request: glot prompt scaffold $lang $phase/$module"
    fi

    printf '%s\n' "$dir"
    return 0
}

# _glot_cmd_save <paso|alias> [lenguaje] [fase/módulo] — commit guiado con la
# convención del repositorio. El mensaje no se escribe a mano: sale del catálogo de
# commits (`data/commits.tsv`), que es la tabla del sprint puesta en datos. Añade el
# submódulo completo al índice y confirma en el submódulo. No hace push, no toca el
# puntero del monorepo ni el roadmap (eso es `pointer`, v0.11.0, y `close`, v0.10.0).
# Códigos: 0 confirmado (o `nothing`) · 1 entorno · 2 uso · 3 no se pudo escribir.
_glot_cmd_save() {
    local step="${1:-}"
    local target=""
    local lang=""
    local phase=""
    local module=""
    local root=""
    local sub=""
    local folder=""
    local scope=""
    local msg=""
    local porcelain=""
    local outside=""
    local branch=""
    local state_branch=""
    local sha=""

    if [[ -z "$step" ]]; then
        _glot_error 'falta el paso del sprint / missing sprint step'
        _glot_info 'uso / usage: glot save <paso|alias> [lenguaje] [fase/módulo]'
        # Dato para el autor y para el autocompletado: los pasos que sí se confirman aquí.
        _glot_commits_list 2>/dev/null | awk -F'\t' '$3 == "submodule"' || true
        return 2
    fi
    shift

    target="$(_glot_exec_target "$@")" || return $?
    IFS=$'\t' read -r lang phase module <<<"$target"

    if ! _glot_commit_line "$step" >/dev/null; then
        _glot_error "paso desconocido / unknown step: $step"
        _glot_info 'mira el catálogo / check the catalogue: scripts/data/commits.tsv'
        return 2
    fi

    scope="$(_glot_commit_field "$step" 3)"
    if [[ "$scope" != "submodule" ]]; then
        _glot_error "ese paso se confirma en el monorepo / that step is committed in the monorepo: $step"
        _glot_info "llega con close (v0.10.0) y pointer (v0.11.0) / it arrives with close (v0.10.0) and pointer (v0.11.0)"
        return 1
    fi

    msg="$(_glot_expand_state "$lang" "$phase" "$module" "$(_glot_commit_field "$step" 4)")" || return $?

    root="$(_glot_repo_root)" || {
        _glot_error 'no se detectó la raíz del monorepo / monorepo root not detected'
        return 1
    }

    sub="$root/$lang"
    if [[ ! -e "$sub/.git" ]]; then
        _glot_error "submódulo sin inicializar / submodule not initialised: $lang"
        _glot_info "prueba / try: git submodule update --init -- $lang"
        return 1
    fi

    porcelain="$(git -C "$sub" status --porcelain 2>/dev/null || true)"
    if [[ -z "$porcelain" ]]; then
        _glot_warn "no hay nada que confirmar / nothing to commit: $lang"
        printf 'nothing\n'
        return 0
    fi

    # Hallazgos del estado sucio: se nombran antes de confirmar, sin bloquear.
    folder="$(_glot_module_folder "$root" "$lang" "$phase" "$module" || printf '%s' "$module")"
    outside="$(printf '%s\n' "$porcelain" | grep -vE "core/$phase/$folder(/|\$)" || true)"
    if [[ -n "$outside" ]]; then
        _glot_warn "hay cambios fuera del módulo que también entran / there are changes outside the module that go in too"
        printf '%s\n' "$outside" | sed 's/^/  /' >&2
    fi

    branch="$(git -C "$sub" symbolic-ref --short -q HEAD || true)"
    state_branch="$(_glot_state_get branch 2>/dev/null || true)"
    if [[ -n "$state_branch" && -n "$branch" && "$state_branch" != "$branch" ]]; then
        _glot_warn "la rama del sprint no es la activa / the sprint branch is not the active one"
        _glot_info "estado / state: $state_branch; activa / active: $branch"
    fi

    if ((_glot_dry_run)); then
        printf 'git -C %s add -A\n' "$sub"
        printf "git -C %s commit -m '%s'\n" "$sub" "$msg"
        return 0
    fi

    _glot_info "save: $msg"

    if ! git -C "$sub" add -A 2>/dev/null; then
        _glot_error "no se pudo preparar el índice / cannot stage: $sub"
        return 3
    fi

    if ! git -C "$sub" commit -q -m "$msg" 2>/dev/null; then
        _glot_error "no se pudo confirmar / cannot commit: $lang $phase/$module"
        return 4
    fi

    sha="$(git -C "$sub" rev-parse --short HEAD)"
    printf '%s\n' "$sha"
    _glot_info "sin push y sin tocar el puntero del monorepo / no push and the monorepo pointer is untouched"
    return 0
}

_glot_usage() {
    cat <<'EOF'
glot — CLI del monorepo / monorepo CLI

Uso / Usage:
  glot <verbo> [argumentos]

Verbos / Verbs:
  version            Versión instalada / installed version
  help [verbo]       Esta ayuda o la de un verbo / this help or a verb's
  doctor             Diagnóstico del entorno y del repositorio / environment check
  greet [nombre]     Saludo; el nombre llega por argumento o stdin
                     Greeting; the name comes as an argument or from stdin
  hello [nombre]     Igual que greet (compatibilidad v0.2.0, se retira en v1.0.0)
                     Same as greet (v0.2.0 compatibility, removed in v1.0.0)
  set <clave> <valor> Guarda una clave del estado / stores a state key
  get <clave>        Imprime el valor de la clave / prints the key value
  unset <clave>      Elimina la clave / removes the key
  list                Lista el estado como clave=valor / lists state as key=value
  path                Imprime la ruta del archivo de estado / prints the state file path
  langs               Catálogo de lenguajes: lenguaje<TAB>prueba nativa
                     Language catalogue: language<TAB>native test command
  modules [fase]      Catálogo de módulos del roadmap: id<TAB>fase<TAB>módulo<TAB>especificación
                     Roadmap module catalogue: id<TAB>phase<TAB>module<TAB>specification
  progress [fase]     Estado del roadmap: contadores globales, o una línea por módulo
                     de la fase / roadmap state: global counters, or one line per module
  completion [shell]  Imprime el autocompletado en stdout (bash|zsh)
                     Prints the completion script to stdout (bash|zsh)
  test [lenguaje] [fase/módulo]
                     Ejecuta la suite del módulo asignado en su directorio; la salida
                     del runner va a stdout. Sin argumentos usa el estado del sprint
                     Runs the assigned module's suite in its directory; the runner's
                     output goes to stdout. With no arguments it uses the sprint state
  verify [lenguaje] [fase/módulo]
                     Ejecuta el verificador (sintaxis/lint) del lenguaje; `skipped` si
                     el lenguaje aún no tiene uno
                     Runs the language verifier (syntax/lint); `skipped` when the
                     language has none yet
  prompt [encargo] [lenguaje] [fase/módulo]
                     Sin encargo, lista el registro; con encargo, imprime el encargo
                     armado con el estado del sprint. No muta nada
                     With no request it lists the registry; with one it prints the
                     request built from the sprint state. It mutates nothing
  ask <encargo> [lenguaje] [fase/módulo]
                     Arma el encargo y lo envía a GLOT_DELEGATE por stdin
                     Builds the request and pipes it to GLOT_DELEGATE
  use <lenguaje> <fase>/<módulo> [tipo]
                     Sitúa el trabajo: valida y, con el árbol limpio, activa o crea
                     la rama {tipo}/{fase}/{módulo} desde main y la publica con
                     upstream; con trabajo sin confirmar solo informa (si ya estás
                     en la rama, la republica). Guarda el estado e imprime la ruta
                     Locates the work: validates and, with a clean tree, activates or
                     creates the {tipo}/{fase}/{módulo} branch from main and publishes
                     it with upstream; with uncommitted work it only reports (if you
                     are already on the branch, it republishes it). Stores state and
                     prints the module path
  new [lenguaje] [fase/módulo]
                     Inicializa el lenguaje y crea el esqueleto mecánico del módulo:
                     ejecuta el inicializador del catálogo (o crea las carpetas si el
                     esqueleto es manual) y normaliza lo que deja. No escribe la suite
                     Initialises the language and creates the module's mechanical
                     skeleton: runs the catalogue initializer (or creates the folders
                     when the skeleton is manual) and normalises what it leaves. It
                     does not write the suite
  save <paso|alias> [lenguaje] [fase/módulo]
                     Confirma con el mensaje de la convención del repositorio, que sale
                     del catálogo de commits. Sin push y sin tocar el monorepo
                     Commits with the message from the repository convention, taken
                     from the commit catalogue. No push and the monorepo is untouched

Opciones globales / Global options:
  -q, --quiet        Silencia el diagnóstico de stderr / silence stderr diagnostics
  -n, --dry-run      No escribe ni toca git: muestra el plan / writes nothing and touches no git: shows the plan
  -h, --help         Igual que help / same as help
  --version          Igual que version / same as version
EOF
}

_glot_help_verb() {
    case "$1" in
        version | -V | --version)
            printf 'glot version — escribe la versión instalada / prints the installed version\n'
            ;;
        help | -h | --help)
            printf 'glot help [verbo] — ayuda general o de un verbo / general or per-verb help\n'
            ;;
        doctor)
            printf 'glot doctor — diagnóstico: versión de bash, git, raíz del monorepo y ruta del estado\n'
            printf 'glot doctor — diagnostics: bash version, git, monorepo root and state path\n'
            ;;
        greet)
            printf 'glot greet [nombre] — saluda con el nombre dado o leído de stdin\n'
            printf 'glot greet [name] — greets with the given name or one read from stdin\n'
            ;;
        set)
            printf 'glot set <clave> <valor> — guarda una clave en el estado (claves [A-Za-z0-9_.-])\n'
            printf 'glot set <key> <value> — stores a state key (keys [A-Za-z0-9_.-])\n'
            printf 'Claves reservadas / reserved keys: lang, phase, module, branch, spec, repo\n'
            ;;
        get)
            printf 'glot get <clave> — imprime el valor; 1 si la clave no existe\n'
            printf 'glot get <key> — prints the value; 1 when the key does not exist\n'
            ;;
        unset)
            printf 'glot unset <clave> — elimina la clave; es idempotente\n'
            printf 'glot unset <key> — removes the key; it is idempotent\n'
            ;;
        list)
            printf 'glot list — lista el estado como clave=valor ordenado por clave\n'
            printf 'glot list — lists the state as key=value sorted by key\n'
            ;;
        path)
            printf 'glot path — imprime la ruta del archivo de estado\n'
            printf 'glot path — prints the state file path\n'
            ;;
        langs)
            printf 'glot langs — catálogo de lenguajes: lenguaje<TAB>comando nativo de pruebas\n'
            printf 'glot langs — language catalogue: language<TAB>native test command\n'
            printf 'Lenguajes de .gitmodules; el comando nativo sale de data/languages.tsv\n'
            printf 'Languages from .gitmodules; the native command comes from data/languages.tsv\n'
            ;;
        modules)
            printf 'glot modules [fase] — catálogo de módulos del roadmap\n'
            printf 'glot modules [phase] — roadmap module catalogue\n'
            printf 'Columnas / columns: id<TAB>fase<TAB>módulo<TAB>especificación (- si falta)\n'
            ;;
        progress)
            printf 'glot progress [fase] — estado del roadmap, que es la fuente de verdad\n'
            printf 'glot progress [phase] — roadmap state, which is the source of truth\n'
            printf 'Sin fase / without a phase: registrados, homologados, modulos, pares_hechos, pares_total\n'
            printf 'Con fase / with a phase: modulo<TAB>estado<TAB>hechos<TAB>total\n'
            ;;
        completion)
            printf 'glot completion [bash|zsh] — imprime el autocompletado en stdout\n'
            printf 'glot completion [bash|zsh] — prints the completion script to stdout\n'
            printf 'No lo instala: eso es de install (v1.0.0) / it does not install it: that is install (v1.0.0)\n'
            ;;
        test)
            printf 'glot test [lenguaje] [fase/módulo] — ejecuta la suite del módulo asignado\n'
            printf 'glot test [language] [phase/module] — runs the assigned module suite\n'
            printf 'En el directorio del módulo, con el comando nativo del lenguaje; la salida del runner va a stdout\n'
            printf 'In the module directory, with the language native command; the runner output goes to stdout\n'
            printf 'Códigos / codes: 0 verde · 1 no se pudo preparar · 4 falló / failed\n'
            ;;
        verify)
            printf 'glot verify [lenguaje] [fase/módulo] — ejecuta el verificador del lenguaje\n'
            printf 'glot verify [language] [phase/module] — runs the language verifier\n'
            printf 'Sintaxis o formato, con la herramienta del propio lenguaje; `skipped` si no hay\n'
            printf 'Syntax or formatting, with the language own tool; `skipped` when there is none\n'
            printf 'Códigos / codes: 0 correcto · 4 hallazgos / findings\n'
            ;;
        prompt)
            printf 'glot prompt [encargo] [lenguaje] [fase/módulo]\n'
            printf 'Sin encargo lista el registro de plantillas de scripts/prompts\n'
            printf 'With no request it lists the template registry in scripts/prompts\n'
            printf 'Con encargo imprime el encargo armado: estado del sprint + plantilla expandida\n'
            printf 'With a request it prints the built request: sprint state + expanded template\n'
            printf 'Marcadores / placeholders: lang, phase, module, Module, repo, branch, spec, module_dir\n'
            printf 'No muta nada y no necesita -n / it mutates nothing and does not need -n\n'
            ;;
        ask)
            printf 'glot ask <encargo> [lenguaje] [fase/módulo] — envía el encargo al delegado\n'
            printf 'glot ask <request> [language] [phase/module] — pipes the request to the delegate\n'
            printf 'El encargo va por stdin a la orden de GLOT_DELEGATE y su salida va a stdout\n'
            printf 'The request goes to the GLOT_DELEGATE command over stdin and its output to stdout\n'
            printf 'Sin GLOT_DELEGATE devuelve 1; `-n` imprime el plan sin enviar nada\n'
            printf 'With no GLOT_DELEGATE it returns 1; `-n` prints the plan without sending anything\n'
            ;;
        use)
            printf 'glot use <lenguaje> <fase>/<módulo> [tipo] — sitúa el trabajo del sprint\n'
            printf '  valida contra .gitmodules y la especificación; con el árbol limpio\n'
            printf '  activa o crea la rama {tipo}/{fase}/{módulo} desde main y la publica\n'
            printf '  con -u; con trabajo sin confirmar solo informa (si ya estás en la rama,\n'
            printf '  la republica). Crea la carpeta del módulo si falta. Guarda el estado\n'
            printf '  e imprime la ruta\n'
            printf 'glot use <language> <phase>/<module> [type] — locates the sprint work\n'
            printf '  validates against .gitmodules and the spec; with a clean tree it\n'
            printf '  activates or creates the {type}/{phase}/{module} branch from main and\n'
            printf '  publishes it with -u; with uncommitted work it only reports (if you are\n'
            printf '  already on the branch, it republishes it). Creates the module folder\n'
            printf '  when missing. Stores state and prints the path\n'
            printf 'Tipos / types: feat (por defecto/default), fix, docs, chore, refactor, test\n'
            printf 'Con el módulo ya cerrado hay que indicar el tipo / with a closed module the type must be given\n'
            printf 'Desde dentro de un submódulo se puede omitir el lenguaje / the language can be omitted inside a submodule\n'
            ;;
        new)
            printf 'glot new [lenguaje] [fase/módulo] — inicializador y esqueleto del módulo\n'
            printf 'glot new [language] [phase/module] — initializer and module skeleton\n'
            printf 'Ejecuta el comando del catálogo en el directorio del módulo (que prepara\n'
            printf '`use`), crea las carpetas si el lenguaje no tiene herramienta y normaliza\n'
            printf 'lo que deja (aplanar el nido, quitar el .git anidado, descartar el vendoring\n'
            printf 'que el repositorio rechaza). No escribe la suite: eso es `glot prompt suite`\n'
            printf 'Runs the catalogue command in the module directory (prepared by `use`),\n'
            printf 'creates the folders when the language has no tool and normalises what it\n'
            printf 'leaves (flatten the nest, drop the nested .git, discard the vendoring the\n'
            printf 'repository rejects). It does not write the suite: that is `glot prompt suite`\n'
            printf 'Tipos / kinds: tool (ejecuta / runs), manual (carpetas / folders), deferred (agente / agent)\n'
            printf 'Códigos / codes: 0 correcto o skipped · 1 entorno · 4 el inicializador falló\n'
            ;;
        save)
            printf 'glot save <paso|alias> [lenguaje] [fase/módulo] — commit guiado\n'
            printf 'glot save <step|alias> [language] [phase/module] — guided commit\n'
            printf 'El mensaje sale del catálogo de commits (la tabla del sprint en datos); no\n'
            printf 'se escribe a mano. Añade el submódulo al índice y confirma en el submódulo\n'
            printf 'The message comes from the commit catalogue (the sprint table in data); it\n'
            printf 'is not written by hand. It stages the submodule and commits in it\n'
            printf 'Pasos / steps: 4a (andamiaje/scaffold) · 4b (suite) · 5 (implementación) · 7 · 8\n'
            printf 'Los commits del monorepo (puntero y roadmap) llegan con close y pointer\n'
            printf 'Monorepo commits (pointer and roadmap) arrive with close and pointer\n'
            printf 'No hace push / it does not push; `-n` imprime el plan / prints the plan\n'
            ;;
        *)
            _glot_error "verbo desconocido / unknown verb: $1"
            _glot_hint
            return 2
            ;;
    esac
}

_glot_cmd_help() {
    if [[ $# -eq 0 ]]; then
        _glot_usage
        return 0
    fi
    _glot_help_verb "$1"
}

# --- catálogo (L2.5) --------------------------------------------------------

# El catálogo no adivina nombres: los convierte. Un id canónico (`data_structures`)
# se proyecta a todas sus formas, y las divergencias legacy del módulo se resuelven
# sondeando el disco, no con una tabla completa.

_glot_kebab() { printf '%s\n' "${1//_/-}"; }

# _glot_gitmodules_list — lenguajes registrados en .gitmodules, una ruta por línea.
_glot_gitmodules_list() {
    local root=""

    root="$(_glot_repo_root)" || return 1
    [[ -f "$root/.gitmodules" ]] || return 1

    git -C "$root" config --file "$root/.gitmodules" --get-regexp '\.path$' 2>/dev/null |
        awk '{print $NF}'
}

# _glot_langs — lenguajes registrados en .gitmodules, ordenados en LC_ALL=C.
_glot_langs() {
    _glot_gitmodules_list | LC_ALL=C sort
}

# _glot_data_file — catálogo de datos del tooling (una fila por lenguaje).
# Se busca junto al script vivo y también un nivel arriba, para que un snapshot de
# versions/ pueda imprimir el autocompletado junto al glot.sh que lo acompaña.
_glot_data_file() {
    local dir=""

    for dir in "$GLOT_SCRIPT_DIR/data" "$GLOT_SCRIPT_DIR/../data"; do
        if [[ -r "$dir/languages.tsv" ]]; then
            printf '%s\n' "$dir/languages.tsv"
            return 0
        fi
    done

    return 1
}

# _glot_completion_file <shell> — guion de autocompletado de ese shell.
_glot_completion_file() {
    local shell="$1"
    local dir=""

    for dir in "$GLOT_SCRIPT_DIR/completions" "$GLOT_SCRIPT_DIR/../completions"; do
        if [[ -r "$dir/glot.$shell" ]]; then
            printf '%s\n' "$dir/glot.$shell"
            return 0
        fi
    done

    return 1
}

# _glot_lang_field <lenguaje> <campo> — campo del catálogo de datos:
# 1 lenguaje · 2 inicialización · 3 manifiestos · 4 pruebas.
_glot_lang_field() {
    local lang="$1"
    local field="$2"
    local file=""
    local line=""

    file="$(_glot_data_file)" || return 1

    while IFS= read -r line; do
        if [[ "${line%%$'\t'*}" == "$lang" ]]; then
            printf '%s\n' "$line" | cut -f"$field"
            return 0
        fi
    done <"$file"

    return 1
}

# _glot_native_test <lenguaje> — comando nativo de pruebas, que consume `test` (L3).
_glot_native_test() {
    _glot_lang_field "$1" 4
}

# _glot_init_kind <lenguaje> — tipo de inicialización (columna 6 del catálogo):
#   tool     — hay herramienta y su comando se ejecuta tal cual
#   manual   — no hay herramienta; se crean las carpetas del esqueleto
#   deferred — sin inicializador validado: lo escribe el agente (nunca se adivina)
_glot_init_kind() {
    _glot_lang_field "$1" 6
}

# _glot_init_run <lenguaje> — comando que ejecuta `new` (columna 7). En modo manual es
# la creación de carpetas; `-` cuando el tipo es `deferred`.
_glot_init_run() {
    _glot_lang_field "$1" 7
}

# _glot_init_fix <lenguaje> — normalización posterior a la herramienta (columna 8):
# operaciones separadas por `;`, `-` si no hace falta ninguna.
#   flat:<sub>        — sube el contenido de <sub> al directorio del módulo y lo borra
#   rm:<ruta>         — elimina (tolerante: si no está, no pasa nada)
_glot_init_fix() {
    _glot_lang_field "$1" 8
}

# _glot_commits_file — convención de mensajes de commit del repositorio, en datos y
# no dentro del script: una deriva entre la tabla del sprint y el catálogo se detecta
# en el harness, no en el commit.
_glot_commits_file() {
    local dir=""

    for dir in "$GLOT_SCRIPT_DIR/data" "$GLOT_SCRIPT_DIR/../data"; do
        if [[ -r "$dir/commits.tsv" ]]; then
            printf '%s\n' "$dir/commits.tsv"
            return 0
        fi
    done

    return 1
}

# _glot_commits_list — pasos del catálogo tal cual: paso<TAB>alias<TAB>ámbito<TAB>mensaje.
_glot_commits_list() {
    local file=""
    local line=""

    file="$(_glot_commits_file)" || return 1

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == '#'* ]] && continue
        printf '%s\n' "$line"
    done <"$file"
}

# _glot_commit_line <paso|alias> — línea del catálogo de commits. El paso del sprint
# (`4a`) y el nombre del encargo (`suite`) son la misma cosa vista desde dos sitios.
_glot_commit_line() {
    local want="$1"
    local line=""
    local step=""
    local alias=""

    while IFS= read -r line; do
        step="${line%%$'\t'*}"
        alias="$(printf '%s\n' "$line" | cut -f2)"
        if [[ "$step" == "$want" || "$alias" == "$want" ]]; then
            printf '%s\n' "$line"
            return 0
        fi
    done < <(_glot_commits_list)

    return 1
}

# _glot_commit_field <paso|alias> <campo> — campo del catálogo de commits:
# 1 paso · 2 alias (encargo) · 3 ámbito (submodule|monorepo) · 4 mensaje.
_glot_commit_field() {
    _glot_commit_line "$1" | cut -f"$2"
}

# _glot_lang_from_path <raíz> — lenguaje deducido del directorio actual, si estamos
# dentro de un submódulo. Usa la raíz de git del directorio actual, así que funciona
# también entrando por un enlace simbólico.
_glot_lang_from_path() {
    local root="$1"
    local top=""
    local rel=""

    top="$(git rev-parse --show-toplevel 2>/dev/null || true)"
    [[ -n "$top" ]] || return 1

    rel="${top#"$root"/}"
    [[ "$rel" != "$top" ]] || return 1
    printf '%s\n' "${rel%%/*}"
}

# _glot_title <id> — forma legible: data_structures -> Data Structures.
_glot_title() {
    local word=""
    local out=""

    for word in ${1//_/ }; do
        out+="${word^} "
    done

    printf '%s\n' "${out% }"
}

# _glot_doc_stem <id> — nombre del módulo dentro de la especificación:
# data_structures -> Data_Structures. `unit_test` es la única excepción legacy: su
# documento es 03_Unit_Test_Calculator.md.
_glot_doc_stem() {
    case "$1" in
        unit_test) printf 'Unit_Test_Calculator\n' ;;
        *) printf '%s\n' "$(_glot_title "$1")" | tr ' ' '_' ;;
    esac
}

# _glot_spec_path <raíz> <fase> <id> — ruta relativa de la especificación del módulo.
# El prefijo NN_ se lee del disco, no se codifica, y la comparación del nombre no
# distingue mayúsculas (`etl_basico` encuentra `14_ETL_Basico.md`). Cero
# coincidencias (falta el documento) o más de una (nombre ambiguo) son error.
_glot_spec_path() {
    local root="$1"
    local phase="$2"
    local id="$3"
    local dir="$root/docs/core/$phase"
    local stem=""
    local want=""
    local file=""
    local base=""
    local hits=0
    local found=""

    [[ -d "$dir" ]] || return 1

    stem="$(_glot_doc_stem "$id")"
    want="${stem,,}"

    for file in "$dir/"*.md; do
        [[ -e "$file" ]] || continue
        base="$(basename -- "$file")"
        base="${base#[0-9][0-9]_}"
        base="${base%.md}"
        [[ "${base,,}" == "$want" ]] || continue
        found="docs/core/$phase/$(basename -- "$file")"
        hits=$((hits + 1))
    done

    ((hits == 1)) || return 1
    printf '%s\n' "$found"
}

# _glot_canon_module <raíz> <fase> <nombre> — id canónico del módulo. Acepta lo que
# escriba el autor (el id del roadmap, el nombre real de la carpeta o una carpeta
# anidada) y devuelve el id del roadmap: `helloworld` -> `hello_world`,
# `unit_test/calculator` -> `unit_test`.
_glot_canon_module() {
    local root="$1"
    local phase="$2"
    local raw="$3"
    local alias=""
    local candidate=""

    case "$raw" in
        helloworld) alias="hello_world" ;;
        hellouser) alias="hello_user" ;;
    esac

    for candidate in "$raw" "$alias" "${raw%%/*}"; do
        [[ -n "$candidate" ]] || continue
        if _glot_spec_path "$root" "$phase" "$candidate" >/dev/null; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

# _glot_module_folder <raíz> <lenguaje> <fase> <id> — carpeta del módulo tal como
# existe en ese lenguaje (puede ser una subcarpeta). Sondea de la forma más
# especifica a la más general y cubre los dos casos legacy: `unit_test/calculator`
# (donde vive el código) y `helloworld`/`hellouser` (49 lenguajes; Ada usa el id).
_glot_module_folder() {
    local root="$1"
    local lang="$2"
    local phase="$3"
    local id="$4"
    local base="$root/$lang/core/$phase"
    local candidate=""

    for candidate in "$id/calculator" "$id" "${id//_/}"; do
        if [[ -d "$base/$candidate" ]]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

# _glot_module_dir <raíz> <lenguaje> <fase> <id> — directorio de trabajo del módulo
# (donde viven `src/` y la suite). Si la carpeta no existe todavía, devuelve la ruta
# convencional, que es la que `use` creará.
_glot_module_dir() {
    local root="$1"
    local lang="$2"
    local phase="$3"
    local id="$4"
    local folder=""

    folder="$(_glot_module_folder "$root" "$lang" "$phase" "$id" || printf '%s' "$id")"
    printf '%s\n' "$root/$lang/core/$phase/$folder"
}

# _glot_pascal <id> — forma PascalCase del id: naive_sort -> NaiveSort.
_glot_pascal() {
    local title=""

    title="$(_glot_title "$1")"
    printf '%s\n' "${title// /}"
}

# _glot_expand_command <directorio> <id> <plantilla> — resuelve los marcadores de la
# plantilla: `{module}` (id), `{Module}` (PascalCase) y `{suite}` (archivo de suite).
# `{suite}` se deduce del propio patrón: del token que lo contiene se toman el prefijo
# y el sufijo (`test/{suite}.vala` -> `test/*.vala`, `{suite}_guile.scm` ->
# `*_guile.scm`), se busca en el directorio efectivo —el del `cd` inicial, si lo hay—
# y se exige una única coincidencia que además nombre al módulo.
_glot_expand_command() {
    local dir="$1"
    local id="$2"
    local template="$3"
    local cmd="$template"
    local effdir=""
    local prefix=""
    local suffix=""
    local file=""
    local base=""
    local norm=""
    local want=""
    local -a hits=()
    local -a named=()

    cmd="${cmd//\{module\}/$id}"
    cmd="${cmd//\{Module\}/$(_glot_pascal "$id")}"

    [[ "$cmd" == *'{suite}'* ]] || {
        printf '%s\n' "$cmd"
        return 0
    }

    effdir="$dir"
    if [[ "$cmd" =~ ^cd[[:space:]]+([^[:space:]\&]+)[[:space:]]+\&\&[[:space:]]+ ]]; then
        effdir="$dir/${BASH_REMATCH[1]}"
    fi

    prefix="${cmd%%\{suite\}*}"
    prefix="${prefix##*[[:space:]]}"
    suffix="${cmd#*\{suite\}}"
    suffix="${suffix%%[[:space:]]*}"

    for file in "$effdir/$prefix"*"$suffix"; do
        [[ -f "$file" ]] || continue
        base="$(basename -- "$file")"
        hits+=("$base")
    done

    if (( ${#hits[@]} == 0 )); then
        _glot_error "no se encontró la suite / suite not found: $effdir/$prefix*$suffix"
        return 1
    fi

    if (( ${#hits[@]} > 1 )); then
        want="${id//[-_]/}"
        want="${want,,}"
        for base in "${hits[@]}"; do
            norm="${base//[-_]/}"
            norm="${norm,,}"
            [[ "$norm" == *"$want"* ]] && named+=("$base")
        done
        (( ${#named[@]} == 1 )) && hits=("${named[0]}")
    fi

    if (( ${#hits[@]} != 1 )); then
        _glot_error "suite ambigua / ambiguous suite: ${hits[*]}"
        return 1
    fi

    base="${hits[0]}"
    base="${base%"$suffix"}"
    printf '%s\n' "${cmd//\{suite\}/$base}"
}

# _glot_status_name <marca> — traduce la marca del roadmap a una palabra estable.
# Las marcas se escriben por bytes a propósito: el parser no depende de que el
# emoji sobreviva a un editor, y si no lo reconoce lo dice en vez de adivinar.
_glot_status_name() {
    case "$1" in
        $'\xe2\x9c\x85') printf 'done\n' ;;            # ✅
        $'\xf0\x9f\x94\x84') printf 'in_progress\n' ;; # 🔄
        $'\xf0\x9f\x93\x8b') printf 'planned\n' ;;     # 📋
        $'\xe2\x8f\xb3') printf 'pending\n' ;;         # ⏳
        *) return 1 ;;
    esac
}

# _glot_roadmap_modules — módulos de `core` del bloque de contadores de
# docs/ROADMAP.md, que es la fuente de verdad del estado. Una línea por módulo:
#   fase<TAB>modulo<TAB>estado<TAB>hechos<TAB>total<TAB>listados
# El estado sale de la marca; si falta, se deduce del contador `X/N`. `listados` es
# cuántos lenguajes nombra la lista entre paréntesis (`-` si no hay lista), que sirve
# para detectar un contador que contradice su propia lista. Una línea de `core.*`
# que no se entienda es un error: nunca se inventa un recuento.
_glot_roadmap_modules() {
    local root=""
    local file=""
    local line=""
    local id=""
    local rest=""
    local tok=""
    local inner=""
    local commas=""
    local phase=""
    local module=""
    local status=""
    local listados="-"
    local done=0
    local total=0

    root="$(_glot_repo_root)" || return 1
    file="$root/docs/ROADMAP.md"
    [[ -r "$file" ]] || return 1

    while IFS= read -r line; do
        [[ "$line" == core.* ]] || continue
        id="${line%%[[:space:]]*}"
        [[ "$id" =~ ^core\.[a-z_]+\.[a-z_0-9]+$ ]] || continue

        rest="${line#"$id"}"
        rest="${rest#"${rest%%[![:space:]]*}"}"
        tok="${rest%%[[:space:]]*}"

        status=""
        if ! status="$(_glot_status_name "$tok")"; then
            status=""
        fi

        done=0
        total=0
        if [[ "$rest" =~ ([0-9]+)/([0-9]+) ]]; then
            done="${BASH_REMATCH[1]}"
            total="${BASH_REMATCH[2]}"
        fi

        listados="-"
        if ((total > 0)) && [[ "$rest" == *"("*")"* ]]; then
            inner="${rest#*(}"
            inner="${inner%%)*}"
            if [[ "$inner" == *,* ]]; then
                commas="${inner//[^,]/}"
                listados="$((${#commas} + 1))"
            fi
        fi

        if [[ -z "$status" ]]; then
            if ((total == 0)); then
                _glot_error "línea del roadmap no reconocida / unrecognised roadmap line: $id"
                return 1
            fi
            if ((done == total)); then
                status="done"
            elif ((done > 0)); then
                status="in_progress"
            else
                status="planned"
            fi
        fi

        phase="${id#core.}"
        phase="${phase%%.*}"
        module="${id##*.}"
        printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
            "$phase" "$module" "$status" "$done" "$total" "$listados"
    done <"$file"
}

# --- asignación (L2) --------------------------------------------------------

# _glot_cmd_use <lenguaje> <fase>/<módulo> [tipo] — sitúa el trabajo del sprint:
# valida y, con el árbol limpio, activa o crea la rama {tipo}/{fase}/{módulo} desde
# main y la publica con upstream; con trabajo sin confirmar solo informa (salvo que
# ya estés en la rama, que se republica). Guarda el estado e imprime la ruta
# absoluta. No implementa, no genera esqueleto y no toca el monorepo.
_glot_cmd_use() {
    local -a pos=()
    local arg=""
    local lang=""
    local target=""
    local kind="feat"
    local phase=""
    local module=""
    local root=""
    local sub=""
    local folder=""
    local module_dir=""
    local spec=""
    local branch=""
    local current=""
    local dirty=""
    local dirty_work=""
    local pair=""
    local branch_exists=0
    local module_exists=0
    local kind_given=0

    # 1. Argumentos: rechaza opciones y decide qué es cada posición.
    for arg in "$@"; do
        case "$arg" in
            -*)
                _glot_error "opción desconocida / unknown option: $arg"
                _glot_hint
                return 2
                ;;
        esac
        pos+=("$arg")
    done

    case "${#pos[@]}" in
        1)
            [[ "${pos[0]}" == */* ]] || {
                _glot_error "faltan argumentos / missing arguments"
                _glot_error "uso / usage: glot use <lenguaje> <fase>/<módulo> [tipo]"
                _glot_hint
                return 2
            }
            target="${pos[0]}"
            ;;
        2)
            if [[ "${pos[0]}" == */* ]]; then
                target="${pos[0]}"
                kind="${pos[1]}"
                kind_given=1
            else
                lang="${pos[0]}"
                target="${pos[1]}"
            fi
            ;;
        3)
            lang="${pos[0]}"
            target="${pos[1]}"
            kind="${pos[2]}"
            kind_given=1
            ;;
        *)
            _glot_error "uso / usage: glot use <lenguaje> <fase>/<módulo> [tipo]"
            _glot_hint
            return 2
            ;;
    esac

    case "$kind" in
        feat | fix | docs | chore | refactor | test) ;;
        *)
            _glot_error "tipo no permitido / type not allowed: $kind"
            _glot_info "permitidos / allowed: feat, fix, docs, chore, refactor, test"
            return 2
            ;;
    esac

    phase="${target%%/*}"
    module="${target#*/}"
    if [[ -z "$phase" || -z "$module" || "$phase" == "$target" ]]; then
        _glot_error "fase/módulo mal formados / malformed phase/module: $target"
        _glot_info "formato esperado / expected format: algorithms/naive_sort"
        return 2
    fi

    # 2. Entorno y catálogo: todo se valida antes de tocar nada.
    root="$(_glot_repo_root)" || {
        _glot_error "no se detectó la raíz del monorepo / monorepo root not detected"
        return 1
    }

    if [[ -z "$lang" ]]; then
        lang="$(_glot_lang_from_path "$root")" || {
            _glot_error "no estás dentro de un submódulo; indica el lenguaje / not inside a submodule; name the language"
            return 1
        }
    fi

    if ! _glot_gitmodules_list | grep -qx -- "$lang"; then
        _glot_error "lenguaje no registrado en .gitmodules / language not in .gitmodules: $lang"
        return 1
    fi

    sub="$root/$lang"
    if [[ ! -e "$sub/.git" ]]; then
        _glot_error "submódulo sin inicializar / submodule not initialised: $lang"
        _glot_info "prueba / try: git submodule update --init -- $lang"
        return 1
    fi

    if [[ ! -d "$sub/core/$phase" ]]; then
        _glot_error "fase inexistente / missing phase: $phase"
        return 1
    fi

    # El módulo se normaliza al id canónico del roadmap: el autor puede escribir el
    # id (`hello_world`) o el nombre real de la carpeta (`helloworld`), y las carpetas
    # anidadas se resuelven por el id de su módulo.
    if ! module="$(_glot_canon_module "$root" "$phase" "$module")"; then
        _glot_error "especificación ausente / missing specification: docs/core/$phase/…_$module.md"
        _glot_info "mira el catálogo / check the catalogue: glot modules $phase"
        return 1
    fi

    spec="$(_glot_spec_path "$root" "$phase" "$module")" || {
        _glot_error "especificación ausente / missing specification: docs/core/$phase/…_$module.md"
        return 1
    }

    folder="$(_glot_module_folder "$root" "$lang" "$phase" "$module" || printf '%s' "$module")"
    module_dir="$sub/core/$phase/$folder"
    branch="$kind/$phase/$(_glot_kebab "$module")"
    current="$(git -C "$sub" symbolic-ref --short -q HEAD || true)"
    if git -C "$sub" show-ref --verify --quiet "refs/heads/$branch"; then
        branch_exists=1
    fi

    # El directorio puede existir ya: se está trabajando en el módulo o está cerrado.
    # En ese caso no hay esqueleto que crear y solo se avisa, sin bloquear.
    if [[ -d "$module_dir" ]]; then
        module_exists=1
    elif [[ -e "$module_dir" ]]; then
        _glot_error "la ruta del módulo existe y no es un directorio / module path exists and is not a directory: $module_dir"
        return 1
    fi

    # El propio directorio del módulo no cuenta como suciedad: dentro de él, un
    # árbol sucio es el estado normal de un sprint en curso (reanudar tras una
    # jornada, un corte de luz o una implementación a medias).
    dirty="$(git -C "$sub" status --porcelain 2>/dev/null | grep -vE "core/$phase/$folder(/|\$)" || true)"
    if [[ -n "$dirty" ]]; then
        _glot_error "el submódulo tiene cambios sin confirmar fuera del módulo / submodule has uncommitted changes outside the module"
        _glot_info "$dirty"
        return 1
    fi

    # Descartado lo anterior, cualquier resto de suciedad está dentro del módulo:
    # trabajo de un sprint a medias. `use` lo respeta y nunca crea ni cambia ramas
    # con trabajo sin confirmar.
    dirty_work="$(git -C "$sub" status --porcelain 2>/dev/null || true)"

    # 3. Ensayo: imprime el plan y no toca ni git ni el estado.
    if ((_glot_dry_run)); then
        if ((module_exists)); then
            _glot_warn "el módulo ya existe, no se genera esqueleto / module already exists, no scaffolding: $module_dir"
            if [[ "$current" == "$branch" ]]; then
                printf 'git -C %s push -u origin %s\n' "$sub" "$branch"
            elif ((branch_exists)) && [[ -z "$dirty_work" ]]; then
                printf 'git -C %s switch %s\n' "$sub" "$branch"
                printf 'git -C %s push -u origin %s\n' "$sub" "$branch"
            elif [[ -n "$dirty_work" ]]; then
                printf '# sin pasos: hay trabajo sin confirmar / no steps: there is uncommitted work\n'
            elif ((kind_given)); then
                printf 'git -C %s switch -c %s main\n' "$sub" "$branch"
                printf 'git -C %s push -u origin %s\n' "$sub" "$branch"
            else
                printf '# sin pasos: módulo cerrado y sin tipo / no steps: closed module and no type\n'
            fi
        else
            if ((branch_exists)); then
                printf 'git -C %s switch %s\n' "$sub" "$branch"
            else
                printf 'git -C %s switch -c %s main\n' "$sub" "$branch"
            fi
            printf 'git -C %s push -u origin %s\n' "$sub" "$branch"
            printf 'mkdir -p %s\n' "$module_dir"
        fi
        printf 'lang=%s\n' "$lang"
        printf 'phase=%s\n' "$phase"
        printf 'module=%s\n' "$module"
        printf 'branch=%s\n' "$branch"
        printf 'spec=%s\n' "$spec"
        printf 'repo=%s\n' "$lang"
        return 0
    fi

    # 4. Dos preguntas deciden todo: ¿existe el módulo? ¿existe la rama objetivo?
    #    Regla de oro: con trabajo sin confirmar, `use` no crea ni cambia ramas,
    #    solo informa; con el árbol limpio, situarse es seguro.
    #    - módulo NUEVO: se cambia a su rama, creada desde main, se publica con
    #      upstream y se crea el directorio del módulo (vacío: el esqueleto del
    #      lenguaje es de `new`, v0.9.0);
    #    - módulo EXISTENTE: la carpeta ya está, no hay esqueleto que crear. Si ya
    #      estás en la rama, se republica (el push no toca el árbol de trabajo, así
    #      que reanudar con trabajo a medias es seguro); con el árbol limpio se
    #      activa la rama existente o se abre una de mantenimiento cuando el módulo
    #      ya está cerrado y se indica el tipo.
    if ((module_exists)); then
        _glot_warn "el módulo ya existe, no se genera esqueleto / module already exists, no scaffolding: $module_dir"

        if [[ "$current" == "$branch" ]]; then
            _glot_info "rama ya activa / branch already active: $branch"
            if ! git -C "$sub" push -q -u origin "$branch" 2>/dev/null; then
                _glot_error "no se pudo publicar la rama / cannot publish branch: $branch"
                _glot_info "la rama local existe; revisa el remoto / the local branch exists; check the remote"
                return 1
            fi
            _glot_info "publicada / published: origin/$branch"
        elif ((branch_exists)) && [[ -z "$dirty_work" ]]; then
            if ! git -C "$sub" switch -q "$branch" 2>/dev/null; then
                _glot_error "no se pudo activar la rama / cannot switch to branch: $branch"
                return 1
            fi
            _glot_info "rama activada / branch activated: ${current:-detached} → $branch"
            if ! git -C "$sub" push -q -u origin "$branch" 2>/dev/null; then
                _glot_error "no se pudo publicar la rama / cannot publish branch: $branch"
                return 1
            fi
            _glot_info "publicada / published: origin/$branch"
        elif ((branch_exists)); then
            _glot_warn "existe la rama $branch, pero no estás en ella / branch $branch exists, but you are not on it"
            _glot_info "hay trabajo sin confirmar: use no cambia de rama / there is uncommitted work: use does not switch branches"
            _glot_info "actual / current: ${current:-detached}; cámbiate tú / switch yourself: git -C $sub switch $branch"
        elif [[ -n "$dirty_work" ]]; then
            _glot_warn "trabajo sin confirmar y la rama no existe / uncommitted work and the branch does not exist: $branch"
            _glot_info "use no crea ni cambia nada; confirma o publica tu trabajo / use creates and changes nothing; commit or publish your work"
            _glot_info "actual / current: ${current:-detached}; listo cuando quieras / ready when you want: git -C $sub switch -c $branch"
        elif ((kind_given)); then
            if git -C "$sub" switch -q -c "$branch" main 2>/dev/null; then
                _glot_info "rama creada desde main / branch created from main: $branch"
            elif git -C "$sub" switch -q -c "$branch" 2>/dev/null; then
                _glot_warn "no hay rama main; la rama nace de ${current:-HEAD} / no main branch; branch created from ${current:-HEAD}"
            else
                _glot_error "no se pudo crear la rama / cannot create branch: $branch"
                return 1
            fi
            if ! git -C "$sub" push -q -u origin "$branch" 2>/dev/null; then
                _glot_error "no se pudo publicar la rama / cannot publish branch: $branch"
                return 1
            fi
            _glot_info "publicada / published: origin/$branch"
        else
            _glot_warn "el módulo ya está cerrado y no se indicó tipo / the module is already closed and no type was given"
            _glot_info "indica el tipo de trabajo / name the kind of work: glot use $lang $target test|fix|refactor|docs|chore"
        fi
    else
        if ((branch_exists)); then
            if ! git -C "$sub" switch -q "$branch" 2>/dev/null; then
                _glot_error "no se pudo activar la rama / cannot switch to branch: $branch"
                return 1
            fi
            _glot_info "rama existente activada / existing branch activated: $branch"
        elif git -C "$sub" switch -q -c "$branch" main 2>/dev/null; then
            _glot_info "rama creada desde main / branch created from main: $branch"
        elif git -C "$sub" switch -q -c "$branch" 2>/dev/null; then
            _glot_warn "no hay rama main; la rama nace de ${current:-HEAD} / no main branch; branch created from ${current:-HEAD}"
        else
            _glot_error "no se pudo crear la rama / cannot create branch: $branch"
            return 1
        fi

        if ! git -C "$sub" push -q -u origin "$branch" 2>/dev/null; then
            _glot_error "no se pudo publicar la rama / cannot publish branch: $branch"
            return 1
        fi
        _glot_info "publicada / published: origin/$branch"

        if ! mkdir -p -- "$module_dir"; then
            _glot_error "no se pudo crear el directorio / cannot create directory: $module_dir"
            return 1
        fi
    fi

    # 7. Estado del sprint: si falla, la rama ya estaría preparada y se avisa.
    for pair in "lang=$lang" "phase=$phase" "module=$module" "branch=$branch" "spec=$spec" "repo=$lang"; do
        if ! _glot_state_rewrite set "${pair%%=*}" "${pair#*=}"; then
            _glot_error "la rama ya está preparada, pero no se pudo guardar el estado / the branch is ready, but the state could not be saved"
            return 3
        fi
    done

    # 8. Dato para stdout: la ruta absoluta del módulo.
    printf '%s\n' "$module_dir"
    _glot_info "recuerda / remember: cd \"\$(glot use $lang $target $kind)\" (el cd real llega en v1.0.0)"

    return 0
}

# --- dispatcher --------------------------------------------------------------

glot() {
    # Inicializa las variables de estado globales / Initialize global state variables
    local cmd=""

    # Opciones globales: -q / --quiet
    # Procesa las opciones globales antes de despachar el comando
    # Process global options before dispatching the command
    while [[ $# -gt 0 ]]; do
        # Maneja las opciones globales / Handle global options
        case "$1" in
            -q | --quiet)
                # Activa el modo silencioso / Enable quiet mode
                _glot_quiet=1
                # Continúa con el siguiente argumento / Continue with the next argument
                shift
                ;;
            -n | --dry-run)
                # No escribe el estado, solo muestra el plan / Do not write state, just show the plan
                _glot_dry_run=1
                shift
                ;;
            *) break ;;
        esac
    done

    # Despacha el comando / Dispatch the command
    cmd="${1:-}"
    # El primer argumento después de las opciones globales es el comando / The first argument after global options is the command
    if [[ $# -gt 0 ]]; then
        # Elimina el comando de la lista de argumentos / Remove the command from the argument list
        shift
    fi

    # Despacha el comando según el verbo / Dispatch the command based on the verb
    case "$cmd" in
        "" | help | -h | --help)
            # Muestra la ayuda para el comando dado / Show help for the given command
            _glot_cmd_help "$@"
            ;;
        version | -V | --version)
            # Muestra la versión de la herramienta / Show the tool version
            _glot_cmd_version
            ;;
        doctor)
            # Ejecuta el diagnóstico del entorno / Run environment diagnostics
            _glot_cmd_doctor
            ;;
        greet)
            # Saluda al usuario / Greet the user
            _glot_cmd_greet "$@"
            ;;
        hello)
            # Compatibilidad v0.2.0: saludo con el nombre de v0.2 sin verbo.
            # Se retira en v1.0.0.
            # Greet the user (deprecated)
            _glot_cmd_greet "$@"
            ;;
        set)
            # Guarda una clave en el estado / Store a state key
            _glot_cmd_set "$@"
            ;;
        get)
            # Lee una clave del estado / Read a state key
            _glot_cmd_get "$@"
            ;;
        unset)
            # Elimina una clave del estado / Remove a state key
            _glot_cmd_unset "$@"
            ;;
        list)
            # Lista el estado / List the state
            _glot_cmd_list
            ;;
        path)
            # Imprime la ruta del archivo de estado / Print the state file path
            _glot_cmd_path
            ;;
        langs)
            # Catálogo de lenguajes / Language catalogue
            _glot_cmd_langs
            ;;
        modules)
            # Catálogo de módulos del roadmap / Roadmap module catalogue
            _glot_cmd_modules "$@"
            ;;
        progress)
            # Estado del roadmap / Roadmap state
            _glot_cmd_progress "$@"
            ;;
        completion)
            # Autocompletado en stdout / Completion script on stdout
            _glot_cmd_completion "$@"
            ;;
        test)
            # Ejecuta la suite del módulo asignado / Runs the assigned module suite
            _glot_cmd_test "$@"
            ;;
        verify)
            # Ejecuta el verificador del lenguaje / Runs the language verifier
            _glot_cmd_verify "$@"
            ;;
        prompt)
            # Arma el encargo del sprint / Builds the sprint request
            _glot_cmd_prompt "$@"
            ;;
        ask)
            # Envía el encargo al delegado / Sends the request to the delegate
            _glot_cmd_ask "$@"
            ;;
        use)
            # Sitúa el trabajo del sprint / Locates the sprint work
            _glot_cmd_use "$@"
            ;;
        new)
            # Inicializa el lenguaje y crea el esqueleto / initialises the language and creates the skeleton
            _glot_cmd_new "$@"
            ;;
        save)
            # Confirma con la convención del repositorio / commits with the repository convention
            _glot_cmd_save "$@"
            ;;
        -*)
            # Maneja las opciones desconocidas / Handle unknown options
            _glot_error "opción desconocida / unknown option: $cmd"
            _glot_hint
            return 2
            ;;
        *)
            # Maneja los verbos desconocidos / Handle unknown verbs
            _glot_error "verbo desconocido / unknown verb: $cmd"
            _glot_info "si querías el saludo / if you meant the greeting: glot greet $cmd"
            _glot_hint
            return 2
            ;;
    esac
}

glot "$@"
