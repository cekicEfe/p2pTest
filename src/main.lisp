(load (sb-ext:posix-getenv "ASDF"))
(asdf:load-system 'alexandria)
(asdf:load-system 'local-time)
(asdf:load-system 'usocket)

(defconstant +port+ 8008)
;;(do-external-symbols (s (find-package "USOCKET"))
;;  (print s))

(defparameter *server-out* nil)

;;for tcp
(defun create-server (&key port ip)
  (format t "Waiting for connection~%")
  (let* ((socket (usocket:socket-listen ip port))
	 (connection (usocket:socket-accept socket :element-type
                     'character)))
    (unwind-protect
      (progn
	(format t "Connected!~%")
	(setq *server-out* (read-line))
	(format (usocket:socket-stream connection)
          *server-out*)
	(force-output (usocket:socket-stream connection)))
      (progn
	(format t "Closing sockets~%")
	(usocket:socket-close connection)
        (usocket:socket-close socket)))))

(defun create-client (&key port ip)
  (usocket:with-client-socket (socket stream ip port
                                      :element-type 'character)
    (unwind-protect
      (progn
	(format t "Connected!~%")
        (usocket:wait-for-input socket)
        (format t "Input is: ~a~%" (read-line stream)))
      (usocket:socket-close socket))))


;;for udp
(defparameter *test-buffer* (make-array 8 :element-type '(unsigned-byte 8)))

(defun create-server-bindless (&key port ip (buffer *test-buffer*))
  (let* ((socket (usocket:socket-connect nil nil
					:protocol :datagram
					:element-type '(unsigned-byte 8)
					:local-host ip
					:local-port port)))
    (unwind-protect
      (multiple-value-bind (buffer size client receive-port)
	(usocket:socket-receive socket buffer 8)
	(format t "~A~%" buffer)
	  (usocket:socket-send socket (reverse buffer) size
				:port receive-port
				:host client))
      (usocket:socket-close socket))))

(defun create-client-bindless (&key port ip (buffer *test-buffer*))
  (let ((socket (usocket:socket-connect ip port
					 :protocol :datagram
					 :element-type '(unsigned-byte 8))))
    (unwind-protect
      (progn
	(format t "Sending data~%")
	(replace buffer #(1 2 3 4 5 6 7 8))
	(format t "Receiving data~%")
	(usocket:socket-send socket buffer 8)
	(usocket:socket-receive socket buffer 8)
	(format t "~A~%" buffer))
      (usocket:socket-close socket))))


