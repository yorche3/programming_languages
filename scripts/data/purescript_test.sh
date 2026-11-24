#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: purescript_test.sh\n' >&2
    exit 1
fi
if [[ -L spago.yaml || ! -f spago.yaml ]]; then
    printf 'test: falta manifiesto Spago regular / missing regular Spago manifest\n' >&2
    exit 1
fi

work_dir="$(mktemp -d)" || {
    printf 'test: no se pudo crear directorio temporal / could not create temporary directory\n' >&2
    exit 1
}
trap 'rm -rf -- "$work_dir"' EXIT
output="$work_dir/spago.log"
if spago test --offline --strict --no-color --output "$work_dir/output" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1

passed=0
while IFS= read -r count; do
    [[ -n "$count" ]] || continue
    passed=$((passed + count))
done < <(grep -E 'All [0-9]+ tests? passed!' "$output" | sed -E 's/.*All ([0-9]+) tests? passed!.*/\1/')

if ((rc != 0)); then
    exit "$rc"
fi
if ! awk '
    function visible_count(value, parts) {
        if (value ~ /^[0-9]+$/) return value + 0
        if (value ~ /^[0-9]+\/[0-9]+$/) {
            split(value, parts, "/")
            return parts[1] + 0
        }
        return -1
    }
    /^[[:space:]]*Src[[:space:]]+Lib[[:space:]]+All[[:space:]]*$/ {
        headers++
        expecting = 1
        next
    }
    expecting {
        expecting = 0
        if ($1 != "Warnings" || NF != 4) {
            invalid = 1
            next
        }
        summaries++
        src = visible_count($2)
        lib = visible_count($3)
        all = visible_count($4)
        if (src < 0 || lib < 0 || all < 0 || src + lib != all || all != 0) invalid = 1
    }
    END { exit !(headers == 1 && summaries == 1 && !invalid && !expecting) }
' "$output"; then
    printf 'test: resumen de warnings PureScript ausente, inválido o no vacío / missing, invalid or nonzero PureScript warning summary\n' >&2
    exit 1
fi
if ((passed == 0)); then
    printf 'test: no se ejecutaron casos PureScript / no PureScript test cases executed\n' >&2
    exit 1
fi
