#!/usr/bin/env bash
# glot 0.3.0 — contrato y dispatcher de verbos del CLI del monorepo.
#
# Versión viva del script: las versiones cerradas se archivan en versions/.
# No asume rutas del usuario: el script se localiza con BASH_SOURCE y la raíz del
# monorepo se resuelve con GLOT_ROOT, el superproyecto o la raíz de git.
#
# Uso / Usage:
#   ./scripts/glot.sh help
#   ./scripts/glot.sh doctor
#   ./scripts/glot.sh greet Ada
#   printf 'Ada\n' | ./scripts/glot.sh greet

set -euo pipefail

GLOT_VERSION="0.3.0"

# Contrato L0: stdout solo dato, stderr solo diagnóstico.
# Códigos: 0 correcto · 1 error de entorno · 2 uso incorrecto · 3 estado ilegible.

_glot_error() { printf 'glot: error: %s\n' "$*" >&2; }
_glot_warn() { printf 'glot: aviso / warning: %s\n' "$*" >&2; }

_glot_quiet=0
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

# _glot_state_dir — ubicación prevista del estado; la usará el almacén de v0.4.0.
_glot_state_dir() {
    printf '%s\n' "${GLOT_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/glot}"
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
    if [[ -d "$state_dir" ]]; then
        printf 'state_dir: %s (existe / exists)\n' "$state_dir"
    else
        printf 'state_dir: %s (se creará en v0.4.0 / will be created in v0.4.0)\n' "$state_dir"
    fi

    return "$status"
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

Opciones globales / Global options:
  -q, --quiet        Silencia el diagnóstico de stderr / silence stderr diagnostics
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
    local cmd=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -q | --quiet)
                _glot_quiet=1
                shift
                ;;
            *) break ;;
        esac
    done

    cmd="${1:-}"
    if [[ $# -gt 0 ]]; then
        shift
    fi

    case "$cmd" in
        "" | help | -h | --help)
            _glot_cmd_help "$@"
            ;;
        version | -V | --version)
            _glot_cmd_version
            ;;
        doctor)
            _glot_cmd_doctor
            ;;
        greet)
            _glot_cmd_greet "$@"
            ;;
        hello)
            # Compatibilidad v0.2.0: saludo con el nombre de v0.2 sin verbo.
            # Se retira en v1.0.0.
            _glot_cmd_greet "$@"
            ;;
        -*)
            _glot_error "opción desconocida / unknown option: $cmd"
            _glot_hint
            return 2
            ;;
        *)
            _glot_error "verbo desconocido / unknown verb: $cmd"
            _glot_info "si querías el saludo / if you meant the greeting: glot greet $cmd"
            _glot_hint
            return 2
            ;;
    esac
}

glot "$@"
