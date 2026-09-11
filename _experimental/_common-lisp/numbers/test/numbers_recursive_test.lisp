(load "src/numbers_recursive.lisp")

(defpackage :tests-r
  (:use :cl :numbers-recursive))
(in-package :tests-r)

(defun test-recursive-fibonacci ()
  (assert (= (numbers-recursive::fibonacci 5) 5))
  (format t "Recursive Fibonacci tests passed.~%"))

(defun test-recursive-factorial ()
  (assert (= (numbers-recursive::factorial 5) 120))
  (format t "Recursive Factorial tests passed.~%"))

(defun test-recursive-sum ()
  (assert (= (numbers-recursive::sum_numbers 5) 15))
  (format t "Recursive Sum tests passed.~%"))

(defun run-recursive-suite ()
  (format t "Running Recursive Tests Suite...~%")
  (test-recursive-fibonacci)
  (test-recursive-factorial)
  (test-recursive-sum)
  (format t "All recursive tests completed.~%"))