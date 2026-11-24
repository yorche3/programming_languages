#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: crystal_test.sh\n' >&2
    exit 1
fi
if ! command -v python3 >/dev/null 2>&1; then
    printf 'test: falta Python 3 para leer JUnit / Python 3 is required to read JUnit\n' >&2
    exit 1
fi

report_dir="$(mktemp -d)"
report="$report_dir/report.xml"
trap 'rm -f -- "$report"; rmdir -- "$report_dir"' EXIT
if crystal spec --junit_output "$report"; then
    rc=0
else
    rc=$?
fi
if ((rc != 0)); then
    exit "$rc"
fi
if [[ ! -s "$report" ]]; then
    printf 'test: falta el informe JUnit de Crystal / missing Crystal JUnit report\n' >&2
    exit 1
fi

python3 - "$report" <<'PY'
import sys
import xml.etree.ElementTree as ET

try:
    root = ET.parse(sys.argv[1]).getroot()
    if root.tag != "testsuite":
        raise ValueError("expected testsuite")
    counts = {name: int(root.attrib[name]) for name in ("tests", "skipped", "errors", "failures")}
    if any(value < 0 for value in counts.values()):
        raise ValueError("negative count")
    cases = root.findall("testcase")
    states = [sum(case.find(name) is not None for name in ("skipped", "error", "failure")) for case in cases]
    if len(cases) != counts["tests"] or any(state > 1 for state in states):
        raise ValueError("inconsistent test cases")
    for field, tag in (("skipped", "skipped"), ("errors", "error"), ("failures", "failure")):
        if sum(case.find(tag) is not None for case in cases) != counts[field]:
            raise ValueError(f"inconsistent {field} count")
except (ET.ParseError, OSError, KeyError, ValueError) as exc:
    print(f"test: informe Crystal inválido / invalid Crystal report: {exc}", file=sys.stderr)
    raise SystemExit(1)

passed = counts["tests"] - counts["skipped"] - counts["errors"] - counts["failures"]
if counts["errors"] or counts["failures"] or passed <= 0:
    print("test: no hay casos Crystal aprobados o hay fallos / no passing Crystal cases or failures detected", file=sys.stderr)
    raise SystemExit(1)
PY
