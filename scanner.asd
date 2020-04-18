(defsystem :scanner
  :depends-on (:loops :alexandria)
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")))))

(defsystem :scanner/use
  :depends-on (:scanner)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "decls")
                                     (:file "tokenizer" :depends-on ("decls"))
                                     (:file "comments" :depends-on ("decls"))
                                     (:file "spaces" :depends-on ("decls"))
                                     (:file "strings" :depends-on ("decls"))
                                     (:file "symbols" :depends-on ("decls"))
                                     (:file "integers" :depends-on ("decls"))
				     
				     (:file "scanner" :depends-on ("decls"
								   "tokenizer"
								   "spaces"
								   "strings"
								   "symbols"
								   "integers"
								))
				     (:file "test" :depends-on ("scanner"))))))
