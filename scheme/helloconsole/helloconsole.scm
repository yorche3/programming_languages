(display "¿Cuál es tu nombre?   ")
(define name (read-line))
(display (format "Hola ~s\n" name)
	 (current-output-port))
