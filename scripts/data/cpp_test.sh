#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: cpp_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if bazelisk test --test_output=all //... >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    {
        gsub(/\033\[[0-9;]*m/, "")
        line = $0

        if (line ~ /^\[==========\] Running [0-9]+ tests? from [0-9]+ test suites?\.$/) {
            starts++
            sub(/^\[==========\] Running /, "", line)
            split(line, fields, /[[:space:]]+/)
            started += fields[1] + 0
        } else if (line ~ /^\[==========\] [0-9]+ tests? from [0-9]+ test suites? ran\./) {
            summaries++
            sub(/^\[==========\] /, "", line)
            split(line, fields, /[[:space:]]+/)
            finished += fields[1] + 0
        } else if (line ~ /^\[[[:space:]]*PASSED[[:space:]]*\][[:space:]]+[0-9]+ tests?\./) {
            sub(/^\[[[:space:]]*PASSED[[:space:]]*\][[:space:]]*/, "", line)
            split(line, fields, /[[:space:]]+/)
            passed += fields[1] + 0
        } else if (line ~ /^\[[[:space:]]*FAILED[[:space:]]*\][[:space:]]+[0-9]+ tests?([.,]|[[:space:]])/) {
            sub(/^\[[[:space:]]*FAILED[[:space:]]*\][[:space:]]*/, "", line)
            split(line, fields, /[[:space:]]+/)
            failed += fields[1] + 0
        } else if (line ~ /^\[[[:space:]]*SKIPPED[[:space:]]*\][[:space:]]+[0-9]+ tests?([.,]|[[:space:]])/) {
            sub(/^\[[[:space:]]*SKIPPED[[:space:]]*\][[:space:]]*/, "", line)
            split(line, fields, /[[:space:]]+/)
            skipped += fields[1] + 0
        }
    }
    END {
        exit !(starts > 0 && starts == summaries && started == finished &&
               passed > 0 && failed == 0 &&
               finished == passed + failed + skipped)
    }
' "$output"; then
    printf 'test: resumen Google Test ausente, vacío, inconsistente o fallido / missing, empty, inconsistent, or failing Google Test summary\n' >&2
    exit 1
fi

printf 'C++ tests: passed\n'
