(use-package org
  :config
  (setq
   org-agenda-files '("~/Nextcloud/Documents/org/")
   org-log-done 'time
   org-time-stamp-custom-formats '("<%a %b %e>" . "<%a %b %e %Y %H:%M>"))
  (setq-default org-display-custom-times t)
  (map!
   (:map org-mode-map
     :n "C-t" 'org-timestamp-down-day
     :n "C-n" 'org-timestamp-up-day
     "C-S-RET" 'org-insert-todo-subheading)))
