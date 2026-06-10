(ns numerical-test
  (:require [clojure.test :refer [deftest are run-tests testing]]
            [numerical :refer [fibonacci factorial gcd lcm]]))

(deftest test-fibonacci
  (testing "Fibonacci"
    (are [n expected] (= (fibonacci n) expected)
      -3 -1
      10 55
      15 610)))

(deftest test-factorial
  (testing "Factorial"
    (are [n expected] (= (factorial n) expected)
      -3 -1
      5 120
      10 3628800)))

(deftest test-gcd
  (testing "Greatest Common Divisor"
    (are [a b expected] (= (gcd a b) expected)
      48 18 6
      100 25 25
      17 13 1)))

(deftest test-lcm
  (testing "Lowest Common Divisor"
    (are [a b expected] (= (lcm a b) expected)
      4 6 12
      21 6 42
      7 3 21)))

(defn run-all-tests []
  (run-tests 'numerical-test))