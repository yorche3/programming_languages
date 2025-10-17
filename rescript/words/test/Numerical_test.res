open Jest
open Expect

describe("Numerical functions", () => {
  describe("fibonacci", () => {
    testAll("", list{
      (-3, -1),
      (10, 55),
      (15, 610)
      }, ((n, expected)) => {
      expect(Numerical.fibonacci(n))->toBe(expected)
    })
  })

  describe("factorial", () => {
    testAll("", list{
      (-3, -1),
      (5, 120),
      (10, 3628800)
    }, ((n, expected)) => {
      expect(Numerical.factorial(n))->toBe(expected)
    })
  })

  describe("gcd", () => {
    testAll("", list{
      (48, 18, 6),
      (100, 25, 25),
      (17, 13, 1)
    }, ((a, b, expected)) => {
      expect(Numerical.gcd(a, b))->toBe(expected)
    })
  })

  describe("lcm", () => {
    testAll("", list{
      (6, 4, 12),
      (21, 6, 42),
      (7, 3, 21)
    }, ((a, b, expected)) => {
      expect(Numerical.lcm(a, b))->toBe(expected)
    })
  })
});
