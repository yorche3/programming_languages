(defpackage :numbers-recursive
  (:use :cl))
(in-package :numbers-recursive)

(defun fibonacci (N)
  (cond
    ((<= N 1) N)
    (t (+ (fibonacci (- N 1))
          (fibonacci (- N 2))))))

(defun factorial (N)
  (if (<= N 1)
      1
      (* N (factorial (- N 1)))))

(defun sum_numbers (N)
  (if (= N 0)
      0
      (+ N (sum_numbers (- N 1)))))