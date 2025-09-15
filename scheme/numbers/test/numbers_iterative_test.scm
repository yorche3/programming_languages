;; tests/test_iterative.scm
(load "../src/numbers_iterative.scm")

(define (assert-equal expected actual description)
  (if (not (equal? expected actual))
      (begin
        (display "FAIL: ") (display description) (newline)
        (exit 1))))
 
(define (run-tests-ite)
  (assert-equal 5 (fibonacci 5) "fibonacci(5)")
  (assert-equal 120 (factorial 5) "factorial(5)")
  (assert-equal 10 (sum_numbers 4) "sum_numbers(4)"))