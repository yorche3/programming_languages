(define (reverse-string str)
  (let loop ((chars (string->list str))
             (result '()))
    (if (null? chars)
        (list->string result)
        (loop (cdr chars) (cons (car chars) result)))))

(define (remove-all-whitespaces str)
  (let ((whitespace-chars '(#\space #\newline #\return #\tab)))
    (list->string
     (filter (lambda (ch)
               (not (member ch whitespace-chars)))
             (string->list str)))))

(define (is-palindrome str)
  (let* ((cleaned-str (remove-all-whitespaces str))
				(i 0)
				(j (- (string-length cleaned-str) 1)))
		(let loop ()
			(cond
				((>= i j) #t)
				((char=? (string-ref cleaned-str i) (string-ref cleaned-str j))
						(begin
							(set! i (+ i 1))
							(set! j (- j 1))
							(loop)))
				(else #f)))))

(define (compute-lps-array pat)
  (let* ((len-pat (string-length pat))
				 (lps (make-vector len-pat 0))
				 (length 0)
				 (i 1))
		(let loop ()
			(cond
				((= i len-pat) lps)
				((char=? (string-ref pat i) (string-ref pat length))
				 (begin
					 (set! length (+ length 1))
					 (vector-set! lps i length)
					 (set! i (+ i 1))
					 (loop)))
				((> length 0)
				 (begin
					 (set! length (vector-ref lps (- length 1)))
					 (loop)))
				(else
				 (begin
					 (vector-set! lps i 0)
					 (set! i (+ i 1))
					 (loop)))))))

(define (kmp-search sub str)
	(let* ((len-sub (string-length sub))
				 (len-str (string-length str)))
		(cond
			((= len-sub 0) #t)
			((> len-sub len-str) #f)
			(else 
				(let* ((lps (compute-lps-array sub))
									 (i 0)
									 (j 0))
					(let loop ()
						(cond
							((= i len-str) #f)
							((char=? (string-ref sub j) (string-ref str i))
								(begin
									(set! i (+ i 1))
									(set! j (+ j 1))
									(if (= j len-sub)
										#t
										(loop))))
							((> j 0)
								(begin
									(set! j (vector-ref lps (- j 1)))
									(loop)))
							(else
								(begin
									(set! i (+ i 1))
									(loop))))))))))

(define (make-matrix rows cols)
  (make-vector rows (make-vector cols 0)))

(define (matrix-ref matrix i j)
	(vector-ref (vector-ref matrix i) j))

(define (matrix-set! matrix i j val)
	(vector-set! (vector-ref matrix i) j val))

(define (lcs str1 str2)
  (let* ((len1 (string-length str1))
				 (len2 (string-length str2))
				 (dp (make-matrix (+ len1 1) (+ len2 1)))
				 (i 1)
				 (j 1))
		(let loop ()
			(cond
				((> i len1) '())
				((> j len2)
				 (begin
					 (set! i (+ i 1))
					 (set! j 1)
					 (loop)))
				((char=? (string-ref str1 (- i 1)) (string-ref str2 (- j 1)))
				 (begin
					 (matrix-set! dp i j (+ 1 (matrix-ref dp (- i 1) (- j 1))))
					 (set! j (+ j 1))
					 (loop)))
				(else
				 (begin
					 (matrix-set! dp i j (max (matrix-ref dp (- i 1) j)
																		(matrix-ref dp i (- j 1))))
					 (set! j (+ j 1))
					 (loop)))))
		(matrix-ref dp len1 len2)))