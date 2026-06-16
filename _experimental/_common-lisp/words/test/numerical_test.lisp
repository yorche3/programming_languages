(require :fiveam)

(load "src/numerical.lisp")

(defpackage :test-numerical
  (:use :cl :fiveam :numerical))
(in-package :test-numerical)

(def-suite numerical-suite
  :description "Suite of numerical tests")
(in-suite numerical-suite)

(test fibonacci-test
  (is (= (numerical::fibonacci -3) -1))
  (is (= (numerical::fibonacci 10) 55))
  (is (= (numerical::fibonacci 15) 610)))

(test factorial-test
  (is (= (numerical::factorial -3) -1))
  (is (= (numerical::factorial 5) 120))
  (is (= (numerical::factorial 10) 3628800)))

(test gcd-test
  (is (= (numerical::g-c-d 48 18) 6))
  (is (= (numerical::g-c-d 100 25) 25))
  (is (= (numerical::g-c-d 17 13) 1)))

(test lcm-test
  (is (= (numerical::l-c-m 4 6) 12))
  (is (= (numerical::l-c-m 21 6) 42))
  (is (= (numerical::l-c-m 7 3) 21)))