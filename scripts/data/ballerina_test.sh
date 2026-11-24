#!/usr/bin/env bash

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: ballerina_test.sh\n' >&2
    exit 1
fi
if [[ -L Ballerina.toml || ! -f Ballerina.toml ]]; then
    printf 'test: falta manifiesto Ballerina regular / missing regular Ballerina manifest\n' >&2
    exit 1
fi
if [[ -L tests || ( -e tests && ! -d tests ) ]]; then
    printf 'test: ruta de pruebas Ballerina no segura / unsafe Ballerina test path\n' >&2
    exit 1
fi

if [[ -L target || ( -e target && ! -d target ) || -L target/report || ( -e target/report && ! -d target/report ) ]]; then
    printf 'test: ruta de informes Ballerina no segura / unsafe Ballerina report path\n' >&2
    exit 1
fi
if ! mkdir -p -- target/report; then
    printf 'test: no se pudo crear el directorio de informes Ballerina / could not create Ballerina report directory\n' >&2
    exit 1
fi
report_dir="$(mktemp -d target/report/glot-run.XXXXXXXX)" || {
    printf 'test: no se pudo aislar el informe Ballerina / could not isolate Ballerina report\n' >&2
    exit 1
}

output="$(mktemp)"
if bal test --offline --test-report --test-report-dir="$report_dir" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"
rm -f -- "$output"

reports=()
mapfile -t reports < <(find "$report_dir" -type f -name '*test_results.json' -print 2>/dev/null | sort)
if (( ${#reports[@]} != 1 )); then
    printf 'test: falta o es ambiguo el informe JSON de Ballerina / missing or ambiguous Ballerina JSON test report\n' >&2
    exit 1
fi
report="${reports[0]}"

python3 - "$report" <<'PY'
import json
import sys

path = sys.argv[1]
try:
    with open(path, "r", encoding="utf-8") as handle:
        report = json.load(handle)
except Exception as exc:
    print(f"test: informe JSON Ballerina ilegible / unreadable Ballerina JSON report: {exc}", file=sys.stderr)
    raise SystemExit(1)

if not isinstance(report, dict):
    print("test: informe JSON Ballerina inválido / invalid Ballerina JSON report", file=sys.stderr)
    raise SystemExit(1)
keys = ("totalTests", "passed", "failed", "skipped")
if any(type(report.get(key)) is not int for key in keys):
    print("test: informe JSON Ballerina incompleto / incomplete Ballerina JSON report", file=sys.stderr)
    raise SystemExit(1)
total, passed, failed, skipped = (report[key] for key in keys)
if total < 0 or passed < 0 or failed < 0 or skipped < 0 or total != passed + failed + skipped:
    print("test: contadores Ballerina inválidos / invalid Ballerina test counters", file=sys.stderr)
    raise SystemExit(1)
if failed:
    print("test: fallaron casos Ballerina / Ballerina test cases failed", file=sys.stderr)
    raise SystemExit(1)
if passed == 0 or total == 0:
    print("test: no se ejecutaron casos Ballerina / no Ballerina test cases executed", file=sys.stderr)
    raise SystemExit(1)
PY
parse_rc=$?
if ((parse_rc != 0)); then
    exit "$parse_rc"
fi
if ((rc != 0)); then
    exit "$rc"
fi
