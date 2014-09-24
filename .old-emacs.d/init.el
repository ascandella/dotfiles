(add-to-list 'load-path "~/.emacs.d/elisp")
(load-library "melpa")
(load-library "backups")
(load-library "ui")
(load-library "projectile")

(package-initialize)
(projectile-global-mode)

(load-library "theme")
(load-library "keys")
