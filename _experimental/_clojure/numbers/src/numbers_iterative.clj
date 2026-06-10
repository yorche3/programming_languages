(ns numbers-iterative)

(defn fibonacci-iter [n acc2 acc1]
  (cond
    (<= n 1) n
    (= n 2) acc1 + acc2
    :else (fibonacci-iter (dec n) acc1 (+ acc1 acc2))))

(defn fibonacci [n]
  (fibonacci-iter n 0 1))

(defn factorial-iter [n i acc]
  (if (<= n 1)
    acc
    (factorial-iter (dec n) (inc i) (* acc n))))

(defn factorial [n]
  (factorial-iter n 0 1))

(defn sum-numbers-iter [n acc]
  (if (<= n 0)
    acc
    (sum-numbers-iter (dec n) (+ acc n))))

(defn sum-numbers [n]
  (sum-numbers-iter n 0))