;; Create a buffer-local hook to run elixir-format on save, only when we enable elixir-mode.
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

;; (add-hook elixir-format-hook '(lambda ()
;;                                  (if (projectile-project-p)
;;                                      (setq elixir-format-arguments (list "--dot-formatter" (concat (projectile-project-root) "/.formatter.exs")))
;;                                    (setq elixir-format-arguments nil))))

(add-hook 'lsp-after-initialize-hook
          (lambda ()
            (lsp-register-custom-settings '(("elixirLS.projectDir" lsp-elixir-project-dir)))))

 (use-package lsp-mode
    :commands lsp
    :diminish lsp-mode
    :hook
    (elixir-mode . lsp)
    :init
    (add-to-list 'exec-path "~/src/elixir-ls")
    (setq lsp-enable-file-watchers nil))

(with-eval-after-load 'lsp-mode
    (add-to-list 'lsp-file-watch-ignored "\\.elixir_ls$")
    (add-to-list 'lsp-file-watch-ignored "deps$")
    (add-to-list 'lsp-file-watch-ignored "node_modules$")
    (add-to-list 'lsp-file-watch-ignored "_build$"))

(map! :mode elixir-mode
      :leader
      :desc "iMenu" :nve  "e/"    #'lsp-ui-imenu
      :desc "Run all tests"   :nve  "ett"   #'exunit-verify-all
      :desc "Run all in umbrella"   :nve  "etT"   #'exunit-verify-all-in-umbrella
      :desc "Re-run tests"   :nve  "etx"   #'exunit-rerun
      :desc "Run single test"   :nve  "ets"   #'exunit-verify-single)
