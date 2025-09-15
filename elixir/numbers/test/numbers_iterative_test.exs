defmodule NumbersIterativeTest do
  use ExUnit.Case
  doctest NumbersIterative

  test "fibonacci of 10" do
    assert NumbersIterative.fibonacci(10) == 55
  end

  test "factorial of 5" do
    assert NumbersIterative.factorial(5) == 120
  end

  test "sum of first 5 numbers" do
    assert NumbersIterative.sum_numbers(5) == 15
  end
end
