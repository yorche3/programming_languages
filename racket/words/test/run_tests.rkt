#lang racket

(require rackunit/text-ui rackunit-fancy-runner)
(require "./numerical_test.rkt")
(require "./words_test.rkt")

(run-tests/fancy numerical-suite)
(run-tests/fancy words-suite)
