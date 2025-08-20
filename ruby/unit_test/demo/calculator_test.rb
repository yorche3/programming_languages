require 'minitest/autorun'
require_relative 'calculator'

class TestCalculator < Minitest::Test
  def setup
    @calculator = Calculator.new
  end

  def test_add
    puts "\nTesting addition method..."
    assert_equal 5, @calculator.add(2, 3)
  end

  def test_subtract
    puts "\nTesting subtraction method..."
    assert_equal 2, @calculator.subtract(5, 3)
  end
end