
# Unit Test projects with Deps.edn and Clojure with Clojure.test
How were built unit test projects.

## Requisites
- Install
  - [Clojure](https://clojure.org/index)

## Structure
```text
demo
├── src
├── test
│   └── run_tests.clj
├── deps.edn
└── project.clj
```

## Configure
Go to `demo` directory and
- Modify `project.clj` file similar to following:
```clojure
(defproject demo"0.1.0-SNAPSHOT"
  :description "A minimal Clojure project with tests"
  :url "http://example.com/myproject"
  :license {:name "MIT License"
            :url "https://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.10.3"]]
  :main main-demo
  :source-paths ["src" "sources"]
  :profiles {:dev {:dependencies []}})
```

- Modify `deps.edn` for setting sources accesibles:
```edn
{:deps {org.clojure/clojure {:mvn/version "1.11.1"}}
 :paths ["src" "test"] 
 :aliases {:test {:extra-paths ["test"]}}
 :prep-lib {:alias :build
                 :fn compile
                 :ensure "target/classes"}}
```

## Build project
No need for this type of projects.

## Modify project
- For each `"lib"` `example.clj` add a `example_test.clj` in `test` dir similar to the following:
```clojure
(ns example-test
  (:require [clojure.test :refer [deftest is run-tests testing]]
            [example :refer [list of functions]]))

(deftest test-function1
  (testing "Testing function1"
    (is (= (function1 X) expected))))

(deftest test-function2
  (testing "Testing function2"
    (is (= (function2 X) expected))))

(defn run-all-tests []
  (run-tests 'example-test))
```
- Adecuate the `run_test` for your suites:
```clojure
(ns run-tests
  (:require [example1-test :as ex1t]
            [exampple1-test :as ex2t]))

(defn -main []
  (println "Running demo tests...")
  (ex1t/run-all-tests)
  (ex2t/run-all-tests))
```
## Compile and run tests
```bash
clj -M -m run-tests
```