#!/usr/bin/env bash
# glot 0.4.0 — contrato, dispatcher de verbos y almacén de estado (L1).
#
# Snapshot archivado: versión cerrada el 2026-09-21. No se edita; el código es
# el mismo que tenía la versión viva en su cierre.
# No asume rutas del usuario: el script se localiza con BASH_SOURCE y la raíz del
# monorepo se resuelve con GLOT_ROOT, el superproyecto o la raíz de git.
# El estado vive fuera del repositorio (XDG) y se puede redirigir con GLOT_STATE_FILE.
#
# Uso / Usage:
#   ./versions/glot_0.4.0.sh help
#   ./scripts/glot.sh doctor
#   ./scripts/glot.sh set lang php
#   ./scripts/glot.sh get lang
#   ./scripts/glot.sh list
#   ./scripts/glot.sh unset lang

set -euo pipefail

GLOT_VERSION="0.4.0"

# Contrato L0: stdout solo dato, stderr solo diagnóstico.
# Códigos: 0 correcto · 1 error de entorno · 2 uso incorrecto · 3 estado ilegible.

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
_glot_state_dir() {
    printf '%s\n' "${GLOT_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/glot}"
}

# _glot_state_file — archivo del estado: GLOT_STATE_FILE > <dir>/state.
_glot_state_file() {
    if [[ -n "${GLOT_STATE_FILE:-}" ]]; then
        printf '%s\n' "$GLOT_STATE_FILE"
        return 0
    fi
    printf '%s\n' "$(_glot_state_dir)/state"
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

    file="$(_glot_state_file)"
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

    file="$(_glot_state_file)"
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

    file="$(_glot_state_file)"
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

    if root="$(_glot_repo_root)"; then
        printf 'root: %s\n' "$root"
    else
        printf 'root: (no detectado / not detected)\n'
        _glot_warn 'define GLOT_ROOT o ejecuta dentro del monorepo / set GLOT_ROOT or run inside the monorepo'
        status=1
    fi

    state_dir="$(_glot_state_dir)"
    state_file="$(_glot_state_file)"

    if [[ -d "$state_dir" ]]; then
        printf 'state_dir: %s (existe / exists)\n' "$state_dir"
    else
        printf 'state_dir: %s (aún no existe / not created yet)\n' "$state_dir"
    fi

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

    if value="$(_glot_state_get "$key")"; then
        printf '%s\n' "$value"
        return 0
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
    printf '%s\n' "$(_glot_state_file)"
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

Opciones globales / Global options:
  -q, --quiet        Silencia el diagnóstico de stderr / silence stderr diagnostics
  -n, --dry-run      No escribe el estado: muestra lo que haría / do not write state: show the plan
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
            printf 'Claves reservadas / reserved keys: lang, module, branch\n'
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
