;;; Code:

(defun bump-dotfiles (args)
  "Select inside paragraph."
  (interactive "sCommit message: ")
  (magit-stage-all)
  (magit-diff-staged)
  (magit-commit ars))

;;; funcs.el ends here
