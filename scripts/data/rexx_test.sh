#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: rexx_test.sh\n' >&2
    exit 1
fi
if [[ -L test || ( -e test && ! -d test ) ]]; then
    printf 'test: ruta Rexx no segura / unsafe Rexx test path\n' >&2
    exit 1
fi
if [[ ! -d test ]]; then
    printf 'test: falta test/ / missing test/\n' >&2
    exit 1
fi

suites=()
while IFS= read -r -d '' suite; do
    suites+=("$suite")
done < <(find test -mindepth 1 -maxdepth 1 -type f -name '*.rexx' -print0 | sort -z)
if ((${#suites[@]} == 0)); then
    printf 'test: no hay suites Rexx / no Rexx test suites\n' >&2
    exit 1
fi

test_runs=0
successful=0
failed=0
errors=0
for suite in "${suites[@]}"; do
    output="$(mktemp)"
    if rexx "$suite" >"$output" 2>&1; then
        rc=0
    else
        rc=$?
    fi
    cat -- "$output"

    suite_runs="$(grep -E 'nr of test runs:[[:space:]]*[0-9]+' "$output" | tail -n1 | sed -E 's/.*:[[:space:]]*([0-9]+).*/\1/')"
    suite_successful="$(grep -E 'nr of successful assertions:[[:space:]]*[0-9]+' "$output" | tail -n1 | sed -E 's/.*:[[:space:]]*([0-9]+).*/\1/')"
    suite_failed="$(grep -E 'nr of failures:[[:space:]]*[0-9]+' "$output" | tail -n1 | sed -E 's/.*:[[:space:]]*([0-9]+).*/\1/')"
    suite_errors="$(grep -E 'nr of errors:[[:space:]]*[0-9]+' "$output" | tail -n1 | sed -E 's/.*:[[:space:]]*([0-9]+).*/\1/')"
    rm -f -- "$output"

    if [[ -z "$suite_runs" || -z "$suite_successful" || -z "$suite_failed" || -z "$suite_errors" ]]; then
        printf 'test: informe ooRexxUnit incompleto: %s / incomplete ooRexxUnit report: %s\n' "$suite" "$suite" >&2
        exit 1
    fi
    test_runs=$((test_runs + suite_runs))
    successful=$((successful + suite_successful))
    failed=$((failed + suite_failed))
    errors=$((errors + suite_errors))
    if ((rc != 0)); then
        exit "$rc"
    fi
done

if ((failed != 0 || errors != 0)); then
    printf 'test: fallaron o dieron error casos Rexx / Rexx test failures or errors\n' >&2
    exit 1
fi
if ((test_runs == 0 || successful == 0)); then
    printf 'test: no se ejecutaron casos Rexx / no Rexx test cases executed\n' >&2
    exit 1
fi
