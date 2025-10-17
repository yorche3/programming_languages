namespace test.WordsTests

open NUnit.Framework
open lib.Words

[<TestFixture>]
module WordsTests =

    [<Test>]
    let ``Test Reverse String`` () =
        Assert.AreEqual("olleh", Words.reverseString "hello")
        Assert.AreEqual("a", Words.reverseString "a")
        Assert.AreEqual("", Words.reverseString "")

    [<Test>]
    let ``Test Is Palindrome`` () =
        Assert.AreEqual(true, Words.isPalindrome "race car")
        Assert.AreEqual(true, Words.isPalindrome "level")
        Assert.AreEqual(false, Words.isPalindrome "hello")
        Assert.AreEqual(true, Words.isPalindrome "a")
        Assert.AreEqual(true, Words.isPalindrome "")

    [<Test>]
    let ``Test Is Substring`` () =
        Assert.AreEqual(true, Words.kmpSearch "test" "this is a test")
        Assert.AreEqual(false, Words.kmpSearch "not" "this is a test")
        Assert.AreEqual(true, Words.kmpSearch "" "any string")
        Assert.AreEqual(true, Words.kmpSearch "abc" "abc")
        Assert.AreEqual(false, Words.kmpSearch "abc" "ab")

    [<Test>]
    let ``Test Longest Common Subsequence`` () =
        Assert.AreEqual(4, Words.lcs "AGGTAB" "GXTXAYB")
        Assert.AreEqual(3, Words.lcs "ABC" "ABC")
        Assert.AreEqual(0, Words.lcs "ABC" "DEF")
        Assert.AreEqual(0, Words.lcs "" "ABC")
        Assert.AreEqual(0, Words.lcs "ABC" "")