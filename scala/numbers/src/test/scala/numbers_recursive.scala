import org.scalatest.funsuite.AnyFunSuite

class NumbersRecursiveTest extends AnyFunSuite {
  val nr = new NumbersRecursive

  test("Fibonacci Recursive") {
    assert(nr.fibonacci(5) == 5)
  }

  test("Factorial Recursive") {
    assert(nr.factorial(5) == 120)
  }

  test("Sum_Numbers Recursive") {
    assert(nr.sum_numbers(5) == 15)
  }
}