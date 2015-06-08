;;; Code:

(defun bump-dotfiles (args)
  "Select inside paragraph."
  (interactive "sCommit message: ")
  (magit-stage-all)
  (magit-diff-staged)
  (magit-commit args)
  (magit-push))

;;; funcs.el ends here
