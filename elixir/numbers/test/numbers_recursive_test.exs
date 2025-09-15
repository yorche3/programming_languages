defmodule NumbersRecursiveTest do
  use ExUnit.Case
  doctest NumbersRecursive

  test "fibonacci of 10" do
    assert NumbersRecursive.fibonacci(10) == 55
  end

  test "factorial of 5" do
    assert NumbersRecursive.factorial(5) == 120
  end

  test "sum of first 5 numbers" do
    assert NumbersRecursive.sum_numbers(5) == 15
  end
end
