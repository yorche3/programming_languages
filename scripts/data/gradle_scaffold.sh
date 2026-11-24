#!/usr/bin/env bash

if [[ $# != 2 ]]; then
    printf 'scaffold: uso inválido / invalid usage: gradle_scaffold.sh <groovy|kotlin> <module>\n' >&2
    exit 1
fi

language=$1
module=$2
case "$language" in
    groovy) extension=groovy ;;
    kotlin) extension=kt ;;
    *) printf 'scaffold: lenguaje Gradle no admitido / unsupported Gradle language: %s\n' "$language" >&2; exit 1 ;;
esac
if [[ ! "$module" =~ ^[a-z0-9_]+$ ]]; then
    printf 'scaffold: id de módulo inválido / invalid module id: %s\n' "$module" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
src="lib/src/main/$language/$module/Library.$extension"
tst="lib/src/test/$language/$module/LibraryTest.$extension"
for path in lib lib/src lib/src/main "lib/src/main/$language" "lib/src/main/$language/$module" \
    lib/src/test "lib/src/test/$language" "lib/src/test/$language/$module"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta Gradle no segura / unsafe Gradle path: %s\n' "$path" >&2
        exit 1
    fi
done
if [[ ! -d lib/src || -L "$src" || -L "$tst" ||
      ( -e "$src" && ! -f "$src" ) || ( -e "$tst" && ! -f "$tst" ) ]]; then
    printf 'scaffold: ruta Gradle no segura o fuentes ausentes / unsafe Gradle path or missing sources\n' >&2
    exit 1
fi
if [[ ! -f "$src" || ! -f "$tst" ]]; then
    exit 0
fi

source_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/$language.Library.$extension")" || exit 1
test_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/$language.LibraryTest.$extension")" || exit 1
if [[ -z "$source_sample" || -z "$test_sample" ]]; then
    printf 'scaffold: plantilla Gradle vacía / empty Gradle sample\n' >&2
    exit 1
fi
if cmp -s "$src" <(printf '%s\n' "$source_sample"); then a=0; else a=$?; fi
if cmp -s "$tst" <(printf '%s\n' "$test_sample"); then b=0; else b=$?; fi
if ((a > 1 || b > 1)); then
    printf 'scaffold: no se pudo comparar la muestra Gradle / could not compare Gradle sample\n' >&2
    exit 1
fi
if ((a != 0 || b != 0)); then
    exit 0
fi
extra="$(find lib/src \( -type f -o -type l \) ! -path "$src" ! -path "$tst" -print -quit)" || exit 1
if [[ -z "$extra" ]]; then
    rm -- "$tst" "$src"
fi
