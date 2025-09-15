require "spec"
require "../src/numbers_recursive.cr"

describe NumbersRecursive do
  it "fibonacci" do
    puts "Testing fibonacci"
    NumbersRecursive.fibonacci(5).should eq 5
  end

  it "factorial" do
    puts "Testing factorial"
    NumbersRecursive.factorial(5).should eq 120
  end

  it "sum_numbers" do
    puts "Testing sum of numbers"
    NumbersRecursive.sum_numbers(5).should eq 15
  end
end
