#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: erlang_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if rebar3 eunit >"$output" 2>&1; then
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
    /^[0-9]+ tests, [0-9]+ failures$/ {
        summaries++
        if ($1 > 0 && $3 == 0) valid++
    }
    /^0 tests$/ { summaries++ }
    END { exit !(summaries == 1 && valid == 1) }
' "$output"; then
    printf 'test: resumen EUnit ausente, ambiguo o sin casos aprobados / missing, ambiguous or empty EUnit summary\n' >&2
    exit 1
fi
