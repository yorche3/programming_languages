(load "../src/numerical.scm")
(load "./test.scm")

(define (run-numerical-suite)
  (display "--- Running Numerical Test Suite ---")
  (newline)
  (let ((suite (make-test-suite 0 0)))
    (add-test suite "Fibonacci"
      (list (make-test-case -1 (fibonacci -3) "negative input")
      (make-test-case 55 (fibonacci 10) "positive input")
      (make-test-case 610 (fibonacci 15) "larger positive input")))

    (add-test suite "Factorial"
      (list (make-test-case -1 (factorial -3) "negative input")
      (make-test-case 120 (factorial 5) "positive input")
      (make-test-case 3628800 (factorial 10) "larger positive input")))

    (add-test suite "GCD"
      (list (make-test-case 6 (gcd 48 18) "case 1")
      (make-test-case 25 (gcd 100 25) "case 2")
      (make-test-case 1 (gcd 17 13) "case 3")))

    (add-test suite "LCM"
      (list (make-test-case 12 (lcm 4 6) "case 1")
      (make-test-case 42 (lcm 21 6) "case 2")
      (make-test-case 21 (lcm 7 3) "case 3")))

    (summary suite)))
