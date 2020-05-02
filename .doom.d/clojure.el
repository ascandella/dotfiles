;; Clojure stuff
(setq
 clojure-indent-style 'always-align ;; the default
 clojure-align-forms-automatically t
 ;; Metabase style
 cljr-favor-prefix-notation t)

(use-package cider
  :config
  (flycheck-clojure-setup)
  (map!
   (:map cider-mode-map
     :n "C-c C-w" '+clojure/cider-switch-to-repl-buffer-and-switch-ns)))

(evil-set-initial-state 'cider-repl-mode 'emacs)

;; https://github.com/metabase/metabase/wiki/Metabase-Clojure-Style-Guide#keep-lines-to-120-chars
(add-hook
 'clojure-mode-hook
 (lambda ()
   (setq-local fill-column 118)
   (setq-local clojure-docstring-fill-column 118)))

;; https://github.com/DogLooksGood/parinfer-mode
(use-package parinfer
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            pretty-parens  ; different paren styles for different modes.
            evil           ; If you use Evil.
            paredit        ; Introduce some paredit commands.
            smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
            smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))
