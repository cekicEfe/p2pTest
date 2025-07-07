(load (sb-ext:posix-getenv "ASDF"))

(asdf:load-system 'alexandria)
(asdf:load-system 'local-time)
(asdf:load-system 'usocket)
(asdf:load-system 'ironclad)
(asdf:load-system 'cl-gtk4)
(asdf:load-system 'bt-semaphore)

(load "./server/server-tcp.lisp")

(defconstant +port+ 8008)
(defconstant +ip+ "127.0.0.1")

(defun main ( state )
  (case state
    (:server (tcp:create-server-mlt :port +port+ :ip +ip+))
    (:client (tcp:create-client-mlt :port +port+ :ip +ip+))
    (t (format t "That is sadly not an option exiting ~%"))
  ) 
)


