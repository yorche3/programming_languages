module Numerical
  def self.fibonacci(n : Int32) : Int32
    if n < 0
      return -1
    elsif n < 2
      return n
    end
    acc1 = 1
    acc2 = 0
    while n > 2
      acc2, acc1 = acc1, acc1 + acc2
      n -= 1
    end
    return acc1 + acc2
  end

  def self.factorial(n : Int32) : Int32
    if n < 0
        return -1        
    end
    acc = 1
    while n > 1
      acc *= n
      n -= 1
    end
    return acc
  end

  def self.gcd(a : Int32, b : Int32) : Int32
    while b != 0
      a, b = b, a % b
    end
    return a
  end

  def self.lcm(a : Int32, b : Int32) : Int32
    return (a // gcd(a, b)) * b
  end
end