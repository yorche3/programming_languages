(defn hola []
  "Hola")

(defn palindromo [x]
  (= (seq x) (reverse x)))

(defn reversa
  ([] (str))
  ([x] (reverse x)))

(defn repet [word ch c]
  (cond
    (= 0 (count word)) c
    :else (cond
    	    (= ch (str (first word))) (repet (rest word) ch (+ 1 c))
	    :else (repet (rest word) ch c))))

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