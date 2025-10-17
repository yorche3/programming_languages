(define (fibonacci n)
  (fibonacci_calc n 0 1))

(define (fibonacci_calc n acc2 acc1)
  (cond ((< n 0) -1)
        ((< n 2) n)
        ((= n 2) (+ acc2 acc1))
        (else (fibonacci_calc (- n 1) acc1 (+ acc1 acc2)))))

(define (factorial n)
  (factorial_calc n 1))

(define (factorial_calc n acc)
  (cond ((< n 0) -1)
        ((<= n 1) acc)
        (else (factorial_calc (- n 1) (* n acc)))))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (lcm a b)
  (* (/ a (gcd a b)) b))