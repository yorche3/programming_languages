import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

@test:Config {}
function testFibonacci() {
    test:assertEquals(fibonacci(5), 5, "should be 5");
}

@test:Config {}
function testFactorial() {
    test:assertEquals(factorial(5), 120, "should be 120");
}

@test:Config {}
function testSumNumbers() {
    test:assertEquals(sumNumbers(5), 15, "should be 15");
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
