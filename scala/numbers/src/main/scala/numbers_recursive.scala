class NumbersRecursive {
  def fibonacci(n: Int): Int = {
    if (n <= 0) 0
    else if (n == 1) 1
    else fibonacci(n - 1) + fibonacci(n - 2)
  }

  def factorial(n: Int): Int = {
    if (n <= 1) 1
    else n * factorial(n - 1)
  }

  def sum_numbers(n: Int): Int = {
    if (n <= 0) 0
    else n + sum_numbers(n - 1)
  }
}