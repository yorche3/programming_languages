module NumbersRecursive
  def self.fibonacci(n : Int32) : Int32
    if (n <= 1)
      return n
    else
      return fibonacci(n - 1) + fibonacci(n - 2)
    end
  end

  def self.factorial(n : Int32) : Int32
    if (n <= 1)
      return 1
    else
      return n * factorial(n - 1)
    end
  end

  def self.sum_numbers(n : Int32) : Int32
    if (n <= 0)
      return 0
    else
      return n + sum_numbers(n - 1)
    end
  end
end
