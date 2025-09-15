(format t "Enter your name: ")
(force-output)  ;; ensure prompt is displayed immediately
(let ((name (read-line)))
  (format t "Hello, ~a!~%" name))