(ns run-tests
  (:require [calculator-test :as ct]))

(defn -main []
  (println "Running calculator tests...")
  (ct/run-all-tests))