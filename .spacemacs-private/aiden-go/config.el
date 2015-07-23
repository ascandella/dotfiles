;;; Code:
(setq gofmt-command "goimports")

(defun my-go-mode-hook ()
  (whitespace-mode -1) ; don't highlight hard tabs
  (setq
   tab-width 2         ; display tabs as two-spaces
   indent-tabs-mode 1  ; use hard tabs to indent
   fill-column 100))   ; set a reasonable fill width

; (add-hook 'before-save-hook #'gofmt-before-save)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun go-display-cover-out ()
  "Display go coverage from cover.out"
  (go-coverage (expand-file-name "./cover.out")))

(defun generic-go-test-and-coverage (cmd)
  (message "Running tests...")
  (shell-command cmd)
  (go-display-cover-out))

(defun golang-compile-and-coverage ()
  "Compile with coverage."
  (interactive)
  (generic-go-test-and-coverage "make -k test"))

(defun golang-test-and-coverage ()
  "Compile with coverage."
  (interactive)
  (generic-go-test-and-coverage "go test . -v -coverprofile cover.out"))

(defun disable-go-build ()
  "Disable go-build checker for tramp sessions."
  (interactive)
  (setq-local flycheck-disabled-checkers '(go-build)))

(defun reset-flycheck ()
  (interactive)
  (setq-local flycheck-disabled-checkers nil))

(evil-leader/set-key-for-mode 'go-mode
  "l" 'golang-test-and-coverage)

;;; config.el ends here
