#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: dart_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if dart test --reporter expanded --no-color >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    /All tests passed!$/ {
        summaries++
        if ($1 !~ /^[0-9]+:[0-9][0-9]$/) {
            invalid = 1
            next
        }
        if (NF == 5 && $2 ~ /^\+[0-9]+:$/ &&
            $3 == "All" && $4 == "tests" && $5 == "passed!") {
            count = $2
            sub(/:/, "", count)
            passed += substr(count, 2) + 0
        } else if (NF == 6 && $2 ~ /^\+[0-9]+$/ &&
                   $3 ~ /^~[0-9]+:$/ && $4 == "All" &&
                   $5 == "tests" && $6 == "passed!") {
            passed += substr($2, 2) + 0
        } else {
            invalid = 1
        }
    }
    END { exit !(summaries == 1 && passed > 0 && !invalid) }
' "$output"; then
    printf 'test: resumen Dart ausente, inválido o sin casos aprobados / missing, invalid or empty Dart test summary\n' >&2
    exit 1
fi
