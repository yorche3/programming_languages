require 'minitest/autorun'
require_relative '../src/numbers_iterative'

class IterativeTests < Minitest::Test
  def test_fibonacci
    assert_equal 0, NumbersIterative.fibonacci(0)
    assert_equal 1, NumbersIterative.fibonacci(1)
    assert_equal 5, NumbersIterative.fibonacci(5)
    assert_equal 55, NumbersIterative.fibonacci(10)
  end

  def test_factorial
    assert_equal 1, NumbersIterative.factorial(0)
    assert_equal 1, NumbersIterative.factorial(1)
    assert_equal 120, NumbersIterative.factorial(5)
    assert_equal 3628800, NumbersIterative.factorial(10)
  end

  def test_sum_numbers
    assert_equal 0, NumbersIterative.sum_numbers(0)
    assert_equal 1, NumbersIterative.sum_numbers(1)
    assert_equal 15, NumbersIterative.sum_numbers(5)
    assert_equal 55, NumbersIterative.sum_numbers(10)
  end
end