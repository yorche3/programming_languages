require 'minitest/autorun'
require_relative '../src/numbers_recursive'

class RecursiveTests < Minitest::Test
  def test_fibonacci
    assert_equal 0, NumbersRecursive.fibonacci(0)
    assert_equal 1, NumbersRecursive.fibonacci(1)
    assert_equal 5, NumbersRecursive.fibonacci(5)
    assert_equal 55, NumbersRecursive.fibonacci(10)
  end

  def test_factorial
    assert_equal 1, NumbersRecursive.factorial(0)
    assert_equal 1, NumbersRecursive.factorial(1)
    assert_equal 120, NumbersRecursive.factorial(5)
  end

  def test_sum_numbers
    assert_equal 0, NumbersRecursive.sum_numbers(0)
    assert_equal 1, NumbersRecursive.sum_numbers(1)
    assert_equal 15, NumbersRecursive.sum_numbers(5)
    assert_equal 55, NumbersRecursive.sum_numbers(10)
  end
end