defmodule NumbersIterative do
  def fibonacci(n), do: fibonacci_iter(n, 0, 1)

  defp fibonacci_iter(n, acc2, acc1) when n <= 1, do: n
  defp fibonacci_iter(n, acc2, acc1) when n == 2, do: acc1 + acc2
  defp fibonacci_iter(n, acc2, acc1), do: fibonacci_iter(n - 1, acc1, acc1 + acc2)

  def factorial(n), do: factorial_iter(n, 1)

  defp factorial_iter(0, accumulator), do: accumulator
  defp factorial_iter(n, accumulator), do: factorial_iter(n - 1, n * accumulator)

  def sum_numbers(n), do: sum_numbers_iter(n, 0)

  defp sum_numbers_iter(0, accumulator), do: accumulator
  defp sum_numbers_iter(n, accumulator), do: sum_numbers_iter(n - 1, n + accumulator)
end
