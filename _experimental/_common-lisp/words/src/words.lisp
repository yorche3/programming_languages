(defpackage :words
  (:use :cl))
(in-package :words)

(defun reverse-string (s)
  (let ((len (length s))
        (result '()))
    (loop for i from 0 upto (1- len) do
      (push (char s i) result))
    (coerce result 'string)))

(defun is-palindrome (s)
  (let* ((cleaned (remove-if #'(lambda (c) (find c " \t\n\r")) s))
         (len (length cleaned)))
    (labels ((helper (i j)
               (cond
                 ((> i j) t)
                 ((not (char= (aref cleaned i) (aref cleaned j))) nil)
                 (t (helper (1+ i) (1- j))))))
      (helper 0 (1- len)))))

(defun compute-lps-array (pattern)
  (let* ((len-pattern (length pattern))
         (lps (make-array len-pattern :initial-element 0))
         (i 1)
         (len 0))
    (loop while (< i len-pattern) do
      (if (char= (aref pattern i) (aref pattern len))
          (progn
            (incf len)
            (setf (aref lps i) len)
            (incf i))
          (if (> len 0)
              (setf len (aref lps (1- len)))
              (progn
                (setf (aref lps i) 0)
                (incf i)))))
    lps))

(defun k-m-p-search (patt text)
  (let ((len-patt (length patt))
        (len-text (length text)))
    (cond
      ((= len-patt 0) t)
      ((> len-patt len-text) nil)
      (t
        (let* ((lps (compute-lps-array patt))
               (i 0)
               (j 0))
          (block loop-search
            (loop while (< i len-text) do
              (if (char= (char text i) (char patt j))
                (progn
                  (incf i)
                  (incf j)
                  (when (= j len-patt)
                    (return-from loop-search t)))
                (if (/= j 0)
                  (setf j (aref lps (1- j)))
                  (incf i))))
            nil))))))

(defun l-c-s (str1 str2)
  (let* ((len1 (length str1))
        (len2 (length str2))
        (dp (make-array (list (1+ len1) (1+ len2)) :initial-element 0)))
    (dotimes (i len1)
      (dotimes (j len2)
        (if (char= (char str1 i) (char str2 j))
            (setf (aref dp (1+ i) (1+ j)) (1+ (aref dp i j)))
            (setf (aref dp (1+ i) (1+ j)) (max (aref dp i (1+ j)) (aref dp (1+ i) j))))))
    (aref dp len1 len2)))