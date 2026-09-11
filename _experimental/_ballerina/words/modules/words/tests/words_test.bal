import ballerina/io;
import ballerina/test;

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function

@test:Config {}
function testReverseString() {
    test:assertEquals(reverseString("hello"), "olleh", "should be \"olleh\"");
    test:assertEquals(reverseString("a"), "a", "should be \"olleh\"");
    test:assertEquals(reverseString(""), "", "should be \"\"");
}

@test:Config {}
function testIsPalindrome() {
    test:assertEquals(isPalindrome("race car"), true, "race car should be true");
    test:assertEquals(isPalindrome("level"), true, "should be true");
    test:assertEquals(isPalindrome("hello"), false, "should be false");
    test:assertEquals(isPalindrome("a"), true, "should be true");
    test:assertEquals(isPalindrome(""), true, "should be true");
}

@test:Config {}
function testIsSubstring() {
    test:assertEquals(kmpSearch("test", "this is a test"), true, "should be true");
    test:assertEquals(kmpSearch("not", "this is a test"), false, "should be false");
    test:assertEquals(kmpSearch("", "any string"), true, "should be true");
    test:assertEquals(kmpSearch("abc", "abc"), true, "should be true");
    test:assertEquals(kmpSearch("abc", "ab"), false, "should be false");
}

@test:Config {}
function testLCS() {
    test:assertEquals(lcs("AGGTAB", "GXTXAYB"), 4, "should be 4");
    test:assertEquals(lcs("ABC", "ABC"), 3, "should be 3");
    test:assertEquals(lcs("ABC", "DEF"), 0, "should be 0");
    test:assertEquals(lcs("", "ABC"), 0, "should be 0");
    test:assertEquals(lcs("ABC", ""), 0, "should be 0");
}
// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
