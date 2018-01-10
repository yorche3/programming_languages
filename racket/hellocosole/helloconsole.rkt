#lang racket

(display "¿Cuál es tu nombre?   ")
(define a (read-line (current-input-port) 'any))
(printf "Hola ~a\n"
        a)