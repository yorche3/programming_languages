#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: v_test.sh\n' >&2
    exit 1
fi
if [[ -L v.mod || ! -f v.mod ]]; then
    printf 'test: falta manifiesto V regular / missing regular V manifest\n' >&2
    exit 1
fi

output="$(mktemp)"
if v test . >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

summary="$(grep 'Summary for all V _test.v files:' "$output" | tail -n1)"
rm -f -- "$output"
if ((rc != 0)); then
    exit "$rc"
fi
if [[ -z "$summary" ]]; then
    printf 'test: no se pudo verificar el resumen de V / could not verify V test summary\n' >&2
    exit 1
fi

counts="$(printf '%s\n' "$summary" | grep -oE '[0-9]+ passed, [0-9]+ total' | tail -n1)"
if [[ -z "$counts" ]]; then
    printf 'test: no se ejecutaron casos V / no V test cases executed\n' >&2
    exit 1
fi
passed="$(printf '%s\n' "$counts" | sed -E 's/^([0-9]+) passed.*/\1/')"
total="$(printf '%s\n' "$counts" | sed -E 's/.* ([0-9]+) total$/\1/')"
if ((passed == 0 || total == 0)); then
    printf 'test: no se ejecutaron casos V / no V test cases executed\n' >&2
    exit 1
fi
failed="$(printf '%s\n' "$summary" | grep -oE '[0-9]+ failed' | tail -n1 | sed -E 's/^([0-9]+) failed$/\1/' || true)"
if [[ "$failed" =~ ^[0-9]+$ ]] && ((failed != 0)); then
    printf 'test: fallaron casos V / V test cases failed\n' >&2
    exit 1
fi
