#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: grain_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if make test >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    { gsub(/\033\[[0-9;]*m/, "") }
    /^(Tests|Cases): [0-9]+ passed, [0-9]+ failed, [0-9]+ total$/ {
        summaries++
        line = $0
        sub(/^(Tests|Cases): /, "", line)
        split(line, counts, /[^0-9]+/)
        passed = counts[1] + 0
        failed = counts[2] + 0
        total = counts[3] + 0
        if (passed + failed != total || passed == 0 || failed != 0) bad = 1
    }
    /^Test .* PASSED\.$/ { individual_passed++ }
    /^Test .* FAILED:/ { individual_failed++ }
    END {
        if (summaries == 1 && individual_passed == 0 && individual_failed == 0 && !bad) exit 0
        if (summaries == 0 && individual_passed > 0 && individual_failed == 0 && !bad) exit 0
        exit 1
    }
' "$output"; then
    printf 'test: resumen Grain ausente, vacío o fallido / missing, empty, or failed Grain results\n' >&2
    exit 1
fi
