#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 ]]; then
    printf 'scaffold: uso inválido / invalid usage: java_scaffold.sh <module> <Module>\n' >&2
    exit 1
fi

module=$1
class=$2
if [[ ! "$module" =~ ^[a-z][a-z0-9_]*$ || ! "$class" =~ ^[A-Z][A-Za-z0-9_]*$ ]]; then
    printf 'scaffold: nombre Java inválido / invalid Java name: %s %s\n' "$module" "$class" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
directories=(
    src
    src/main
    src/main/java
    "src/main/java/$module"
    src/test
    src/test/java
    "src/test/java/$module"
)
for path in "${directories[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta Java no segura / unsafe Java path: %s\n' "$path" >&2
        exit 1
    fi
done

source="src/main/java/$module/$class.java"
files=("$source" pom.xml .gitignore)
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo Java no seguro / unsafe Java file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in java.Main.java java.pom.xml java.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla Java ausente o vacía / missing or empty Java template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- "src/main/java/$module" "src/test/java/$module"
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        "$source")
            (set -C; sed "s/@MODULE@/$module/g; s/@CLASS@/$class/g" \
                "$data_dir/scaffold_templates/java.Main.java" >"$path") || {
                printf 'scaffold: no se pudo crear la clase Java / could not create Java class: %s\n' "$path" >&2
                exit 1
            }
            ;;
        pom.xml)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/java.pom.xml" >"$path") || {
                printf 'scaffold: no se pudo crear pom.xml / could not create pom.xml\n' >&2
                exit 1
            }
            ;;
        .gitignore)
            (set -C; cat -- "$data_dir/scaffold_templates/java.gitignore" >"$path") || {
                printf 'scaffold: no se pudo crear .gitignore Java / could not create Java .gitignore\n' >&2
                exit 1
            }
            ;;
    esac
done
