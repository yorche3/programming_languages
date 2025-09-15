defmodule NumbersRecursive do
  def fibonacci(0), do: 0
  def fibonacci(1), do: 1
  def fibonacci(n), do: fibonacci(n - 1) + fibonacci(n - 2)

  def factorial(0), do: 1
  def factorial(n), do: n * factorial(n - 1)

  def sum_numbers(0), do: 0
  def sum_numbers(n), do: n + sum_numbers(n - 1)
end
