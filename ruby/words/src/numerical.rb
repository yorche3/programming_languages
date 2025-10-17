module Numerical
  def self.fibonacci(n)
    return -1 if n < 0
    return n if n <= 1
    acc1, acc2 = 1, 0
    (3..n).each do |i|
      acc1, acc2 = acc1 + acc2, acc1
    end
    acc1 + acc2
  end

  def self.factorial(n)
    return -1 if n < 0
    result = 1
    (2..n).each do |i|
      result *= i
    end
    result
  end

  def self.gcd(a, b)
    while b != 0
      a, b = b, a % b
    end
    a
  end

  def self.lcm(a, b)
    (a / gcd(a, b)) * b
  end
end