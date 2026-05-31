;; -*- lexical-binding: t -*-

(declare-function eshell-send-input "esh-mode.el")

(defun eshell-clear-buffer ()
  "Clear eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (move-beginning-of-line nil)
    (let ((str (buffer-substring (point) (point-max))))
      (erase-buffer)
      (eshell-send-input)
      (insert str))))

(defun eshell-kill-line ()
  "Delete current eshell line and put it in the kill ring."
  (interactive)
  (let ((inhibit-read-only t))
    (move-beginning-of-line nil)
    (kill-line)))
