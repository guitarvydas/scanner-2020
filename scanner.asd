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
                                     (:file "decls" :depends-on ("package"))
                                     (:file "tokenizer" :depends-on ("decls"))
                                     (:file "comments" :depends-on ("decls"))
                                     (:file "spaces" :depends-on ("decls"))
                                     (:file "strings" :depends-on ("decls"))
                                     (:file "symbols" :depends-on ("decls"))
                                     (:file "integers" :depends-on ("decls"))
				     
				     (:file "scanner" :depends-on ("package" "decls"
								   "tokenizer"
								   "spaces"
								   "strings"
								   "symbols"
								   "integers"
								))
				     (:file "test" :depends-on ("scanner"))))))

