package test;

import haxe.unit.TestCase;
import haxe.unit.TestStatus;
import NumbersRecursive;

class NumbersRecursiveTest extends TestCase {
    
    private var numbersRecursive:NumbersRecursive;

    public function new() {
        super();
        numbersRecursive = new NumbersRecursive();
    }

    public function testFibonacci() {
        var expected = 5;
        var actual = numbersRecursive.fibonacci(5);
        this.assertEquals(expected, actual);
    }

    public function testFactorial() {
        var expected = 120;
        var actual = numbersRecursive.factorial(5);
        this.assertEquals(expected, actual);
    }

    public function testSumNumbers() {
        var expected = 15;
        var actual = numbersRecursive.sumNumbers(5);
        this.assertEquals(expected, actual);
    }
}
