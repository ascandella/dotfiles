(defun my-php-mode-hook ()
  (shift-width 2)
  (setq tab-width 2))

(add-hook 'php-mode-hook 'my-php-mode-hook)
