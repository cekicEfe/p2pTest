(defpackage :package-server-tcp
  (:use :cl 
	:usocket 
	:local-time
	:bt-semaphore)
  (:export #:create-server-dummy
	   #:create-client-dummy)
  (:nicknames :tcp))

(in-package :package-server-tcp)

(defun dummy-connection-handler (connection stream out)
  (unwind-protect
    (progn
      (format out "Connected!~%")
      (format stream "test str~%")
      (force-output stream)
      (usocket:wait-for-input connection)
      (format out (read-line stream)))
    (progn
      (format out "Closing connection~%")
      (usocket:socket-close connection))))

(defun create-server-dummy (&key ip port)
  (let ((socket (usocket:socket-listen ip port)))
    (unwind-protect
      (loop
	(let* ((connection (usocket:socket-accept socket :element-type 'character))
	       (stream (usocket:socket-stream connection))
	       (top-level-output *standard-output*))
	  (bt:make-thread 
	    (lambda () 
	      (dummy-connection-handler 
		connection 
		stream 
		top-level-output)))))
      (progn
	(usocket:socket-close socket)
	(format t "Exited gracefully hopefully~%")))))

(defun create-client-dummy (&key ip port)
  (let* ((socket (usocket:socket-connect ip port :element-type 'character))
	 (stream (usocket:socket-stream socket)))
    (unwind-protect
      (progn
	(format t "Connected!~%")
	(usocket:wait-for-input socket)
	(format t "Input is :~a~%" (read-line stream))
	(format stream "stream test~%")
	(force-output stream))
      (progn
	(format t "Server socket closed~%")
	(usocket:socket-close socket)))))

