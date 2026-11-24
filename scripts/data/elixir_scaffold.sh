#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 || ! "$1" =~ ^[a-z][a-z0-9_]*$ || ! "$2" =~ ^[A-Z][A-Za-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: elixir_scaffold.sh <module> <Module>\n' >&2
    exit 1
fi

module=$1
class=$2
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
src="lib/$module.ex"
tst="test/${module}_test.exs"

for path in lib test; do
    if [[ -L "$path" || ! -d "$path" ]]; then
        printf 'scaffold: directorio Elixir no seguro o ausente / unsafe or missing Elixir directory: %s\n' "$path" >&2
        exit 1
    fi
done
for path in "$src" "$tst" test/test_helper.exs .gitignore; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Elixir no seguro / unsafe Elixir file: %s\n' "$path" >&2
        exit 1
    fi
done
for template in elixir.module.ex elixir.module_test.exs elixir.sentinel_test.exs; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Elixir ausente o vacía / missing or empty Elixir template: %s\n' "$template" >&2
        exit 1
    fi
done
if [[ ! -e .gitignore ]]; then
    (set -C; : >.gitignore)
fi

if [[ ! -f "$src" || ! -f "$tst" || ! -f test/test_helper.exs ]]; then
    exit 0
fi
source_sample="$(sed "s/@MODULE@/$class/g" "$data_dir/scaffold_templates/elixir.module.ex")"
test_sample="$(sed "s/@MODULE@/$class/g" "$data_dir/scaffold_templates/elixir.module_test.exs")"
if cmp -s "$src" <(printf '%s\n' "$source_sample"); then a=0; else a=$?; fi
if cmp -s "$tst" <(printf '%s\n' "$test_sample"); then b=0; else b=$?; fi
if cmp -s test/test_helper.exs <(printf 'ExUnit.start()\n'); then c=0; else c=$?; fi
if ((a > 1 || b > 1 || c > 1)); then
    printf 'scaffold: no se pudo comparar la muestra Elixir / could not compare Elixir sample\n' >&2
    exit 1
fi
if ((a != 0 || b != 0 || c != 0)); then
    exit 0
fi
extra="$(find lib test -mindepth 1 ! -type d ! -path "$src" ! -path "$tst" ! -path test/test_helper.exs -print -quit)"
if [[ -n "$extra" ]]; then
    exit 0
fi

tmp="$(mktemp test/.glot-elixir-sentinel.XXXXXX)"
trap 'rm -f -- "$tmp"' EXIT
sed "s/@MODULE@/$class/g" "$data_dir/scaffold_templates/elixir.sentinel_test.exs" >"$tmp"
mv -- "$tmp" "$tst"
rm -- "$src"
