(provide 'packages/org)

(use-package org
  :ensure nil
  :custom
  ;; indent headings and their contents
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
  ;; start a org document folded
  (org-startup-folded t)
  ;; when creating a new heading or item with M-RET don't split the line if the cursor is in the middle of the line
  (org-M-RET-may-split-line nil)
  ;; record timestamp for current time when a todo items moves to DONE state
  (org-log-done 'time)
  ;; by default org will always use #B when adding priority to a heading. which is annoying, just cycle through!
  (org-priority-start-cycle-with-default nil)
  ;; directory to main org files to be consumed by org and org-agenda
  (org-directory (expand-file-name "Documents/Org/" "~"))
  (org-agenda-files `(,org-directory))
  :config
  (defun oxcl/org-jump-in ()
    """if the cursor is on a heading jump to its first subheading if it has any otherwise show its folded contents
       and if the cursor is not on a heading jump to next heading"""
    (interactive)
    (if (org-at-heading-p)
	(if (org-goto-first-child)
	    (progn (org-fold-reveal) (org-end-of-line) (org-beginning-of-line))
	  (org-show-subtree))
      (org-back-to-heading t)
      (org-beginning-of-line)))

  (defun oxcl/org-jump-out ()
    """if the cursor is on a heading fold its contents, and if it is already folded jump to its parent heading
       and if the cursor is not on a heading jump to previous heading"""
    (interactive)
    (if (org-at-heading-p)
	(if (org-invisible-p (point-at-eol))
            (progn (outline-up-heading 1) (org-fold-hide-subtree) (org-end-of-line) (org-beginning-of-line))
	  (org-fold-hide-subtree)
	  (when (not (org-invisible-p (point-at-eol)))
		(progn (outline-up-heading 1) (org-fold-hide-subtree) (org-end-of-line) (org-beginning-of-line))))
      (org-back-to-heading t)
      (org-beginning-of-line)))

  (defun oxcl/org-jump-next ()
    (interactive)
    (org-forward-heading-same-level 1)
    (org-end-of-line)
    (org-beginning-of-line))
  (defun oxcl/org-jump-prev ()
    (interactive)
    (org-backward-heading-same-level 1)
    (org-end-of-line)
    (org-beginning-of-line))

  (defun oxcl/org-shiftmetadown ()
    (interactive)
    (if (region-active-p)
         (drag-stuff-down 1)
      (org-shiftmetadown)))
   (defun oxcl/org-shiftmetaup ()
     (interactive)
     (if (region-active-p)
         (drag-stuff-up 1)
      (org-shiftmetaup)))
  
  :bind (:map org-mode-map
	      ("C-c C-b"     . org-copy-visible) ; this is will actually be C-p C-c
	      ;; structural movement in org-mode
	      ("C-M-<up>"       . oxcl/org-jump-prev)
	      ("C-M-<down>"     . oxcl/org-jump-next)
	      ("C-M-<left>"     . oxcl/org-jump-out)
	      ("C-M-<right>"    . oxcl/org-jump-in)
	      ;; move C-RET and C-S-RET org mode functionality to M-C-RET and M-C-S-RET because
	      ;; i want C-RET for completion
	      ("C-M-<return>"   . org-insert-heading-respect-content)
	      ("C-M-S-<return>" . org-insert-todo-heading-respect-content)
	      ;; M-<up/down> to move individual lines and M-S-<up/down> to move by heading
	      ("M-<up>"         . oxcl/org-shiftmetaup)
	      ("M-<down>"       . oxcl/org-shiftmetadown)
	      ("M-S-<up>"       . org-metaup)
	      ("M-S-<down>"     . org-metadown))
  :commands (org-mode))
