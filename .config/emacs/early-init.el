
(setq real-user-emacs-directory user-emacs-directory)
(setq user-emacs-directory (expand-file-name "emacs" (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache"))))

(setq package-enable-at-startup nil) ; disable package.el in favor of elpaca

;; disable garbage collection threshold at startup
(setq gc-cons-threshold most-positive-fixnum)

;; set garbage collection threshold to reasonably large number after startup
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 8000000)))



