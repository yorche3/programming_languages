#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso o id Ruby inválido / invalid usage or Ruby module id: ruby_scaffold.sh <module>\n' >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
for path in src test; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta Ruby no segura / unsafe Ruby path: %s\n' "$path" >&2
        exit 1
    fi
done

files=(Gemfile .rspec .gitignore)
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Ruby no seguro / unsafe Ruby file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in ruby.Gemfile ruby.rspec ruby.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Ruby ausente o vacía / missing or empty Ruby template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- src test
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        Gemfile) template=ruby.Gemfile ;;
        .rspec) template=ruby.rspec ;;
        .gitignore) template=ruby.gitignore ;;
    esac
    (set -C; cat -- "$data_dir/scaffold_templates/$template" >"$path") || {
        printf 'scaffold: no se pudo crear archivo Ruby / could not create Ruby file: %s\n' "$path" >&2
        exit 1
    }
done
