(In-package :rephrase)

;; spaces to end of line, begin with %
(defconstant +comment-char+ #\%)

(defclass spaces (rephrase)
  ((state :accessor state)
   (chars :accessor chars)
   (line :accessor line)
   (start-position :accessor start-position)))

(defmethod reset ((self spaces))
  (setf (state self) :idle)
  (setf (chars self) nil)
  (setf (line self) 1)
  (setf (start-position self) 1))

(defmethod filter ((self spaces) token-list)
  (flet ((ws? (tok)
	   (and (eq :character (token-kind tok))
		(or (char= #\Space (token-text tok))
		    (char= #\Newline (token-text tok))
		    (char= #\; (token-text tok))
		    (char= #\, (token-text tok)))))
	 (make-comment-token ()
	   (let ((chars (reverse (chars self))))
	     (let ((str (with-output-to-string (s)
			  (@:loop
			    (@:exit-when (null chars))
			    (let ((ch (pop chars)))
			      (write-char ch s))))))
	       (make-token :kind :space
			   :text str
			   :line (line self)
			   :position (start-position self))))))
    (let ((output nil))
      (@:loop
	(@:exit-when (null token-list))
	(let ((tok (pop token-list)))
	  (ecase (state self)
	    (:idle
	     (cond ((eq :EOF (token-kind tok))
		    (push tok output)
		    (assert (null token-list)))
		   ((ws? tok)
		    (push (token-text tok) (chars self))
		    (setf (line self) (token-line tok))
		    (setf (start-position self) (token-position tok))
		    (setf (state self) :ignoring))
		   (t (push tok output)))) ;; skip, forward token downstream
	    (:ignoring
	     (cond ((eq :EOF (token-kind tok))
		    (push (make-comment-token) output)
		    (reset self)
		    (push tok output)
		    (reset self)
		    (assert (null token-list)))
		   ((ws? tok)
		    (push (token-text tok) (chars self)))
		   (t 
		    (push (make-comment-token) output)
		    (reset self)
		    (push tok output)))))))
      (reverse output))))
