#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: clojure_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT

if clojure -T:build test >"$output" 2>&1; then
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
    print("test: Clojure process failed", file=sys.stderr)
    raise SystemExit(rc)

try:
    with open(sys.argv[2], encoding="utf-8") as stream:
        output = stream.read()
except OSError as exc:
    print(f"test: no se pudo leer la salida Clojure / cannot read Clojure output: {exc}", file=sys.stderr)
    raise SystemExit(1)

summaries = re.findall(
    r"^Ran\s+(\d+)\s+tests?\s+containing\s+(\d+)\s+assertions?\.$",
    output,
    re.MULTILINE,
)
results = re.findall(
    r"^(\d+)\s+failures?,\s+(\d+)\s+errors?\.$",
    output,
    re.MULTILINE,
)
if len(summaries) != 1 or len(results) != 1:
    print("test: resumen Clojure ausente o ambiguo / missing or ambiguous Clojure summary", file=sys.stderr)
    raise SystemExit(1)

tests, assertions = map(int, summaries[0])
failures, errors = map(int, results[0])
if tests <= 0:
    print("test: suite Clojure vacía / empty Clojure suite", file=sys.stderr)
    raise SystemExit(1)
if failures or errors:
    print("test: fallaron tests Clojure / Clojure test failures", file=sys.stderr)
    raise SystemExit(1)

print(f"Clojure tests: {tests} passed, {assertions} assertions")
PY
