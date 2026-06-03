import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function

@test:Config {}
function testFibonacci() {
    test:assertEquals(fibonacci(-3), -1, "should be -1");
    test:assertEquals(fibonacci(10), 55, "should be 55");
    test:assertEquals(fibonacci(15), 610, "should be 610");
}

// Negative Test function

@test:Config {}
function testFactorial() {
    test:assertEquals(factorial(-3), -1, "should be -1");
    test:assertEquals(factorial(5), 120, "should be 120");
    test:assertEquals(factorial(10), 3628800, "should be 3628800");
}

@test:Config {}
function testGCD() {
    test:assertEquals(gcd(48, 18), 6, "should be 6");
    test:assertEquals(gcd(100, 25), 25, "should be 25");
    test:assertEquals(gcd(17, 13), 1, "should be 1");
}

@test:Config {}
function testLCM() {
    test:assertEquals(lcm(4, 6), 12, "should be 12");
    test:assertEquals(lcm(21, 6), 42, "should be 42");
    test:assertEquals(lcm(7, 3), 21, "should be 21");
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
