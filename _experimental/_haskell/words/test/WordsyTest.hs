module WordsyTest where

import Test.HUnit
import Wordsy (reverseString, isPalindrome, kmpSearch, lcsy)

testReverseString :: Test
testReverseString = TestList
  [ "Reverse String" ~: "olleh" ~=? reverseString "hello"
  , "Reverse String" ~: "a" ~=? reverseString "a"
  , "Reverse String" ~: "" ~=? reverseString ""
  ]

testIsPalindrome :: Test
testIsPalindrome = TestList
  [ "Is Palindrome" ~: True ~=? isPalindrome "race car"
  , "Is Palindrome" ~: True ~=? isPalindrome "level"
  , "Is Palindrome" ~: False ~=? isPalindrome "hello"
  , "Is Palindrome" ~: True ~=? isPalindrome "a"
  , "Is Palindrome" ~: True ~=? isPalindrome ""
  ]

testIsSubstring :: Test
testIsSubstring = TestList
  [ "Is Substring" ~: True ~=? kmpSearch "test" "this is a test"
  , "Is Substring" ~: False ~=? kmpSearch "not" "this is a test"
  , "Is Substring" ~: True ~=? kmpSearch "" "any string"
  , "Is Substring" ~: True ~=? kmpSearch "abc" "abc"
  , "Is Substring" ~: False ~=? kmpSearch "abc" "ab"
  ]

testLcs :: Test
testLcs = TestList
  [ "Longest Common Subsequence" ~: 4 ~=? lcsy "AGGTAB" "GXTXAYB"
  , "Longest Common Subsequence" ~: 3 ~=? lcsy "ABC" "ABC"
  , "Longest Common Subsequence" ~: 0 ~=? lcsy "ABC" "DEF"
  , "Longest Common Subsequence" ~: 0 ~=? lcsy "" "ABC"
  , "Longest Common Subsequence" ~: 0 ~=? lcsy "ABC" ""
  ]

tests :: Test
tests = TestList [
  TestLabel "Reverse String Tests" testReverseString,
  TestLabel "Is Palindrome Tests" testIsPalindrome,
  TestLabel "Is Substring Tests" testIsSubstring,
  TestLabel "Longest Common Subsequence Tests" testLcs
  ]