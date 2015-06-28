;;; packages.el --- ui Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq ui-packages
    '(
      ;; package uis go here
      ansi-color
      exec-path-from-shell
      powerline
      ))

;; List of packages to exclude.
(setq ui-excluded-packages '())

;; For each package, define a function ui/init-<package-ui>
;;
(defun ui/init-exec-path-from-shell ()
  (use-package exec-path-from-shell
    :defer t
    :config
    ;; ensure stuff gets shelled out properly
    (when (memq window-system '(mac ns))
        (exec-path-from-shell-initialize)
        (exec-path-from-shell-copy-env "GOPATH")))
  )

(defun ui/init-powerline ()
  (use-package powerline
    :defer t
    :config
    (setq powerline-default-separator 'arrow)))

;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
