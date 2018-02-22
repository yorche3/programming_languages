;; Función que regresa un saludo
(defn hola []
  "Hola")

;; Funcion que verifica si una palabra es palindromo
;; @param x palabra a evaluar
;; @returns true si lo es, false en otro caso
(defn palindromo [x]
  (= (seq x) (reverse x)))

;; Funcion que invierte una cadena
;; @param x palabra a evaluar
;; @returns cadena invertida
(defn reversa
  ([] (str))
  ([x] (reverse x)))

;; Función que cuenta el número de repeticiones de una carácter en una palabra
;; @param word  palabra a evaluar
;; @param ch    carácter a buscar
;; @param c     contador de repeticiones
;; @returns el contador con el número de repeticiones
(defn repet [word ch c]
  (cond
    (= 0 (count word)) c
    :else (cond
    	    (= ch (str (first word))) (repet (rest word) ch (+ 1 c))
	    :else (repet (rest word) ch c))))

;; Función que llama a contar el número de repeticiones
;; del carpacter y en la palabra x
(defn repeticiones [x y]
  (repet x y 0))

(println (hola))
(println "Escribe una palabra")
(let [name (read-line)]
  (println "Es palindromo :" (palindromo name))
  (println "Palabra invertida" (reversa name))
  (println "Carácter a buscar")
  (def ch (read-line))
  (println "repeticiones de" ch ":" (repeticiones name ch)))