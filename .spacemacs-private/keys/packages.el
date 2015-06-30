;;; packages.el --- keys Layer packages File for Spacemacs
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
(setq keys-packages
    '(
      ;; package keyss go here
      evil-leader
      evil-nerd-commenter
      multiple-cursors
      org
      ))

;; List of packages to exclude.
(setq keys-excluded-packages '())

;; For each package, define a function keys/init-<package-keys>
;;
(defun keys/init-org()
  "Initialize my package"
  (use-package org
    :defer t
    :init
    (add-hook 'org-mode-hook
              (lambda ()
                (evil-leader/set-key-for-mode 'org-mode "t" 'evil-next-line)))
    )
  )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
