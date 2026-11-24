#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 ]]; then
    printf 'scaffold: uso inválido / invalid usage: csharp_scaffold.sh <Module>\n' >&2
    exit 1
fi

module=$1
if [[ ! "$module" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    printf 'scaffold: nombre C# inválido / invalid C# name: %s\n' "$module" >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
paths=(
    src
    "src/$module"
    test
    "test/$module.Tests"
    "src/$module/Class1.cs"
    "test/$module.Tests/UnitTest1.cs"
)
for path in "${paths[@]}"; do
    if [[ -L "$path" || ( -e "$path" && ! -d "$path" && "$path" != *.cs ) ||
          ( "$path" == *.cs && -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: ruta C# no segura / unsafe C# path: %s\n' "$path" >&2
        exit 1
    fi
done

compare_sample() {
    local target=$1
    local template=$2
    if [[ ! -r "$target" || ! -s "$template" || ! -r "$template" ]] ||
        ! grep -Fq '@MODULE@' "$template"; then
        printf 'scaffold: muestra C# ilegible o inválida / unreadable or invalid C# sample: %s\n' "$template" >&2
        return 2
    fi

    if sed '1s/^\xef\xbb\xbf//' "$target" | tr -d '\r' |
        cmp -s - <(sed "s/@MODULE@/$module/g" "$template"); then
        return 0
    else
        local result=$?
        if ((result == 1)); then
            return 1
        fi
        printf 'scaffold: no se pudo comparar la muestra C# / could not compare C# sample: %s\n' "$target" >&2
        return 2
    fi
}

class_source="src/$module/Class1.cs"
test_source="test/$module.Tests/UnitTest1.cs"
remove_class=0
remove_test=0

if [[ -e "$class_source" ]]; then
    if compare_sample "$class_source" "$data_dir/scaffold_templates/csharp.Class1.cs"; then
        remove_class=1
    else
        result=$?
        ((result == 1)) || exit 1
    fi
fi
if [[ -e "$test_source" ]]; then
    if compare_sample "$test_source" "$data_dir/scaffold_templates/csharp.UnitTest1.cs"; then
        remove_test=1
    else
        result=$?
        ((result == 1)) || exit 1
    fi
fi

if ((remove_class)); then
    rm -- "$class_source" || {
        printf 'scaffold: no se pudo retirar la muestra C# / could not remove C# sample: %s\n' "$class_source" >&2
        exit 1
    }
fi
if ((remove_test)); then
    rm -- "$test_source" || {
        printf 'scaffold: no se pudo retirar la muestra C# / could not remove C# sample: %s\n' "$test_source" >&2
        exit 1
    }
fi
