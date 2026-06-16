(require :fiveam)

(load "src/words.lisp")

(defpackage :test-words
  (:use :cl :fiveam :words))
(in-package :test-words)

(def-suite words-suite
  :description "Suite of words tests")
(in-suite words-suite)

(test reverse-string-test
  (is (string= (words::reverse-string "hello") "olleh"))
  (is (string= (words::reverse-string "a") "a"))
  (is (string= (words::reverse-string "") "")))

(test is-palindrome-test
  (is (equal (words::is-palindrome "race car") t))
  (is (equal (words::is-palindrome "level") t))
  (is (equal (words::is-palindrome "hello") nil))
  (is (equal (words::is-palindrome "a") t))
  (is (equal (words::is-palindrome "") t)))

(test is-substring-test
  (is (equal (words::k-m-p-search "test" "this is a test") t))
  (is (equal (words::k-m-p-search "not" "this is a test") nil))
  (is (equal (words::k-m-p-search "" "any string") t))
  (is (equal (words::k-m-p-search "abc" "abc") t))
  (is (equal (words::k-m-p-search "abc" "ab") nil)))

(test lcs-test
  (is (= (words::l-c-s "AGGTAB" "GXTXAYB") 4))
  (is (= (words::l-c-s "ABC" "ABC") 3))
  (is (= (words::l-c-s "ABC" "DEF") 0))
  (is (= (words::l-c-s "" "ABC") 0))
  (is (= (words::l-c-s "ABC" "") 0)))