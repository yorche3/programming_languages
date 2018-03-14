#lang racket
1;2802;0c 
;@title(Cadenas)
;@author{Jorge Eduardo Ascencio Espíndola}
;@version{v1.0}

;@defproc[(hola)]{
;  Imprime un saludo.
;}
(define (hola)
  (display "Hola\n"))

;@defproc[(reversa [word string?])
;         string]
;  Returns la cadena invertida
;}
(define (reversa word)
  (list->string(reverse(string->list word))))

;@defproc[(palindromo [word string?])
;	  boolean]{
;  Returns true si es palindromo, false en otro caso
;}
(define (palindromo word)
  (equal? word (reversa word)))

;función auxiliar de iteración para evitar el llenado del stack
(define (repet word ch count)
  (cond
    [(empty? word) count]
    [else (if (equal? (car word) ch) (repet (cdr word) ch (+ count 1))
              (repet (cdr word) ch count))]))
	      
;@defproc[(repeticiones [word string?]
;			[ch char?])
;	  int]
;  Returns el número de apariciones de ch en la palabra word
;}
(define (repeticiones word ch)
  (repet (string->list word) ch 0))

(hola)
(display "Escribe una palabra   ")
(define word (read-line (current-input-port) 'any))
(printf "Hola ~a\n" word)
(display "Caracter a buscar   \n")
(define ch (read-char (current-input-port)))
(printf "repeticiones: ~a\n" (repeticiones word ch))
(printf "Palabra invertida : ~a\n" (reversa word))