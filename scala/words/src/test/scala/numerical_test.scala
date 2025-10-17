import org.scalatest.funsuite.AnyFunSuite

class NumericalTest extends AnyFunSuite {
  test("fibonacci") {
    assert(Numerical.fibonacci(-3) == -1)
    assert(Numerical.fibonacci(10) == 55)
    assert(Numerical.fibonacci(15) == 610)
  }

  test("factorial") {
    assert(Numerical.factorial(-3) == -1)
    assert(Numerical.factorial(5) == 120)
    assert(Numerical.factorial(10) == 3628800)
  }

  test("greatest common divisor") {
    assert(Numerical.gcd(48, 18) == 6)
    assert(Numerical.gcd(100, 25) == 25)
    assert(Numerical.gcd(17, 13) == 1)
  }

  test("least common multiple") {
    assert(Numerical.lcm(6, 4) == 12)
    assert(Numerical.lcm(21, 6) == 42)
    assert(Numerical.lcm(7, 3) == 21)
  }
}