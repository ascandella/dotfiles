;;; packages.el --- flycheck-global Layer packages File for Spacemacs
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
(setq flycheck-global-packages
    '(
      ;; package flycheck-globals go here
      flycheck
      ))

;; List of packages to exclude.
(setq flycheck-global-excluded-packages '())

;; For each package, define a function flycheck-global/init-<package-flycheck-global>
;;
(defun flycheck-global/init-flycheck ()
  "Initialize my package"
  (use-package flycheck
    :defer t
    :init
    (add-hook 'after-init-hook #'global-flycheck-mode)))

;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
