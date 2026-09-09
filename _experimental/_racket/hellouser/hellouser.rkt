#lang racket

(display "Enter your name: ")
(define name (read-line))
(printf "Hello, ~a!\n" name)