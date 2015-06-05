;;; Code

(define-key global-map (kbd "RET") 'newline-and-indent)
;; (electric-indent-mode +1)

(define-key evil-normal-state-map "s" 'evil-forward-char)
(define-key evil-normal-state-map "k" 'kill-word)
(define-key evil-normal-state-map "j" 'evil-delete-backward-word)

(define-key evil-motion-state-map "l" 'evil-search-next)
(define-key evil-motion-state-map "n" 'evil-previous-line)
(define-key evil-motion-state-map "t" 'evil-next-line)
(define-key evil-motion-state-map "h" 'evil-backward-char)
(define-key evil-motion-state-map "s" 'evil-forward-char)

(define-key evil-normal-state-map (kbd "DEL") 'delete-window)

;; leader
;; (global-evil-leader-mode)

;; (evil-leader/set-leader ",")

(evil-leader/set-key
  "w" 'evil-write
  "," 'projectile-find-file
  "n" 'helm-mini
  "g" 'helm-M-x
  "y" 'helm-show-kill-ring
  "a" 'projectile-ag
  "p" 'toggle-pbcopy
  "cd" 'cd
  "r" 'select-paragraph)

;; evil nerd commenter hotkeys
;; (evilnc-default-hotkeys)

(evil-leader/set-key "-" 'evilnc-comment-or-uncomment-lines)

;; better m-x
(global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "C-b") 'hippie-expand)
;; disable evil-states toggle
(define-key evil-motion-state-map (kbd "C-z") nil)
(define-key evil-insert-state-map (kbd "C-z") nil)

;; git rebase mode is dumb
(setq auto-mode-alist (delete '("git-rebase-todo" . rebase-mode)
                              auto-mode-alist))

(add-to-list 'auto-mode-alist '("git-rebase-todo" . git-commit-mode))

(setq-default auto-fill-function 'do-auto-fill)

(evil-leader/set-key
  "." 'vi-line-above
  "u" 'vi-line-below
  "d" 'trailing-comma
  "ss" 'sort-lines)

(define-key evil-motion-state-map "gr" 'go-to-reviewers)

(global-set-key (kbd "C-c v") 'pbpaste)

(evil-leader/set-key
  "cq" 'tell-emacsclients-for-buffer-to-die
  ;; "m" 'magit-status
  "b" 'magit-blame-mode
  "h" 'magit-blame-locate-commit)

(evil-leader/set-key
  "2" (lambda () (interactive) (shift-width 2))
  "4" (lambda () (interactive) (shift-width 4)))
