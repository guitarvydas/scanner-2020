(in-package :rephrase)

;; strings - ignore escapes for now

(defclass strings (rephrase)
  ((state :accessor state)
   (chars :accessor chars)
   (line :accessor line)
   (sposition :accessor sposition)))

(defmethod reset ((self strings))
  (setf (state self) :idle)
  (setf (chars self) nil)
  (setf (line self) 0)
  (setf (sposition self) 0))

(defmethod filter ((self strings) token-list)
  (flet ((string-start? (tok)
	   (and (eq :character (token-kind tok))
		(char= #\" (token-text tok))))
	 (string-end? (tok)
	   (and (eq :character (token-kind tok))
		(char= #\" (token-text tok))))
	 (make-string-token ()
	   (let ((chars (reverse (chars self))))
	     (let ((str (with-output-to-string (s)
			  (@:loop
			    (@:exit-when (null chars))
			    (let ((ch (pop chars)))
			      (write-char ch s))))))
	       (let ((result (make-token :kind :string
					 :text str
					 :line (line self)
					 :position (sposition self))))
		 result)))))
    (let ((output nil))
      (@:loop
	(@:exit-when (null token-list))
	(let ((tok (pop token-list)))
	  (ecase (state self)
	    (:idle
	     (cond ((eq :EOF (token-kind tok))
		    (push tok output)
		    (assert (null token-list)))
		   ((string-start? tok)
		    (setf (line self) (token-line tok))
		    (setf (sposition self) (token-position tok))
		    (setf (state self) :collecting))
		   (t (push tok output))))
	    (:collecting
	     (cond ((eq :EOF (token-kind tok))
		    (push (make-string-token) output)
		    (push tok output)
		    (assert (null token-list)))
		   ((string-end? tok)
		    (push (make-string-token) output)
		    (reset self)
		    (setf (state self) :idle))
		   (t
		    (push (token-text tok) (chars self)))))
	    )))
      (reverse output))))

