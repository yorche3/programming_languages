#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: c_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if make test >"$output" 2>&1; then
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
        if (index($0, "Synthesis:") == 0) next

        summaries++
        line = $0
        sub(/^.*Synthesis:[[:space:]]*/, "", line)
        count = split(line, fields, /\|/)
        if (count != 4) {
            invalid = 1
            next
        }

        for (i = 1; i <= count; i++) {
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", fields[i])
        }
        if (fields[1] !~ /^Tested: [0-9]+$/ ||
            fields[2] !~ /^Passing: [0-9]+$/ ||
            fields[3] !~ /^Failing: [0-9]+$/ ||
            fields[4] !~ /^Crashing: [0-9]+$/) {
            invalid = 1
            next
        }

        sub(/^Tested: /, "", fields[1])
        sub(/^Passing: /, "", fields[2])
        sub(/^Failing: /, "", fields[3])
        sub(/^Crashing: /, "", fields[4])
        tested = fields[1] + 0
        passed = fields[2] + 0
        failed = fields[3] + 0
        crashed = fields[4] + 0
        if (tested != passed + failed + crashed || passed == 0 ||
            failed != 0 || crashed != 0) {
            invalid = 1
        }
    }
    END {
        exit !(summaries == 1 && !invalid && tested > 0)
    }
' "$output"; then
    printf 'test: resumen Criterion ausente, vacío, inconsistente o fallido / missing, empty, inconsistent, or failing Criterion summary\n' >&2
    exit 1
fi

printf 'C tests: passed\n'
