(defpackage :package-lobby
  (:use :cl 
	:usocket 
	:local-time
	:bt-semaphore)
  (:export :with-created-lobby
	   :with-joined-lobby)
  (:nicknames :lobby))

(in-package :package-lobby)

(defconstant +port+ 8008)
(defconstant +ip+ "127.0.0.1")
(defvar *thread-lock* (bt:make-lock))

(defun create-lobby (&key (guest-count-max-supplied 10))
  (let ((socket (usocket:socket-listen +ip+ +port+))
	 (guest-count-max guest-count-max-supplied)
	 (current-guest-count 0)
	 (last-str ""))
    (unwind-protect
      (loop
	(let* ((connection (usocket:socket-accept socket :element-type 'character))
	       (stream (usocket:socket-stream connection)))
	  (bt:make-thread 
	    (lambda ()
	      (usocket:wait-for-input)
	      ())
	  )
	)
      )
      (progn
	(usocket:socket-close socket)
	(format t "---Exited gracefully hopefully---~%")))))

(defun join-lobby (&key ip port)
  (let* ((socket (usocket:socket-connect ip port :element-type 'character))
	 (stream (usocket:socket-stream socket)))
    (unwind-protect
      (progn
	(bt:make-thread 
	  (lambda ()
	    )
	)
      )
      (progn
	(format t "---Connection closed---~%")
	(usocket:socket-close socket))))
)

