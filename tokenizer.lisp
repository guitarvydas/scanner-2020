(in-package :rephrase)

(defclass tokenizer (rephrase)
  ((nline :accessor nline)
   (nposition :accessor nposition)
   (state :accessor state)
   (str-stream :accessor str-stream)))


(defmethod reset ((self tokenizer))
  (setf (state self) :idle)
  (setf (nline self) 1)
  (setf (nposition self) 1))

(defmethod exec-with-string ((self tokenizer) str)
  (setf (str-stream self) (make-string-input-stream str))
  (setf (nposition self) 1)
  (setf (nline self) 1)
  (setf (state self) :running)
  
  (let ((token-list nil)
	(c #\a))
    (@:loop
      (setf c (read-char (str-stream self) nil #\Nul))
      (@:exit-when (char= #\NUL c))
      (let ((tok (make-token :position (nposition self)
			     :line (nline self)
			     :kind :character
			     :text c)))
	(setf token-list (cons tok token-list)))
      (incf (nposition self))
      (when (char= #\Newline c)
	(incf (nline self))
	(setf (nposition self) 1)))
    (let ((eof-token (make-token :position (nposition self)
				 :line (nline self)
				 :kind :eof
				 :text #\Nul)))
      (setf token-list (cons eof-token token-list))
      (setf token-list (reverse token-list))
      token-list)))
