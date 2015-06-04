;;; packages.el --- aiden-go Layer packages File for Spacemacs
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
(setq aiden-go-packages
    '(
      ;; package aiden-gos go here
      go
      go-eldoc
      go-autocomplete
      ))

;; List of packages to exclude.
(setq aiden-go-excluded-packages '())

;; For each package, define a function aiden-go/init-<package-aiden-go>
;;
(defun aiden-go/init-my-package ()
   "Initialize my package"
   (use-package go-mode
     :defer t
     :init
     (progn
       (setq gofmt-command "goimports")
       (load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")))
  )
