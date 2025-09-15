#lang racket

(provide fibonacci factorial sum_numbers)

(define (fibonacci n)
  (cond
    [(<= n 0) 0]
    [(<= n 2) 1]
    [else (+ (fibonacci (sub1 n)) (fibonacci (- n 2)))]))

(define (factorial n)
  (if (<= n 1)
      1
      (* n (factorial (sub1 n)))))

(define (sum_numbers n)
  (if (<= n 0)
  0
  (+ n (sum_numbers (sub1 n)))))