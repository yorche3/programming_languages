local nit = require("numbers_iterative")

describe("Rescursive Specs", function()
  it("fibonacci", function()
    assert.are.equal(5, nit.fibonacci(5))
  end)

  it("factorial", function()
    assert.are.equal(120, nit.factorial(5))
  end)

  it("sum_numbers", function()
    assert.are.equal(15, nit.sum_numbers(5))
  end)
end)