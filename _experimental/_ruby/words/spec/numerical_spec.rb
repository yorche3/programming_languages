require 'minitest/autorun'
require_relative '../src/numerical'

class NumericalTests < Minitest::Test
  def test_fibonacci
    assert_equal (-1), Numerical.fibonacci(-5)
    assert_equal 55, Numerical.fibonacci(10)
    assert_equal 610, Numerical.fibonacci(15)
  end

  def test_factorial
    assert_equal (-1), Numerical.factorial(-3)
    assert_equal 120, Numerical.factorial(5)
    assert_equal 3628800, Numerical.factorial(10)
  end
  
  def test_gcd
    assert_equal 6, Numerical.gcd(48, 18)
    assert_equal 25, Numerical.gcd(100, 25)
    assert_equal 1, Numerical.gcd(17, 13)
  end

  def test_lcm
    assert_equal 12, Numerical.lcm(4, 6)
    assert_equal 42, Numerical.lcm(21, 6)
    assert_equal 21, Numerical.lcm(7, 3)
  end
end