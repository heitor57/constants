(defgroup constants nil
  "Tool for constants."
  :group 'tools)

(defcustom constants-precision 100
  "The constants precision."
  :type 'integer
  :group 'constants)

(defcustom constants-game-true-color "Green"
  "In constants-game this is the color if a digit is successful."
  :type 'string
  :group 'constants)

(defcustom constants-game-false-color "Red"
  "In constants-game this is the color if a digit is wrong."
  :type 'string
  :group 'constants)

(defcustom constants-game-buffer-name "constants-game"
  "This is the name of the constants-game buffer."
  :type 'string
  :group 'constants)

(setq constants-game-current-constant nil) 

(setq constants `(
		  (math
		   (pi . ,(calc-eval `("evalv(pi)" calc-internal-prec ,constants-precision)))
		   (euler . ,(calc-eval `("evalv(e)" calc-internal-prec ,constants-precision)))
		   (gamma . ,(calc-eval `("evalv(gamma)" calc-internal-prec ,constants-precision)))
		   (phi . ,(calc-eval `("evalv(phi)" calc-internal-prec ,constants-precision)))
		   )
		  (physics
		   (elementary-charge . 1.602e-19)
		   (gravity . 6.674e-11)
		   (mol . 6.022e+23)
		   )
		  ))
(defun get-constant(category name)
  (assoc name (assoc category constants)))
(defun get-constant-value(category name)
  (cdr (assoc name (assoc category constants))))
(defun add-category (category)
  (add-to-list 'constants '(category))
  )
(defun add-constant(category key value)
  (let ((temp (assoc category constants)))
    (let ((temp-category
	   (append temp (list (cons key value)))))
      (print temp-category)
      (setq constants (cons temp-category (assq-delete-all category constants)))
      )
    )
  )
(defun add-constant-start(category key value)
  (let ((temp (assoc category constants)))
    (let ((temp-category
	   (acons key value temp)))
      (print temp-category)
      (setq constants (cons temp-category (assq-delete-all category constants)))
      )
    )
  )

(defun get-constant-value-no-cat(key)
  "Get constant value without category but it has more cost"
  (let* ((cs (copy-tree constants))
	 (constants (mapcan 'cdr cs)))
    (cdr (assoc key constants))
    )
  )
(defun constants-print(constant)
  (interactive "sName of constant: ")
  (message (get-constant-value-no-cat (intern constant))))
(defun highlight-point (pos color)
  "Highlight character, mainly used to display game true or false response"
  (progn
    (message "%d %s" pos color)
    (put-text-property
     pos (+ pos 1)
     'face `(:foreground ,color))))
(defun constants-game-checker()
  "Check if entry is equal to the constant number"
  (let ((const (get-constant-value-no-cat (intern constants-game-current-constant))))
    (message "%s  == %s" (char-to-string (char-before)) (substring const (- (point) 2) (- (point) 1)))
    (if (equal (char-to-string (char-before)) (substring const (- (point) 2) (- (point) 1)))
	(highlight-point (- (point) 1) constants-game-true-color)   
      (highlight-point (- (point) 1) constants-game-false-color)   
      )
    )
  )

(defun x-open-me ()
  "open a buffer using current line as buffer name"
  (interactive)
  (switch-to-buffer
   (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
  (erase-buffer)
  (setq constants-game-current-constant (buffer-name))
  (add-hook 'post-self-insert-hook 'constants-game-checker nil 'local)
  )

(defvar x-keymap nil "game option keymap")
(setq x-keymap (make-sparse-keymap))
(define-key x-keymap (kbd "RET") 'x-open-me)

(defun constants-game()
  "Test your skills with memorization of constants numbers"
  (interactive)
  (switch-to-buffer-other-window constants-game-buffer-name)
  (erase-buffer)
  
  (let* ((cs (copy-tree constants))
	 (constants-name (mapcar 'car (mapcan 'cdr cs)) ))
    (mapcar
     (lambda (x)
       (let ((s (symbol-name x)))
	 (put-text-property 0 (length s) 'face 'bold s)
	 (put-text-property 0 (length s) 'keymap x-keymap s)
	 (insert (format "%s\n" s))
	 )
       )
     constants-name)
    )
  )
