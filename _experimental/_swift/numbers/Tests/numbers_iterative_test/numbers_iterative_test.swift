import XCTest
@testable import numbers_iterative

final class IterativeTests: XCTestCase {
    func testFibonacci() {
        XCTAssertEqual(NumbersIterative.fibonacci(5), 5)
    }
    func testFactorial() {
        XCTAssertEqual(NumbersIterative.factorial(5), 120)
    }
    func testSumNumbers() {
        XCTAssertEqual(NumbersIterative.sumNumbers(5), 15)
    }
}