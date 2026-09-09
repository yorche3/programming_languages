(load-option 'format)

(define-structure test-suite passed failed)
(define-structure test-case expected actual description)

(define (incr-passed suite)
    (set-test-suite-passed! suite (+ (test-suite-passed suite) 1)))

(define (incr-failed suite)
    (set-test-suite-failed! suite (+ (test-suite-failed suite) 1)))

(define (assert-eq suite a-test-case)
    (if (equal? (test-case-actual a-test-case) (test-case-expected a-test-case))
        (incr-passed suite)
        (begin 
            (format #t "~A FAILED... expected: ~A, actual: ~A~%" 
                (test-case-description a-test-case) (test-case-expected a-test-case) (test-case-actual a-test-case))
            (incr-failed suite))))

(define (add-test suite name test-cases)
    (for-each (lambda (test-case)
        (assert-eq suite test-case)) test-cases))

(define (summary suite)
    (format #t "SUMMARY: ~A passed, ~A failed.~%" (test-suite-passed suite) (test-suite-failed suite)))