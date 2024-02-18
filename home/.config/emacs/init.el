(unless init-file-debug
  (setq frame-inhibit-implied-size t
	inhibit-startup-screen t
	inhibit-startup-echo-area-message user-login-name
	initial-major-mode 'fundamental-mode
	initial-scratch-message nil
	inhibit-redisplay t
	inhibit-message t
	read-process-output-max (* 1024 1024 3))
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
    (add-transient-hook! 'tool-bar-mode (tool-bar-setup))))

(setq real-user-emacs-directory user-emacs-directory)
(setq user-emacs-directory oxcl/cache-dir)
(setq server-auth-dir (expand-file-name "server" real-user-emacs-directory))

(setq backup-directory-alist `((".*" . ,(expand-file-name "emacs/backups" oxcl/cache-dir))))

(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "save" oxcl/cache-dir) t)))

(setq create-lockfiles nil)

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

(add-to-list 'load-path (expand-file-name "lisp" real-user-emacs-directory))

(defvar elpaca-installer-version 0.6)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
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
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
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

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq use-package-always-ensure t))
(elpaca-wait)

(setq ring-bell-function 'ignore ; disable visual or audible ring
      overflow-newline-into-fringe nil)  ; stop cursor & chars from going in fringe zone
(scroll-bar-mode -1)
(tool-bar-mode -1) ; hide the tool bar (with the icons)
(menu-bar-mode -1) ; hide the menu bar
(tooltip-mode -1) ; hide tooltip popup window on mouse hover
(blink-cursor-mode -1) ; disable cursor blink
(set-fringe-mode '(0 . 10)) ; add small margin to the right of the editor

(set-frame-font "JetBrainsMono 11")
;;	 (set-frame-font (format "JetBrains Mono %d" (round (/ 11000 (+( x-display-pixel-width) 120)))) nil t)
      ;;  (set-face-attribute 'default (selected-frame) :height (round (/ 100000 (* (x-display-pixel-width)  1.1)))) :family "JetBrainsMono Nerd Font")
;;    (set-face-attribute 'default (selected-frame) :family "JetBrainsMono Nerd Font" :height (/ 102400 (* (x-display-pixel-width) 1)))
    (setq-default line-spacing 1) ; small padding between each line

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t 
      doom-themes-enable-italic t
      custom-theme-directory (expand-file-name "themes/" real-user-emacs-directory)
      doom-my-theme-brighter-modeline t
      doom-my-theme-padded-modeline 4)
  (doom-themes-org-config)
  (if (equal (getenv "MY_THEME_LOADED") "1")
    (load-theme 'doom-my t)
    (load-theme 'doom-gruvbox t)))
(use-package solaire-mode
  :after doom-themes
  :config
  (solaire-global-mode +1))

(setq-default display-line-numbers-width 4) ; how many digits for line numbers
(dolist (mode '(prog-mode-hook text-mode-hook restclient-mode-hook conf-mode-hook))
  (add-hook mode 'display-line-numbers-mode))
(setq require-final-newline t)

(global-hl-line-mode)
(dolist (mode '(comint-mode-hook restclient-mode-hook org-mode-hook vterm-mode-hook))
  (add-hook mode (lambda () (setq-local global-hl-line-mode nil)))) ; org-mode has a lot of bugs with hl-line

(use-package all-the-icons
  :if (display-graphic-p))

(setq track_eol t)

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

(use-package ace-window
  :bind ("M-o" . 'ace-window)
  :config
  (setq aw-keys '(?a ?r ?s ?d ?g ?p ?d ?b ?v)))

(use-package idle-highlight-mode
  :hook ((prog-mode text-mode) . idle-highlight-mode)
  :custom
  (idle-highlight-idle-time 0.1)
  (idle-highlight-exceptions-face '(font-lock-comment-face)))

;; this function adds wrap functionality to smartscan.
(defun oxcl/smartscan-wrap ()
  (interactive)
  (let ((symbol (smartscan-symbol-at-pt 'end))
	(pos (point)))
    (when (smartscan-symbol-go-forward)
      (beginning-of-buffer)
      (smartscan-symbol-goto symbol 'forward)
      (unless (bobp) (setq pos (point)))
      (goto-char pos))))
(use-package smartscan
  :config
  (global-smartscan-mode)
  (keymap-global-set "C-*" 'oxcl/smartscan-wrap))

(keymap-global-unset "C-/")
(keymap-global-unset "C-?")
(keymap-global-set "C-_" #'undo-only)
(keymap-global-set "C--" #'undo-redo)

(save-place-mode 1)
(setq save-place-forget-unreadable-files nil)

;; ignore case sensitive spell checks
(defun oxcl/jinx-lower-case-word-valid-p (start)
  "Return non-nil if word, that is assumed to be in lower case, at
   START is valid, or would be valid if capitalized or upcased."
  (let ((word (buffer-substring-no-properties start (point))))
    (or (member word jinx--session-words)
	(cl-loop for dict in jinx--dicts thereis
		 (or
		  (jinx--mod-check dict (upcase word))
		  (jinx--mod-check dict (capitalize word))
		  (jinx--mod-check dict word))))))
(defun oxcl/jinx-add-to-personal ()
  (interactive)
  (let ((word (current-word t t)))
    (jinx--save-personal t nil word)
    (jinx-mode -1)
    (jinx-mode 1)))
(use-package jinx
  :hook ((text-mode prog-mode conf-mode org-mode) . jinx-mode)
  :custom
  (jinx-languages "en_US fa_IR")
  (jinx-camel-modes '(prog-mode conf-mode org-mode))
  (jinx-exclude-faces '((org-mode org-block-begin-line org-block-end-line)
			(t font-lock-keyword-face font-lock-builtin-face)))
  :config
  (add-to-list 'jinx-exclude-regexps '(t "\\b[a-zA-Z]\\{2\\}\\b"))
  (set 'jinx--predicates
       (cl-substitute
	#'oxcl/jinx-lower-case-word-valid-p
	#'jinx--word-valid-p
	jinx--predicates))
  :bind
  ("C-$" . jinx-correct)
  ("C-@" . oxcl/jinx-add-to-personal))

(savehist-mode 1)
(add-to-list 'savehist-additional-variables '(search-ring-regexp-search-ring file-name-history))

(defun oxcl/set-minibuffer-keybindings ()
  "Add custom keybindings for the  minibuffer."
  (local-set-key (kbd "M-<up>")   #'previous-history-element)
  (local-set-key (kbd "M-<down>") #'next-history-element))
(add-hook 'minibuffer-setup-hook 'oxcl/set-minibuffer-keybindings)

(setq-default case-fold-search nil ; make search case sensitive by default
	      char-fold-symmetric t  ; accent character's match the regular character as well
	      search-ring-max 64
	      regexp-search-ring-max 64)
;; TODO: make sure char-fold-table includes farsi letters

;; while using incremental search when going from C-s to C-r or from C-r to C-s go to the
;; next/previous match immediately. instead of requiring two key presses
(setq isearch-repeat-on-direction-change t)

;; make the backspace delete the search query immediately!
;; for going back to the previous match use C-r
(define-key isearch-mode-map [remap isearch-delete-char] 'isearch-del-char)
;; clear the search string with C-S-<backspace> like other minibuffer prompts
(defun oxcl/isearch-clear ()
  (interactive))
(define-key isearch-mode-map (kbd "C-S-<backspace>") #'oxcl/isearch-clear)
;; automatically wrap around the buffer when no result is found
(setq isearch-wrap-pause 'no)

;; exit out of search with a single C-g in all scenarios
(defun oxcl/isearch-full-abort ()
  (interactive)
  (isearch-abort)
  (when isearch-mode (isearch-abort)))
(define-key isearch-mode-map [remap isearch-abort] #'oxcl/isearch-full-abort)

(define-key isearch-mode-map (kbd "<M-up>") 'isearch-ring-retreat)
(define-key isearch-mode-map (kbd "<M-down>") 'isearch-ring-advance)

(defun oxcl/isearch--momentary-message (orig-fun &rest args)
  (apply orig-fun `(,(car args) 0)))
(advice-add 'isearch--momentary-message :around #'oxcl/isearch--momentary-message)

(defun oxcl/loose-search (&optional arg)
  (interactive)
  (if (bound-and-true-p oxcl/loose-search)
      (if (bound-and-true-p arg)
	  (isearch-repeat-backward)
	(isearch-repeat-forward))
    (setq oxcl/loose-search t)
    (or (featurep 'char-fold) (require 'char-fold))
    (oxcl/enable-loose-color)
    (let ((case-fold-search t) ; case insensitive
	  (default-search-mode 'char-fold-to-regexp)
	  (search-upper-case nil)
	  (search-whitespace-regexp "[ .\t\n\\(\\)\\.,_-]+")) ; stops uppercase letters to change case sensitivity behavior
      (set-char-table-range char-fold-table ?_ "-")
      (set-char-table-range char-fold-table ?- "_")
      (if (bound-and-true-p arg) (isearch-backward) (isearch-forward))
      (set-char-table-range char-fold-table ?_ nil)
      (set-char-table-range char-fold-table ?- nil)
      (oxcl/disable-loose-color)
      (setq oxcl/loose-search nil))))
(defun oxcl/loose-backward-search ()
  (interactive)
  (oxcl/loose-search t))
(keymap-global-set "C-S-s" #'oxcl/loose-search)
(keymap-global-set "C-S-r" #'oxcl/loose-backward-search)
(defun oxcl/make-loose (&optional arg)
  (interactive)
  (unless (featurep 'char-fold) (require 'char-fold))
  (if (bound-and-true-p oxcl/loose-search)
      (if (bound-and-true-p arg)
	  (isearch-repeat-backward)
	(isearch-repeat-forward))
    (setq oxcl/loose-search t)
    (isearch-toggle-case-fold)
    (isearch-toggle-char-fold)
    (oxcl/enable-loose-color))
  (add-hook 'isearch-mode-end-hook #'oxcl/disable-loose-color))
(defun oxcl/make-loose-backward ()
  (interactive)
  (oxcl/make-loose t))
(define-key isearch-mode-map (kbd "C-S-s") #'oxcl/make-loose)
(define-key isearch-mode-map (kbd "C-S-r") #'oxcl/make-loose-backward)

(setq isearch-lazy-count t
      lazy-highlight-initial-delay 0)



(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 6.0
	which-key-idle-secondary-delay 0.05
	which-key-show-early-on-C-h t))

;;  (setq org-confirm-babel-evaluate nil)
;;  (define-key org-mode-map (kbd "C-.") 'org-edit-src-code)
;;  (define-key org-src-mode-map (kbd "C-.") 'org-edit-src-exit)

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
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("go\\.mod\\'" . go-mod-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
(add-to-list 'auto-mode-alist '("\\(\\.cmake\\|CMakeLists\\.txt\\)\\'" . cmake-ts-mode))
(setq treesit-font-lock-level 4)

(use-package clojure-ts-mode
  :commands (clojure-ts-mode)
  :mode "\\.\\(clj\\|cljs\\|cljc\\)\\'")

(use-package kotlin-ts-mode
  :commands (kotlin-ts-mode)
  :mode "\\.kt\\'")

(use-package nix-ts-mode
  :commands (nix-ts-mode)
  :mode "\\.nix\\'")

;;  (use-package lua-ts-mode
;;    :straight (:host sourcehut :repo "johnmuhl/lua-ts-mode")
;;    :mode "\\.lua\\'"
;;    :commands (lua-ts-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(show-paren-mode)
(setq show-paren-delay 0)
(defun my-show-paren-any (orig-fun)
  (or (if (looking-at "\\s(") (funcall orig-fun))
      (if (looking-at "\\s)") (save-excursion (forward-char 1) (funcall orig-fun)))))
(add-function :around show-paren-data-function #'my-show-paren-any)

;; since C-* is used also for smart-scan this function will fallback to oxcl/smartscan-wrap if the cursor
;; on a parenthesis
(defun oxcl/goto-match-paren ()
  (interactive)
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (oxcl/smartscan-wrap))))
(keymap-global-set "C-*" #'oxcl/goto-match-paren)

(electric-pair-mode)
(setq electric-pair-skip-whitespace nil)

(defun oxcl/hungry-delete ()
  (interactive)
  (let (( current-line (buffer-substring-no-properties
			(line-beginning-position)
			(line-end-position))))
    (if (and (string-blank-p current-line) (not (string-empty-p current-line)))
	(progn
	  (open-line 1)
	  (beginning-of-line)
	  (kill-line))
      (delete-backward-char 1))))
(defun oxcl/add-hungry-delete-bindings ()
  (local-set-key (kbd "S-DEL") (key-binding (kbd "DEL")))
  (local-set-key (kbd "DEL") #'oxcl/hungry-delete))
(add-hook 'prog-mode-hook #'oxcl/add-hungry-delete-bindings)
(add-hook 'text-mode-hook #'oxcl/add-hungry-delete-bindings)

;;  (use-package magit)

(defun oxcl/yas-insert ()
  "Replace text in yasnippet templates."
  (yas-expand-snippet (buffer-string) (point-min) (point-max)))

(defun oxcl/setup-auto-insert ()
  (unless (featurep 'autoinsert)
    (require 'autoinsert)
    (auto-insert-mode)
    (setq auto-insert-query nil
	  auto-insert-directory (expand-file-name "auto-inserts/" real-user-emacs-directory)
	  auto-insert-alist '())
    ;; automatically load auto-insert snippets from .config/emacs/auto-inserts folder.
    ;; files which have only an underscore in the name will be applied to every file with that extension but only
    ;; if a more specific template is not found.
    (let ((auto-insert-files (cdr (cdr (directory-files (expand-file-name "auto-inserts" real-user-emacs-directory))))))
    (dolist (item auto-insert-files)
      (let ((pattern-name (if (equal (file-name-base item) "_")
			      (concat "\\." (file-name-extension item) "\\'")
			    (if (file-name-extension item)
				(concat (file-name-base item) "\\." (file-name-extension item))
			      (file-name-base item)))))
	(add-to-list 'auto-insert-alist `(,pattern-name . [,item oxcl/yas-insert]) ))))))

(use-package yasnippet
  :custom
  (yas-snippet-dirs `(,(expand-file-name "snippets" real-user-emacs-directory)))
  :config
  (yas-global-mode 1)
  (oxcl/setup-auto-insert))

;;  (setq-default completion-styles '(basic))

;;	(use-package prescient
;;	  :defer t
;;	  :config
;;	  (prescient-persist-mode))

;;  (use-package company-prescient
;;    :requires prescient
;;    :after company
;;    :hook (company-mode . company-prescient-mode))

(use-package rainbow-mode
  :hook (css-base-mode . rainbow-mode))

(add-hook 'find-file-hook (lambda ()
			    (when (equal buffer-file-coding-system 'no-conversion) (hexl-mode))))
(add-to-list 'auto-mode-alist '("\\.\\(bin\\|exe\\|dat\\|dll\\|ana\\|anac\\|hex\\)\\'" . hexl-mode))

(defun oxcl/hexl-backspace ()
  (interactive)
  (hexl-backward-char 1)
  (hexl-insert-char 0 1)
  (hexl-backward-char 1))
(add-hook 'hexl-mode-hook (lambda ()
			    (keymap-local-set "<backspace>" #'oxcl/hexl-backspace)))

(setq oxcl/hexl-val-in-byte ""
      oxcl/hexl-val-in-short ""
      oxcl/hexl-val-in-int32 ""
      oxcl/hexl-val-in-int64 ""
      oxcl/hexl-val-in-float ""
      oxcl/hexl-val-in-double "")
(defun oxcl/hexl-update-mode-line ()
  ;;    (setq oxcl/hexl-val-in-byte (format "byte: %s" (char-after-point)))
  (force-mode-line-update) "string")
(add-hook 'hexl-mode-hook
	  (lambda ()
	    (setq mode-line-format (append mode-line-format '((:eval oxcl/hexl-val-in-byte))))))

(setq oxcl/hexl-printable-left-regexp "$[2-7][a-zA-Z0-9]\\(?: \\)"
      oxcl/hexl-printable-right-regexp "\\(?:\\b\\)[2-7][a-zA-Z0-9]"
      oxcl/hexl-null-left-regexp  "00\\b"
      oxcl/hexl-null-right-regexp " 00"
      oxcl/hexl-ascii-regexp ".\\{1,16\\}$")
(font-lock-add-keywords 'hexl-mode `((,oxcl/hexl-ascii-regexp           . 'oxcl/hexl-ascii-face)
				     (,oxcl/hexl-printable-left-regexp  . 'oxcl/hexl-printable-face)
				     (,oxcl/hexl-printable-right-regexp . 'oxcl/hexl-printable-face)
				     (,oxcl/hexl-null-left-regexp       . 'oxcl/hexl-null-face)
				     (,oxcl/hexl-null-right-regexp      . 'oxcl/hexl-null-face)) 'set)

(use-package poke
  :requires (poke-mode))

(use-package poke-mode)

(use-package editorconfig
  :config
  (editorconfig-mode 1))

;;  (use-package vterm
;;    :custom
;;    (vterm-ignore-blink-cursor t)
;;    (vterm-environment '("_VTERM=1"))
;;    (vterm-clear-scrollback-when-clearing t)
;;    :config
;;    (add-hook 'vterm-mode-hook (lambda () )))

(use-package restclient
  :mode ("\\.http\\'" . restclient-mode)
  :commands restclient-mode
  :bind 
  (:map restclient-mode-map
  ("C-c C-v" . restclient-http-send-current)
  ("C-c C-c" . restclient-http-send-current-stay-in-window)
  ("C-c C-d" . oxcl/restclient-send-current-show-headers))
  :config
  ;; fix yasnippet expand in restclient mode when fold/outline functionality is enabled
  (add-hook 'restclient-mode-hook (lambda () (local-set-key (kbd "<tab>") yas-maybe-expand)))
  ;; (remove-hook 'restclient-mode-hook 'restclient-outline-mode) ; disable fold in restclient-mode

  (setq restclient-inhibit-cookies t
	restclient-response-body-only t
	restclient-content-type-modes (append '(("application/json" . json-ts-mode)
						("application/octet-stream" . oxcl/restclient-hexl-mode))
					    restclient-content-type-modes))
  (add-hook 'restclient-response-mode-hook (lambda () (jinx-mode -1) (yas-minor-mode -1))))
(defun oxcl/restclient-send-current-show-headers ()
  (interactive)
  (setq restclient-response-body-only nil)
  (restclient-http-send-current-stay-in-window)
  (add-hook 'restclient-response-loaded-hook (lambda () (setq restclient-response-body-only t))))

(defun oxcl/inject-http-to-url ()
(interactive)
(let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
  (when (and ;; if line begins with a http method but it doesn't include a http:// or https://
       (string-match "^\\(GET\\|POST\\|PUT\\|PATCH\\|DELETE\\|HEAD\\|CONNECT\\|OPTIONS\\|TRACE\\) .*$" line)
       (not (string-match "^\\w* \\(https:\\|http:\\)" line)))
    (save-excursion
      (beginning-of-line)
      (forward-word)
      (forward-char)
      (insert "http://"))))
(newline))
(add-hook 'restclient-mode-hook (lambda () (local-set-key (kbd "<return>") #'oxcl/inject-http-to-url)))

(use-package ob-restclient
  :after org-mode
  :config
  (org-babel-do-load-languages 'org-babel-load-languages ''((restclient . t))))

(use-package jq-mode
  :hook (restclient-mode . (lambda () (require 'jq-mode))))
(use-package restclient-jq :after jq-mode)



(add-hook
 'restclient-mode-hook
 (lambda () (add-hook 'restclient-response-loaded-hook
		      (lambda () (when (eq major-mode 'json-ts-mode) (json-pretty-print-buffer))))))

(defun oxcl/restclient-hexl-mode ()
  (set-buffer-file-coding-system 'binary)
  (setq buffer-undo-list nil)
  (hexl-mode))
(add-hook 'restclient-mode-hook
	  (lambda() 
	    (add-hook 'restclient-response-received-hook
		      (lambda ()  (set-buffer-file-coding-system 'utf-8)
			(when (eq major-mode 'hexl-mode) (hexl-mode-exit 0))))))

(setq delete-by-moving-to-trash t
      dired-listing-switches "-Ahl -v --group-directories-first"
      dired-dwim-target t
      dired-recursive-deletes t
      dired-kill-when-opening-new-dired-buffer t
      dired-create-destination-dirs t
      dired-auto-revert-buffer t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; toggle a dired buffer in other window for current directory with C-x C-d
;;  (keymap-global-set "C-x C-d" #'dired-jump-other-window)
(add-hook 'dired-mode-hook (lambda () 
			     (local-set-key (kbd "C-x C-d") #'quit-window)
			     ;; home key moves to the first item in list instead of the dired header
			     (local-set-key (kbd "<C-home>") (lambda ()
							       (beginning-of-buffer)
							       (next-line)))
			     ;; end key moves to the last item in list instead of the empty line
			     (local-set-key (kbd "<C-end>") (lambda ()
							      (end-of-buffer)
							      (previous-line)))
			     ;; replace '% m' with '%' and '% g' with '$'
			     (local-set-key (kbd "%") #'dired-mark-files-regexp)
			     (local-set-key (kbd "$") #'dired-mark-files-containing-regexp)))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq org-fold-core-style 'overlays)

(use-package ctrlf
  :config
  (ctrlf-mode 1))
