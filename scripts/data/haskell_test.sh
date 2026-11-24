#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: haskell_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || exit 1
trap 'rm -f -- "$output"' EXIT

if cabal clean >"$output" 2>&1; then
    clean_rc=0
else
    clean_rc=$?
fi
cat -- "$output" >&2
: >"$output"
if ((clean_rc != 0)); then
    exit "$clean_rc"
fi

if cabal test .:tests --jobs=1 --ghc-options=-Werror=missing-home-modules \
    --test-show-details=direct --test-options='--format=progress --no-color --no-dry-run' >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

awk '
    /^Test suite .+: RUNNING\.\.\.$/ {
        if (active) {
            print "test: salidas Cabal superpuestas / overlapping Cabal suite output" > "/dev/stderr"
            bad = 1
            exit 1
        }
        name = $0
        sub(/^Test suite /, "", name)
        sub(/: RUNNING\.\.\.$/, "", name)
        active = 1
        summaries = 0
        next
    }
    active && /^[0-9]+ examples?, [0-9]+ failures?(, [0-9]+ pending)?$/ {
        summaries++
        examples = $1 + 0
        failures = $3 + 0
        pending = NF == 6 ? $5 + 0 : 0
        next
    }
    /^Test suite .+: PASS$/ {
        passed_name = $0
        sub(/^Test suite /, "", passed_name)
        sub(/: PASS$/, "", passed_name)
        if (!active || name != passed_name || summaries != 1) {
            print "test: falta resumen Hspec inequívoco / missing unambiguous Hspec summary" > "/dev/stderr"
            bad = 1
            exit 1
        }
        if (examples == 0 || failures != 0 || pending != 0) {
            print "test: suite Hspec vacía, fallida o pendiente / empty, failing or pending Hspec suite: " name > "/dev/stderr"
            bad = 1
            exit 1
        }
        active = 0
        passed++
        next
    }
    END {
        if (bad) exit 1
        if (active || passed == 0) {
            print "test: faltan resultados de suites Hspec / missing Hspec suite results" > "/dev/stderr"
            exit 1
        }
    }
' "$output"
