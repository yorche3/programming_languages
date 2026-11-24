#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso o id ReScript inválido / invalid usage or ReScript module id: rescript_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
for path in src test; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta ReScript no segura / unsafe ReScript path: %s\n' "$path" >&2
        exit 1
    fi
done

files=(package.json rescript.json jest.config.js babel.config.js .gitignore)
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo ReScript no seguro / unsafe ReScript file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in rescript.package.json rescript.rescript.json rescript.jest.config.js \
    rescript.babel.config.js rescript.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla ReScript ausente o vacía / missing or empty ReScript template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- src test
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        package.json) template=rescript.package.json ;;
        rescript.json) template=rescript.rescript.json ;;
        jest.config.js) template=rescript.jest.config.js ;;
        babel.config.js) template=rescript.babel.config.js ;;
        .gitignore) template=rescript.gitignore ;;
    esac
    (set -C; sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/$template" >"$path") || {
        printf 'scaffold: no se pudo crear archivo ReScript / could not create ReScript file: %s\n' "$path" >&2
        exit 1
    }
done
