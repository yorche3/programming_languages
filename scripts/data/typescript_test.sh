#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: typescript_test.sh\n' >&2
    exit 1
fi
if [[ -L package.json || ! -f package.json ]]; then
    printf 'test: falta package.json regular / missing regular package.json\n' >&2
    exit 1
fi

report="$(mktemp)"
rm -f -- "$report"
if [[ -x node_modules/.bin/jest ]]; then
    jest_cmd=(./node_modules/.bin/jest)
elif command -v jest >/dev/null 2>&1; then
    jest_cmd=(jest)
else
    printf 'test: falta Jest / missing Jest\n' >&2
    rm -f -- "$report"
    exit 1
fi

output="$(mktemp)"
if "${jest_cmd[@]}" --runInBand --json --outputFile="$report" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"
rm -f -- "$output"

if [[ ! -f "$report" || -L "$report" ]]; then
    printf 'test: falta informe Jest JSON / missing Jest JSON report\n' >&2
    rm -f -- "$report"
    exit 1
fi
python3 - "$report" "$rc" <<'PY'
import json
import sys

path = sys.argv[1]
rc = int(sys.argv[2])
try:
    with open(path, "r", encoding="utf-8") as handle:
        report = json.load(handle)
except Exception as exc:
    print(f"test: informe Jest ilegible / unreadable Jest report: {exc}", file=sys.stderr)
    raise SystemExit(1)

total = report.get("numTotalTests")
passed = report.get("numPassedTests")
failed = report.get("numFailedTests")
pending = report.get("numPendingTests")
if any(type(value) is not int for value in (total, passed, failed, pending)):
    print("test: informe Jest incompleto / incomplete Jest report", file=sys.stderr)
    raise SystemExit(1)
if rc != 0 or not report.get("success", False) or failed != 0:
    print("test: fallaron casos TypeScript / TypeScript test failures", file=sys.stderr)
    raise SystemExit(1)
if pending != 0:
    print("test: TypeScript test cases skipped", file=sys.stderr)
    raise SystemExit(1)
if passed == 0 or total == 0:
    print("test: no se ejecutaron casos TypeScript / no TypeScript test cases executed", file=sys.stderr)
    raise SystemExit(1)
PY
parse_rc=$?
rm -f -- "$report"
exit "$parse_rc"
