(in-package :rephrase)

(defclass integers (rephrase)
  ((state :accessor state)
   (chars :accessor chars)
   (line :accessor line)
   (sposition :accessor sposition)))

(defmethod reset ((self integers))
  (setf (state self) :idle)
  (setf (chars self) nil)
  (setf (line self) 0)
  (setf (sposition self) 0))

(defmethod filter ((self integers) token-list)
  (flet ((integer? (tok)
	   (and (eq :character (token-kind tok))
		(or (and (char<= #\0 (token-text tok)) (char>= #\9 (token-text tok))))))
	 (make-integer-token ()
	   (let ((chars (reverse (chars self))))
	     (let ((str (with-output-to-string (s)
			  (@:loop
			    (@:exit-when (null chars))
			    (let ((ch (pop chars)))
			      (write-char ch s))))))
	       (make-token :kind :integer
			   :text str
			   :line (line self)
			   :position (sposition self))))))		   
    (let ((output nil))
      (@:loop
	(@:exit-when (null token-list))
	(let ((tok (pop token-list)))
	  (ecase (state self)
	    (:idle
	     (cond ((eq :EOF (token-kind tok))
		    (push tok output)
		    (assert (null token-list)))
		   ((integer? tok)
		    (setf (line self) (token-line tok))
		    (setf (sposition self) (token-position tok))
		    (push (token-text tok) (chars self))
		    (setf (state self) :collecting))
		   (t (push tok output))))
	    (:collecting
	     (cond ((eq :EOF (token-kind tok))
		    (push (make-integer-token) output)
		    (push tok output)
		    (assert (null token-list)))
		   ((integer? tok)
		    (push (token-text tok) (chars self)))
		   (t
		    (push (make-integer-token) output)
		    (push tok output)
		    (reset self)
		    (setf (state self) :idle))))
	    )))
      (reverse output))))

