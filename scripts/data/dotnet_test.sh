#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: dotnet_test.sh\n' >&2
    exit 1
fi

reports="$(mktemp -d)"
output="$(mktemp)"
trap 'rm -rf -- "$reports"; rm -f -- "$output"' EXIT

if dotnet test --logger 'trx;LogFileName=glot-tests.trx' --results-directory "$reports" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

python3 - "$rc" "$reports" <<'PY'
import glob
import os
import sys
import xml.etree.ElementTree as ET

rc = int(sys.argv[1])
if rc != 0:
    print("test: dotnet test process failed", file=sys.stderr)
    raise SystemExit(rc)

files = glob.glob(os.path.join(sys.argv[2], "**", "*.trx"), recursive=True)
if not files:
    print("test: faltan informes TRX / missing TRX reports", file=sys.stderr)
    raise SystemExit(1)

def local_name(element):
    return element.tag.rsplit("}", 1)[-1]

total = passed = skipped = 0
for path in files:
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as exc:
        print(f"test: informe TRX ilegible / unreadable TRX report {path}: {exc}", file=sys.stderr)
        raise SystemExit(1)

    summaries = [element for element in root.iter() if local_name(element) == "ResultSummary"]
    if len(summaries) != 1:
        print(f"test: resumen TRX ausente o ambiguo / missing or ambiguous TRX summary in {path}", file=sys.stderr)
        raise SystemExit(1)
    if summaries[0].attrib.get("outcome") != "Completed":
        print(f"test: resultado TRX incompleto o fallido / incomplete or failed TRX result in {path}", file=sys.stderr)
        raise SystemExit(1)
    counters = [element for element in summaries[0] if local_name(element) == "Counters"]
    if len(counters) != 1:
        print(f"test: contadores TRX ausentes o ambiguos / missing or ambiguous TRX counters in {path}", file=sys.stderr)
        raise SystemExit(1)

    attrs = counters[0].attrib
    try:
        counts = {
            name: int(attrs[name])
            for name in (
                "total",
                "passed",
                "failed",
                "error",
                "timeout",
                "aborted",
                "inconclusive",
                "passedButRunAborted",
                "notRunnable",
                "notExecuted",
                "disconnected",
                "inProgress",
                "pending",
            )
        }
    except (KeyError, ValueError) as exc:
        print(f"test: contadores TRX inválidos / invalid TRX counters in {path}: {exc}", file=sys.stderr)
        raise SystemExit(1)

    if any(value < 0 for value in counts.values()):
        print(f"test: contadores TRX negativos / negative TRX counters in {path}", file=sys.stderr)
        raise SystemExit(1)
    if any(
        counts[name] != 0
        for name in (
            "failed",
            "error",
            "timeout",
            "aborted",
            "inconclusive",
            "passedButRunAborted",
            "notRunnable",
            "disconnected",
            "inProgress",
            "pending",
        )
    ):
        print("test: fallaron pruebas .NET / .NET test failures", file=sys.stderr)
        raise SystemExit(1)
    if counts["total"] <= 0 or counts["passed"] <= 0 or counts["passed"] > counts["total"]:
        print("test: suite .NET vacía o sin casos aprobados / empty .NET suite or no passing cases", file=sys.stderr)
        raise SystemExit(1)
    if counts["passed"] + counts["notExecuted"] != counts["total"]:
        print("test: contadores TRX inconsistentes / inconsistent TRX counters", file=sys.stderr)
        raise SystemExit(1)

    total += counts["total"]
    passed += counts["passed"]
    skipped += counts["notExecuted"]

print(f".NET tests: {passed} passed, {skipped} not executed ({total} total)")
PY
