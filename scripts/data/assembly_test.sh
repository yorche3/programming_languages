#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: assembly_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if make run >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

if ! awk '
    {
        gsub(/\033\[[0-9;]*m/, "")
        line = $0
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
        if (line ~ /^tests run(ned)? [0-9]+$/) {
            total_count++
            split(line, fields, /[[:space:]]+/)
            total = fields[3] + 0
        } else if (line ~ /^passed [0-9]+$/) {
            passed_count++
            split(line, fields, /[[:space:]]+/)
            passed = fields[2] + 0
        } else if (line ~ /^failed [0-9]+$/) {
            failed_count++
            split(line, fields, /[[:space:]]+/)
            failed = fields[2] + 0
        }
    }
    END {
        exit !(total_count == 1 && passed_count == 1 && failed_count == 1 &&
               total > 0 && passed > 0 && failed == 0 &&
               total == passed + failed)
    }
' "$output"; then
    printf 'test: resumen Assembly ausente, vacío, inconsistente o fallido / missing, empty, inconsistent, or failing Assembly summary\n' >&2
    exit 1
fi

printf 'Assembly tests: passed\n'
