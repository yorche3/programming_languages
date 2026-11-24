#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: d_scaffold.sh <module>\n' >&2
    exit 1
fi
if [[ -L dub.sdl || ! -f dub.sdl ]]; then
    printf 'scaffold: manifiesto D no regular / D manifest is not a regular file\n' >&2
    exit 1
fi

module="$1"
templates="$(cd -- "$(dirname -- "$0")" && pwd -P)/scaffold_templates"
result=0
awk -v module="$module" '
    NR == 1 { ok = ($0 == "name \"" module "\""); next }
    NR == 2 { ok = ok && ($0 == "description \"A minimal D application.\""); next }
    NR == 3 { ok = ok && ($0 ~ /^authors "[^"]*"$/); next }
    NR == 4 { ok = ok && ($0 == "license \"proprietary\""); next }
    { ok = 0 }
    END { exit !(NR == 4 && ok) }
' dub.sdl || result=$?

if [[ "$result" == 0 ]]; then
    append="$templates/d.configurations.sdl"
elif [[ "$result" == 1 ]]; then
    result=0
    awk -v module="$module" '
        NR == 1 { ok = ($0 == "name \"" module "\""); next }
        NR == 2 { ok = ok && ($0 ~ /^description "[^"]*"$/); next }
        NR == 3 { ok = ok && ($0 ~ /^authors "[^"]*"$/); next }
        NR == 4 { ok = ok && ($0 ~ /^copyright "[^"]*"$/); next }
        NR == 5 { ok = ok && ($0 == "license \"proprietary\""); next }
        NR == 6 { ok = ok && ($0 == "targetType \"library\""); next }
        { ok = 0 }
        END { exit !(NR == 6 && ok) }
    ' dub.sdl || result=$?
    if [[ "$result" == 0 ]]; then
        append="$templates/d.unittest.sdl"
    elif [[ "$result" == 1 ]]; then
        exit 0
    else
        printf 'scaffold: no se pudo leer el manifiesto D / could not read D manifest\n' >&2
        exit 1
    fi
else
    printf 'scaffold: no se pudo leer el manifiesto D / could not read D manifest\n' >&2
    exit 1
fi

if [[ -L "$append" || ! -f "$append" ]]; then
    printf 'scaffold: plantilla de configuración D ausente o insegura / missing or unsafe D configuration template\n' >&2
    exit 1
fi
cat -- "$append" >> dub.sdl
