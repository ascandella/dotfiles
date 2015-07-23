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
  "h" 'helm-swoop
  "r" 'select-paragraph
  "." 'vi-line-above
  "'" 'vi-line-below
  "d" 'trailing-comma
  "cq" 'tell-emacsclients-for-buffer-to-die
  ;; "m" 'magit-status
  "b" 'magit-blame-mode
  "ss" 'sort-lines
  "-" 'evilnc-comment-or-uncomment-lines
  "2" (lambda () (interactive) (shift-width 2))
  "4" (lambda () (interactive) (shift-width 4)))

;; evil nerd commenter hotkeys
;; (evilnc-default-hotkeys)

;; better m-x
(global-set-key (kbd "M-x") 'helm-M-x)

(global-set-key (kbd "s-n") 'make-frame-command)

;; (global-set-key (kbd "C-b") 'hippie-expand)
;; disable evil-states toggle
(define-key evil-motion-state-map (kbd "C-z") nil)
(define-key evil-insert-state-map (kbd "C-z") nil)

;; git rebase mode is dumb
(setq auto-mode-alist (delete '("git-rebase-todo" . rebase-mode)
                              auto-mode-alist))

(add-to-list 'auto-mode-alist '("git-rebase-todo" . git-commit-mode))

(setq-default auto-fill-function 'do-auto-fill)

(define-key evil-motion-state-map "gr" 'go-to-reviewers)

(global-set-key (kbd "C-c v") 'pbpaste)

(global-set-key (kbd "C-c b") 'browse-url)

(setq mc/cmds-to-run-for-all
      '(
        evil-append-line
        evil-backward-char
        evil-forward-char
        evil-backward-WORD-begin
        evil-backward-word-begin
        evil-change
        evil-delete-char
        evil-delete-line
        evil-digit-argument-or-evil-beginning-of-line
        evil-emacs-state
        evil-end-of-line
        evil-force-normal-state
        evil-forward-WORD-begin
        evil-forward-WORD-end
        evil-forward-word-begin
        evil-forward-word-end
        evil-insert
        evil-insert-line
        evil-next-line
        evil-normal-state
        evil-previous-line
        ))

(global-set-key (kbd "C-c m") 'mc/edit-lines)

;;; keybindings.el ends here
