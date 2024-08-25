(provide 'packages/dired)

(use-package dired
  :ensure nil
  :custom
  (dired-free-space nil)
  :config
  (keymap-unset dired-mode-map "C-o"))
