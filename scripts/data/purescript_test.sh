#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: purescript_test.sh\n' >&2
    exit 1
fi
if [[ -L spago.yaml || ! -f spago.yaml ]]; then
    printf 'test: falta manifiesto Spago regular / missing regular Spago manifest\n' >&2
    exit 1
fi

output="$(mktemp)"
if spago test --offline --strict >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

passed=0
while IFS= read -r count; do
    [[ -n "$count" ]] || continue
    passed=$((passed + count))
done < <(grep -E 'All [0-9]+ tests? passed!' "$output" | sed -E 's/.*All ([0-9]+) tests? passed!.*/\1/')

rm -f -- "$output"
if ((rc != 0)); then
    exit "$rc"
fi
if ((passed == 0)); then
    printf 'test: no se ejecutaron casos PureScript / no PureScript test cases executed\n' >&2
    exit 1
fi
