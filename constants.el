(setq constants-precision 100)
(setq constants-game-true-color "Green")
(setq constants-game-false-color "Red")

(setq constants-game-buffer-name "constants-game")
(setq constants `(
		  (math
		   (pi . ,(calc-eval `("evalv(pi)" calc-internal-prec ,constants-precision)))
		   (euler . ,(calc-eval `("evalv(e)" calc-internal-prec ,constants-precision)))
		   )
		  (physics
		   (elementary-charge . 1.602e-19)
		   (gravity . 6.674e-11)
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
(defun constant-print(constant)
  (interactive "sName of constant: ")
  (message "Not implemented"))
(defun highlight-point (pos color)
  "Highlight character, mainly used to display game true or false response"
  (progn
    (message "%d %s" pos color)
    (put-text-property
     pos (+ pos 1)
     'face `(:foreground ,color))))
(defun constants-game-checker()
  "Check if entry is equal to the constant number"
  (let ((euler (get-constant-value 'math 'euler)))
    (message "%s  == %s" (char-to-string (char-before)) (substring euler (- (point) 2) (- (point) 1)))
    (if (equal (char-to-string (char-before)) (substring euler (- (point) 2) (- (point) 1)))
	(highlight-point (- (point) 1) constants-game-true-color)   
      (highlight-point (- (point) 1) constants-game-false-color)   
      )
    )
  )
(defun constants-game()
  "Test your skills with memorization of constants numbers"
  (interactive)
  (generate-new-buffer constants-game-buffer-name)
  (display-buffer constants-game-buffer-name)
  (with-current-buffer constants-game-buffer-name
    (add-hook 'post-self-insert-hook 'constants-game-checker nil 'local))

  )




