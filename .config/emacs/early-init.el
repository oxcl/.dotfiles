;; temporarily disable garbage collection for the initialization
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook (lambda ()
			     (setq gc-cons-threshold (* 1024 1024 100)))) ; 100mb

;; disable package.el
(setq package-enable-at-startup nil)

;; this optimization is taken from doom emacs early-init
(setq load-prefer-newer noninteractive)

;; relocate eln cache dircetory to xdg cache
(setq oxcl/cache-dir (expand-file-name "emacs" (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache"))))
(startup-redirect-eln-cache (expand-file-name "eln" oxcl/cache-dir))


