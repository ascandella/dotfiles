(setq org-directory
      (cond ((equal (system-name) "ai10")
             "/mnt/c/Users/Aiden/Nextcloud/Documents/org")

            (t
             "~/Nextcloud/Documents/org")))

(use-package org
  :config
  (setq
   org-agenda-files (cons org-directory '())
   org-log-done 'time
   org-time-stamp-custom-formats '("<%a %b %e>" . "<%a %b %e %Y %H:%M>"))
  (setq-default org-display-custom-times t)
  (map!
   (:map org-mode-map
     :n "C-t" 'org-timestamp-down-day
     :n "C-n" 'org-timestamp-up-day
     "C-S-RET" 'org-insert-todo-subheading)))

;; https://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html
(setq org-agenda-custom-commands
      '(("d" "Done today"
         ((agenda "" ((org-agenda-span 1)))
          ;; limits the agenda display to a single day
          (tags "CLOSED>\"<-1d>\"")
          ((org-agenda-compact-blocks t))))))
