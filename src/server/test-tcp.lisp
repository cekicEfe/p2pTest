(defpackage :package-server-test-tcp
  (:use :cl :usocket :local-time)
  (:export #:create-server
	   #:create-client)
  (:nicknames :test-tcp))

(in-package :package-server-test-tcp)

(defparameter *test-buffer* (make-array 8 :element-type '(unsigned-byte 8)))

(defun create-server (&key port ip buffer)
  (let* ((socket (usocket:socket-connect port ip :element-type '(unsigned-byte 8))))
    (unwind-protect
      (multiple-value-bind (buffer size client receive-port)
	(usocket:socket-receive socket buffer 8)
	(format t "~A~%" buffer)
	(usocket:socket-send socket (reverse buffer) size
				:port receive-port
				:host client))
      (usocket:socket-close socket)
    )
  )
)

(defun create-client (&key port ip buffer)
  (let ((socket (usocket:socket-connect ip port
					 :element-type '(unsigned-byte 8))))
    (unwind-protect
      (progn
	(format t "Sending data~%")
	(replace buffer #(1 2 3 4 5 6 7 8))
	(usocket:socket-send socket buffer 8)
	
	(format t "Receiving data~%")
	(usocket:socket-receive socket buffer 8)
	(format t "Got message :~%")
	(format t "~A~%" buffer)
      )
      (format t "Closing connection")
      (usocket:socket-close socket)
    )
  )
)

