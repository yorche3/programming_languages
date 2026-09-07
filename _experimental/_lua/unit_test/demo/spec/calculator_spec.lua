local calculator = require("calculator")

describe("Calculator", function()
  it("adds two numbers correctly", function()
    assert.are.equal(5, calculator.add(2, 3))
  end)

  it("subtracts two numbers correctly", function()
    assert.are.equal(3, calculator.subtract(5, 2))
  end)
end)