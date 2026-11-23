#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: nim_test.sh\n' >&2
    exit 1
fi
if [[ ! -d tests ]]; then
    printf 'test: falta tests/ / missing tests/\n' >&2
    exit 1
fi

suites=()
while IFS= read -r -d '' suite; do
    suites+=("$suite")
done < <(find tests -mindepth 1 -maxdepth 1 -type f -name '*.nim' -print0 | sort -z)
if (( ${#suites[@]} == 0 )); then
    printf 'test: no hay suites Nim / no Nim test suites\n' >&2
    exit 1
fi

executed=0
for suite in "${suites[@]}"; do
    output="$(mktemp)"
    if nim c -r --hints:off --warnings:off --path:src "$suite" >"$output" 2>&1; then
        rc=0
    else
        rc=$?
    fi
    cat -- "$output"
    ok="$(grep -Ec '\[OK\]' "$output" || true)"
    rm -f -- "$output"
    if ((rc != 0)); then
        exit "$rc"
    fi
    executed=$((executed + ok))
done
if ((executed == 0)); then
    printf 'test: no se ejecutaron casos Nim / no Nim test cases executed\n' >&2
    exit 1
fi
