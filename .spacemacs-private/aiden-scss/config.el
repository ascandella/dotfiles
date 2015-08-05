(defun my-scss-mode-hook ()
  (shift-width 2)
  (setq tab-width 2))

(add-hook 'scss-mode-hook 'my-scss-mode-hook)
