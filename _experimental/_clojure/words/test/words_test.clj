(ns words-test
  (:require [clojure.test :refer [deftest are run-tests testing]]
            [words :refer [reverse-string is-palindrome kmp-search lcs]]))

(deftest test-reverse-string
  (testing "Reverse String"
    (are [s expected] (= (reverse-string s) expected)
      "hello" "olleh"
      "a" "a"
      "" ""
      "abcde" "edcba")))

(deftest test-is-palindrome
  (testing "Is Palindrome"
    (are [s expected] (= (is-palindrome s) expected)
      "race car" true
      "level" true
      "hello" false
      "a" true
      "" true)))

(deftest test-is-substring
  (testing "Is Substring"
    (are [subst strng expected] (= (kmp-search subst strng) expected)
      "test" "this is a test" true
      "not" "this is a test" false
      "" "any string" true
      "abc" "abc" true
      "abc" "ab" false)))

(deftest test-lcs
  (testing "Longest Common Subsequence"
    (are [str1 str2 expected] (= (lcs str1 str2) expected)
      "AGGTAB" "GXTXAYB" 4
      "ABC" "ABC" 3
      "ABC" "DEF" 0
      "" "ABC" 0
      "ABC" "" 0)))

(defn run-all-tests []
  (run-tests 'words-test))