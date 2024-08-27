(provide 'packages/sane-defaults)

;; hide tool bar and vertical scroll bar
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq tool-bar-mode nil
      scroll-bar-mode nil)

;; disable menu bar unless in MacOS
(unless (eq system-type 'darwin)
  (push '(menu-bar-lines . 0)   default-frame-alist)
  (setq menu-bar-mode nil))

(setq initial-scratch-message  ""        ; Make *scratch* buffer blank
      ring-bell-function       #'ignore  ; disable visual and audible bell
      vc-follow-symlinks       t         ; follow a symlink without asking wtf?
      inhibit-startup-message  t         ; don't present the infamous emacs startup buffer
      
      ;; don't add customizations made by customize interface to init.el and add it to custom.el instead
      ;; I'm not loading custom.el here because elpaca requires it to be loaded after initialization with 'elpaca-after-init-hook
      ;; but if you are not using elpaca you can load it here.
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(fset 'yes-or-no-p 'y-or-n-p)           ; why should i type the whole world "yes" instead of just "y" richard stallman? why??
(delete-selection-mode 1)               ; Selected text will be overwritten when you start typing
(global-auto-revert-mode t)             ; Auto-update buffer if file has changed on disk

;; teach emacs to keep your folders clean
(setq create-lockfiles nil
      backup-directory-alist `((".*" . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-list-file-prefix (expand-file-name "auto-saves/" user-emacs-directory))
(make-directory auto-save-list-file-prefix t)

;; save the cursor position for files across emacs sessions
(save-place-mode)

;; save mini buffer history across emacs sessions
(savehist-mode)


