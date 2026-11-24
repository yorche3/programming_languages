#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: gleam_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
src="src/$module.gleam"
suite="test/${module}_test.gleam"
for path in src test; do
    if [[ -L "$path" || ! -d "$path" ]]; then
        printf 'scaffold: directorio Gleam no seguro o ausente / unsafe or missing Gleam directory: %s\n' "$path" >&2
        exit 1
    fi
done
for path in "$src" "$suite" .gitignore; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Gleam no seguro / unsafe Gleam file: %s\n' "$path" >&2
        exit 1
    fi
done
for template in gleam.module.gleam gleam.module_test.gleam gleam.sentinel.gleam; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Gleam ausente o vacía / missing or empty Gleam template: %s\n' "$template" >&2
        exit 1
    fi
done
if [[ ! -e .gitignore ]]; then
    (set -C; : >.gitignore)
fi
if [[ ! -f "$src" || ! -f "$suite" ]]; then
    exit 0
fi
sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/gleam.module.gleam")"
if cmp -s "$src" <(printf '%s\n' "$sample"); then a=0; else a=$?; fi
if cmp -s "$suite" "$data_dir/scaffold_templates/gleam.module_test.gleam"; then b=0; else b=$?; fi
if ((a > 1 || b > 1)); then
    printf 'scaffold: no se pudo comparar la muestra Gleam / could not compare Gleam sample\n' >&2
    exit 1
fi
if ((a != 0 || b != 0)); then
    exit 0
fi
extra="$(find src test -mindepth 1 ! -type d ! -path "$src" ! -path "$suite" -print -quit)"
if [[ -n "$extra" ]]; then
    exit 0
fi

tmp="$(mktemp test/.glot-gleam-sentinel.XXXXXX)"
trap 'rm -f -- "$tmp"' EXIT
cat -- "$data_dir/scaffold_templates/gleam.sentinel.gleam" >"$tmp"
mv -- "$tmp" "$suite"
rm -- "$src"
