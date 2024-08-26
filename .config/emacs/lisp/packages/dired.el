(provide 'packages/dired)

(use-package dired
  :ensure nil
  :custom
  (dired-free-space nil)          ; hide the text at the top about the free available space on disk
  (dired-listing-switches "-alh") ; make file sizes human readable
  :config
  (keymap-unset dired-mode-map "C-o"))
