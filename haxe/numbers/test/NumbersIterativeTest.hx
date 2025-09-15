package test;

import haxe.unit.TestCase;
import haxe.unit.TestStatus;
import NumbersIterative;

class NumbersIterativeTest extends TestCase {
    
    private var numbersIterative:NumbersIterative;

    public function new() {
        super();
        numbersIterative = new NumbersIterative();
    }

    public function testFibonacci() {
        var expected = 5;
        var actual = numbersIterative.fibonacci(5);
        assertEquals(expected, actual);
    }

    public function testFactorial() {
        var expected = 120;
        var actual = numbersIterative.factorial(5);
        assertEquals(expected, actual);
    }

    public function testSumNumbers() {
        var expected = 15;
        var actual = numbersIterative.sumNumbers(5);
        assertEquals(expected, actual);
    }
    
}