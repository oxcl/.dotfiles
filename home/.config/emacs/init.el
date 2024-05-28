(unless init-file-debug
  (setq frame-inhibit-implied-size t
	inhibit-startup-screen t
	inhibit-startup-echo-area-message user-login-name
	initial-major-mode 'fundamental-mode
	initial-scratch-message nil
	read-process-output-max (* 1024 1024 3))

  (unless after-init-time
    (setq inhibit-redisplay t
	  inhibit-message nil)
    (defun oxcl/reset-inhibited-vars-h ()
      (setq-default inhibit-redisplay nil
		    inhibit-message nil)
      (redraw-frame))
    (add-hook 'after-init-hook #'oxcl/reset-inhibited-vars-h)
    (define-advice startup--load-user-init-file (:after (&rest _) undo-inhibit-vars)
      (when init-file-had-error
	(doom--reset-inhibited-vars-h)))
    (advice-add #'display-startup-echo_area-message :override #'ignore)
    (advice-add #'display-startup-screen :override #'ignore)
    (define-advice load-file (:override (file) silence)
      (load file nil 'nomessage))
    (define-advice startup--load-user-init-file (:before (&rest _) undo-silence)
      (advice-remove #'load-file #'load-file@silence))
    (advice-add #'tool-bar-setup :override #'ignore)
    (define-advice startup--load-user-init-file (:before (&rest _) defer-tool-bar-setup)
      (advice-remove #'tool-bar-setup #'ignore)
      (add-transient-hook! 'tool-bar-mode (tool-bar-setup)))))

(setq real-user-emacs-directory user-emacs-directory
      user-emacs-directory oxcl/cache-dir
      server-auth-dir (expand-file-name "server" real-user-emacs-directory)
      ;; relocate backup files
      backup-directory-alist `((".*" . ,(expand-file-name "emacs/backups" oxcl/cache-dir)))
      ;; relocate auto-save files
      auto-save-file-name-transforms `((".*" ,(expand-file-name "save" oxcl/cache-dir) t))
      ;; disable lockfiles
      create-lockfiles nil)

;; suppress compiler warnings
(setq native-comp-async-report-warnings-errors init-file-debug
      native-comp-warning-on-missing-source init-file-debug
      ad-redefinition-action 'accept)

(setq gnutls-verify-error noninteractive
gnutls-algorithm-priority
(when (boundp 'libgnutls-version)
  (concat "SECURE128:+SECURE192:-VERS-ALL"
    (if (and (not (memq system-type '(cygwin windows-nt ms-dos)))
       (>= libgnutls-version 30605))
        ":+VERS-TLS1.3")
    ":+VERS-TLS1.2"))
;; `gnutls-min-prime-bits' is set based on recommendations from
;; https://www.keylength.com/en/4/
gnutls-min-prime-bits 3072
tls-checktrust gnutls-verify-error
;; Emacs is built with gnutls.el by default, so `tls-program' won't
;; typically be used, but in the odd case that it does, we ensure a more
;; secure default for it (falling back to `openssl' if absolutely
;; necessary). See https://redd.it/8sykl1 for details.
tls-program '("openssl s_client -connect %h:%p -CAfile %t -nbio -no_ssl3 -no_tls1 -no_tls1_1 -ign_eof"
        "gnutls-cli -p %p --dh-bits=3072 --ocsp --x509cafile=%t \
--strict-tofu --priority='SECURE192:+SECURE128:-VERS-ALL:+VERS-TLS1.2:+VERS-TLS1.3' %h"
        ;; compatibility fallbacks
        "gnutls-cli -p %p %h"))

(defun oxcl/add-tangle-and-reload-hook ()
  (when (equal (file-truename (concat real-user-emacs-directory "config.org"))
	       (buffer-file-name))
    (add-hook 'after-save-hook #'oxcl/tangle-and-reload nil t)))
(defun oxcl/tangle-and-reload ()
  (org-babel-tangle)
  (load-file user-init-file))
(add-hook 'org-mode-hook #'oxcl/add-tangle-and-reload-hook)

(setq ring-bell-function 'ignore ; disable visual or audible ring
      overflow-newline-into-fringe nil  ; stop cursor & chars from going in fringe zone
      save-interprogram-paste-before-kill t ; before killing some text make sure the system clipboard content is added to emacs kill ring
      require-final-newline t ; ensure a final new line at the end of the buffer before saving
      backup-by-copying t ; create a backup by copying instead of renaming current file as backup
      frame-inhibit-implied-resize t
      uniquify-buffer-name-style 'forward) ; display name of files with the same name similar to vscode
(setq-default indent-tabs-mode nil) ; don't use tab characters for indentation
(blink-cursor-mode -1) ; disable cursor blink
(tooltip-mode -1) ; hide tooltip popup window on mouse hover
(set-fringe-mode '(5 . 10)) ; add small margin to the right of the editor

(save-place-mode 1)
(setq save-place-forget-unreadable-files nil)

(savehist-mode 1)
(add-to-list 'savehist-additional-variables '(search-ring-regexp-search-ring file-name-history))

(set-frame-font "ioZevka Code 11" nil t)
(variable-pitch-mode t)

(set-face-attribute 'variable-pitch nil :family "ioZevka Quasi")
;; (setq-default line-spacing 0) ; small padding between each line

(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; don't open the elpaca buffer every time the init file is reloaded
(defun oxcl/hide-elpaca-buffer-when-reloading-config ()
  (ignore (elpaca-process-queues)))
(with-eval-after-load "elpaca-log"
  (setf (alist-get #'oxcl/hide-elpaca-buffer-when-reloading-config elpaca-log-command-queries) 'silent))
(advice-add #'oxcl/tangle-and-reload :after #'oxcl/hide-elpaca-buffer-when-reloading-config)

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq use-package-always-ensure t
        use-package-always-defer t))
(elpaca-wait)

(use-package delight
  :demand t)
(elpaca-wait)

(add-to-list 'load-path (expand-file-name "lisp" real-user-emacs-directory))

(use-package modus-themes
  :demand t
  :config
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-mixed-fonts t ; enable proper proportional fonts in org mode
        modus-themes-variable-pitch-ui t ; use proportional fonts in ui elements (mainly mode line)
        modus-themes-prompts '(italic bold)) ; how to style the prompts in the minibuffer
  ;; how to style the completion user interfaces
  ;; 'matches' is the part of completion that matches user input
  ;; 'selection' is the currently selected completion item
  (setq modus-themes-completions '((matches . (extrabold))
                                   (selection . (semibold italic text-also))))

  ;; different font styles for each org-mode heading based on its level
  (setq modus-themes-headings
    '((0 . (1.3))
      (1 . (1.5))
      (2 . (1.3))
      (3 . (1.2))
      (t . (1.1))))

  (require 'modus-custom)
  (load-theme 'modus-vivendi :no-confirm))

(use-package rainbow-mode
  :config
  (setq rainbow-x-colors-font-lock-keywords '())
  :hook (css-base-mode . rainbow-mode))
