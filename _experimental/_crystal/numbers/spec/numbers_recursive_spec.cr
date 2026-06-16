require "spec"
require "../src/numbers_recursive.cr"

describe NumbersRecursive do
  it "fibonacci" do
    NumbersRecursive.fibonacci(5).should eq 5
  end

  it "factorial" do
    NumbersRecursive.factorial(5).should eq 120
  end

  it "sum_numbers" do
    NumbersRecursive.sum_numbers(5).should eq 15
  end
end
