;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Aiden Scandella"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq
 doom-font
 (cond ((and (display-graphic-p) (equal (system-name) "aix1"))
        (font-spec :family "Ubuntu Mono Nerd Font" :size 22))

       ((equal (system-name) "ai10")
        (font-spec :family "Consolas" :size 16))

       (t
        (font-spec :family "monospace" :size 14))))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; from https://dotdoom.netlify.com/config.html
(after! helm
  ;; I want backspace to go up a level, like ivy
  (add-hook! 'helm-find-files-after-init-hook
    (map! :map helm-find-files-map
         "<DEL>" #'helm-find-files-up-one-level)))

(setq
 doom-leader-key ","
 ;; Disable line numbers by default
 display-line-numbers-type nil

 aw-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n))

(setq
 rg-command-line-flags '("--hidden"))

(defun helm-projectile-rg-word ()
  (interactive)
  (helm-rg (thing-at-point 'symbol) nil (list (projectile-project-root))))

(map!
 ;; Swap semicolon and colon
 :n ";" 'evil-ex

 ;; Dvorak
 :n "n" 'evil-previous-line
 :n "t" 'evil-next-line
 :n "s" 'evil-forward-char
 :n "h" 'evil-backward-char

 :n "C-w <right>" 'evil-window-right
 :n "C-w <left>" 'evil-window-left
 :n "C-w <up>" 'evil-window-up
 :n "C-w <down>" 'evil-window-down
 :n "-" 'helm-find-files
 :n "C-w o" 'doom/window-maximize-buffer

 :n "l" 'evil-ex-search-next
 :n "L" 'evil-ex-search-previous
 :leader "g n" 'git-gutter:next-hunk
 :leader "g p" 'git-gutter:previous-hunk
 :leader "g b" 'magit-blame-echo

 ;; Things I'm used to
 :leader "h" 'helm-recentf
 :leader "w" 'save-buffer
 :leader "a" 'helm-projectile-rg-word
 :leader "g c" 'magit-status
 :leader "k" 'helm-show-kill-ring
 :leader "b d" 'kill-current-buffer

 :leader "," '+helm/projectile-find-file
 :leader "." '+helm/workspace-mini

 :leader "TAB ," '+workspace/other

 ;; NERD commenter
 :leader "-" 'comment-line

 ;; Vim muscle memory
 :leader "r n" 'doom/toggle-line-numbers)

(global-set-key (kbd "C-h r c") (λ! (load-file "~/.doom.d/config.el")))

(setq git-gutter:ask-p nil)
(setq magit-blame-echo-style 'margin)
(setq projectile-switch-project-action '+helm/projectile-find-file)

;; How to remap: f1-k to show keybinding

;; Disable snipe mode: https://github.com/hlissner/doom-emacs/issues/1642#issuecomment-518711170
(after! evil-snipe
  (evil-snipe-mode -1))

(setq yas-snippet-dirs
      '("~/.doom.d/snippets"))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq
   flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(use-package web-mode
  :config
  (setq web-mode-enable-auto-quoting nil
        web-mode-enable-auto-indentation nil))

(use-package tide
  :init
  (require 'web-mode)

  ;; TSX config
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))

  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode)

  (map!
   (:map tide-mode-map
     :n "C-c C-j" #'tide-jump-to-definition))

  ;; JSX config
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "jsx" (file-name-extension buffer-file-name))
                (setup-tide-mode))))

  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append))

(add-hook 'typescript-mode-hook
          (setq tab-width 2))

(use-package prettier-js
 :config
 (add-hook 'web-mode-hook
  'prettier-js-mode))

;; Python stuff
(use-package anaconda-mode
  :config
  (add-hook 'python-mode-hook 'anaconda-mode)
  (map!
   (:map anaconda-mode-map
     :n "C-c C-j" 'anaconda-mode-find-definitions)))

(setq confirm-kill-processes nil)

(use-package helm
  :config
  (setq helm-completion-style 'emacs)
  (setq helm-recentf-fuzzy-match t)
  (setq completion-styles '(helm-flex)))

(use-package helm-projectile
  :init
  (setq helm-projectile-fuzzy-match t))

;; Enable format-on-save for terraform
(add-hook
 'terraform-mode-hook
 #'terraform-format-on-save-mode)

(add-to-list 'auto-mode-alist '("\\.hcl\\'" . terraform-mode))

;; shell
(setq
  sh-basic-offset 2
  sh-indentation 2)

(add-to-list 'auto-mode-alist'("\\.dotfiles/shell/" . sh-mode))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package lsp-mode
  :config
  (add-hook 'before-save-hook #'lsp-format-buffer)
  (add-hook 'before-save-hook #'lsp-organize-imports)
  (map!
   (:map lsp-mode-map
     :n "C-c C-j" 'lsp-find-definition)))

(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(add-hook 'go-mode-hook 'lsp-deferred)

(setq-default left-margin-width 1
              right-margin-width 1)

(eval-after-load 'evil-ex
  '(evil-ex-define-cmd "W" 'save-buffer))

(load! "completion")
(load! "org-config")
(load! "clojure")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
