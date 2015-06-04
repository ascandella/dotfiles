(setq gofmt-command "goimports")

(defun my-go-mode-hook ()
  (whitespace-mode -1) ; don't highlight hard tabs
  (setq
   tab-width 2         ; display tabs as two-spaces
   indent-tabs-mode 1  ; use hard tabs to indent
   fill-column 100))   ; set a reasonable fill width

; (add-hook 'before-save-hook #'gofmt-before-save)
; (add-hook 'go-mode-hook 'my-go-mode-hook)

(defun go-display-cover-out ()
  "Display go coverage from coverage.out"
  (go-coverage (expand-file-name "./profile.cov")))

(defun golang-compile-and-coverage ()
  "Compile with coverage."
  (interactive)
  (message "Running tests...")
  (shell-command "make -k test")
  (go-display-cover-out))

(evil-leader/set-key-for-mode 'go-mode
  "l" 'golang-compile-and-coverage)
