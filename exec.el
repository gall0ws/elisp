;; -*- lexical-binding: t -*-
;;
;; TODO: it would be better when `discard-stderr' is nil to redirect
;; STDERR to its own separate buffer (something like
;; *COMMAND-STDERR*).
;; This cannot accomplished using `call-process': we should switch to
;; the more sophisticated `make-process' instead.

(defun exec< (command &optional discard-stderr)
  "Execute COMMAND redirecting its output before point.

The command COMMAND is executed using the shell set in the environment
variable `SHELL', its output (both stdout and stderr) is redirected in
the current buffer before point, unless DISCARD-STDERR is non-nil: in
such case standard error is simply discarded.

DISCARD-STDERR can be set using `universal-argument' \\[universal-argument]."
  (interactive
      (list
       (read-shell-command "Command: ")
       current-prefix-arg))
  (call-process (getenv "SHELL")
		nil `(t ,(not discard-stderr)) t "-c" command))

(defun exec> (command &optional start end discard-stderr)
  "Execute COMMAND providing its standard input.

The command COMMAND is executed using the shell set in the environment
variable `SHELL', its input is provided from the area in the current
buffer delimited by START and END. When called in interactive mode,
the area will correspond to the active region or, if there is no
active region, the whole buffer.

COMMAND output (both stdout and stderr) is redirected in a separate
buffer, unless DISCARD-STDERR is non-nil: in such case standard error
is simply discarded.

DISCARD-STDERR can be set using `universal-argument' \\[universal-argument]."
  (interactive
      (list
       (read-shell-command "Command: ")
       (when (use-region-p) (region-beginning))
       (when (use-region-p) (region-end))
       current-prefix-arg))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq end (point-max)))
  (let ((bufname (generate-new-buffer-name (format "*%s-OUTPUT*" (car (string-split command)))))
	(temp-buffer-show-hook (lambda ()
				 (read-only-mode)
				 (text-mode))))
    (with-output-to-temp-buffer bufname
      (call-process-region
       start end
       (getenv "SHELL") nil (list bufname (not discard-stderr)) t
       "-c" command))))

(defun exec| (command &optional start end discard-stderr)
  "Execute COMMAND providing stdin and replacing the area selected with its output.

The command COMMAND is executed using the shell set in the environment
variable `SHELL', its input is provided from the area in the current
buffer delimited by START and END. When called in interactive mode,
the area will correspond to the active region or, if there is no
active region, the whole buffer.

COMMAND output (both stdout and stderr) will replace the area between
START and END in the current buffer, unless DISCARD-STDERR is non-nil:
in such case standard error is simply discarded.

DISCARD-STDERR can be set using `universal-argument' \\[universal-argument]."
  (interactive
      (list
       (read-shell-command "Command: ")
       (when (use-region-p) (region-beginning))
       (when (use-region-p) (region-end))
       current-prefix-arg))
  (unless (numberp start) (setq start (point-min)))
  (unless (numberp end) (setq start (point-max)))
  (save-excursion
    (call-process-region
     start end
     (getenv "SHELL") t `(t ,(not discard-stderr)) t
     "-c" command)))

(defun exec! (command &optional discard-stderr)
  "Execute COMMAND and print its output in a separate buffer.

The command COMMAND is executed using the shell set in the environment
variable `SHELL'.

COMMAND output (both stdout and stderr) is redirected in a separate
buffer, unless DISCARD-STDERR is non-nil: in such case standard error
is simply discarded.

DISCARD-STDERR can be set using `universal-argument' \\[universal-argument]."
  (interactive
      (list
       (read-shell-command "Command: ")
       current-prefix-arg))
  (let ((bufname (generate-new-buffer-name (format "*%s-OUTPUT*" (car (string-split command)))))
        (temp-buffer-show-hook (lambda ()
				 (read-only-mode)
				 (text-mode))))
    (with-output-to-temp-buffer bufname
      (call-process (getenv "SHELL") nil (list bufname (not discard-stderr)) t
		    "-c" command))))

(provide 'exec)
