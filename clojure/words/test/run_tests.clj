(ns run-tests
  (:require [numerical-test :as num-t]
            [words-test :as wor-t]))

(defn -main []
  (println "Running tests...")
  (num-t/run-all-tests)
  (wor-t/run-all-tests))