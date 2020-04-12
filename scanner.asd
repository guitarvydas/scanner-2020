(defsystem :rephrase2
  :depends-on (:loops :alexandria)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "rephrase" :depends-on ("package"))
                                     (:file "tokenizer" :depends-on ("rephrase"))
                                     (:file "comments" :depends-on ("rephrase"))
                                     (:file "spaces" :depends-on ("rephrase"))
                                     (:file "strings" :depends-on ("rephrase"))
                                     (:file "symbols" :depends-on ("rephrase"))
                                     (:file "integers" :depends-on ("rephrase"))
				     
				     (:file "scanner" :depends-on ("rephrase" 
								   "tokenizer"
								   "spaces"
								   "strings"
								   "symbols"
								   "integers"
								))
				     (:file "test" :depends-on ("scanner"))))))

