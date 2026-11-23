#!/usr/bin/env bash

set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z0-9_]+$ ]]; then
    printf 'scaffold: id Haskell inválido / invalid Haskell module id\n' >&2
    exit 1
fi

package="${1//_/-}"
manifest="$package.cabal"
main=test/Main.hs
runner=test/RunTests.hs
templates="$(cd -- "$(dirname -- "$0")" && pwd -P)/scaffold_templates"

for path in test "$manifest" "$main" "$runner"; do
    if [[ -L "$path" || ( -e "$path" && "$path" == test && ! -d "$path" ) ||
          ( -e "$path" && "$path" != test && ! -f "$path" ) ]]; then
        printf 'scaffold: ruta Haskell no segura / unsafe Haskell path: %s\n' "$path" >&2
        exit 1
    fi
done

if [[ ! -f "$manifest" || ! -f "$main" || -e "$runner" ]]; then
    printf 'scaffold: revisar manifiesto y runner Haskell conservados / review preserved Haskell manifest and runner\n' >&2
    exit 0
fi

if cmp -s -- "$main" "$templates/haskell.Main.hs"; then
    :
else
    status=$?
    if ((status != 1)); then
        printf 'scaffold: no se pudo comparar el runner Haskell / could not compare Haskell runner\n' >&2
        exit 1
    fi
    printf 'scaffold: runner Haskell propio conservado / custom Haskell runner preserved\n' >&2
    exit 0
fi

tmp="$(mktemp -d ./.glot-haskell.XXXXXXXX)"
trap 'rm -f -- "$tmp/suite" "$tmp/expected" "$tmp/manifest" "$tmp/original"; rmdir -- "$tmp"' EXIT

cp -p -- "$manifest" "$tmp/original"
awk '/^test-suite / { suite = 1 } suite { print }' "$tmp/original" >"$tmp/suite"
base="$(sed -n 's/^        \(base \^>=[0-9][0-9.]*\),$/\1/p' "$tmp/suite")"
if [[ ! "$base" =~ ^base\ \^\>=([0-9]+\.)*[0-9]+$ ]]; then
    printf 'scaffold: test-suite Cabal no reconocido / unrecognized Cabal test suite\n' >&2
    exit 0
fi
sed -e "s/@PACKAGE@/$package/g" -e "s/@BASE@/$base/g" \
    "$templates/haskell.cabal-test" >"$tmp/expected"
if cmp -s -- "$tmp/suite" "$tmp/expected"; then
    :
else
    status=$?
    if ((status != 1)); then
        printf 'scaffold: no se pudo comparar el manifiesto Cabal / could not compare Cabal manifest\n' >&2
        exit 1
    fi
    printf 'scaffold: test-suite Cabal propio conservado / custom Cabal test suite preserved\n' >&2
    exit 0
fi

cp -p -- "$tmp/original" "$tmp/manifest"
{
    awk '/^test-suite / { exit } { print }' "$tmp/original"
    sed -e 's/    main-is:          Main.hs/    main-is:          RunTests.hs/' \
        -e "s/^        $package$/        $package,/" "$tmp/suite"
    printf '        hspec ^>=2.11.0\n'
} >"$tmp/manifest"

if ! cmp -s -- "$manifest" "$tmp/original" || ! cmp -s -- "$main" "$templates/haskell.Main.hs"; then
    printf 'scaffold: archivos Haskell cambiaron durante la preparación / Haskell files changed during preparation\n' >&2
    exit 1
fi
if ! (set -C; cat -- "$templates/haskell.RunTests.hs" >"$runner"); then
    printf 'scaffold: no se pudo crear el runner Haskell / could not create Haskell runner\n' >&2
    exit 1
fi
if ! mv -- "$tmp/manifest" "$manifest"; then
    printf 'scaffold: no se pudo actualizar el manifiesto Cabal / could not update Cabal manifest\n' >&2
    exit 1
fi
if cmp -s -- "$main" "$templates/haskell.Main.hs"; then
    rm -- "$main"
else
    printf 'scaffold: runner anterior modificado, conservado / modified previous runner preserved\n' >&2
    exit 1
fi
printf 'scaffold: test-suite Haskell adaptado a Hspec / Haskell test suite adapted to Hspec\n' >&2
