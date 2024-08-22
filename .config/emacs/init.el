(use-package org
  :custom
  ;; virtually indent headlines and their contents
  (org-startup-indented t)
  ;; jump to the beginning/end of the headline with ctrl-a/ctrl-k and home/end instead of beginning/end of the line
  (org-special-ctrl-a/e t)
  ;; try to be smart when killing a line with ctrl-k on a headline based on where the cursor is placed
  (org-special-ctrl-k t)
  ;; signal org to not use Shift+Arrow-Keys and use the replacements instead
  (org-replace-disputed-keys t)
  (org-disputed-keys `((,(kbd "S-<up>")      . ,(kbd "M-_"))
		       (,(kbd "S-<down>")    . ,(kbd "M-="))
		       (,(kbd "S-<right>")   . ,(kbd "M-."))
		       (,(kbd "S-<left>")    . ,(kbd "M-,"))
		       (,(kbd "C-S-<right>") . ,(kbd "C-M-."))
		       (,(kbd "C-S-<left>")  . ,(kbd "C-M-,"))))
  :commands (org-mode))
  
