(defpackage :package-user
  (:use :cl 
	:usocket 
	:local-time
	:bt-semaphore)
  (:export #:create-lobby
	   #:join-lobby)
  (:nicknames :usr))

(in-package :package-user)

(defconstant +port+ 8008)
(defconstant +ip+ "127.0.0.1")

(defun create-lobby (&key (guest-count-max 10))
  (let ((socket (usocket:socket-listen +ip+ +port+)))
    (unwind-protect
      (loop
	(let* ((connection (usocket:socket-accept socket :element-type 'character))
	       (stream (usocket:socket-stream connection))
	       (top-level-output *standard-output*))
	  (bt:make-thread 
	    (lambda () 
	      ;; do things here
	    ))))
      (progn
	(usocket:socket-close socket)
	(format t "Exited gracefully hopefully~%")))))
