#lang racket

(require rackunit rackunit-fancy-runner)
(require "../src/numbers_recursive.rkt")

(define numbers-recursive-suite
  (test-suite "Recursive"
    (test-case "fibonacci"
      (check-equal? (fibonacci 5) 5))

    (test-case "factorial"
      (check-equal? (factorial 5) 120))
  
    (test-case "sum numbers"
      (check-equal? (sum_numbers 5) 15))))
(run-tests/fancy numbers-recursive-suite)