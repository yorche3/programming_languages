module NumbersIterative
  def self.fibonacci(n)
    fibonacci_iter(n, 0, 1)
  end

  def self.fibonacci_iter(n, acc2, acc1)
    if n <= 0
      acc2
    elsif n == 1
      acc1
    else
      fibonacci_iter(n - 1, acc1, acc1 + acc2)
    end
  end

  def self.factorial(n)
    factorial_iter(n, 1)
  end

  def self.factorial_iter(n, acc)
    if n <= 1
      acc
    else
      factorial_iter(n - 1, n * acc)
    end
  end

  def self.sum_numbers(n)
    sum_numbers_iter(n, 0)
  end

  def self.sum_numbers_iter(n, acc)
    if n <= 0
      acc
    else
      sum_numbers_iter(n - 1, n + acc)
    end
  end
end