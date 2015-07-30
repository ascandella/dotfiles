;; Disable smartparens for most pairs, my editing style doesn't play well with it
(eval-after-load 'smartparens
  '(progn
    (sp-pair "(" nil :actions :rem)
    (sp-pair "'" nil :actions :rem)
    (sp-pair "\"" nil :actions :rem)))
