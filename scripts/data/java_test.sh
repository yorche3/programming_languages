#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: java_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT
if mvn clean test >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$rc" <<'PY'
import glob
import sys
import xml.etree.ElementTree as ET

rc = int(sys.argv[1])
if rc != 0:
    print("test: Maven test process failed", file=sys.stderr)
    raise SystemExit(rc)

files = glob.glob("target/surefire-reports/TEST-*.xml")
if not files:
    print("test: faltan informes XML Surefire / missing Surefire XML reports", file=sys.stderr)
    raise SystemExit(1)

tests = failures = errors = skipped = 0
for path in files:
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as exc:
        print(f"test: informe XML Surefire ilegible / unreadable Surefire XML report {path}: {exc}", file=sys.stderr)
        raise SystemExit(1)

    suites = [root] if root.tag.endswith("testsuite") else root.findall(".//testsuite")
    try:
        for suite in suites:
            tests += int(suite.attrib.get("tests", 0))
            failures += int(suite.attrib.get("failures", 0))
            errors += int(suite.attrib.get("errors", 0))
            skipped += int(suite.attrib.get("skipped", 0))
    except ValueError as exc:
        print(f"test: contadores Surefire inválidos / invalid Surefire counters in {path}: {exc}", file=sys.stderr)
        raise SystemExit(1)

if failures or errors:
    print("test: fallaron casos Java / Java test failures", file=sys.stderr)
    raise SystemExit(1)

passed = tests - failures - errors - skipped
if passed <= 0:
    print("test: no se ejecutaron casos Java aprobados / no passing Java test cases executed", file=sys.stderr)
    raise SystemExit(1)

print(f"Java tests: {passed} passed, {skipped} skipped")
PY
