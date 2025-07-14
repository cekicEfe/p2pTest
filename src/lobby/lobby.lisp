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
;;(defvar *thread-lock* (bt:make-lock))

(defun create-lobby ()
  (let* ((socket (usocket:socket-listen +ip+ +port+))
	 (stdout *standard-output*))
    (unwind-protect
      (loop
	(let* ((connection (usocket:socket-accept socket :element-type 'character))
	      (stream (usocket:socket-stream connection)))
	  (bt:make-thread 
	    (lambda()
	      (format stdout "Connected with a peer!~%")
	      (finish-output)
	      (unwind-protect
		(progn
		  (loop
		    (usocket:wait-for-input connection)
		    (format stdout "Recieved message : ~a ~%" (read-line stream))
		    (finish-output stdout)))
		(progn
		  (usocket:socket-close connection)
		  (format stdout "Closing connection with peer.~%")))))))
      (progn
	(usocket:socket-close socket)
	(format t "---Exited gracefully---~%")))))

(defun join-lobby (&key (ip +ip+) (port +port+))
  (let* ((socket (usocket:socket-connect ip port :element-type 'character))
	 (stream (usocket:socket-stream socket)))
    (format t "Connected !~%")
    (finish-output)
    (unwind-protect
      (progn
	(loop
	  (format t "Give input : ")
	  (finish-output)
	  (format stream (read-line))
	  (terpri stream)
	  (force-output stream)
	  (format t "~% Message sent ~%")
	  (finish-output)))
      (progn
	(format t "---Connection closed---~%")
	(usocket:socket-close socket)))))

