#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
    printf 'scaffold: uso inválido / invalid usage: common_lisp_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
if [[ ! "$module" =~ ^[a-z0-9_]+$ ]]; then
    printf 'scaffold: id de módulo inválido / invalid module id: %s\n' "$module" >&2
    exit 1
fi

for path in src tests; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta Common Lisp no segura / unsafe Common Lisp path: %s\n' "$path" >&2
        exit 1
    fi
done

source_files=(src/main.lisp tests/main.lisp)
target_files=("src/$module.lisp" "tests/$module-test.lisp")
for index in "${!source_files[@]}"; do
    source=${source_files[$index]}
    target=${target_files[$index]}
    for path in "$source" "$target"; do
        if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
            printf 'scaffold: archivo Common Lisp no seguro / unsafe Common Lisp file: %s\n' "$path" >&2
            exit 1
        fi
    done
    if [[ -e "$source" && -e "$target" ]]; then
        printf 'scaffold: origen y destino ya existen; se conservan ambos / source and target both exist; preserving both: %s %s\n' \
            "$source" "$target" >&2
        exit 1
    fi
    if [[ ! -e "$source" && ! -e "$target" ]]; then
        printf 'scaffold: faltan origen y destino / source and target are both missing: %s %s\n' \
            "$source" "$target" >&2
        exit 1
    fi
done

if [[ -L run-tests.lisp || ( -e run-tests.lisp && ! -f run-tests.lisp ) ]]; then
    printf 'scaffold: runner Common Lisp no seguro / unsafe Common Lisp runner\n' >&2
    exit 1
fi

for index in "${!source_files[@]}"; do
    source=${source_files[$index]}
    target=${target_files[$index]}
    if [[ -e "$source" ]]; then
        if ! mv -n -- "$source" "$target" || [[ -e "$source" || ! -f "$target" ]]; then
            printf 'scaffold: no se pudo renombrar sin sobrescribir / could not rename without overwriting: %s\n' \
                "$target" >&2
            exit 1
        fi
    fi
done

if [[ ! -e run-tests.lisp ]]; then
    (set -C; : > run-tests.lisp) || {
        printf 'scaffold: no se pudo crear el runner Common Lisp / could not create Common Lisp runner\n' >&2
        exit 1
    }
fi
