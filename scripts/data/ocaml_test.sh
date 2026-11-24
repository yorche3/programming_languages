#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: ocaml_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if dune runtest --force --display=short -j 1 --action-stdout-on-success=print --action-stderr-on-success=print >"$output" 2>&1; then
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
    /^[[:space:]]*[^[:space:]]+[[:space:]]+alias[[:space:]]+([^[:space:]]*\/)?runtest(-[^[:space:]]+)?[[:space:]]*$/ {
        if (active && summaries != 1) bad = 1
        active = 1
        actions++
        summaries = 0
        next
    }
    /^Test Successful in [^ ]+\. [0-9]+ tests? run\.$/ {
        if (!active) bad = 1
        summaries++
        if ($(NF - 2) <= 0) bad = 1
    }
    END { exit !(actions > 0 && active && summaries == 1 && !bad) }
' "$output"; then
    printf 'test: falta un resumen Alcotest no vacío por acción Dune / missing or empty Alcotest summary per Dune test action\n' >&2
    exit 1
fi
