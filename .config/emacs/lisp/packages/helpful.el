(provide 'packages/helpful)

(use-package helpful
  :bind
  ("C-h f" . #'helpful-callable)
  ("C-h v" . #'helpful-variable)
  ("C-h k" . #'helpful-key)
  ("C-h x" . #'helpful-command)
  ("C-h h" . #'help-for-help)
  ("C-h C-h" . #'helpful-at-point))
