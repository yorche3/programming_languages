import XCTest
@testable import Tests

fileprivate extension CalculatorTests {
    @available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
    static let __allTests__CalculatorTests = [
        ("testAddition", testAddition),
        ("testSubtraction", testSubtraction)
    ]
}
@available(*, deprecated, message: "Not actually deprecated. Marked as deprecated to allow inclusion of deprecated tests (which test deprecated functionality) without warnings")
func __Tests__allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CalculatorTests.__allTests__CalculatorTests)
    ]
}