(load "../src/words.scm")
(load "./test.scm")

(define (run-words-suite)
  (display "--- Running Words Test Suite ---")
  (newline)
  (let ((suite (make-test-suite 0 0)))
    (add-test suite "Reverse String"
      (list (make-test-case "olleh" (reverse-string "hello") "hello")
        (make-test-case "a" (reverse-string "a") "a")
        (make-test-case "" (reverse-string "") "")))

    (add-test suite "Is Palindrome"
      (list (make-test-case #t (is-palindrome "race car") "race car")
        (make-test-case #t (is-palindrome "level") "level")
        (make-test-case #f (is-palindrome "hello") "hello")
        (make-test-case #t (is-palindrome "a") "a")
        (make-test-case #t (is-palindrome "") "")))
    
    (add-test suite "Is Substring"
      (list (make-test-case #t (kmp-search "test" "this is a test") "test")
        (make-test-case #f (kmp-search "not" "this is a test") "not")
        (make-test-case #t (kmp-search "" "any string") "")
        (make-test-case #t (kmp-search "abc" "abc") "abc")
        (make-test-case #f (kmp-search "abc" "ab") "abc")))

    (add-test suite "Longest Common Subsequence"
      (list (make-test-case 4 (lcs "AGGTAB" "GXTXAYB") "AGGTAB")
        (make-test-case 3 (lcs "ABC" "ABC") "ABC")
        (make-test-case 0 (lcs "ABC" "DEF") "ABC")
        (make-test-case 0 (lcs "" "ABC") "")
        (make-test-case 0 (lcs "ABC" "") "ABC")))

    (summary suite)))