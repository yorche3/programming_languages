local nr = require("numbers_recursive")

describe("Rescursive Specs", function()
  it("fibonacci", function()
    assert.are.equal(5, nr.fibonacci(5))
  end)

  it("factorial", function()
    assert.are.equal(120, nr.factorial(5))
  end)

  it("sum_numbers", function()
    assert.are.equal(15, nr.sum_numbers(5))
  end)
end)