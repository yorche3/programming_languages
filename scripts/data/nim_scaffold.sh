#!/usr/bin/env bash

if [[ $# != 1 ]]; then
    printf 'scaffold: uso inválido / invalid usage: nim_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
if [[ ! "$module" =~ ^[a-z0-9_]+$ ]]; then
    printf 'scaffold: id de módulo inválido / invalid module id: %s\n' "$module" >&2
    exit 1
fi
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
for path in src "src/$module" tests "$module.nimble"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" && "$path" != "$module.nimble" ) ]]; then
        printf 'scaffold: ruta Nim no segura / unsafe Nim path: %s\n' "$path" >&2
        exit 1
    fi
done

main="src/$module.nim"
submodule="src/$module/submodule.nim"
test1="tests/test1.nim"

main_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/nim.main.nim")" || exit 1
submodule_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/nim.submodule.nim")" || exit 1
test1_sample="$(sed "s/@MODULE@/$module/g" "$data_dir/scaffold_templates/nim.test1.nim")" || exit 1
if [[ -z "$main_sample" || -z "$submodule_sample" || -z "$test1_sample" ]]; then
    printf 'scaffold: plantilla Nim vacía / empty Nim sample\n' >&2
    exit 1
fi

if [[ -f "$main" ]] && cmp -s "$main" <(printf '%s\n' "$main_sample"); then
    rm -- "$main"
fi
if [[ -f "$submodule" ]] && cmp -s "$submodule" <(printf '%s\n' "$submodule_sample"); then
    extra="$(find "src/$module" \( -type f -o -type l \) ! -path "$submodule" -print -quit)" || exit 1
    if [[ -z "$extra" ]]; then
        rm -- "$submodule"
        rmdir -- "src/$module" 2>/dev/null || true
    fi
fi
if [[ -f "$test1" ]] && cmp -s "$test1" <(printf '%s\n' "$test1_sample"); then
    rm -- "$test1"
fi

manifest="$module.nimble"
if [[ -f "$manifest" ]] && ! grep -Fq 'nim c -r tests/' "$manifest"; then
    task='task test, "Run the unit tests":
    exec "nim c -r tests/{module}_tests.nim"
'
    task="${task//\{module\}/$module}"
    printf '\n%s\n' "$task" >>"$manifest"
fi
