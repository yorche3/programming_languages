require "spec"
require "./Calculator"

describe Calculator do
  it "adds numbers" do
    puts "Testing add..."
    Calculator.add(2, 3).should eq 5
  end

  it "subtracts numbers" do
    puts "Testing subtract..."
    Calculator.subtract(5, 3).should eq 2
  end
end