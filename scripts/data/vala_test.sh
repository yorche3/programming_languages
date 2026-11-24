#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: vala_test.sh\n' >&2
    exit 1
fi
if [[ -L src || ( -e src && ! -d src ) || -L test || ( -e test && ! -d test ) ]]; then
    printf 'test: ruta Vala no segura / unsafe Vala test path\n' >&2
    exit 1
fi

mapfile -t sources < <(find src -type f -name '*.vala' -print 2>/dev/null | sort)
mapfile -t suites < <(find test -type f -name '*.vala' -print 2>/dev/null | sort)
if (( ${#sources[@]} == 0 || ${#suites[@]} == 0 )); then
    printf 'test: faltan fuentes o suites Vala / missing Vala sources or suites\n' >&2
    exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
total_passed=0
for suite in "${suites[@]}"; do
    base="$(basename -- "$suite" .vala)"
    output="$tmp/$base.output"
    binary="$tmp/$base"
    if ! valac "${sources[@]}" "$suite" --pkg glib-2.0 -o "$binary" >"$output" 2>&1; then
        cat -- "$output" >&2
        exit 1
    fi
    if "$binary" >"$output" 2>&1; then
        rc=0
    else
        rc=$?
    fi
    cat -- "$output"
    if ((rc != 0)); then
        exit "$rc"
    fi

    awk -v suite="$base" '
        /^TAP version [0-9]+$/ { tap=1 }
        /^1\.\.[0-9]+$/ { plan=$0; sub(/^1\.\./, "", plan); plans++ }
        /^ok([[:space:]]|$)/ {
            if ($0 ~ /# SKIP([[:space:]]|$)/) skipped++
            else passed++
        }
        /^not ok([[:space:]]|$)/ { failed++ }
        /^Bail out!/ { bailout++ }
        END {
            if (!tap || plans != 1 || bailout || failed || skipped || passed <= 0) exit 1
            if (plan + 0 <= 0 || plan + 0 != passed + skipped) exit 1
        }
    ' "$output" || {
        printf 'test: suite Vala sin casos reales, omitida o fallida / Vala suite missing, skipped or failed: %s\n' "$base" >&2
        exit 1
    }
    passed="$(awk '/^ok([[:space:]]|$)/ && $0 !~ /# SKIP([[:space:]]|$)/ {n++} END {print n+0}' "$output")"
    total_passed=$((total_passed + passed))
done
if ((total_passed <= 0)); then
    printf 'test: no se ejecutaron casos Vala aprobados / no passing Vala cases\n' >&2
    exit 1
fi
