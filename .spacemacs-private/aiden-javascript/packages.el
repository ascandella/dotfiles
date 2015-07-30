;;; packages.el --- aiden-javascript Layer packages File for Spacemacs
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
(setq aiden-javascript-packages
    '(
      ;; package names go here
      js2-mode
      ))

;; List of packages to exclude.
(setq aiden-javascript-excluded-packages '())

;; For each package, define a function aiden-javascript/init-<package-name>
;;
(defun aiden-javascript/init-js2-mode ()
  "Initialize my package"
  (use-package js2-mode
    :defer t
    :config
    (progn
      (setq-default
       js2-basic-indent 2
       js2-basic-offset 2
       js2-cleanup-whitespace t
       js2-enter-indents-newline t
       js2-indent-on-enter-key t
       flycheck-disabled-checkers (append flycheck-disabled-checkers '(javascript-standard))
       )
      (add-hook 'js2-mode-hook (lambda ()
                                 (shift-width 2)))
    )
  ))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
