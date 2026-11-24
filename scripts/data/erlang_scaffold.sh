#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: erlang_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
src="src/$module.erl"
app="src/$module.app.src"
suite="test/${module}_test.erl"

if [[ -L src || ! -d src || -L test || ( -e test && ! -d test ) ]]; then
    printf 'scaffold: directorio Erlang no seguro o ausente / unsafe or missing Erlang directory\n' >&2
    exit 1
fi
for path in "$src" "$app" "$suite" .gitignore; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Erlang no seguro / unsafe Erlang file: %s\n' "$path" >&2
        exit 1
    fi
done
for template in erlang.module.erl erlang.sentinel.erl; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Erlang ausente o vacía / missing or empty Erlang template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- test
if [[ ! -e .gitignore ]]; then
    (set -C; : >.gitignore)
fi
if [[ ! -f "$src" || -e "$suite" ]]; then
    exit 0
fi
sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/erlang.module.erl")"
if cmp -s "$src" <(printf '%s\n' "$sample"); then result=0; else result=$?; fi
if ((result > 1)); then
    printf 'scaffold: no se pudo comparar la muestra Erlang / could not compare Erlang sample\n' >&2
    exit 1
fi
if ((result != 0)); then
    exit 0
fi
extra="$(find src test -mindepth 1 ! -type d ! -path "$src" ! -path "$app" -print -quit)"
if [[ -z "$extra" ]]; then
    (set -C; sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/erlang.sentinel.erl" >"$suite")
fi
