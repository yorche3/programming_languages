#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: zig_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT

if zig build test --summary all >"$output" 2>&1; then
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
    print("test: Zig process failed", file=sys.stderr)
    raise SystemExit(rc)

try:
    with open(sys.argv[2], encoding="utf-8") as stream:
        output = stream.read()
except OSError as exc:
    print(f"test: no se pudo leer la salida Zig / cannot read Zig output: {exc}", file=sys.stderr)
    raise SystemExit(1)

summaries = re.findall(
    r"^Build Summary: (\d+)/(\d+) steps succeeded; (\d+)/(\d+) tests passed$",
    output,
    re.MULTILINE,
)
if len(summaries) != 1:
    print("test: resumen Zig ausente o ambiguo / missing or ambiguous Zig summary", file=sys.stderr)
    raise SystemExit(1)

steps_passed, steps_total, tests_passed, tests_total = map(int, summaries[0])
if steps_total <= 0 or steps_passed != steps_total:
    print("test: pasos Zig incompletos / incomplete Zig build steps", file=sys.stderr)
    raise SystemExit(1)
if tests_total <= 0 or tests_passed != tests_total:
    print("test: suite Zig vacía o con fallos / empty Zig suite or test failures", file=sys.stderr)
    raise SystemExit(1)

print(f"Zig tests: {tests_passed} passed")
PY
