import XCTest
@testable import numbers_recursive

final class RecursiveTests: XCTestCase {
    func testFibonacci() {
        XCTAssertEqual(NumbersRecursive.fibonacci(5), 5)
    }
    func testFactorial() {
        XCTAssertEqual(NumbersRecursive.factorial(5), 120)
    }
    func testSumNumbers() {
        XCTAssertEqual(NumbersRecursive.sumNumbers(5), 15)
    }
}