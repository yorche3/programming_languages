(defpackage :numbers-iterative
  (:use :cl))
(in-package :numbers-iterative)

(defun fibonacci-iter (N Acc2 Acc1)
  (cond
    ((<= N 1) N)
    ((= N 2) (+ Acc2 Acc1))
    (t (fibonacci-iter (- N 1) Acc1 (+ Acc2 Acc1)))))

(defun fibonacci (N)
  (fibonacci-iter N 0 1))

(defun factorial-iter (N Accumulator)
  (if (<= N 1)
      Accumulator
      (factorial-iter (- N 1) (* N Accumulator))))

(defun factorial (N)
  (factorial-iter N 1))

(defun sum_numbers-iter (N Accumulator)
  (if (= N 0)
      Accumulator
      (sum_numbers-iter (- N 1) (+ N Accumulator))))
      
(defun sum_numbers (N)
  (sum_numbers-iter N 0))