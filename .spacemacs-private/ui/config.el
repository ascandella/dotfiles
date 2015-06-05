(setq-default fill-column 80)

(set-face-attribute 'vertical-border
                    nil
                    :foreground "#282a2e")

(if window-system
  (progn
    (setq-default dotspacemacs-default-font '(:size 14))))
