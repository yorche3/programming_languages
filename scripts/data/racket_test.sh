#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: racket_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT

if raco test -x . >"$output" 2>&1; then
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
    print("test: raco test process failed", file=sys.stderr)
    raise SystemExit(rc)

try:
    output = open(sys.argv[2], encoding="utf-8").read()
except OSError as exc:
    print(f"test: no se pudo leer salida de raco / cannot read raco output: {exc}", file=sys.stderr)
    raise SystemExit(1)

summaries = re.findall(r"^(\d+)\s+tests?\s+passed\s*$", output, re.MULTILINE)
if len(summaries) != 1:
    print("test: resumen de RackUnit ausente o ambiguo / missing or ambiguous RackUnit summary", file=sys.stderr)
    raise SystemExit(1)

passed = int(summaries[0])
if passed <= 0:
    print("test: suite Racket vacía / empty Racket suite", file=sys.stderr)
    raise SystemExit(1)

print(f"Racket tests: {passed} passed")
PY
