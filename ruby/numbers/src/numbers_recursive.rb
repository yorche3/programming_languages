module NumbersRecursive
  def self.fibonacci(n)
    if n <= 0
      0
    elsif n == 1
      1
    else
      fibonacci(n - 1) + fibonacci(n - 2)
    end
  end

  def self.factorial(n)
    if n <= 1
      1
    else
      n * factorial(n - 1)
    end
  end

  def self.sum_numbers(n)
    if n <= 0
      0
    else
      n + sum_numbers(n - 1)
    end
  end
end