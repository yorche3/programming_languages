module Test.WordsTest where

import Prelude

import Effect (Effect)
import Test.Unit (suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Words (reverseString, isPalindrome, kmpSearch, lcs)

main :: Effect Unit
main = runTest do
  suite "Words Suite" do
    test "reverse string" do
      Assert.equal (reverseString "hello") "olleh"
      Assert.equal (reverseString "a") "a"
      Assert.equal (reverseString "") ""
    test "is palindrome" do
      Assert.equal (isPalindrome "race car") true
      Assert.equal (isPalindrome "level") true
      Assert.equal (isPalindrome "hello") false
      Assert.equal (isPalindrome "a") true
      Assert.equal (isPalindrome "") true
    test "is substring" do
      Assert.equal (kmpSearch "test" "this is a test") true
      Assert.equal (kmpSearch "not" "this is a test") false
      Assert.equal (kmpSearch "" "any string") true
      Assert.equal (kmpSearch "abc" "abc") true
      Assert.equal (kmpSearch "abc" "ab") false
    test "longest common subsequence" do
      Assert.equal 4 (lcs "AGGTAB" "GXTXAYB")
      Assert.equal 3 (lcs "ABC" "ABC")
      Assert.equal 0 (lcs "ABC" "DEF")
      Assert.equal 0 (lcs "" "ABC")
      Assert.equal 0 (lcs "ABC" "")