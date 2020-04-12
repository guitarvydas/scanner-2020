(in-package :scanner)

(defun test ()
  (let ((str (alexandria:read-file-into-string (asdf:system-relative-pathname :scanner "test.dsl"))))
    (scanner str)))

