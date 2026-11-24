#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: rust_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if cargo test --color never >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    /^[[:space:]]*(Running |Doc-tests )/ {
        if (active && summaries != 1) bad = 1
        active = 1
        targets++
        running = -1
        summaries = 0
        next
    }
    /^running [0-9]+ tests?$/ {
        if (!active || running != -1) bad = 1
        running = $2 + 0
        next
    }
    /^test result:/ {
        if (!active || running < 0 || $3 != "ok." ||
            $4 !~ /^[0-9]+$/ || $5 != "passed;" ||
            $6 !~ /^[0-9]+$/ || $7 != "failed;" ||
            $8 !~ /^[0-9]+$/ || $9 != "ignored;" ||
            $10 !~ /^[0-9]+$/ || $11 != "measured;" ||
            $12 !~ /^[0-9]+$/ || $13 != "filtered" || $14 != "out;" ||
            $6 != 0 || $12 != 0 || running != $4 + $6 + $8 + $10) {
            bad = 1
        }
        summaries++
        passed += $4
        next
    }
    END { exit !(targets > 0 && active && summaries == 1 && passed > 0 && !bad) }
' "$output"; then
    printf 'test: resultados Rust ausentes, inconsistentes o sin casos aprobados / missing, inconsistent or empty Rust test results\n' >&2
    exit 1
fi
