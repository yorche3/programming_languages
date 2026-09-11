#lang racket

(require rackunit)
(require "../src/words.rkt")

(provide words-suite)

(define words-suite
  (test-suite "Word Algorithms"
    (test-case "reverse-string"
      (check-equal? (reverse-string "hello") "olleh")
      (check-equal? (reverse-string "a") "a")
      (check-equal? (reverse-string "") ""))

    (test-case "is-palindrome"
      (check-equal? (is-palindrome "race car") true)
      (check-equal? (is-palindrome "level") true)
      (check-equal? (is-palindrome "hello") false)
      (check-equal? (is-palindrome "a") true)
      (check-equal? (is-palindrome "") true))

		(test-case "is substring"
      (check-equal? (kmp-search "test" "this is a test") true)
      (check-equal? (kmp-search "not" "this is a test") false)
      (check-equal? (kmp-search "" "any string") true)
      (check-equal? (kmp-search "abc" "abc") true)
      (check-equal? (kmp-search "abc" "ab") false))

		(test-case "longest common subsequence"
      (check-equal? (lcs "AGGTAB" "GXTXAYB") 4)
      (check-equal? (lcs "ABC" "ABC") 3)
      (check-equal? (lcs "ABC" "DEF") 0)
      (check-equal? (lcs "" "ABC") 0)
      (check-equal? (lcs "ABC" "") 0))))
