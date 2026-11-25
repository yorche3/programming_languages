#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: ada_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if alr -C tests run >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$rc" "$output" <<'PY'
import re
import sys

rc = int(sys.argv[1])
if rc != 0:
    print("test: Alire test process failed", file=sys.stderr)
    raise SystemExit(rc)

labels = {
    "Total Tests Run": "total",
    "Successful Tests": "successful",
    "Failed Assertions": "failed_assertions",
    "Unexpected Errors": "unexpected_errors",
}
pattern = re.compile(
    r"^\s*(Total Tests Run|Successful Tests|Failed Assertions|Unexpected Errors):\s*(\d+)\s*$"
)
results = {}
with open(sys.argv[2], encoding="utf-8") as output:
    for line in output:
        match = pattern.fullmatch(line.rstrip("\n"))
        if match:
            key = labels[match.group(1)]
            if key in results:
                print("test: resumen AUnit duplicado / duplicate AUnit summary", file=sys.stderr)
                raise SystemExit(1)
            results[key] = int(match.group(2))

required = set(labels.values())
if results.keys() != required:
    print("test: falta el resumen AUnit / missing AUnit summary", file=sys.stderr)
    raise SystemExit(1)

total = results["total"]
successful = results["successful"]
if (
    total <= 0
    or successful != total
    or results["failed_assertions"] != 0
    or results["unexpected_errors"] != 0
):
    print("test: resultados AUnit vacíos o fallidos / empty or failing AUnit results", file=sys.stderr)
    raise SystemExit(1)

print(f"Ada tests: {successful} passed")
PY
