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
      overflow-newline-into-fringe t  ; stop cursor & chars from going in fringe zone
      save-interprogram-paste-before-kill t ; before killing some text make sure the system clipboard content is added to emacs kill ring
      require-final-newline t ; ensure a final new line at the end of the buffer before saving
      backup-by-copying t ; create a backup by copying instead of renaming current file as backup
      frame-inhibit-implied-resize t
      uniquify-buffer-name-style 'forward) ; display name of files with the same name similar to vscode
(setq-default indent-tabs-mode nil) ; don't use tab characters for indentation
(blink-cursor-mode -1) ; disable cursor blink
(tooltip-mode -1) ; hide tooltip popup window on mouse hover
(set-fringe-mode '(2 . 2)) ; add small margin to the right of the editor

(setq scroll-error-top-bottom t ; put the cursor at the top or bottom of the window if no more scrolls are possible
      scroll-conservatively 100 ; only scroll the minimum lines at a time when the cursor goes out the window
      scroll-margin 5) ; start scrolling the window when the distance between the cursor and the window boundaries are less than this number

;; make ScrollDown and ScrollUp Commands Scroll half a screen
(defun oxcl/scroll-up-half ()
  (interactive)
  (scroll-up-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))
(defun oxcl/scroll-down-half ()
  (interactive)
  (scroll-down-command
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))
(defun oxcl/scroll-other-down-half()
  (interactive)
  (scroll-other-window-down
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))
(defun oxcl/scroll-other-up-half()
  (interactive)
  (scroll-other-window
   (floor
    (- (window-height)
       next-screen-context-lines)
    2)))
(global-set-key (kbd "<next>") 'oxcl/scroll-up-half)
(global-set-key (kbd "<prior>") 'oxcl/scroll-down-half)
(global-set-key (kbd "M-<next>") 'oxcl/scroll-other-up-half)
(global-set-key (kbd "M-<prior>") 'oxcl/scroll-other-down-half)

(save-place-mode 1)
(setq save-place-forget-unreadable-files nil)

(savehist-mode 1)
(add-to-list 'savehist-additional-variables '(search-ring-regexp-search-ring file-name-history))

(set-frame-font "ioZevka Code 11" nil t)
(set-face-attribute 'fixed-pitch nil :family "ioZevka Code")
(set-face-attribute 'variable-pitch nil :family "ioZevka Quasi")
(set-face-attribute 'bold nil :weight 'semibold)
(setq-default line-spacing 1) ; small padding between each line

(setq-default display-line-numbers-width-start 4 ; how many digits for line numbers
              display-line-numbers-grow-only t) ; in case a buffer is larger than 9999 lines
(dolist (mode '(prog-mode-hook text-mode-hook restclient-mode-hook conf-mode-hook text-mode))
  (add-hook mode 'display-line-numbers-mode))

(global-hl-line-mode)
(dolist (mode '(comint-mode-hook restclient-mode-hook org-mode-hook vterm-mode-hook))
  (add-hook mode (lambda () (setq-local global-hl-line-mode nil)))) ; org-mode has a lot of bugs with hl-line

(setq-default tab-width 4
              standard-indent 4
              ;; c, c++, c#, objective-c java, bpftrace, awk, protobuf
              c-basic-offset standard-indent
              c-ts-mode-indent-offset standard-indent
              csharp-ts-mode-indent-offset standard-indent
              c-basic-offset standard-indent
              ;; javascript, json
              js-indent-level standard-indent
              sgml-basic-offset standard-indent
              js2-basic-offset standard-indent
              js3-indent-level standard-indent
              json-ts-mode-indent-offset standard-indent
              ;; typescript
              typescript-indent-level standard-indent
              typescript-ts-mode-indent-offset standard-indent
              ;; html, xml
              html-ts-mode-indent-offset standard-indent
              ;; css, scss
              css-indent-offset standard-indent
              ;; toml
              toml-ts-mode-indent-offset standard-indent
              ;; yaml-mode 
              yaml-indent-offset standard-indent
              ;; bash
              sh-basic-offset standard-indent
              sh-indentation standard-indent
              ;; python
              python-indent standard-indent
              python-indent-offset standard-indent
              ;; lisp
              lisp-indent-offset nil
              ;; kotlin
              kotlin-tab-width standard-indent
              kotlin-ts-mode-indent-offset standard-indent
              ;; lua
              lua-indent-level standard-indent
              lua-ts-indent-offset standard-indent
              ;; go
              go-ts-mode-indent-offset standard-indent
              ;; rust
              rust-indent-offset standard-indent
              rust-ts-mode-indent-offset standard-indent
              ;; zig-mode 
              zig-indent-offset standard-indent
              ;; cmake
              cmake-tab-width standard-indent
              cmake-ts-mode-indent-offset standard-indent
              ;; java
              java-ts-mode-indent-offset standard-indent
              ;; nginx
              nginx-indent-level standard-indent
              ;; svelte
              svelte-basic-offset standard-indent
              ;; graphql
              graphql-indent-level standard-indent
              ;; gdscript
              gdscript-indent-offset standard-indent
              ;; haskell
              haskell-indent-spaces standard-indent
              haskell-indent-offset standard-indent
              haskell-indentation-layout-offset standard-indent
              haskell-indentation-left-offset standard-indent
              haskell-indentation-starter-offset standard-indent
              haskell-indentation-where-post-offset standard-indent
              haskell-indentation-where-pre-offset standard-indent
              shm-indent-spaces standard-indent
              ;; scala 
              scala-indent:step standard-indent
              ;; perl
              perl-indent-level standard-indent
              ;; php
              php-ts-mode-indent-offset standard-indent
              ;; swift
              swift-mode:basic-offset standard-indent
              ;; apache-mode 
              apache-indent-level standard-indent
              ;; coffee
              coffee-tab-width standard-indent
              ;; cperl
              cperl-indent-level standard-indent
              ;; crystal
              crystal-indent-level standard-indent
              ;; elixir
              elixir-ts-indent-offset standard-indent
              ;; ruby
              ruby-indent-level standard-indent
              enh-ruby-indent-level standard-indent
              ;; erlang
              erlang-indent-level standard-indent
              ;; fortran
              f90-associate-indent standard-indent
              f90-continuation-indent standard-indent
              f90-critical-indent standard-indent
              f90-do-indent standard-indent
              f90-if-indent standard-indent
              f90-program-indent standard-indent
              f90-type-indent standard-indent
              ;; f#
              fsharp-continuation-offset standard-indent
              fsharp-indent-level standard-indent
              fsharp-indent-offset standard-indent
              ;; groovy
              groovy-indent-offset standard-indent
              ;; hcl
              hcl-indent-level standard-indent
              ;; jade
              jade-tab-width standard-indent
              ;; jsonian 
              jsonian-default-indentation standard-indent
              ;; julia
              julia-indent-offset standard-indent
              ;; livescript
              livescript-tab-width standard-indent
              ;; magik
              magik-indent-level standard-indent
              ;; matlab
              matlab-indent-level standard-indent
              ;; meson
              meson-indent-basic standard-indent
              ;; mips
              mips-tab-width standard-indent
              ;; mustache
              mustache-basic-offset standard-indent
              ;; nasm 
              nasm-basic-offset standard-indent
              ;; octave
              octave-block-offset standard-indent
              ;; postscript
              ps-mode-tab standard-indent
              ;; pug
              pug-tab-width standard-indent
              ;; puppet
              puppet-indent-level standard-indent
              ;; rustic
              rustic-indent-offset standard-indent
              ;; slim
              slim-indent-offset standard-indent
              ;; sml-mode
              sml-indent-level standard-indent
              ;; terra
              terra-indent-level standard-indent
              ;; tcl
              tcl-indent-level standard-indent
              tcl-continued-indent-level standard-indent
              ;; verilog
              verilog-indent-level standard-indent
              verilog-indent-level-behavioral standard-indent
              verilog-indent-level-declaration standard-indent
              verilog-indent-level-module standard-indent
              verilog-cexp-indent standard-indent
              verilog-case-indent standard-indent)

(setq electric-indent-mode nil)
(defun oxcl/newline-dwim ()
  (interactive)
  (let ((break-open-pair (or (and (looking-back "{") (looking-at "}"))
                           (and (looking-back ">") (looking-at "<"))
                           (and (looking-back "(") (looking-at ")"))
                           (and (looking-back "\\[") (looking-at "\\]")))))
    (if break-open-pair
      (progn (newline)
        (save-excursion
          (newline)
          (indent-for-tab-command))
        (indent-for-tab-command))
      (newline-and-indent))))
(global-set-key (kbd "RET") #'oxcl/newline-dwim)
(add-hook 'org-mode-hook (lambda () (local-set-key (kbd "RET") #'org-return-and-maybe-indent)))

(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
             (or (derived-mode-p 'org-mode)
                 (derived-mode-p 'prog-mode)
                 (derived-mode-p 'conf-mode))
             (let ((mark-even-if-inactive transient-mark-mode))
               (indent-region (region-beginning) (region-end) nil))))))

(defun oxcl/indent-left ()
  (interactive)
  (undo-auto-amalgamate)
  (if (use-region-p)
    (let ((line (line-number-at-pos (mark)))
           (col (save-excursion (goto-char (mark)) (current-column))))
      (save-excursion
        (indent-rigidly-left-to-tab-stop (save-excursion
                                           (goto-char (region-beginning)) (beginning-of-line) (point))
          (region-end))
        (goto-line line)
        (goto-column col)
        (push-mark (point) t t))
      (setq deactivate-mark nil))
    (if  (string-match-p "\\`\\s-*$" (thing-at-point 'line))
      (move-to-column (max 0 (- (current-column) tab-width)))
      (indent-rigidly-left-to-tab-stop (line-beginning-position)
        (line-end-position)))))
(defun oxcl/indent-right ()
  (interactive)
  (undo-auto-amalgamate)
  (if (use-region-p)
    (let ((line (line-number-at-pos (mark)))
           (col (save-excursion (goto-char (mark)) (current-column))))
      (save-excursion
        (indent-rigidly-right-to-tab-stop (save-excursion
                                            (goto-char (region-beginning)) (beginning-of-line) (point))
          (region-end))
        (goto-line line)
        (goto-column col)
        (push-mark (point) t t))
      (setq deactivate-mark nil))

    (if  (string-match-p "\\`\\s-*$" (thing-at-point 'line))
      (tab-to-tab-stop)
      (indent-rigidly-right-to-tab-stop (line-beginning-position)
        (line-end-position)))))
(global-set-key (kbd "M-i") #'oxcl/indent-right)
(global-set-key (kbd "M-m") #'oxcl/indent-left)

(defun oxcl/backspace-whitespace-to-tab-stop ()
  "Delete whitespace backwards to the next tab-stop, otherwise delete one character."
  (interactive)
  (if (or indent-tabs-mode (use-region-p)
          (> (point)
             (save-excursion
               (back-to-indentation)
               (point))))
      (call-interactively 'backward-delete-char)
    (let ((step (% (current-column) tab-width))
          (pt (point)))
      (when (zerop step)
        (setq step tab-width))
      ;; Account for edge case near beginning of buffer.
      (setq step (min (- pt 1) step))
      (save-match-data
        (if (string-match "[^\t ]*\\([\t ]+\\)$"
                          (buffer-substring-no-properties
                           (- pt step) pt))
            (backward-delete-char (- (match-end 1)
                                     (match-beginning 1)))
          (call-interactively 'backward-delete-char))))))
(global-set-key (kbd "DEL") #'oxcl/backspace-whitespace-to-tab-stop)

(setq-default fill-column 100)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(setq major-mode-remap-alist '((ruby-mode . ruby-ts-mode)
                               (c++-mode . c++-ts-mode)
                               (c-or-c++-mode . c-or-c++-ts-mode)
                               (c-mode . c-ts-mode)
                               (java-mode . java-ts-mode)
                               (js-mode . js-ts-mode)
                               (csharp-mode . csharp-ts-mode)
                               (js-json-mode . json-ts-mode)
                               (css-mode . css-ts-mode)
                               (python-mode . python-ts-mode)
                               (conf-toml-mode . toml-ts-mode)
                               (sh-mode . bash-ts-mode)))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("go\\.mod\\'" . go-mod-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\(/Dockerfile\\|\\.Dockerfile\\)\\'" . dockerfile-ts-mode))
(add-to-list 'auto-mode-alist '("\\(\\.cmake\\|CMakeLists\\.txt\\)\\'" . cmake-ts-mode))
(setq treesit-font-lock-level 4)

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
  (modus-themes-load-theme 'modus-vivendi))

(use-package indent-bars
  :ensure (:host github :repo "jdtsmith/indent-bars" :branch "dev")
  :config
  (setq indent-bars-color '("white" :blend 0.1)
   indent-bars-ts-color '("white" :blend 0.1)
   indent-bars-highlight-current-depth '(:color "white" :blend 0.25)
   indent-bars-starting-column 0
   indent-bars-color-by-depth nil
   indent-bars-pattern "."
   indent-bars-width-frac 0.1
   indent-bars-treesit-support t
   indent-bars-treesit-scope '((bash if_statement))
   indent-bars-depth-update-delay 0.03
   indent-bars-treesit-update-delay 0.3
   indent-bars-treesit-scope-min-lines 0)
  ;;          indent-bars-no-descend-string t
  :hook (prog-mode conf-mode)
  :hook (emacs-lisp-mode . (lambda () (indent-bars-mode -1))))

(use-package highlight-indent-guides
  :hook (lisp-mode emacs-lisp-mode)
  :custom-face
  (highlight-indent-guides-character-face ((t :foreground "white")))
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-auto-character-face-perc 85))

(use-package idle-highlight-mode
  :hook ((prog-mode text-mode) . idle-highlight-mode)
  :config
  (setq idle-highlight-idle-time 0.1
        idle-highlight-exceptions-face nil ; '(font-lock-comment-face)
        idle-highlight-visible-buffers t
        idle-highlight-before-point t))

(use-package nix-ts-mode
  :commands (nix-ts-mode)
  :mode "\\.nix\\'")

(use-package lua-ts-mode
  :ensure (:host sourcehut :repo "johnmuhl/lua-ts-mode")
  :mode "\\.lua\\'"
  :commands (lua-ts-mode))

(use-package kotlin-ts-mode
  :commands (kotlin-ts-mode)
  :mode "\\.kt\\'")

(use-package clojure-ts-mode
  :commands (clojure-ts-mode)
  :mode "\\.\\(clj\\|cljs\\|cljc\\)\\'")

(use-package ws-butler
  :demand t
  :delight
  :config
  (setq ws-butler-convert-leading-tabs-or-spaces t)

  ;; if the 'indent-bars' package is enabled it should be temporarily disabled before saving a file
  (setq oxcl/indent-bars-mode-off-for-now nil)
  (make-local-variable 'oxcl/indent-bars-mode-off-for-now)
  (add-hook 'before-save-hook (lambda ()
                                (when (bound-and-true-p indent-bars-mode)
                                  (indent-bars-mode -1)
                                  (setq oxcl/indent-bars-mode-off-for-now t))))
  (add-hook 'after-save-hook (lambda ()
                               (when (and (boundp indent-bars-mode)
                                          oxcl/indent-bars-mode-off-for-now)
                                 (indent-bars-mode 1)
                                 (setq oxcl/indent-bars-mode-off-for-now nil))))
  (ws-butler-global-mode))

(use-package editorconfig
  :demand t
  :config
  (setq editorconfig-trim-whitespaces-mode (if (boundp 'ws-butler-mode) 'ws-butler-mode nil))
  (defun oxcl/update-indent-bars-with-editorconfig (size)
    (when (bound-and-true-p indent-bars-mode)
      (setq indent-bars-spacing-override size)
      (indent-bars-reset)))
  (dolist (_mode editorconfig-indentation-alist)
    (let ((_varlist (cdr _mode)))
      (setcdr _mode (append '((_ . oxcl/update-indent-bars-with-editorconfig))
                                (if (listp _varlist) _varlist `(,_varlist))))))
      (editorconfig-mode 1))

(use-package ligature
  :demand t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures '(prog-mode org-mode)
                          '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                            ;; =:= =!=
                            ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                            ;; ;; ;;;
                            (";" (rx (+ ";")))
                            ;; && &&&
                            ("&" (rx (+ "&")))
                            ;; !! !!! !. !: !!. != !== !~
                            ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                            ;; ?? ??? ?:  ?=  ?.
                            ("?" (rx (or ":" "=" "\." (+ "?"))))
                            ;; %% %%%
                            ("%" (rx (+ "%")))
                            ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                            ;; |->>-||-<<-| |- |== ||=||
                            ;; |==>>==<<==<=>==//==/=!==:===>
                            ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                            "-" "=" ))))
                            ;; \\ \\\ \/
                            ("\\" (rx (or "/" (+ "\\"))))
                            ;; ++ +++ ++++ +>
                            ("+" (rx (or ">" (+ "+"))))
                            ;; :: ::: :::: :> :< := :// ::=
                            (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                            ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                            ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                            "="))))
                            ;; .. ... .... .= .- .? ..= ..<
                            ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                            ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                            ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                            ;; *> */ *)  ** *** ****
                            ("*" (rx (or ">" "/" ")" "*" "***" )))
                            ;; www wwww
                            ("w" (rx (+ "w")))
                            ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                            ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                            ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                            ;; << <<< <<<<
                            ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                            "-"  "/" "|" "="))))
                            ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                            ;; >> >>> >>>>
                            (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                            ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                            ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                         (+ "#"))))
                            ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                            ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                            ;; __ ___ ____ _|_ __|____|_
                            ("_" (rx (+ (or "_" "|"))))
                            ;; Fira code: 0xFF 0x12
                            ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                            ;; Fira code:
                            "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                            ;; The few not covered by the regexps.
                            "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(use-package jinx
  :config
  (setq jinx-languages "en_US de_DE fa_IR"
        jinx-camel-modes '(prog-mode conf-mode org-mode)
        jinx-exclude-faces '((t font-lock-keyword-face font-lock-builtin-face)))
  (add-to-list 'jinx-exclude-regexps '(t "\\b[a-zA-Z]\\{2\\}\\b"))
  (defun oxcl/jinx-lower-case-word-valid-p (start)
    "Returns non-nil if word, that is assumed to be in lower case, at
     START is valid, or would be valid if capitalized or upcased."
    (let ((word (buffer-substring-no-properties start (point))))
      (or (member word jinx--session-words)
          (cl-loop for dict in jinx--dicts thereis
                   (or
                    (jinx--mod-check dict (upcase word))
                    (jinx--mod-check dict (capitalize word))
                    (jinx--mod-check dict word))))))
  (set 'jinx--predicates (cl-substitute
                          #'oxcl/jinx-lower-case-word-valid-p
                          #'jinx--word-valid-p
                          jinx--predicates))
  (defun oxcl/jinx-add-to-personal ()
    (interactive)
    (execute-kbd-macro (kbd "C-$ @")))
  :bind
  ("C-$" . jinx-correct)
  ("C-@" . oxcl/jinx-add-to-personal)
  :hook (text-mode prog-mode conf-mode org-mode))

(use-package rainbow-mode
  :config
  (setq rainbow-x-colors-font-lock-keywords '())
  :hook (css-base-mode . rainbow-mode))
