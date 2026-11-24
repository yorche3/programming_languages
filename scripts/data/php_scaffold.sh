#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 ]]; then
    printf 'scaffold: uso inválido / invalid usage: php_scaffold.sh <module> <Module>\n' >&2
    exit 1
fi

module=$1
class=$2
if [[ ! "$module" =~ ^[a-z][a-z0-9_]*$ || ! "$class" =~ ^[A-Z][A-Za-z0-9_]*$ ]]; then
    printf 'scaffold: nombre PHP inválido / invalid PHP name: %s %s\n' "$module" "$class" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
for path in src test; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" ) ]]; then
        printf 'scaffold: ruta PHP no segura / unsafe PHP path: %s\n' "$path" >&2
        exit 1
    fi
done

source="src/$class.php"
files=("$source" composer.json phpunit.xml .gitignore)
for path in "${files[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: archivo PHP no seguro / unsafe PHP file: %s\n' "$path" >&2
        exit 1
    fi
done

for template in php.Module.php php.composer.json php.phpunit.xml php.gitignore; do
    if [[ ! -s "$data_dir/scaffold_templates/$template" ]]; then
        printf 'scaffold: plantilla PHP ausente o vacía / missing or empty PHP template: %s\n' "$template" >&2
        exit 1
    fi
done

mkdir -p -- src test
for path in "${files[@]}"; do
    [[ -e "$path" ]] && continue
    case "$path" in
        "$source")
            (set -C; sed "s/@MODULE@/$module/g; s/@CLASS@/$class/g" \
                "$data_dir/scaffold_templates/php.Module.php" >"$path") || {
                printf 'scaffold: no se pudo crear la fuente PHP / could not create PHP source: %s\n' "$path" >&2
                exit 1
            }
            ;;
        composer.json)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/php.composer.json" >"$path") || {
                printf 'scaffold: no se pudo crear composer.json\n' >&2
                exit 1
            }
            ;;
        phpunit.xml)
            (set -C; sed "s/@MODULE@/$module/g" \
                "$data_dir/scaffold_templates/php.phpunit.xml" >"$path") || {
                printf 'scaffold: no se pudo crear phpunit.xml\n' >&2
                exit 1
            }
            ;;
        .gitignore)
            (set -C; cat -- "$data_dir/scaffold_templates/php.gitignore" >"$path") || {
                printf 'scaffold: no se pudo crear .gitignore PHP\n' >&2
                exit 1
            }
            ;;
    esac
done
