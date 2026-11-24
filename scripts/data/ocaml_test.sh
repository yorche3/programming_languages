#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: ocaml_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if dune runtest --force --action-stdout-on-success=print --action-stderr-on-success=print >"$output" 2>&1; then
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
    /^Test Successful in [^ ]+\. [0-9]+ tests? run\.$/ {
        summaries++
        if ($(NF - 2) > 0) valid++
    }
    END { exit !(summaries > 0 && summaries == valid) }
' "$output"; then
    printf 'test: resumen Alcotest ausente o sin casos aprobados / missing or empty Alcotest summary\n' >&2
    exit 1
fi
