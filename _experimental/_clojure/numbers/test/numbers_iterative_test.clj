(ns numbers-iterative-test
  (:require [clojure.test :refer [deftest is run-tests testing]]
            [numbers-iterative :refer [fibonacci factorial sum-numbers]]))

(deftest test-fibonacci
  (testing "Fibonacci iterative function"
    (is (= (fibonacci 5) 5))))

(deftest test-factorial
  (testing "Factorial iterative function"
    (is (= (factorial 5) 120))))

(deftest test-sum-numbers
  (testing "Sum of numbers iterative function"
    (is (= (sum-numbers 5) 15))))

(defn run-all-tests []
  (run-tests 'numbers-iterative-test))