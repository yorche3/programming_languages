package test;

import haxe.unit.TestCase;
import haxe.unit.TestStatus;
import Numerical;

class NumericalTest extends TestCase {

  public function new() {
    super();
  }

  public function testFibonacci() {
    var cases = [
      { input: -3, expected: -1 },
      { input: 10, expected: 55 },
      { input: 15, expected: 610 }
    ];

    for (c in cases) {
      assertEquals(c.expected, Numerical.fibonacci(c.input));
    }
  }

  public function testFactorial() {
    var cases = [
      { input: -3, expected: -1 },
      { input: 5, expected: 120 },
      { input: 10, expected: 3628800 }
    ];

    for (c in cases) {
      assertEquals(c.expected, Numerical.factorial(c.input));
    }
  }
  
  public function testGCD() {
    var cases = [
      { a: 48, b: 18, expected: 6 },
      { a: 100, b: 25, expected: 25 },
      { a: 17, b: 13, expected: 1 }
    ];

    for (c in cases) {
      assertEquals(c.expected, Numerical.gcd(c.a, c.b));
    }
  }

  public function testLCM() {
    var cases = [
      { a: 4, b: 6, expected: 12 },
      { a: 21, b: 6, expected: 42 },
      { a: 7, b: 3, expected: 21 }
    ];

    for (c in cases) {
      assertEquals(c.expected, Numerical.lcm(c.a, c.b));
    }
  }
}