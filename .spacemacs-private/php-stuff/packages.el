;;; packages.el --- php-stuff Layer packages File for Spacemacs
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
(setq php-stuff-packages
    '(
      ;; package php-stuffs go here
      php-mode
      ))

;; List of packages to exclude.
(setq php-stuff-excluded-packages '())

;; For each package, define a function php-stuff/init-<package-php-stuff>
;;
(defun php-stuff/init-php-mode()
  "Initialize my package"
  (use-package php-mode
    :defer t)
  )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
