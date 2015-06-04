(defun close-compile-window ()
  "Close the compilation window."
  (interactive)
    (delete-window (get-buffer-window (get-buffer "*compilation*"))))

(evil-leader/set-key
  "cc" 'close-compile-window)

