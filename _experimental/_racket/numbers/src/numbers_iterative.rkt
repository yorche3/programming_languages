#lang racket

(provide fibonacci factorial sum_numbers)

(define (fibonacci n)
  (fibonacci-iter n 0 1))

(define (fibonacci-iter n acc2 acc1)
  (cond
    [(<= n 0) 0]
    [(<= n 2) (+ acc1 acc2)]
    [else (fibonacci-iter (sub1 n) acc1 (+ acc1 acc2))]))

(define (factorial n)
  (factorial-iter n 1))

(define (factorial-iter n acc)
  (cond
    [(<= n 1) acc]
    [else (factorial-iter (sub1 n) (* n acc))]))

(define (sum_numbers n)
  (sum_numbers-iter n 0))

(define (sum_numbers-iter n acc)
  (cond
    [(<= n 0) acc]
    [else (sum_numbers-iter (sub1 n) (+ n acc))]))