#lang racket

(require rackunit)
(require "../src/numerical.rkt")

(provide numerical-suite)

(define numerical-suite
  (test-suite "Numerical Algorithms"
    (test-case "fibonacci"
      (check-equal? (fibonacci -3) -1)
      (check-equal? (fibonacci 10) 55)
      (check-equal? (fibonacci 15) 610))

    (test-case "factorial"
      (check-equal? (factorial -3) -1)
      (check-equal? (factorial 5) 120)
      (check-equal? (factorial 10) 3628800))
  
    (test-case "greatest common divisor"
      (check-equal? (gcd 48 18) 6)
      (check-equal? (gcd 100 25) 25)
      (check-equal? (gcd 17 13) 1))

    (test-case "least common multiple"
      (check-equal? (lcm 4 6) 12)
      (check-equal? (lcm 21 6) 42)
      (check-equal? (lcm 7 3) 21))))