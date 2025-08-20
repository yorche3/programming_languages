defmodule CalculatorTest do
  use ExUnit.Case
  doctest Calculator

  test "adds two numbers" do
    IO.puts "\nTesting add..."
    assert Calculator.add(2, 3) == 5
  end

  test "subtracts two numbers" do
    IO.puts "Testing subtract..."
    assert Calculator.subtract(5, 3) == 2
  end
end
