#!/usr/bin/env bash

set -euo pipefail

if [[ $# != 4 || ! "$1" =~ ^[a-z0-9_]+$ ||
      ( "$2" != library && "$2" != test ) ||
      ! "$3" =~ ^[A-Z][A-Za-z0-9_]*(\.[A-Z][A-Za-z0-9_]*)*$ || "$3" == Main ||
      ( "$4" != apply && "$4" != dry-run ) ]]; then
    printf 'sync-build: uso inválido / invalid usage\n' >&2
    exit 2
fi

package="${1//_/-}"
target="$2"
module="$3"
mode="$4"
manifest="$package.cabal"
templates="$(cd -- "$(dirname -- "$0")" && pwd -P)/scaffold_templates"

shopt -s nullglob
manifests=( *.cabal )
if [[ ${#manifests[@]} != 1 || "${manifests[0]}" != "$manifest" ||
      -L "$manifest" || ! -f "$manifest" ]]; then
    printf 'sync-build: se requiere un manifiesto Cabal regular único / one regular Cabal manifest required\n' >&2
    exit 1
fi

if [[ "$target" == library ]]; then
    header=library
    source=lib
else
    header="test-suite $package-test"
    source=test
fi

path="$source"
relative="${module//./\/}.hs"
module_pattern="${module//./\\.}"
IFS=/ read -r -a parts <<<"$relative"
for part in "${parts[@]}"; do
    if [[ -L "$path" || ! -d "$path" ]]; then
        printf 'sync-build: directorio de fuente inseguro / unsafe source directory: %s\n' "$path" >&2
        exit 1
    fi
    path="$path/$part"
done
if [[ -L "$path" || ! -f "$path" ]] ||
   ! grep -Eq "^[[:space:]]*module[[:space:]]+$module_pattern([[:space:](]|$)" "$path"; then
    printf 'sync-build: módulo ausente o no reconocido / missing or unrecognized module: %s\n' "$path" >&2
    exit 1
fi

if [[ "$mode" == dry-run ]]; then
    tmp="$(mktemp -d)"
else
    tmp="$(mktemp -d ./.glot-haskell-sync.XXXXXXXX)"
fi
trap 'rm -f -- "$tmp/original" "$tmp/section" "$tmp/normalized" "$tmp/expected" "$tmp/common" "$tmp/result"; rmdir -- "$tmp"' EXIT

cp -p -- "$manifest" "$tmp/original"
extract_section() {
    awk -v header="$1" '
        $0 == header { count++; active = 1 }
        active && $0 != header && /^[^[:space:]]/ && !/^--/ { active = 0 }
        active { print }
        END { if (count != 1) exit 1 }
    ' "$tmp/original" >"$2"
}

if ! extract_section 'common warnings' "$tmp/common" ||
   ! printf 'common warnings\n    ghc-options: -Wall\n\n' | cmp -s - "$tmp/common" ||
   ! extract_section "$header" "$tmp/section"; then
    printf 'sync-build: target Cabal no reconocido / unrecognized Cabal target\n' >&2
    exit 1
fi

declarations="$(awk '/^    other-modules:/ { count++ } END { print count + 0 }' "$tmp/section")"
if ((declarations > 1)); then
    printf 'sync-build: declaraciones ambiguas / ambiguous module declarations\n' >&2
    exit 1
fi
existing=""
if ((declarations == 1)); then
    line="$(grep '^    other-modules:' "$tmp/section")"
    if [[ ! "$line" =~ ^'    other-modules:     '([A-Z][A-Za-z0-9_]*(\.[A-Z][A-Za-z0-9_]*)*)(,\ [A-Z][A-Za-z0-9_]*(\.[A-Z][A-Za-z0-9_]*)*)*$ ]]; then
        printf 'sync-build: lista de módulos no reconocida / unrecognized module list\n' >&2
        exit 1
    fi
    existing="${line#    other-modules:     }"
fi
sed '/^    other-modules:/d' "$tmp/section" >"$tmp/normalized"

if [[ "$target" == library ]]; then
    exposed="$(sed -n 's/^    exposed-modules:  \([A-Z][A-Za-z0-9_.]*\)$/\1/p' "$tmp/section")"
    base="$(sed -n 's/^    build-depends:    \(base \^>=[0-9][0-9.]*\)$/\1/p' "$tmp/section")"
    if [[ ! "$exposed" =~ ^[A-Z][A-Za-z0-9_]*(\.[A-Z][A-Za-z0-9_]*)*$ ]]; then
        printf 'sync-build: interfaz de biblioteca no reconocida / unrecognized library interface\n' >&2
        exit 1
    fi
    template="$templates/haskell.cabal-library"
else
    base="$(sed -n 's/^        \(base \^>=[0-9][0-9.]*\),$/\1/p' "$tmp/section")"
    template="$templates/haskell.cabal-test"
fi
if [[ ! "$base" =~ ^base\ \^\>=([0-9]+\.)*[0-9]+$ ]]; then
    printf 'sync-build: dependencia base no reconocida / unrecognized base dependency\n' >&2
    exit 1
fi
if [[ "$target" == library ]]; then
    sed -e "s/@EXPOSED@/$exposed/g" -e "s/@BASE@/$base/g" "$template" >"$tmp/expected"
else
    sed -e "s/@PACKAGE@/$package/g" -e "s/@BASE@/$base/g" \
        -e 's/    main-is:          Main.hs/    main-is:          RunTests.hs/' \
        -e "s/^        $package$/        $package,/" "$template" >"$tmp/expected"
    printf '        hspec ^>=2.11.0\n' >>"$tmp/expected"
fi
if ! cmp -s -- "$tmp/normalized" "$tmp/expected"; then
    printf 'sync-build: configuración propia conservada / custom Cabal configuration preserved\n' >&2
    exit 1
fi

if [[ "$target" == library && "$module" == "$exposed" ]]; then
    printf 'sync-build: módulo ya exportado / module already exposed: %s\n' "$module" >&2
    printf 'unchanged\n'
    exit 0
fi
if [[ -n "$existing" ]]; then
    IFS=',' read -r -a names <<<"$existing"
    declare -A seen=()
    already=0
    for name in "${names[@]}"; do
        name="${name# }"
        if [[ -n "${seen[$name]:-}" ]]; then
            printf 'sync-build: módulo duplicado / duplicate module: %s\n' "$name" >&2
            exit 1
        fi
        seen[$name]=1
        [[ "$name" == "$module" ]] && already=1
    done
    if ((already)); then
        printf 'sync-build: módulo ya declarado / module already declared: %s\n' "$module" >&2
        printf 'unchanged\n'
        exit 0
    fi
    updated="$existing, $module"
else
    updated="$module"
fi

cp -p -- "$tmp/original" "$tmp/result"
awk -v header="$header" -v list="$updated" '
    $0 == header { active = 1 }
    active && $0 != header && /^[^[:space:]]/ && !/^--/ { active = 0 }
    active && /^    other-modules:/ { next }
    { print }
    active && $0 == "    -- other-modules:" {
        print "    other-modules:     " list
    }
' "$tmp/original" >"$tmp/result"

if [[ "$mode" == dry-run ]]; then
    diff -u -- "$tmp/original" "$tmp/result" || status=$?
    if [[ "${status:-0}" != 1 ]]; then
        printf 'sync-build: no se pudo generar el plan / could not generate plan\n' >&2
        exit 1
    fi
    exit 0
fi
if [[ -L "$manifest" ]] || ! cmp -s -- "$manifest" "$tmp/original"; then
    printf 'sync-build: manifiesto modificado durante la preparación / manifest changed during preparation\n' >&2
    exit 1
fi
mv -- "$tmp/result" "$manifest"
printf 'sync-build: declarado en %s / declared in %s: %s\n' "$header" "$header" "$module" >&2
printf 'updated\n'
