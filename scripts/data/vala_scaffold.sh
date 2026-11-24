#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 1 || ! "$1" =~ ^[a-z][a-z0-9_]*$ ]]; then
    printf 'scaffold: uso inválido / invalid usage: vala_scaffold.sh <module>\n' >&2
    exit 1
fi

module=$1
Module="$(python3 - "$module" <<'PY'
import re, sys
text = sys.argv[1]
print("".join(part[:1].upper() + part[1:] for part in re.split(r"_+", text)))
PY
)"
data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"

if [[ -L src || -L test || ( -e src && ! -d src ) || ( -e test && ! -d test ) ||
      -L meson.build || ( -e meson.build && ! -f meson.build ) ||
      -L "$module.vala" || ( -e "$module.vala" && ! -f "$module.vala" ) ||
      -L "${module}_test.vala" || ( -e "${module}_test.vala" && ! -f "${module}_test.vala" ) ||
      -L "src/$module.vala" || -e "src/$module.vala" ||
      -L "test/${module}_test.vala" || -e "test/${module}_test.vala" ]]; then
    printf 'scaffold: ruta Vala no segura o conflicto / unsafe Vala path or conflict\n' >&2
    exit 1
fi

mkdir -p -- src test

source_template="$data_dir/scaffold_templates/vala.source.vala"
test_template="$data_dir/scaffold_templates/vala.test.vala"
meson_template="$data_dir/scaffold_templates/vala.meson.build"
sentinel_template="$data_dir/scaffold_templates/vala.sentinel.vala"
for template in "$source_template" "$test_template" "$meson_template" "$sentinel_template"; do
    if [[ ! -s "$template" ]]; then
        printf 'scaffold: plantilla Vala ausente o vacía / missing or empty Vala template: %s\n' "$template" >&2
        exit 1
    fi
done

source_sample="$(sed -e "s/@MODULE@/$module/g" -e "s/@MODULE_PASCAL@/$Module/g" "$source_template")"
test_sample="$(sed "s/@MODULE@/$module/g" "$test_template")"
meson_sample="$(sed "s/@MODULE@/$module/g" "$meson_template")"

if [[ -f "$module.vala" && -f "${module}_test.vala" && -f meson.build ]] &&
   cmp -s -- "$module.vala" <(printf '%s\n' "$source_sample") &&
   cmp -s -- "${module}_test.vala" <(printf '%s\n' "$test_sample") &&
   cmp -s -- meson.build <(printf '%s\n' "$meson_sample") &&
   [[ -z "$(find src test -mindepth 1 -print -quit)" ]]; then
    mv -- "$module.vala" "src/$module.vala"
    mv -- "${module}_test.vala" "test/${module}_test.vala"
    sed -e "s/@MODULE@/$module/g" -e "s/@MODULE_PASCAL@/$Module/g" \
        "$sentinel_template" >"test/${module}_test.vala"

    sed \
        -e "s/'$module.vala'/'src\/$module.vala'/" \
        -e "s/'${module}_test.vala'/'test\/${module}_test.vala'/" \
        -e "s/include_directories('\.')/include_directories('src')/" \
        meson.build >meson.build.glot
    mv -- meson.build.glot meson.build
fi
