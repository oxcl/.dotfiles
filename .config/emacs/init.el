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
  (keymap-global-set "C-b" #'kill-ring-save) ; C-b is actually C-c
  ;; C-x is cut
  (keymap-global-set "C-p" #'kill-region) ; C-p is actually C-x
  ;; C-v is paste
  (keymap-global-set "C-v" #'yank)

  ;; C-s is save
  (keymap-global-set "C-s" #'save-buffer)

  ;; C-a is select all
  (keymap-global-set "C-a" #'mark-whole-buffer)

  ;; Alt-F4 is quit
  (keymap-global-set "M-<f4>" #'save-buffers-kill-terminal))

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
  
