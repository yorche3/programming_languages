(ns numerical)

(defn fibonacci [n]
  (cond
    (< n 0) -1
    (< n 2) n
    :else
    (loop [n n
           acc2 0
           acc1 1]
      (if (<= n 2)
        (+ acc1 acc2)
        (recur (dec n) acc1 (+ acc1 acc2))))))

(defn factorial [n]
  (if (< n 0)
    -1
    (loop [n n
           acc 1]
      (if (<= n 1)
        acc
        (recur (dec n) (* n acc))))))

(defn gcd [a b]
  (loop [a a
         b b]
    (if (= b 0)
      a
      (recur b (mod a b)))))

(defn lcm [a b]
  (if (or (= a 0) (= b 0))
    0
    (* (/ a (gcd a b)) b)))