#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: elixir_test.sh\n' >&2
    exit 1
fi

data_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
report="$(mktemp)"
trap 'rm -f -- "$report"' EXIT

if GLOT_ELIXIR_TEST_REPORT="$report" elixir "$data_dir/elixir_test_runner.exs" test; then
    if [[ "$(cat -- "$report")" != ok ]]; then
        printf 'test: ejecución ExUnit incompleta / incomplete ExUnit run\n' >&2
        exit 1
    fi
else
    rc=$?
    exit "$rc"
fi
