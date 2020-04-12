(in-package :rephrase)

(defstruct token
  kind
  text
  position
  line)

(defgeneric exec-with-filename (self filename))
(defgeneric filter (self token-list))

(defclass rephrase () () )
