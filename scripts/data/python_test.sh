#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: python_test.sh\n' >&2
    exit 1
fi

reports="$(mktemp -d)"
output="$(mktemp)"
trap 'rm -rf -- "$reports"; rm -f -- "$output"' EXIT

if pytest --junitxml="$reports/pytest-results.xml" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$rc" "$reports/pytest-results.xml" <<'PY'
import os
import sys
import xml.etree.ElementTree as ET

rc = int(sys.argv[1])
if rc != 0:
    print("test: pytest process failed", file=sys.stderr)
    raise SystemExit(rc)

path = sys.argv[2]
if not os.path.isfile(path):
    print("test: falta el informe JUnit / missing JUnit report", file=sys.stderr)
    raise SystemExit(1)

try:
    root = ET.parse(path).getroot()
except (ET.ParseError, OSError) as exc:
    print(f"test: informe JUnit ilegible / unreadable JUnit report: {exc}", file=sys.stderr)
    raise SystemExit(1)

def local_name(element):
    return element.tag.rsplit("}", 1)[-1]

if local_name(root) == "testsuite":
    suites = [root]
elif local_name(root) == "testsuites":
    suites = [element for element in root if local_name(element) == "testsuite"]
else:
    suites = []

if not suites:
    print("test: suites JUnit ausentes / missing JUnit suites", file=sys.stderr)
    raise SystemExit(1)

total = passed = skipped = failures = errors = 0
for suite in suites:
    attrs = suite.attrib
    try:
        counts = {
            name: int(attrs[name])
            for name in ("tests", "failures", "errors", "skipped")
        }
    except (KeyError, ValueError) as exc:
        print(f"test: contadores JUnit inválidos / invalid JUnit counters: {exc}", file=sys.stderr)
        raise SystemExit(1)

    if any(value < 0 for value in counts.values()):
        print("test: contadores JUnit negativos / negative JUnit counters", file=sys.stderr)
        raise SystemExit(1)

    cases = [element for element in suite if local_name(element) == "testcase"]
    observed = {"failures": 0, "errors": 0, "skipped": 0}
    for case in cases:
        outcomes = [
            local_name(element)
            for element in case
            if local_name(element) in observed
        ]
        if len(outcomes) > 1:
            print("test: resultado JUnit ambiguo / ambiguous JUnit testcase result", file=sys.stderr)
            raise SystemExit(1)
        if outcomes:
            observed[{"failure": "failures", "error": "errors", "skipped": "skipped"}[outcomes[0]]] += 1

    if counts["tests"] != len(cases) or any(
        counts[name] != observed[name] for name in observed
    ):
        print("test: contadores JUnit inconsistentes / inconsistent JUnit counters", file=sys.stderr)
        raise SystemExit(1)

    suite_passed = counts["tests"] - counts["failures"] - counts["errors"] - counts["skipped"]
    if suite_passed < 0:
        print("test: contadores JUnit inválidos / invalid JUnit counters", file=sys.stderr)
        raise SystemExit(1)
    total += counts["tests"]
    passed += suite_passed
    skipped += counts["skipped"]
    failures += counts["failures"]
    errors += counts["errors"]

if failures or errors:
    print("test: fallaron tests Python / Python test failures", file=sys.stderr)
    raise SystemExit(1)
if total <= 0 or passed <= 0:
    print("test: suite Python vacía o sin tests aprobados / empty Python suite or no passing tests", file=sys.stderr)
    raise SystemExit(1)

print(f"Python tests: {passed} passed, {skipped} skipped ({total} total)")
PY
