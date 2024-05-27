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
      overflow-newline-into-fringe nil)  ; stop cursor & chars from going in fringe zone
(blink-cursor-mode -1) ; disable cursor blink
(tooltip-mode -1) ; hide tooltip popup window on mouse hover
(set-fringe-mode '(5 . 10)) ; add small margin to the right of the editor
;;(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
