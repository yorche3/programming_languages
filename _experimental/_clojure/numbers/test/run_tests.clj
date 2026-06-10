(ns run-tests
  (:require [numbers-recursive-test :as rec]
            [numbers-iterative-test :as ite]))

(defn -main []
  (println "Running calculator tests...")
  (rec/run-all-tests)
  (ite/run-all-tests))