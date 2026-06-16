(require :fiveam)

(load "test/numerical_test.lisp")
(load "test/words_test.lisp")

(defpackage :run-all
  (:use :cl :fiveam :test-numerical :test-words))
(in-package :run-all)

(defun run-all-suites ()
  (format t "Running tests...~%")
  (run! 'test-numerical::numerical-suite)
  (run! 'test-words::words-suite))