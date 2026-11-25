#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! -f "$1" || -L "$1" ]]; then
    printf 'scaffold: falta la plantilla Lua / Lua scaffold template is missing\n' >&2
    exit 1
fi

template="$1"
if [[ -L src || ( -e src && ! -d src ) ||
    -L test || ( -e test && ! -d test ) ||
    -L .busted || ( -e .busted && ! -f .busted ) ||
    -L .gitignore || ( -e .gitignore && ! -f .gitignore ) ]]; then
    printf 'scaffold: ruta Lua no segura / unsafe Lua path\n' >&2
    exit 1
fi

mkdir -p -- src test
if [[ ! -e .gitignore ]] && ! (set -C; : >.gitignore); then
    printf 'scaffold: no se pudo crear .gitignore\n' >&2
    exit 1
fi
if [[ ! -e .busted ]] && ! (set -C; cat -- "$template" >.busted); then
    printf 'scaffold: no se pudo crear .busted\n' >&2
    exit 1
fi
