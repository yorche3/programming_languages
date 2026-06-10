(ns words)

(require '[clojure.string :as str])

(defn reverse-string [s]
  (let [len (count s)
        result (loop [len len
                      acc []]
                 (if (= len 0)
                   acc
                   (recur (dec len) (conj acc (nth s (dec len))))))]
    (apply str result)))

(defn is-palindrome [s]
  (let [chars (vec (str/replace s #"\s+" ""))
        len (count chars)]
    (loop [i 0
           j (dec len)]
      (cond
        (> i j) true
        (not= (nth chars i) (nth chars j)) false
        :else 
        (recur (inc i) (dec j))))))

(defn compute-lps-array [pattern]
  (let [len-pattern (count pattern)
        lps (int-array len-pattern)]
    (loop [i 1
           len 0]
      (if (< i len-pattern)
        (if (= (nth pattern i) (nth pattern len))
          (do
            (aset lps i len)
            (recur (inc i) (inc len)))
          (do
            (if (> len 0)
              (recur i (aget lps (dec len)))
              (do
                (aset lps i 0)
                (recur (inc i) 0)))))
        lps))))

(defn compute-lps-array [pattern]
  (let [len-pattern (count pattern)
        lps (int-array len-pattern)]
    (loop [i 1
           len 0]
      (if (< i len-pattern)
        (if (= (nth pattern i) (nth pattern len))
          (do
            (aset lps i len)
            (recur (inc i) (inc len)))
          (do
            (if (> len 0)
              (recur i (aget lps (dec len)))
              (do
                (aset lps i 0)
                (recur (inc i) 0)))))
        lps))))

(defn kmp-search [subst strng]
  (let [len-subst (count subst)
        len-strng (count strng)]
    (cond
      (= len-subst 0) true
      (> len-subst len-strng) false
      :else
      (let [lps (compute-lps-array subst)]
        (loop [i 0
               j 0]
          (cond
            (= j len-subst) true
            (= i len-strng) false
            (= (nth strng i) (nth subst j))
            (recur (inc i) (inc j))
            :else
            (if (pos? j)
              (recur i (aget lps (dec j)))
              (recur (inc i) j))))))))

(defn lcs [str1 str2]
   (let [len1 (count str1)
         len2 (count str2)
         dp (vec (repeat (inc len1) (int-array (inc len2))))]
     (doseq [i (range 1 (inc len1))
             j (range 1 (inc len2))]
       (if (= (nth str1 (dec i))
              (nth str2 (dec j)))
         (aset (nth dp i) j (+ (aget (nth dp (dec i)) (dec j)) 1))
         (aset (nth dp i) j (max (aget (nth dp (dec i)) j)
                                 (aget (nth dp i) (dec j))))))
   (aget (nth dp len1) len2)))