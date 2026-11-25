#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'scaffold: uso inválido / invalid usage: tcl_scaffold.sh\n' >&2
    exit 1
fi

module_dir="$(pwd -P)" || exit 1
module="${module_dir##*/}"
if [[ ! "$module" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: nombre de paquete Tcl no válido / invalid Tcl package name: %s\n' "$module" >&2
    exit 1
fi

parts=()
IFS=_ read -r -a parts <<<"$module"
namespace=""
for part in "${parts[@]}"; do
    namespace+="${part^}"
done

source="src/$module.tcl"
if [[ -L src || ( -e src && ! -d src ) || -L test || ( -e test && ! -d test ) ||
    -L "$source" || ( -e "$source" && ! -f "$source" ) ||
    -L src/pkgIndex.tcl || ( -e src/pkgIndex.tcl && ! -f src/pkgIndex.tcl ) ||
    -L .gitignore || ( -e .gitignore && ! -f .gitignore ) ]]; then
    printf 'scaffold: ruta de Tcl no segura / unsafe Tcl path\n' >&2
    exit 1
fi

mkdir -p -- src test
if [[ ! -e "$source" ]] && ! (set -C; printf 'namespace eval %s {}\n\npackage provide %s 1.0\n' "$namespace" "$module" >"$source"); then
    printf 'scaffold: no se pudo crear la fuente Tcl / could not create Tcl source: %s\n' "$source" >&2
    exit 1
fi
if [[ ! -e src/pkgIndex.tcl ]] &&
    ! (set -C; printf 'package ifneeded %s 1.0 [list source [file join $dir %s.tcl]]\n' "$module" "$module" >src/pkgIndex.tcl); then
    printf 'scaffold: no se pudo crear pkgIndex.tcl\n' >&2
    exit 1
fi
if [[ ! -e .gitignore ]] && ! (set -C; printf '*.log\n' >.gitignore); then
    printf 'scaffold: no se pudo crear .gitignore\n' >&2
    exit 1
fi
