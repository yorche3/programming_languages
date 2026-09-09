(define (fibonacci N)
  (cond ((<= N 1) N)
        (else (+ (fibonacci (- N 1))
                 (fibonacci (- N 2))))))

(define (factorial N)
  (cond ((<= N 1) 1)
        (else (* N (factorial (- N 1))))))

(define (sum_numbers N)
  (if (<= N 0)
      0
      (+ N (sum_numbers (- N 1)))))