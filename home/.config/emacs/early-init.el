;; temporarily disable garbage collection and other things for the faster init time
;; Here I am storing the default value with the intent of restoring it
;; taken from https://protesilaos.com/emacs/dotemacs
;; via the emacs-startup-hook.
(defvar oxcl/file-name-handler-alist file-name-handler-alist)
(defvar oxcl/vc-handled-backends vc-handled-backends)

(setq gc-cons-threshold most-positive-fixnum)
(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 2)
                  gc-cons-percentage 0.2
                  file-name-handler-alist oxcl/file-name-handler-alist
                  vc-handled-backends oxcl/vc-handled-backends)))

;; disable package.el
(setq package-enable-at-startup nil)

;; this optimization is taken from doom emacs early-init
(setq load-prefer-newer noninteractive)

;; relocate eln cache dircetory to xdg cache
(setq oxcl/cache-dir (expand-file-name "emacs" (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache"))))
(startup-redirect-eln-cache (expand-file-name "eln" oxcl/cache-dir))

;; disable useless ui elements for improved performance
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
