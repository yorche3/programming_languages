#lang racket

(provide reverse-string is-palindrome kmp-search lcs)

(define (reverse-string str)
	(define len (string-length str))
	(define sb (make-string len))
	(for ([i (in-range len)])
		(string-set! sb i (string-ref str (- len i 1))))
	sb)

(define (is-palindrome str)
	(define cleaned-str (regexp-replace* #px"\\s+" str ""))
	(let loop ([i 0]
					 [j (- (string-length cleaned-str) 1)])
		(cond
			[(>= i j) true]
			[(char=? (string-ref cleaned-str i) (string-ref cleaned-str j)) (loop (+ i 1) (- j 1))]
			[else false])))

(define (compute-lps-array pat)
	(define len-pat (string-length pat))
	(define lps (make-vector len-pat 0))
	(let loop ([length 0] [i 1])
		(when (< i len-pat)
			(if (char=? (string-ref pat i) (string-ref pat length))
					(begin
						(set! length (+ length 1))
						(vector-set! lps i length)
						(loop length (+ i 1)))
					(if (> length 0)
							(loop (vector-ref lps (- length 1)) i)
							(begin
								(vector-set! lps i 0)
								(loop length (+ i 1)))))))
	lps)

(define (kmp-search sub str)
	(define len-sub (string-length sub))
	(define len-str (string-length str))
	(cond
		[(= len-sub 0) true]
		[(> len-sub len-str) false]
		[else
			(define lps (compute-lps-array sub))
			(let loop ([i 0] [len 0])
				(cond
					[(= i len-str) false]
					[(char=? (string-ref sub len) (string-ref str i))
						(if (= (+ len 1) len-sub)
								true
								(loop (+ i 1) (+ len 1)))]
					[(> len 0) (loop i (vector-ref lps (- len 1)))]
					[else (loop (+ i 1) len)]))]))

(define (make-matrix rows cols)
	(define matrix (make-vector rows))
	(for ([i (in-range rows)])
		(vector-set! matrix i (make-vector cols 0)))
	matrix)

(define (matrix-get matrix i j)
	(vector-ref (vector-ref matrix i) j))

(define (matrix-set! matrix i j val)
	(vector-set! (vector-ref matrix i) j val))

(define (max a b)
	(if (> a b) a b))

(define (lcs s1 s2)
	(define len1 (string-length s1))
	(define len2 (string-length s2))
	(define dp (make-matrix (+ len1 1) (+ len2 1)))
	(for ([i (in-range 1 (+ len1 1))])
		(for ([j (in-range 1 (+ len2 1))])
			(if (char=? (string-ref s1 (- i 1)) (string-ref s2 (- j 1)))
					(matrix-set! dp i j (+ 1 (matrix-get dp (- i 1) (- j 1))))
					(matrix-set! dp i j (max (matrix-get dp (- i 1) j) (matrix-get dp i (- j 1)))))))
	(matrix-get dp len1 len2))