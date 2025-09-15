(load "src/numbers_iterative.lisp")

(defpackage :tests-i
  (:use :cl :numbers-iterative))
(in-package :tests-i)

(defun test-iterative-fibonacci ()
  (assert (= (numbers-iterative::fibonacci 10) 55))
  (format t "Iterative Fibonacci tests passed.~%"))

(defun test-iterative-factorial ()
  (assert (= (numbers-iterative::factorial 5) 120))
  (format t "Iterative Factorial tests passed.~%"))

(defun test-iterative-sum ()
  (assert (= (numbers-iterative::sum_numbers 5) 15))
  (format t "Iterative Sum tests passed.~%"))

(defun run-iterative-suite ()
  (format t "Running Iterative Tests Suite...~%")
  (test-iterative-fibonacci)
  (test-iterative-factorial)
  (test-iterative-sum)
  (format t "All iterative tests completed.~%"))