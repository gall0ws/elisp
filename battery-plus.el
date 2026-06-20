;; -*- lexical-binding: t -*-
(define-inline battery-plus--info (code)
  "Parse `battery-pmset' for battery information.

CODE can assume one of following values:

\"L\": Power source (verbose)
\"B\": Battery status (verbose)
\"b\": Battery status, empty means high, ‘-’ means low,
   ‘!’ means critical, and ‘+’ means charging
\"p\": Battery load percentage
\"m\": Remaining time (to charge or discharge) in minutes
\"h\": Remaining time (to charge or discharge) in hours
\"t\": Remaining time (to charge or discharge) in the form ‘h:min’"
  (assoc-default (string-to-char code)
                 (battery-pmset)))

(define-inline battery-plus-low-p ()
  "Return t if the battery is low on power.

The concept of `low' is governed by the variable `battery-load-low'."
  (string-match-p "-" (battery-plus--info "b")))

(define-inline battery-plus-charging-p ()
"Return t if the battery is charging."
  (string-match-p "+" (battery-plus--info "b")))

(define-inline battery-plus-ac-plugged-p ()
"Return t if the AC is plugged in."
  (string-match-p "AC" (battery-plus--info "L")))

(defun battery-plus-emoji-string ()
  "Return an emoji string appropriate to the current status of the battery.

The prefix will be one amongst `HIGH VOLTAGE SIGN' or `ELECTRIC PLUG'
depending wheter the battery is charging or (just) the AC is
plugged in. If neither of those cases are true, a SPC is printed instead.

Then the `BATTERY' emoji is added, unless the current voltage status
is deemed `low', in such case the `LOW BATTERY' emoji is chosen."
  (concat
   (when (battery-plus-charging-p)
     (string (char-from-name "HIGH VOLTAGE SIGN")))
   (when (battery-plus-ac-plugged-p)
     (string (char-from-name "ELECTRIC PLUG")))
   (string
    (if (battery-plus-low-p)
	(char-from-name "LOW BATTERY")
      (char-from-name "BATTERY")))))

(provide 'battery-plus)
