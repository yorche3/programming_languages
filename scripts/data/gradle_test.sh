#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: gradle_test.sh\n' >&2
    exit 1
fi
if [[ -L gradlew || ( -e gradlew && ! -f gradlew ) ]]; then
    printf 'test: gradlew no seguro / unsafe gradlew\n' >&2
    exit 1
fi

if [[ -x ./gradlew ]]; then
    gradle_cmd=(./gradlew test --offline --no-daemon)
elif command -v gradle >/dev/null 2>&1; then
    gradle_cmd=(gradle test --offline --no-daemon)
else
    printf 'test: falta Gradle / missing Gradle\n' >&2
    exit 1
fi

find lib/build/test-results build/test-results -type f -name '*.xml' -delete 2>/dev/null || true
output="$(mktemp)"
if "${gradle_cmd[@]}" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$output" "$rc" <<'PY'
import glob
import sys
import xml.etree.ElementTree as ET

output_path = sys.argv[1]
rc = int(sys.argv[2])
text = open(output_path, "r", encoding="utf-8", errors="replace").read()

files = glob.glob("lib/build/test-results/test/*.xml") + glob.glob("build/test-results/test/*.xml")
if rc != 0:
    print("test: Gradle test process failed", file=sys.stderr)
    raise SystemExit(rc)
if re_no_source := ("NO-SOURCE" in text):
    print("test: Gradle no ejecutó casos / Gradle ran no cases", file=sys.stderr)
    raise SystemExit(1)

tests = failures = errors = skipped = 0
parsed = 0
for path in files:
    try:
        root = ET.parse(path).getroot()
    except Exception:
        continue
    parsed += 1
    suites = [root] if root.tag.endswith("testsuite") else root.findall(".//testsuite")
    for suite in suites:
        tests += int(suite.attrib.get("tests", 0))
        failures += int(suite.attrib.get("failures", 0))
        errors += int(suite.attrib.get("errors", 0))
        skipped += int(suite.attrib.get("skipped", 0))

if parsed == 0:
    print("test: faltan informes XML Gradle / missing Gradle XML reports", file=sys.stderr)
    raise SystemExit(1)
passed = tests - failures - errors - skipped
if failures or errors:
    print("test: fallaron casos Gradle / Gradle test failures", file=sys.stderr)
    raise SystemExit(1)
if passed <= 0:
    print("test: no se ejecutaron casos Gradle / no Gradle test cases executed", file=sys.stderr)
    raise SystemExit(1)
PY
parse_rc=$?
rm -f -- "$output"
exit "$parse_rc"
