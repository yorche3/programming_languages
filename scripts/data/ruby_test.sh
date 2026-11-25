#!/usr/bin/env bash
set -euo pipefail

if [[ $# != 0 ]]; then
    printf 'test: uso inválido / invalid usage: ruby_test.sh\n' >&2
    exit 1
fi

reports="$(mktemp -d)"
output="$(mktemp)"
trap 'rm -rf -- "$reports"; rm -f -- "$output"' EXIT

if bundle exec rspec --format json --out "$reports/rspec-results.json" >"$output" 2>&1; then
    rc=0
else
    rc=$?
fi
cat -- "$output"

ruby -rjson - "$rc" "$reports/rspec-results.json" <<'RUBY'
rc = Integer(ARGV[0], 10)
if rc != 0
  warn "test: RSpec process failed"
  exit rc
end

begin
  report = JSON.parse(File.read(ARGV[1]))
rescue Errno::ENOENT, JSON::ParserError => error
  warn "test: informe RSpec ausente o inválido / missing or invalid RSpec report: #{error}"
  exit 1
end

summary = report["summary"]
examples = report["examples"]
unless summary.is_a?(Hash) && examples.is_a?(Array)
  warn "test: resumen RSpec ausente o inválido / missing or invalid RSpec summary"
  exit 1
end

counter_names = %w[example_count failure_count pending_count errors_outside_of_examples_count]
counters = {}
counter_names.each do |name|
  value = summary[name]
  unless value.is_a?(Integer) && value >= 0
    warn "test: contador RSpec inválido / invalid RSpec counter: #{name}"
    exit 1
  end
  counters[name] = value
end

statuses = examples.map { |example| example.is_a?(Hash) ? example["status"] : nil }
unless statuses.all? { |status| %w[passed failed pending].include?(status) }
  warn "test: estado de ejemplo RSpec desconocido / unknown RSpec example status"
  exit 1
end

passed = statuses.count("passed")
failed = statuses.count("failed")
pending = statuses.count("pending")
if counters["example_count"] != examples.length ||
    counters["failure_count"] != failed ||
    counters["pending_count"] != pending
  warn "test: contadores RSpec inconsistentes / inconsistent RSpec counters"
  exit 1
end
if failed > 0 || counters["errors_outside_of_examples_count"] > 0
  warn "test: fallaron tests Ruby / Ruby test failures"
  exit 1
end
if counters["example_count"] <= 0 || passed <= 0
  warn "test: suite Ruby vacía o sin ejemplos aprobados / empty Ruby suite or no passing examples"
  exit 1
end

puts "Ruby examples: #{passed} passed, #{pending} pending (#{counters["example_count"]} total)"
RUBY
