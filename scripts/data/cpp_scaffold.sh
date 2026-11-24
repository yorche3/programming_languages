#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
    printf 'scaffold: uso inválido / invalid usage: cpp_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
if [[ ! "$module" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: nombre C++ inválido / invalid C++ name: %s\n' "$module" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
directories=(src include tests)
for path in "${directories[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta C++ no segura / unsafe C++ path: %s\n' "$path" >&2
        exit 1
    fi
done

files=(MODULE.bazel WORKSPACE BUILD .bazelversion .gitignore)
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo C++ no seguro / unsafe C++ file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in cpp.MODULE.bazel cpp.WORKSPACE cpp.BUILD cpp.bazelversion cpp.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla C++ ausente o vacía / missing or empty C++ template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- "${directories[@]}"
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        MODULE.bazel)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/cpp.MODULE.bazel" >"$path") || {
                printf 'scaffold: no se pudo crear MODULE.bazel / could not create MODULE.bazel\n' >&2
                exit 1
            }
            ;;
        WORKSPACE)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/cpp.WORKSPACE" >"$path") || {
                printf 'scaffold: no se pudo crear WORKSPACE / could not create WORKSPACE\n' >&2
                exit 1
            }
            ;;
        BUILD)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/cpp.BUILD" >"$path") || {
                printf 'scaffold: no se pudo crear BUILD / could not create BUILD\n' >&2
                exit 1
            }
            ;;
        .bazelversion)
            (set -C; cat -- "$data_dir/scaffold_templates/cpp.bazelversion" >"$path") || {
                printf 'scaffold: no se pudo crear .bazelversion / could not create .bazelversion\n' >&2
                exit 1
            }
            ;;
        .gitignore)
            (set -C; cat -- "$data_dir/scaffold_templates/cpp.gitignore" >"$path") || {
                printf 'scaffold: no se pudo crear .gitignore C++ / could not create C++ .gitignore\n' >&2
                exit 1
            }
            ;;
    esac
done
