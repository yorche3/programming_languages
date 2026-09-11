import XCTest
@testable import words

final class wordsTests: XCTestCase {
    func testStringReverse() throws {
        XCTAssertEqual(Words.stringReverse(str: "hello"), "olleh")
        XCTAssertEqual(Words.stringReverse(str: "a"), "a")
        XCTAssertEqual(Words.stringReverse(str: ""), "")
    }

    func testPalindrome() throws {
        XCTAssertEqual(Words.isPalindrome(str: "race car"), true)
        XCTAssertEqual(Words.isPalindrome(str: "level"), true)
        XCTAssertEqual(Words.isPalindrome(str: "hello"), false)
        XCTAssertEqual(Words.isPalindrome(str: "a"), true)
        XCTAssertEqual(Words.isPalindrome(str: ""), true)
    }

    func testIsSubstring() throws {
        XCTAssertEqual(Words.kmpSearch(sub: "test",str:  "this is a test"), true)
        XCTAssertEqual(Words.kmpSearch(sub: "not",str:  "this is a test"), false)
        XCTAssertEqual(Words.kmpSearch(sub: "",str:  "any string"), true)
        XCTAssertEqual(Words.kmpSearch(sub: "abc",str:  "abc"), true)
        XCTAssertEqual(Words.kmpSearch(sub: "abc",str:  "ab"), false)
    }

    func testLCS() throws {
        XCTAssertEqual(Words.lcs(str1:  "AGGTAB", str2:  "GXTXAYB"), 4)
        XCTAssertEqual(Words.lcs(str1:  "ABC", str2:  "ABC"), 3)
        XCTAssertEqual(Words.lcs(str1:  "ABC", str2:  "DEF"), 0)
        XCTAssertEqual(Words.lcs(str1:  "", str2:  "ABC"), 0)
        XCTAssertEqual(Words.lcs(str1:  "ABC", str2:  ""), 0)
    }
}
