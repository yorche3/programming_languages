(defproject myproject "0.1.0-SNAPSHOT"
  :description "A minimal Clojure project with tests"
  :url "http://example.com/myproject"
  :license {:name "MIT License"
            :url "https://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.10.3"]]
  :main run-tests
  :source-paths ["src"]
  :profiles {:dev {:dependencies []}})