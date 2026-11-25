#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: d_test.sh\n' >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
module_dir="$(pwd -P)" || exit 1
module="$(basename -- "$module_dir")"
if [[ -L source || ! -d source || -L test || ! -d test ]]; then
    printf 'test: fuente o directorio test D no seguro / unsafe D source or test directory\n' >&2
    exit 1
fi
test_files="$(find test -type f -name '*.d' -print -quit)" || {
    printf 'test: no se pudo inspeccionar test/ / could not inspect test/\n' >&2
    exit 1
}
if [[ -z "$test_files" ]]; then
    printf 'test: no hay fuentes D en test/ / no D test sources in test/\n' >&2
    exit 1
fi

temporary=""
output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
cleanup() {
    rm -f -- "$output"
    if [[ -n "$temporary" ]]; then
        rm -rf -- "$temporary"
    fi
}
trap cleanup EXIT

describe_sources() {
    (cd -- "$1" && dub describe --build=unittest --data=source-files --data-list)
}

test_sources() {
    local root="$1"
    local sources="$2"
    local source=""
    while IFS= read -r source; do
        case "$source" in
            "$root/test/"*.d) printf '%s\n' "$source" ;;
            test/*.d) printf '%s\n' "$root/$source" ;;
        esac
    done <<<"$sources"
}

if sources="$(describe_sources "$module_dir")"; then
    :
else
    rc=$?
    exit "$rc"
fi
selected_tests="$(test_sources "$module_dir" "$sources")"
working_dir="$module_dir"

if [[ -z "$selected_tests" ]]; then
    if [[ -L dub.sdl || ! -f dub.sdl || -L "$data_dir/d_scaffold.sh" ||
        ! -f "$data_dir/d_scaffold.sh" ]]; then
        printf 'test: DUB unittest no incluye test/ y no se puede adaptar el manifiesto / DUB unittest excludes test/ and the manifest cannot be adapted\n' >&2
        exit 1
    fi
    if find source test -type l -print -quit | grep -q .; then
        printf 'test: no se adapta un proyecto D con enlaces en source/ o test/ / refusing D fallback with symlinks in source/ or test/\n' >&2
        exit 1
    fi
    if find source test ! -type d ! -type f -print -quit | grep -q .; then
        printf 'test: no se adapta un proyecto D con archivos especiales / refusing D fallback with special files\n' >&2
        exit 1
    fi

    temporary="$(mktemp -d)" || {
        printf 'test: no se pudo crear copia temporal D / could not create temporary D copy\n' >&2
        exit 1
    }
    cp -a -- dub.sdl source test "$temporary/"
    cp -- "$temporary/dub.sdl" "$temporary/dub.sdl.before"
    if (cd -- "$temporary" && bash "$data_dir/d_scaffold.sh" "$module"); then
        :
    else
        rc=$?
        exit "$rc"
    fi
    if cmp -s -- "$temporary/dub.sdl" "$temporary/dub.sdl.before"; then
        printf 'test: DUB unittest omite test/; adapta un manifiesto compatible con glot scaffold / DUB unittest excludes test/; adapt a manifest supported by glot scaffold\n' >&2
        exit 1
    fi
    rm -- "$temporary/dub.sdl.before"
    if sources="$(describe_sources "$temporary")"; then
        :
    else
        rc=$?
        exit "$rc"
    fi
    selected_tests="$(test_sources "$temporary" "$sources")"
    if [[ -z "$selected_tests" ]]; then
        printf 'test: la configuración temporal DUB sigue omitiendo test/ / temporary DUB configuration still excludes test/\n' >&2
        exit 1
    fi
    working_dir="$temporary"
    printf 'test: ejecutando en copia temporal con la configuración unittest de glot scaffold / running in a temporary copy with glot scaffold unittest configuration\n'
fi

has_unittest=0
while IFS= read -r source; do
    if [[ -L "$source" || ! -f "$source" ]]; then
        printf 'test: fuente de pruebas D no regular / D test source is not a regular file: %s\n' "$source" >&2
        exit 1
    fi
    if grep -Eq '(^|[^[:alnum:]_])unittest([[:space:](]|$)' "$source"; then
        has_unittest=1
    fi
done <<<"$selected_tests"
if ((has_unittest == 0)); then
    printf 'test: no hay bloques unittest en las fuentes de test/ / no unittest blocks in test/ sources\n' >&2
    exit 1
fi

if (cd -- "$working_dir" && dub test) >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
exit "$rc"
