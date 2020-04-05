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
(if (and (display-graphic-p) (equal (system-name) "aix1"))
  (setq doom-font (font-spec :family "monospace" :size 20))
  (setq doom-font (font-spec :family "monospace" :size 14)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

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
 display-line-numbers-type nil)

(setq
 rg-command-line-flags '("--hidden"))

(map!
 ;; Swap semicolon and colon
 :n ";" 'evil-ex

 ;; Dvorak
 :n "n" 'evil-previous-line
 :n "t" 'evil-next-line
 :n "s" 'evil-forward-char
 :n "h" 'evil-backward-char

 :n "l" 'evil-ex-search-next
 :n "L" 'evil-ex-search-previous
 ;; Things I'm used to
 :leader "h" 'helm-recentf
 :leader "w" 'save-buffer
 :leader "a" 'helm-rg
 :leader "g c" 'magit-status
 :leader "k" 'helm-show-kill-ring
 :leader "b d" 'kill-current-buffer

 :leader "," '+helm/projectile-find-file
 :leader "." '+helm/workspace-mini

 ;; NERD commenter
 :leader "-" 'comment-line

 ;; Vim muscle memory
 :leader "r n" 'doom/toggle-line-numbers)

;; How to remap: f1-k to show keybinding

;; Disable snipe mode: https://github.com/hlissner/doom-emacs/issues/1642#issuecomment-518711170
(after! evil-snipe
  (evil-snipe-mode -1))

;; Center helm window in floating buffer
(use-package helm-posframe
  :config
  (when (display-graphic-p)
    (helm-posframe-enable)))

(setq helm-posframe-poshandler
  #'posframe-poshandler-window-center)

(setq yas-snippet-dirs
      '("~/.doom.d/snippets"))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

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
