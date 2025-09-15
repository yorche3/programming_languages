(define (fibonacci N)
  (define (fibonacci_iter N Acc2 Acc1)
    (cond ((<= N 1) N)
          ((= N 2) (+ Acc2 Acc1))
          (else (fibonacci_iter (- N 1) Acc1 (+ Acc2 Acc1)))))
  (fibonacci_iter N 0 1))

(define (factorial N)
  (define (factorial_iter N Acc)
    (if (<= N 1)
        Acc
        (factorial_iter (- N 1) (* N Acc))))
  (factorial_iter N 1))

(define (sum_numbers N)
  (define (sum_numbers_iter N Acc)
    (if (<= N 0)
        Acc
        (sum_numbers_iter (- N 1) (+ N Acc))))
  (sum_numbers_iter N 0))