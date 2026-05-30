;; -*- lexical-binding: t -*-

;; just because.
(fset 'λ 'lambda)

(define-inline add-hook-local (hook function &optional depth)
  "Local version of `add-hook'."
  (inline-quote (add-hook ,hook ,function ,depth t)))

(defun infer-indentation-style ()
  "Set current buffer's indent-tabs-mode guessing the style in use."
  (interactive)
  (setq-local indent-tabs-mode (>= (how-many "^\t" (point-min) (point-max))
				   (how-many "^  " (point-min) (point-max)))))

(defun chomp (&optional start end)
  "Remove trailing whitespaces."
  (interactive
      (when (use-region-p) (list (region-beginning) (region-end))))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq end (point-max)))
  (save-excursion
      (goto-char start)
      (while (re-search-forward "[ \t]+$" end t)
	(replace-match ""))))

(defun fixup-smart-quotes (&optional start end)
  "Replace “smart” quotes with dumb ones."
  (interactive
      (when (use-region-p) (list (region-beginning) (region-end))))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq end (point-max)))
  (save-excursion
    (mapc (λ (cons)
	    (goto-char start)
	    (while (re-search-forward (car cons) end t)
	      (replace-match (cdr cons))))
	  '(("[“”]" . "\"")
	    ("[‘’]" . "'")))))

(defun reread-buffer ()
  "Reload the current buffer."
  (interactive)
  (find-file buffer-file-name))

(defun find-file-sudo (filename)
  "Edit file FILENAME using sudo(1)."
  (interactive "FFind file: ")
  (find-file (concat "/sudo::" filename)))

(defun find-file-ssh (machine filename)
  "Edit file FILENAME on remote host MACHINE using ssh(1)."
  (interactive "MMachine: \nFFile: ")
  (find-file (concat "/ssh:" machine ":" filename)))

(defun eshell-clear-buffer ()
  "Clear eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

(defun show-region-or-point ()
  "Display current active region in the echo area.
If there is no region active, display the point."
  (interactive)
  (message
    (if (use-region-p)
       (format "(%d %d)" (region-beginning) (region-end))
     (format "%d" (point)))))
