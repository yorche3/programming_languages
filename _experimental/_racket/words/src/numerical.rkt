#lang racket

(provide fibonacci factorial gcd lcm)

(define (fibonacci n)
  (fibonacci-calc n 0 1))

(define (fibonacci-calc n acc2 acc1)
	(cond
		[(< n 0) -1]
		[(< n 2) n]
		[(= n 2) (+ acc1 acc2)]
		[else (fibonacci-calc (sub1 n) acc1 (+ acc1 acc2))]))

(define (factorial n)
	(factorial-calc n 1))

(define (factorial-calc n acc)
	(cond
		[(< n 0) -1]
		[(<= n 1) acc]
		[else (factorial-calc (sub1 n) (* n acc))]))

(define (gcd a b)
	(cond
		[(= b 0) a]
		[else (gcd b (modulo a b))]))

(define (lcm a b)
	(* (/ a (gcd a b)) b))