;;; extensions.el --- flycheck-global Layer extensions File for Spacemacs
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

(setq flycheck-global-pre-extensions
      '(
        ;; pre extension flycheck-globals go here
        ))

(setq flycheck-global-post-extensions
      '(
        ;; post extension flycheck-globals go here
        ))

;; For each extension, define a function flycheck-global/init-<extension-flycheck-global>
;;
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
