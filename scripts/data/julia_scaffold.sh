#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 2 || ! "$1" =~ ^[a-z][a-z0-9_]*$ || ! "$2" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: julia_scaffold.sh <module> <Module>\n' >&2
    exit 1
fi

module="$1"
module_pascal="$2"
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)" || exit 1
source="src/$module.jl"
target="src/$module_pascal.jl"
runner="test/run_tests.jl"
pkg_runner="test/runtests.jl"
generated="$(mktemp)"
transformed="$(mktemp)"
project_transformed="$(mktemp)"
trap 'rm -f -- "$generated" "$transformed" "$project_transformed"' EXIT
project_name_ready=0

for path in Project.toml src test; do
    if [[ -L "$path" || ( -e "$path" && ( ( "$path" == Project.toml && ! -f "$path" ) || ( "$path" != Project.toml && ! -d "$path" ) ) ) ]]; then
        printf 'scaffold: ruta Julia no segura / unsafe Julia path: %s\n' "$path" >&2
        exit 1
    fi
done

if [[ ! -f Project.toml || -L "$source" || ( -e "$source" && ! -f "$source" ) ||
    -L "$target" || ( -e "$target" && ! -f "$target" ) ]]; then
    printf 'scaffold: fuente o manifiesto Julia no regular / Julia source or manifest is not a regular file\n' >&2
    exit 1
fi

for path in "$runner" "$pkg_runner"; do
    if [[ -L "$path" || ( -e "$path" && ! -f "$path" ) ]]; then
        printf 'scaffold: runner Julia no seguro / unsafe Julia test runner: %s\n' "$path" >&2
        exit 1
    fi
done

if [[ -L "$data_dir/scaffold_templates/julia.test.toml" ||
    ! -f "$data_dir/scaffold_templates/julia.test.toml" ||
    ! -s "$data_dir/scaffold_templates/julia.test.toml" ]]; then
    printf 'scaffold: plantilla de pruebas Julia ausente o vacía / missing or empty Julia test template\n' >&2
    exit 1
fi

cat >"$generated" <<EOF
module $module

greet() = print("Hello World!")

end # module $module
EOF
cat >"$transformed" <<EOF
module $module_pascal

greet() = print("Hello World!")

end # module $module_pascal
EOF

if awk -v module="$module" '
    NR == 1 { ok = ($0 == "name = \"" module "\""); next }
    NR == 2 { ok = ok && ($0 ~ /^uuid = "[0-9a-f-]{36}"$/); next }
    NR == 3 { ok = ok && ($0 == "version = \"0.1.0\""); next }
    NR == 4 { ok = ok && ($0 ~ /^authors = \[.*\]$/); next }
    { ok = 0 }
    END { exit !(NR == 4 && ok) }
' Project.toml; then
    awk -v module="$module_pascal" '
        NR == 1 { print "name = \"" module "\""; next }
        { print }
    ' Project.toml >"$project_transformed"
    printf '\n' >>"$project_transformed"
    cat -- "$data_dir/scaffold_templates/julia.test.toml" >>"$project_transformed"
    chmod --reference=Project.toml "$project_transformed"
    mv -- "$project_transformed" Project.toml
    project_name_ready=1
elif awk -v module="$module_pascal" '
    NR == 1 { exit !($0 == "name = \"" module "\"") }
' Project.toml; then
    project_name_ready=1
fi

if ((project_name_ready)) && [[ -f "$source" ]] && cmp -s -- "$source" "$generated" && [[ ! -e "$target" ]] &&
    [[ -z "$(find src -mindepth 1 -maxdepth 1 ! -name "$module.jl" -print -quit)" ]]; then
    if (set -C; cat -- "$transformed" >"$target"); then
        rm -- "$source"
    else
        printf 'scaffold: no se pudo renombrar la fuente Julia / could not rename Julia source\n' >&2
        exit 1
    fi
fi

if [[ ! -s "$runner" ]]; then
    printf 'error("scaffold: runner Julia no configurado / Julia test runner not configured")\n' >"$runner"
fi

if [[ ! -s "$pkg_runner" ]]; then
    printf 'include("run_tests.jl")\n' >"$pkg_runner"
fi
