(in-package :rephrase)

(defun test ()
  (let ((str (alexandria:read-file-into-string (asdf:system-relative-pathname :rephrase2 "test.dsl"))))
    (scanner str)))

