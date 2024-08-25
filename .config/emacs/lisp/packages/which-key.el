(provide 'packages/which-key)

(use-package which-key
  :ensure t ; TODO: change to nil on emacs30
  :demand t
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))
