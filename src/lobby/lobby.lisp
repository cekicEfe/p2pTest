(defpackage :package-lobby
  (:use :cl 
	:usocket 
	:local-time
	:bt-semaphore)
  (:export :create-lobby
	   :join-lobby)
  (:nicknames :lobby))

(in-package :package-lobby)

(defconstant +port+ 8008)
(defconstant +ip+ "127.0.0.1")
(defvar *thread-lock* (bt:make-lock))

(defun create-lobby ()
  (let* ((socket (usocket:socket-listen +ip+ +port+))
	 (stdout *standard-output*)
	 (connection (usocket:socket-accept socket :element-type 'character))
	 (stream (usocket:socket-stream connection)))
    (unwind-protect
      (unwind-protect
	(progn
	  (format t "Connected !~%")
	  (usocket:wait-for-input connection)
	  (format stdout (read-line stream))
	  (format stdout "~%"))
	(progn
	  (usocket:socket-close connection)
	  (format stdout "Closing connection with peer~%")))
      (progn
	(usocket:socket-close socket)
	(format t "---Exited gracefully hopefully---~%")))))

(defun join-lobby (&key (ip +ip+) (port +port+))
  (let* ((socket (usocket:socket-connect ip port :element-type 'character))
	 (stream (usocket:socket-stream socket)))
    (unwind-protect
      (progn
	(format t "Connected !~%")
	(format stream (read-line))
	(force-output stream))
      (progn
	(format t "---Connection closed---~%")
	(usocket:socket-close socket))))
)

