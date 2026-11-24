#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 ]]; then
    printf 'scaffold: uso inválido / invalid usage: haxe_scaffold.sh <module> <Module>\n' >&2
    exit 1
fi

module=$1
class=$2
if [[ ! "$module" =~ ^[a-z][a-z0-9_]*$ || ! "$class" =~ ^[A-Z][A-Za-z0-9_]*$ ]]; then
    printf 'scaffold: nombre Haxe inválido / invalid Haxe name: %s %s\n' "$module" "$class" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
for path in src test; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta Haxe no segura / unsafe Haxe path: %s\n' "$path" >&2
        exit 1
    fi
done

suite="test/${class}Test.hx"
files=(build.hxml RunTests.hx .gitignore "$suite")
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Haxe no seguro / unsafe Haxe file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in haxe.build.hxml haxe.RunTests.hx haxe.Test.hx haxe.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Haxe ausente o vacía / missing or empty Haxe template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- src test
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        build.hxml)
            template=haxe.build.hxml
            ;;
        RunTests.hx)
            template=haxe.RunTests.hx
            ;;
        .gitignore)
            template=haxe.gitignore
            ;;
        "$suite")
            template=haxe.Test.hx
            ;;
    esac

    if [[ "$path" == .gitignore ]]; then
        (set -C; cat -- "$data_dir/scaffold_templates/$template" >"$path") || {
            printf 'scaffold: no se pudo crear .gitignore Haxe / could not create Haxe .gitignore\n' >&2
            exit 1
        }
    else
        (set -C; sed "s/@MODULE@/$class/g" "$data_dir/scaffold_templates/$template" >"$path") || {
            printf 'scaffold: no se pudo crear archivo Haxe / could not create Haxe file: %s\n' "$path" >&2
            exit 1
        }
    fi
done
