class NumbersIterative {
  def fibonacci(n: Int): Int = {
    def fibonacci_iter(N: Int, Acc2: Int, Acc1: Int): Int = {
      if (N <= 0) Acc2
      else if (N <= 2) Acc1 + Acc2
      else fibonacci_iter(N - 1, Acc1, Acc1 + Acc2)
    }
    fibonacci_iter(n, 0, 1)
  }

  def factorial(n: Int): Int = {
    def factorial_iter(N: Int, Acc: Int): Int = {
      if (N <= 1) Acc
      else factorial_iter(N - 1, N * Acc)
    }
    factorial_iter(n, 1)
  }

  def sum_numbers(n: Int): Int = {
    def sum_numbers_iter(N: Int, Acc: Int): Int = {
      if (N <= 0) Acc
      else sum_numbers_iter(N - 1, N + Acc)
    }
    sum_numbers_iter(n, 0)
  }
}