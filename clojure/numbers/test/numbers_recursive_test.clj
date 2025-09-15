(ns numbers-recursive-test
  (:require [clojure.test :refer [deftest is run-tests testing]]
            [numbers-recursive :refer [fibonacci factorial sum-numbers]]))

(deftest test-fibonacci
  (testing "Fibonacci recursive function"
    (is (= (fibonacci 5) 5))))

(deftest test-factorial
  (testing "Factorial recursive function"
    (is (= (factorial 5) 120))))

(deftest test-sum-numbers
  (testing "Sum of numbers recursive function"
    (is (= (sum-numbers 5) 15))))

(defn run-all-tests []
  (run-tests 'numbers-recursive-test))