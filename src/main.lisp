(load (sb-ext:posix-getenv "ASDF"))

(asdf:load-system 'alexandria)
(asdf:load-system 'local-time)
(asdf:load-system 'usocket)
(asdf:load-system 'ironclad)
(asdf:load-system 'cl-gtk4)
(asdf:load-system 'bt-semaphore)

(load "./server/server-tcp.lisp")
(load "./lobby/lobby.lisp")

