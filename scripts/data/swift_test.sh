#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: swift_test.sh\n' >&2
    exit 1
fi
if [[ -L Package.swift || ! -f Package.swift ]]; then
    printf 'test: falta Package.swift regular / missing regular Package.swift\n' >&2
    exit 1
fi

output="$(mktemp)"
if swift test --skip-build >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$output" "$rc" <<'PY'
import re
import sys

path = sys.argv[1]
rc = int(sys.argv[2])
text = open(path, "r", encoding="utf-8", errors="replace").read()

xctest = 0
xctest_failures = 0
matches = re.findall(r"Executed (\d+) tests?, with (\d+) failures?", text)
if matches:
    xctest, xctest_failures = max(
        ((int(total), int(failed)) for total, failed in matches),
        key=lambda pair: pair[0],
    )

swift_testing = 0
swift_skipped = 0
swift_run_matches = re.findall(r"Test run with (\d+) tests? in \d+ suites?", text)
if swift_run_matches:
    swift_testing = max(int(count) for count in swift_run_matches)
elif re.search(r"Test run with (\d+) tests? passed", text):
    swift_testing = max(
        int(count)
        for count in re.findall(r"Test run with (\d+) tests? passed", text)
    )

swift_skipped = len(re.findall(r"testSkipped|skipped", text, re.IGNORECASE))
executed = xctest + swift_testing

if rc != 0:
    print("test: Swift test process failed", file=sys.stderr)
    raise SystemExit(rc)
if xctest_failures != 0:
    print("test: Swift test failures detected", file=sys.stderr)
    raise SystemExit(1)
if swift_skipped != 0 or re.search(r"\bs(?:kip(?:ped)?|kipped)\b", text, re.IGNORECASE):
    print("test: Swift test cases skipped", file=sys.stderr)
    raise SystemExit(1)
if executed == 0:
    print("test: no Swift test cases executed", file=sys.stderr)
    raise SystemExit(1)
PY
parse_rc=$?
rm -f -- "$output"
exit "$parse_rc"
