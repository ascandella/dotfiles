;; Clojure stuff
(setq
 clojure-indent-style 'always-align
 clojure-align-forms-automatically t
 ;; Metabase style
 cljr-favor-prefix-notation t)

(use-package cider
  :config
  (flycheck-clojure-setup)
  (map!
   (:map cider-mode-map
     :n "C-c C-j" 'evil-goto-definition
     :n "C-c C-w" '+clojure/cider-switch-to-repl-buffer-and-switch-ns)))

(evil-set-initial-state 'cider-repl-mode 'emacs)

(use-package aggressive-indent-mode
  :hook
  (clojure-mode . aggressive-indent-mode))

(use-package clojure-mode)
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'subword-mode)

;; https://github.com/metabase/metabase/wiki/Metabase-Clojure-Style-Guide#keep-lines-to-120-chars
(add-hook
 'clojure-mode-hook
 (lambda ()
   (setq-local fill-column 118)
   (setq-local clojure-docstring-fill-column 118)))

;; https://github.com/hlissner/doom-emacs/issues/1335#issuecomment-619022468
(after! cider
  (add-hook 'company-completion-started-hook 'custom/set-company-maps)
  (add-hook 'company-completion-finished-hook 'custom/unset-company-maps)
  (add-hook 'company-completion-cancelled-hook 'custom/unset-company-maps))

(defun custom/unset-company-maps (&rest unused)
  "Set default mappings (outside of company).
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" nil
    "<up>"   nil
    "RET"    nil
    [return] nil
    "C-n"    nil
    "C-p"    nil
    "C-j"    nil
    "C-k"    nil
    "C-h"    nil
    "C-u"    nil
    "C-d"    nil
    "C-s"    nil
    "C-S-s"   (cond ((featurep! :completion helm) nil)
                    ((featurep! :completion ivy)  nil))
    "C-SPC"   nil
    "TAB"     nil
    [tab]     nil
    [backtab] nil))

(defun custom/set-company-maps (&rest unused)
  "Set maps for when you're inside company completion.
    Arguments (UNUSED) are ignored."
  (general-def
    :states 'insert
    :keymaps 'override
    "<down>" #'company-select-next
    "<up>" #'company-select-previous
    "RET" #'company-complete
    [return] #'company-complete
    "C-w"     nil  ; don't interfere with `evil-delete-backward-word'
    "C-n"     #'company-select-next
    "C-p"     #'company-select-previous
    "C-j"     #'company-select-next
    "C-k"     #'company-select-previous
    "C-h"     #'company-show-doc-buffer
    "C-u"     #'company-previous-page
    "C-d"     #'company-next-page
    "C-s"     #'company-filter-candidates
    "C-S-s"   (cond ((featurep! :completion helm) #'helm-company)
                    ((featurep! :completion ivy)  #'counsel-company))
    "C-SPC"   #'company-complete-common
    "TAB"     #'company-complete-common-or-cycle
    [tab]     #'company-complete-common-or-cycle
    [backtab] #'company-select-previous    ))
