require "spec"
require "../src/numerical.cr"

describe Numerical do
  it "Fibonacci" do
    Numerical.fibonacci(-3).should eq -1
    Numerical.fibonacci(10).should eq 55
    Numerical.fibonacci(15).should eq 610
  end

  it "Factorial" do
    Numerical.factorial(-3).should eq -1
    Numerical.factorial(5).should eq 120
    Numerical.factorial(10).should eq 3628800
  end

  it "Gratest Common Divisor" do
    Numerical.gcd(48, 18).should eq 6
    Numerical.gcd(100, 25).should eq 25
    Numerical.gcd(17, 13).should eq 1
  end

  it "Lowest Common Multiple" do
    Numerical.lcm(4, 6).should eq 12
    Numerical.lcm(21, 6).should eq 42
    Numerical.lcm(7, 3).should eq 21
  end
end