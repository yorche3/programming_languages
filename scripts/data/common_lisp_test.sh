#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: common_lisp_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)"
trap 'rm -f -- "$output"' EXIT

if ros run --load run-tests.lisp --eval '(uiop:quit)' >"$output" 2>&1; then
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
    print("test: Roswell process failed", file=sys.stderr)
    raise SystemExit(rc)

try:
    with open(sys.argv[2], encoding="utf-8") as stream:
        output = stream.read()
except OSError as exc:
    print(f"test: no se pudo leer la salida Common Lisp / cannot read Common Lisp output: {exc}", file=sys.stderr)
    raise SystemExit(1)

summary_pattern = re.compile(
    r"^[ \t]*Did[ \t]+(\d+)[ \t]+checks?\.[ \t]*\r?\n"
    r"[ \t]*Pass:[ \t]*(\d+)[ \t]+\([^\r\n]*\)[ \t]*\r?\n"
    r"[ \t]*Skip:[ \t]*(\d+)[ \t]+\([^\r\n]*\)[ \t]*\r?\n"
    r"[ \t]*Fail:[ \t]*(\d+)[ \t]+\([^\r\n]*\)[ \t]*\r?$",
    re.MULTILINE,
)
reports = list(summary_pattern.finditer(output))
did_count = len(re.findall(r"^[ \t]*Did[ \t]+\d+[ \t]+checks?\.", output, re.MULTILINE))
counter_counts = [
    len(re.findall(rf"^[ \t]*{label}:[ \t]*\d+[ \t]+\(", output, re.MULTILINE))
    for label in ("Pass", "Skip", "Fail")
]
if not reports or did_count != len(reports) or any(count != len(reports) for count in counter_counts):
    print("test: resumen FiveAM ausente o ambiguo / missing or ambiguous FiveAM summary", file=sys.stderr)
    raise SystemExit(1)

total = passed = skipped = failures = 0
for report in reports:
    checks, suite_passed, suite_skipped, suite_failures = map(int, report.groups())
    if checks != suite_passed + suite_skipped + suite_failures:
        print("test: contadores FiveAM inconsistentes / inconsistent FiveAM counters", file=sys.stderr)
        raise SystemExit(1)
    total += checks
    passed += suite_passed
    skipped += suite_skipped
    failures += suite_failures

if failures:
    print("test: fallaron tests Common Lisp / Common Lisp test failures", file=sys.stderr)
    raise SystemExit(1)
if total <= 0 or passed <= 0:
    print("test: suite Common Lisp vacía o sin tests aprobados / empty Common Lisp suite or no passing tests", file=sys.stderr)
    raise SystemExit(1)

print(f"Common Lisp tests: {passed} passed, {skipped} skipped ({total} checks)")
PY
