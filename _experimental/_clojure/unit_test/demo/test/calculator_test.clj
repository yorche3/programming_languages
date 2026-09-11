(ns calculator-test
  (:require [clojure.test :refer [deftest is run-tests testing]]
            [calculator :refer [add subtract]]))

(deftest test-add
  (testing "Context of the test assertions"
    (is (= 5 (add 2 3)))))

(deftest test-subtract
  (is (= 1 (subtract 3 2))))
  
(defn run-all-tests []
  (run-tests 'calculator-test))