(defpackage :package-server-tcp
  (:use :cl 
	:usocket 
	:local-time
	:bt-semaphore)
  (:export #:create-server
	   #:create-server-mlt
	   #:create-client
	   #:create-client-mlt
	   #:client-test
	   #:server-test)
  (:nicknames :tcp))

(in-package :package-server-tcp)


(defun create-server (&key port ip)
  (let* ((socket (usocket:socket-listen ip port))
	 (connection (usocket:socket-accept socket :element-type
                     'character)))
    (unwind-protect
      (progn
	(format t "Connected!~%")
	(format (usocket:socket-stream connection)
          (progn (read-line)))
	(force-output (usocket:socket-stream connection)))
      (progn
	(format t "Closing sockets~%")
	(usocket:socket-close connection)
        (usocket:socket-close socket))
    )
  )
)

(defun create-client (&key port ip)
  (usocket:with-client-socket (socket stream ip port
                                      :element-type 'character)
    (unwind-protect
      (progn
	(format t "Connected!~%")
        (usocket:wait-for-input socket)
        (format t "Input is: ~a~%" (read-line stream))
      )
      (progn
	(format t "Server socket closed~%")
	(usocket:socket-close socket)
      )
    )
  )
)

(defun create-server-mlt (&key port ip)
  (let ((socket (usocket:socket-listen ip port)))
    (unwind-protect
      (loop
	(let ((connection (usocket:socket-accept socket :element-type 'character))
	      (top-level-output *standard-output*))
	  (bt:make-thread (lambda () 
	    (dummy-connection-handler socket connection top-level-output))
	  ) 
	)
      )
      (progn
	(usocket:socket-close socket)
	(format t "Exited gracefully hopefully~%")
      )
    )
  )
)

(defun dummy-connection-handler (socket connection out)
  (unwind-protect
    (progn
      (format out "Connected!~%")
      (format (usocket:socket-stream connection) "test str~%")
      (force-output (usocket:socket-stream connection))
      (usocket:wait-for-input connection)
      (format out (read-line (usocket:socket-stream connection)))
    )
    (progn
      (format out "Closing connection~%")
      (usocket:socket-close connection)
    )
  )
)

(defun create-client-mlt (&key port ip)
  (let* ((socket (usocket:socket-connect ip port :element-type 'character))
	 (stream (usocket:socket-stream socket )))
    (unwind-protect
      (progn
	(format t "Connected!~%")
	(usocket:wait-for-input socket)
	(format t "Input is :~a~%" (read-line stream))
	(format (usocket:socket-stream socket) "test str back~%")
	(force-output (usocket:socket-stream socket))
      )
      (progn
	(format t "Server socket closed~%")
	(usocket:socket-close socket)
      )
    )
  )
)

