#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: lua_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT

if busted >"$output" 2>&1; then
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
    print("test: Busted process failed", file=sys.stderr)
    raise SystemExit(rc)

try:
    output = open(sys.argv[2], encoding="utf-8").read()
except OSError as exc:
    print(f"test: no se pudo leer salida de Busted / cannot read Busted output: {exc}", file=sys.stderr)
    raise SystemExit(1)

summary = re.compile(
    r"^(\d+)\s+success(?:es)?\s*/\s*(\d+)\s+failures?\s*/\s*"
    r"(\d+)\s+errors?\s*/\s*(\d+)\s+pending\b.*$",
    re.MULTILINE,
)
matches = list(summary.finditer(output))
if len(matches) != 1:
    print("test: resumen Busted ausente o ambiguo / missing or ambiguous Busted summary", file=sys.stderr)
    raise SystemExit(1)

passed, failures, errors, pending = (int(value) for value in matches[0].groups())
if failures or errors:
    print("test: fallaron tests Lua / Lua test failures", file=sys.stderr)
    raise SystemExit(1)
if passed <= 0:
    print("test: suite Lua vacía o sin tests aprobados / empty Lua suite or no passing tests", file=sys.stderr)
    raise SystemExit(1)

print(f"Lua tests: {passed} passed, {pending} pending ({passed + pending} total)")
PY
