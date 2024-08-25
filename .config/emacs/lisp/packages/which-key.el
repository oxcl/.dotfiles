(provide 'packages/which-key)

(use-package which-key
  :demand t
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))
