#lang racket

;(defmodule cadenas con racket
;   @author  Jorge Eduardo Ascencio Espíndola
;   @version v1.0)

;(define hola [] -> String)
; regresa un saludo
(define (hola)
  (display "Hola\n"))

(hola)
(display "¿Cuál es tu nombre?   ")
(define word (read-line (current-input-port) 'any))
(printf "Hola ~a\n"
        word)