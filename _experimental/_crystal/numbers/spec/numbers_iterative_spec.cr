require "spec"
require "../src/numbers_iterative.cr"

describe NumbersIterative do
  it "fibonacci" do
    NumbersIterative.fibonacci(5).should eq 5
  end

  it "factorial" do
    NumbersIterative.factorial(5).should eq 120
  end

  it "sum_numbers" do
    NumbersIterative.sum_numbers(5).should eq 15
  end
end
