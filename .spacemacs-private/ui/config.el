(require 'ansi-color)
(setq-default fill-column 80)

(set-face-attribute 'vertical-border
                    nil
                    :foreground "#282a2e")

(if window-system
  (progn
    (setq-default dotspacemacs-default-font '(:size 14))))

; enable colorization in compilation windo
(require 'ansi-color)

(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(defadvice display-message-or-buffer (before ansi-color activate)
  "Process ANSI color codes in shell output."
  (let ((buf (ad-get-arg 0)))
    (and (bufferp buf)
         (string= (buffer-name buf) "*Shell Command Output*")
         (with-current-buffer buf
           (ansi-color-apply-on-region (point-min) (point-max))))))

;;; config.el ends here
