defmodule Numerical do
  @moduledoc """
  Documentation for `Numerical`.
  """
  def fibonacci(n) when n < 0, do: -1
  def fibonacci(n) when n < 2, do: n
  def fibonacci(n), do: fibonacci_calc(n, 0, 1)

  defp fibonacci_calc(2, acc2, acc1), do: acc1 + acc2
  defp fibonacci_calc(n, acc2, acc1), do: fibonacci_calc(n - 1, acc1, acc1 + acc2)

  def factorial(n) when n < 0, do: -1
  def factorial(0), do: 1
  def factorial(n), do: factorial_calc(n, 1)

  defp factorial_calc(1, acc), do: acc
  defp factorial_calc(n, acc), do: factorial_calc(n - 1, n * acc)

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: div(a, gcd(a, b)) * b
end
