import org.scalatest.funsuite.AnyFunSuite

class CalculatorTest extends AnyFunSuite {
  val calculator = new Calculator

  test("Addition of two numbers") {
    assert(calculator.add(2, 3) == 5)
  }

  test("Subtraction of two numbers") {
    assert(calculator.subtract(5, 3) == 2)
  }
}