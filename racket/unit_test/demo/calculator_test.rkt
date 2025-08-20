#lang racket

(require rackunit rackunit-fancy-runner)
(require "calculator.rkt") ; Import the calculator functions

(define calculator-tests
  (test-suite
   "Calculator Tests"
   (test-case "Addition Test"
     (check-equal? (add 2 3) 5))
   (test-case "Subtraction Test"
     (check-equal? (subtract 5 3) 2))))

(run-tests/fancy calculator-tests)
