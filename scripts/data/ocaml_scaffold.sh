#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: ocaml_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
opam="$module.opam"
suite="test/test_$module.ml"
if [[ -L test || ! -d test ]]; then
    printf 'scaffold: directorio OCaml no seguro o ausente / unsafe or missing OCaml directory\n' >&2
    exit 1
fi
for path in dune-project "$opam" test/dune "$suite" .gitignore; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo OCaml no seguro / unsafe OCaml file: %s\n' "$path" >&2
        exit 1
    fi
done
for template in ocaml.dune-project ocaml.generated.opam ocaml.test-dune ocaml.sentinel.ml; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla OCaml ausente o vacía / missing or empty OCaml template: %s\n' "$template" >&2
        exit 1
    fi
done
if [[ ! -e .gitignore ]]; then
    (set -C; : >.gitignore)
fi
if [[ ! -f dune-project || ! -f "$opam" || ! -f test/dune || ! -f "$suite" || -s "$suite" ]]; then
    exit 0
fi
project_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/ocaml.dune-project")"
test_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/ocaml.test-dune")"
if cmp -s dune-project <(printf '%s\n' "$project_sample"); then a=0; else a=$?; fi
if cmp -s "$opam" "$data_dir/scaffold_templates/ocaml.generated.opam"; then b=0; else b=$?; fi
if cmp -s test/dune <(printf '%s\n' "$test_sample"); then c=0; else c=$?; fi
if ((a > 1 || b > 1 || c > 1)); then
    printf 'scaffold: no se pudo comparar la muestra OCaml / could not compare OCaml sample\n' >&2
    exit 1
fi
if ((a != 0 || b != 0 || c != 0)); then
    exit 0
fi
extra="$(find test -mindepth 1 ! -type d ! -path test/dune ! -path "$suite" -print -quit)"
if [[ -n "$extra" ]]; then
    exit 0
fi

tmp="$(mktemp -d .glot-ocaml.XXXXXX)"
trap 'rm -f -- "$tmp/project" "$tmp/opam" "$tmp/dune" "$tmp/suite"; rmdir -- "$tmp"' EXIT
cp -- dune-project "$tmp/project"
cp -- "$opam" "$tmp/opam"
cp -- test/dune "$tmp/dune"
cp -- "$suite" "$tmp/suite"
sed 's/(depends ocaml)/(depends ocaml (alcotest :with-test))/' dune-project >"$tmp/project"
sed '/^  "ocaml"$/a\  "alcotest" {with-test}' "$opam" >"$tmp/opam"
sed "s/(libraries $module))/(libraries $module alcotest))/" test/dune >"$tmp/dune"
cat -- "$data_dir/scaffold_templates/ocaml.sentinel.ml" >"$tmp/suite"
mv -- "$tmp/project" dune-project
mv -- "$tmp/opam" "$opam"
mv -- "$tmp/dune" test/dune
mv -- "$tmp/suite" "$suite"
