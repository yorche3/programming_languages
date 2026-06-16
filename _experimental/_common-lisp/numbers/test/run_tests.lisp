(load "test/numbers_recursive_test.lisp")
(load "test/numbers_iterative_test.lisp")

(defpackage :run-all
  (:use :cl :tests-i :tests-r))
(in-package :run-all)

(defun run-all-suites ()
  (format t "=== Starting All Test Suites ===~%")
  (tests-r::run-recursive-suite)
  (tests-i::run-iterative-suite)
  (format t "=== All Test Suites Completed ===~%"))

;; To execute, load this file and call (run-all-suites)