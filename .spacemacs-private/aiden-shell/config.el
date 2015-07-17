(defun my-bash-mode-hook ()
  (shift-width 2)
  (setq
   tab-width 2
   sh-basic-offset 2
   sh-indentation 2
   sh-basic-indent-line 2)
  (highlight-indentation-mode)
  (define-key sh-mode-map (kbd "RET") 'reindent-then-newline-and-indent))

(add-hook 'sh-mode-hook 'my-bash-mode-hook)
