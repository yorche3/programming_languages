(ns numbers-recursive)

(defn fibonacci [n]
  (if (<= n 1)
    n
    (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))

(defn factorial [n]
  (if (<= n 1)
    1
    (* n (factorial (dec n)))))

(defn sum-numbers [n]
  (if (<= n 0)
    0
    (+ n (sum-numbers (dec n)))))