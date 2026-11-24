#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: forth_test.sh\n' >&2
    exit 1
fi
if [[ -L test || ! -d test || -L test/run-tests.forth || ! -f test/run-tests.forth ]]; then
    printf 'test: falta runner Forth regular o ruta segura / missing regular Forth runner or safe path\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if (cd -- test && gforth run-tests.forth) >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    /^[[:space:]]*tests runned([[:space:]]|$)/ {
        if (form && form != 1) invalid = 1
        form = 1
        runs++
        if (NF != 3 || $2 != "runned" || $3 !~ /^[0-9]+$/) {
            invalid = 1
        } else {
            total = $3 + 0
        }
        next
    }
    /^[[:space:]]*passed([[:space:]]|$)/ {
        if (form && form != 1) invalid = 1
        form = 1
        passes++
        if (NF != 2 || $2 !~ /^[0-9]+$/) {
            invalid = 1
        } else {
            passed = $2 + 0
        }
        next
    }
    /^[[:space:]]*failed([[:space:]]|$)/ {
        if (form && form != 1) invalid = 1
        form = 1
        failures++
        if (NF != 2 || $2 !~ /^[0-9]+$/) {
            invalid = 1
        } else {
            failed = $2 + 0
        }
        next
    }
    /^[[:space:]]*Tests run:/ {
        if (form && form != 2) invalid = 1
        form = 2
        summaries++
        if (NF != 9 || $1 != "Tests" || $2 != "run:" ||
            $3 !~ /^[0-9]+$/ || $4 != "," ||
            $5 != "Passed:" || $6 !~ /^[0-9]+$/ ||
            $7 != "," || $8 != "Failed:" || $9 !~ /^[0-9]+$/) {
            invalid = 1
        } else {
            total = $3 + 0
            passed = $6 + 0
            failed = $9 + 0
        }
        next
    }
    END {
        if (form == 1) {
            summaries = runs
            if (runs != 1 || passes != 1 || failures != 1) invalid = 1
        } else if (form == 2) {
            if (summaries != 1) invalid = 1
        } else {
            invalid = 1
        }
        exit !(summaries == 1 && !invalid && total == passed + failed &&
               failed == 0 && passed > 0)
    }
' "$output"; then
    printf 'test: resumen Forth ausente, inválido, con fallos o sin casos aprobados / missing, invalid, failing or empty Forth test summary\n' >&2
    exit 1
fi
