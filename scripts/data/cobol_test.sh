#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: cobol_test.sh\n' >&2
    exit 1
fi

output="$(mktemp)" || {
    printf 'test: no se pudo crear archivo temporal / could not create temporary file\n' >&2
    exit 1
}
trap 'rm -f -- "$output"' EXIT

if make test >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output" || exit 1
if ((rc != 0)); then
    exit "$rc"
fi

python3 - "$output" <<'PY'
import re
import sys

try:
    with open(sys.argv[1], encoding="utf-8") as stream:
        output = stream.read()
except OSError as exc:
    print(f"test: no se pudo leer salida COBOL / cannot read COBOL output: {exc}", file=sys.stderr)
    raise SystemExit(1)

blocks = re.split(r"(?m)^[ \t]*SUMMARY:[ \t]*$", output)[1:]
if not blocks:
    print("test: resumen COBOL ausente / missing COBOL summary", file=sys.stderr)
    raise SystemExit(1)

previous_total = previous_passed = previous_failed = 0
for index, block in enumerate(blocks, start=1):
    counts = {}
    for label in ("Total", "Passed", "Failed"):
        matches = re.findall(
            rf"(?m)^[ \t]*{label}:[ \t]*([0-9]+)[ \t]*$",
            block,
        )
        if len(matches) != 1:
            print(
                f"test: resumen COBOL {index} incompleto o ambiguo / "
                f"incomplete or ambiguous COBOL summary {index}",
                file=sys.stderr,
            )
            raise SystemExit(1)
        counts[label] = int(matches[0])

    if (
        counts["Total"] <= 0
        or counts["Passed"] <= 0
        or counts["Failed"] != 0
        or counts["Total"] != counts["Passed"] + counts["Failed"]
    ):
        print(
            f"test: resumen COBOL {index} vacío, inconsistente o fallido / "
            f"empty, inconsistent, or failing COBOL summary {index}",
            file=sys.stderr,
        )
        raise SystemExit(1)

    if index > 1 and (
        counts["Total"] <= previous_total
        or counts["Passed"] < previous_passed
        or counts["Failed"] < previous_failed
    ):
        print(
            "test: contadores COBOL no acumulativos / "
            "non-cumulative COBOL counters",
            file=sys.stderr,
        )
        raise SystemExit(1)
    previous_total = counts["Total"]
    previous_passed = counts["Passed"]
    previous_failed = counts["Failed"]

print(
    f"COBOL tests: {previous_passed}/{previous_total} passed "
    f"across {len(blocks)} summaries"
)
PY
