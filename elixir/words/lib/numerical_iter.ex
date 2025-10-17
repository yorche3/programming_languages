defmodule NumericalIter do
  @moduledoc """
  Documentation for `Numerical`.
  """
  def fibonacci(n) when n < 0, do: -1
  def fibonacci(n) when n < 2, do: n
  def fibonacci(n) do
    2..n
    |> Enum.reduce({0, 1}, fn _, {acc2, acc1} -> {acc1, acc1 + acc2} end)
    |> elem(1)
  end

  def factorial(n) when n < 0, do: -1
  def factorial(0), do: 1
  def factorial(n) do
    1..n
    |> Enum.reduce(1, fn i, acc -> i * acc end)
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: div(a, gcd(a, b)) * b
end
