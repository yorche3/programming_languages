if System.argv() != ["test"] do
  IO.puts(:stderr, "test: uso inválido / invalid usage: elixir_test_runner.exs test")
  exit({:shutdown, 1})
end

{:ok, _} = Application.ensure_all_started(:ex_unit)
results = :ets.new(:glot_exunit_results, [:duplicate_bag, :public])
ExUnit.after_suite(fn stats -> :ets.insert(results, {:suite, stats}) end)

Mix.CLI.main()

case :ets.lookup(results, :suite) do
  [{:suite, %{total: total, failures: failures, excluded: excluded, skipped: skipped}}]
  when is_integer(total) and is_integer(failures) and is_integer(excluded) and
         is_integer(skipped) and total >= 0 and failures >= 0 and excluded >= 0 and
         skipped >= 0 and failures + excluded + skipped <= total ->
    passed = total - failures - excluded - skipped

    IO.puts(
      "glot: ExUnit: #{passed} passed, #{failures} failed, #{skipped} skipped, #{excluded} excluded"
    )

    if passed == 0 or failures > 0 do
      IO.puts(
        :stderr,
        "test: no hay casos ExUnit aprobados o hay fallos / no passing ExUnit cases or failures detected"
      )

      exit({:shutdown, 1})
    end

    File.write!(System.fetch_env!("GLOT_ELIXIR_TEST_REPORT"), "ok\n")

  [] ->
    IO.puts(:stderr, "test: falta el resultado de ExUnit / missing ExUnit result")
    exit({:shutdown, 1})

  _ ->
    IO.puts(
      :stderr,
      "test: resultado ExUnit inválido o múltiples ejecuciones / invalid ExUnit result or multiple runs"
    )

    exit({:shutdown, 1})
end
