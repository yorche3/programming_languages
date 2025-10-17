module NumbersIterative
  def self.fibonacci(n : Int32) : Int32
    return fibonacci_iter(n, 0, 1)
  end

  def self.fibonacci_iter(n : Int32, acc2 : Int32, acc1 : Int32) : Int32
    if n < 0
      return n
    elsif n <= 2
      return acc2 + acc1
    else
      return fibonacci_iter(n - 1, acc1, acc1 + acc2)
    end
  end

  def self.factorial(n : Int32) : Int32
    return factorial_iter(n, 1)
  end

  def self.factorial_iter(n : Int32, accumulator : Int32) : Int32
    if n <= 1
      return accumulator
    else
      return factorial_iter(n - 1, accumulator * n)
    end
  end

  def self.sum_numbers(n : Int32) : Int32
    return sum_numbers_iter(n, 0)
  end

  def self.sum_numbers_iter(n : Int32, accumulator : Int32) : Int32
    if n <= 0
      return accumulator
    else
      return sum_numbers_iter(n - 1, accumulator + n)
    end
  end
end
