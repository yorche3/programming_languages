import XCTest
@testable import numerical

final class numericalTests: XCTestCase {
    func testFibonacci() throws {
        XCTAssertEqual(Numerical.fibonacci(n: -3), -1)
        XCTAssertEqual(Numerical.fibonacci(n: 10), 55)
        XCTAssertEqual(Numerical.fibonacci(n: 15), 610)
    }

    func testFactorial() throws {
        XCTAssertEqual(Numerical.factorial(n: -3), -1)
        XCTAssertEqual(Numerical.factorial(n: 5), 120)
        XCTAssertEqual(Numerical.factorial(n: 10), 3628800)
    }

    func testGCD() throws {
        XCTAssertEqual(Numerical.gcd(a: 12, b: 18), 6)
        XCTAssertEqual(Numerical.gcd(a: 100, b: 25), 25)
        XCTAssertEqual(Numerical.gcd(a: 17, b: 13), 1)
    }

    func testLCM() throws {
        XCTAssertEqual(Numerical.lcm(a: 4, b: 6), 12)
        XCTAssertEqual(Numerical.lcm(a: 21, b: 6), 42)
        XCTAssertEqual(Numerical.lcm(a: 7, b: 3), 21)
    }
}