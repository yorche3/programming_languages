(defpackage :numerical
  (:use :cl))
(in-package :numerical)

(defun fibonacci (n)
  (cond
    ((< n 0) -1)
    ((< n 2) n)
    (t
      (let ((acc2 0)
            (acc1 1)
            (i 2))
        (loop while (< i n) do
          (progn
            (let ((next (+ acc1 acc2)))
              (setf acc2 acc1
              acc1 next))
            (incf i)))
        (+ acc1 acc2)))))

(defun factorial (n)
  (if (< n 0)
    -1
    (let ((acc 1)
          (i n))
      (loop while (> i 1) do
        (progn
          (setf acc (* acc i))
          (decf i)))
      acc)))

(defun g-c-d (a b)
  (loop while (/= b 0) do
    (let ((aux (mod a b)))
      (setf a b)
      (setf b aux)))
  a)

(defun l-c-m (a b)
  (* (/ a (g-c-d a b)) b))