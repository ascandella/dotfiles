(defun my-bash-mode-hook ()
  (shift-width 2)
  (setq tab-width 2))

(add-hook 'sh-mode-hook 'my-bash-mode-hook)
