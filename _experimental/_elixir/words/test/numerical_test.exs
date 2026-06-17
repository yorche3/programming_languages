defmodule NumericalTest do
  use ExUnit.Case
  doctest Numerical

  test "Fibonacci" do
    assert Numerical.fibonacci(-3) == -1
    assert Numerical.fibonacci(10) == 55
    assert Numerical.fibonacci(15) == 610
  end

  test "Factorial" do
    assert Numerical.factorial(-3) == -1
    assert Numerical.factorial(5) == 120
    assert Numerical.factorial(10) == 3628800
  end

  test "Greatest Common Divisor" do
    assert Numerical.gcd(48, 18) == 6
    assert Numerical.gcd(100, 25) == 25
    assert Numerical.gcd(17, 13) == 1
  end

  test "Lowest Common Multiple" do
    assert Numerical.lcm(4, 6) == 12
    assert Numerical.lcm(21, 6) == 42
    assert Numerical.lcm(7, 3) == 21
  end
end
