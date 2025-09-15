import org.scalatest.funsuite.AnyFunSuite

class NumbersIterativeTest extends AnyFunSuite {
  val ni = new NumbersIterative

  test("fibonacci") {
    assert(ni.fibonacci(5) == 5)
  }

  test("factorial") {
    assert(ni.factorial(5) == 120)
  }

  test("sum_numbers") {
    assert(ni.sum_numbers(5) == 15)
  }
}