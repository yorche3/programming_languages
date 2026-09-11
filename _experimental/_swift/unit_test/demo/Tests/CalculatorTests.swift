import XCTest
@testable import demo

final class CalculatorTests: XCTestCase {
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    func testAddition() {
        XCTAssertEqual(calculator.add(2, 3), 5)
    }
    
    func testSubtraction() {
        XCTAssertEqual(calculator.subtract(5, 3), 2)
    }
}