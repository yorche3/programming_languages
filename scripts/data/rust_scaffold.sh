#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'scaffold: uso inválido / invalid usage: rust_scaffold.sh\n' >&2
    exit 1
fi

template="$(cd -- "$(dirname -- "$0")" && pwd -P)/scaffold_templates/rust.lib.rs"
if [[ -L Cargo.toml || ! -f Cargo.toml || -L src || ! -d src ||
      -L src/lib.rs || ! -f src/lib.rs || -L tests ||
      ( -e tests && ! -d tests ) ]]; then
    printf 'scaffold: ruta Rust no segura o archivo ausente / unsafe Rust path or missing file\n' >&2
    exit 1
fi
if [[ ! -s "$template" ]]; then
    printf 'scaffold: plantilla Rust ausente o vacía / missing or empty Rust template\n' >&2
    exit 1
fi

mkdir -p -- tests
if cmp -s -- src/lib.rs "$template"; then
    other_sources="$(find src -mindepth 1 ! -path src/lib.rs -print -quit)"
    other_tests="$(find tests -mindepth 1 -print -quit)"
    if [[ -z "$other_sources" && -z "$other_tests" ]]; then
        tmp="$(mktemp src/.glot-rust.XXXXXX)"
        trap 'rm -f -- "$tmp"' EXIT
        chmod --reference=src/lib.rs "$tmp"
        mv -- "$tmp" src/lib.rs
    fi
else
    rc=$?
    if ((rc != 1)); then
        printf 'scaffold: no se pudo comparar la muestra Rust / could not compare Rust sample\n' >&2
        exit "$rc"
    fi
fi
