(use-package emacs
  :config
  ;; the following code snippet is used to enable the <escape> key to work in terminal environments
  ;; taken from: https://github.com/emacsorphanage/god-mode/issues/43#issuecomment-67193877
  (defvar oxcl/fast-keyseq-timeout 50) ; this timeout determines if a ESC is a Alt combination or a single <escape>
  
  (defun oxcl/-tty-ESC-filter (map)
    (if (and (equal (this-single-command-keys) [?\e])
             (sit-for (/ oxcl/fast-keyseq-timeout 1000.0)))
        [?\C-g] map)) ; i replaced [escape] with [?\C-g] because i want to swap them
  
  (defun oxcl/-lookup-key (map key)
    (catch 'found
      (map-keymap (lambda (k b) (if (equal key k) (throw 'found b))) map)))
  
  (defun oxcl/catch-tty-ESC ()
    "Setup key mappings of current terminal to turn a tty's ESC into `escape'."
    (when (memq (terminal-live-p (frame-terminal)) '(t pc))
      (let ((esc-binding (oxcl/-lookup-key input-decode-map ?\e)))
        (define-key input-decode-map
          [?\e] `(menu-item "" ,esc-binding :filter oxcl/-tty-ESC-filter)))))  
  (oxcl/catch-tty-ESC)

  (defun oxcl/unset (&rest binds)
    (dolist (bind binds)
      (keymap-global-unset bind)))
    

  ;; swap <escape> and Ctrl-g because Ctrl-g is just too good to just quit
  ;; so in key bindings <escape> is actually C-g
  (define-key input-decode-map [?\C-g] [escape] )
  (define-key input-decode-map [escape] [?\C-g] )

  ;; replace C-x with C-p and C-l and replace C-c with C-b and C-j
  ;; this way C-x/C-c keys are available on both sides of the keyboard preserving tempo
  (keymap-set input-decode-map "C-p" "C-x")
  (keymap-set input-decode-map "C-l" "C-x")
  (keymap-set input-decode-map "C-b" "C-c")
  (keymap-set input-decode-map "C-j" "C-c")

  ;; translate C-x as C-p and translate C-c as C-b
  (keymap-set input-decode-map "C-x" "C-p")
  (keymap-set input-decode-map "C-c" "C-b")

  ;; C-c is copy
  (oxcl/unset "M-w")
  (keymap-global-set "C-b" #'kill-ring-save) ; C-b is actually C-c
  
  ;; C-x is cut
  (oxcl/unset "C-w")
  (keymap-global-set "C-p" #'kill-region) ; C-p is actually C-x
  
  ;; C-v is paste
  (oxcl/unset "C-y")
  (keymap-global-set "C-v" #'yank)

  ;; C-s is save
  (oxcl/unset "C-x C-s")
  (keymap-global-set "C-s" #'save-buffer)

  ;; C-a is select all
  (oxcl/unset "C-x h")
  (keymap-global-set "C-a" #'mark-whole-buffer)

  ;; Alt-F4 is quit
  (oxcl/unset "C-x C-c")
  (keymap-global-set "M-<f4>" #'save-buffers-kill-terminal)

  ;; C-z is undo
  (oxcl/unset "C-/" "C-_"  "C-?" "C-M-_" "C-x u")
  (keymap-global-set "C-z" #'undo-only)
  (keymap-global-set "C-S-z" #'undo-redo)
  (keymap-global-set "C-y" #'undo-redo)

  ;; C-o is find-file
  (oxcl/unset "C-x C-f")
  (keymap-global-set "C-o" #'find-file)

  ;; C-+/C-- is zoom in/out and C-= is zoom back to normal
  (oxcl/unset "C-x C-0" "C-x C-=" "C-x C--" "C-x C-+")
  (keymap-global-set "C-+" #'text-scale-increase)
  (keymap-global-set "C--" #'text-scale-decrease)
  (keymap-global-set "C-=" #'oxcl/reset-zoom)
  (defun oxcl/reset-zoom () (interactive) (text-scale-set 0))

  ;; C-f is search
  (keymap-global-set "C-f" #'isearch-forward))

(use-package org
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
	      ("M-<up>"         . org-shiftmetaup)
	      ("M-<down>"       . org-shiftmetadown)
	      ("M-S-<up>"       . org-metaup)
	      ("M-S-<down>"     . org-metadown))
  :commands (org-mode))

(use-package org-tempo
  :after org)
  
