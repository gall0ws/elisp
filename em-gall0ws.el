;;; em-gall0ws.el --- gall0ws' extras for eshell  -*- lexical-binding: t -*-

;;;###esh-module-autoload
(progn
(defgroup eshell-gall0ws nil
  "This module defines some extra stuff for eshell."
  :tag "Extra stuff by gall0ws"
  :group 'eshell-module))

(declare-function eshell-interrupt-process "esh-proc.el")

(defvar-keymap eshell-gall0ws-mode-map
  "C-l"   #'eshell-clear-buffer
  "C-c u" #'eshell-kill-line
  "<deletechar>" #'eshell-interrupt-process)

(define-minor-mode eshell-gall0ws-mode
  "Minor mode for the eshell-gall0ws module.

\\{eshell-gall0ws-mode-map}"
  :keymap eshell-gall0ws-mode-map)

(defun eshell-gall0ws-initialize ()  ;Called from `eshell-mode' via intern-soft!
  (unless eshell-non-interactive-p
    (eshell-gall0ws-mode)))

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

(provide 'em-gall0ws)
