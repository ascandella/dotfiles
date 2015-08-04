(defun select-paragraph ()
  "Select inside paragraph."
  (interactive)
  (backward-paragraph)
  (evil-next-line)
  (evil-visual-line)
  (forward-paragraph)
  (evil-previous-line))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

(defun vi-line-above ()
  "Insert a line above."
  (interactive)
  (save-excursion
    (evil-open-above 1)
    (evil-force-normal-state)))

(defun vi-line-below ()
  "Insert a line below."
  (interactive)
  (save-excursion
    (evil-open-below 1)
    (evil-force-normal-state)))

(defun trailing-comma ()
  "Add a trailing comma!"
  (interactive)
  (save-excursion
    (evil-append-line 1)
    (insert ",")
    (evil-force-normal-state)))

(defun go-to-reviewers()
  (interactive)
  "Go to reviewers section of `arc diff`"
  (search-forward "Reviewers:")
  (evil-append-line 1))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun tell-emacsclients-for-buffer-to-die ()
  "Sends error exit command to every client for the current buffer."
  (interactive)
  (dolist (proc server-buffer-clients)
    (server-send-string proc "-error die")))

(defun shift-width (width)
  (interactive "n")
  (set-variable 'evil-shift-width width)
  (message "set shift width to %d" width))

;;; funcs.el ends here
