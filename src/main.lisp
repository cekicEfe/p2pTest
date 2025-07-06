(load (sb-ext:posix-getenv "ASDF"))

(asdf:load-system 'alexandria)
(asdf:load-system 'local-time)
(asdf:load-system 'usocket)
(asdf:load-system 'ironclad)
(asdf:load-system 'cl-tk)
(asdf:load-system 'bt-semaphore)

(load "./server/test-tcp.lisp")

(defconstant +port+ 8008)
(defconstant +ip+ "192.168.1.111")

(defun main (&key (server nil) )
  (when server 
    ()
  )
  (when (= server t)
    () 
  )
)
