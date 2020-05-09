(setq
 company-idle-delay 0.3
 company-dabbrev-downcase 0)

(use-package company
  :config
  (map!
   (:map company-active-map
     :n "C-n" 'company-select-next-or-abort
     :n "C-p" 'company-select-previous-or-abort)))
