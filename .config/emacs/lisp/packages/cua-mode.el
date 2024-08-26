(provide 'packages/cua-mode)

;; replace emacs garbage default bindings with more modern and conventional key bindings used in other programs as well.
;; this is done by enabling emacs builtin cua mode but also extending it with more keybindings
;; I also try to unset the original keybindings to prevent myself accidentally hitting them and unclutter the which key menu

(cua-mode t)

;; the following code snippet is used to enable the <escape> key to be recognized by terminal environments
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

;; swap <escape> and Ctrl-g because Ctrl-g is just too good for just quit and ESC is just too good to not be used at all
;; so in key bindings <escape> will actually become C-g
;; meaning if you want to bound someting to C-g you have to use <escape>
(define-key input-decode-map [?\C-g] [escape] )
(define-key input-decode-map [escape] [?\C-g] )

(defun oxcl/unset (&rest binds)
  (dolist (bind binds)
    (keymap-global-unset bind)))

(defun oxcl/unset-map (keymap &rest binds)
  (dolist (bind binds)
    (keymap-unset keymap bind)))

;; Ctrl-s is save (save-buffer) instead of C-x C-s
(oxcl/unset "C-x C-s")
(oxcl/unset-map ctl-x-map "C-s")
(keymap-global-set "C-s" #'save-buffer)

;; Ctrl-Shift-s is save as... (write-file) instead of C-x C-w
(oxcl/unset "C-x C-w")
(oxcl/unset-map ctl-x-map "C-w")
(keymap-global-set "C-S-s" #'write-file)

;; Ctrl-o is open file (find-file) instead of C-x C-f
(oxcl/unset "C-x C-f")
(oxcl/unset-map ctl-x-map "C-f")
(keymap-global-set "C-o" #'find-file)

;; Ctrl-a is select all (mark-whole-buffer) instead of C-x h
(oxcl/unset "C-x h")
(oxcl/unset-map ctl-x-map "h")
(keymap-global-set "C-a" #'mark-whole-buffer)

;; Ctrl-z is undo (undo-only) instead of C-/ or C-_ or C-x u
(oxcl/unset "C-/" "C-_" "C-x u")
(oxcl/unset-map ctl-x-map "u")
(keymap-global-set "C-z" #'undo-only)

;; Ctrl-Shift-z and Ctrl-y are redo (undo-redo) instead of C-? or C-M-_
(oxcl/unset "C-?" "C-M-_")
(oxcl/unset-map esc-map "C-_")
(keymap-global-set "C-S-z" #'undo-redo)
(keymap-global-set "C-y" #'undo-redo)

;; Ctrl-+/Ctrl-- is zoom in/out and Ctrl-= is zoom back to normal (text-scale commands) instead of C-x C-= and others
(oxcl/unset "C-x C-0" "C-x C-=" "C-x C--" "C-x C-+")
(oxcl/unset-map ctl-x-map "C-0" "C-=" "C--" "C-+")
(keymap-global-set "C-+" #'text-scale-increase)
(keymap-global-set "C--" #'text-scale-decrease)
(keymap-global-set "C-=" #'oxcl/cua-reset-zoom)
(defun oxcl/cua-reset-zoom () (interactive) (text-scale-set 0))

;; Ctl-f is find (isearch-forward) instead of C-s
(keymap-global-set "C-f" #'isearch-forward)

;; Ctl-Shift-f is find backwards (isearch-backward) instead of C-r
(keymap-global-set "C-S-f" #'isearch-backward)

;; Alt-F4 is quit
(keymap-global-set "M-<f4>" #'save-buffers-kill-terminal)






