(provide 'packages/jinx)

(use-package jinx
  :custom
  (jinx-languages "en_US de_DE fa_IR")
  (jinx-camel-modes '(prog-mode conf-mode toml-ts-mode toml-mode))
  (jinx-include-faces nil)
  (jinx-exclude-faces '((prog-mode font-lock-keyword-face font-lock-builtin-face font-lock-doc-markup-face font-lock-preprocessor-face)
                        (org-mode org-block)
                        (conf-mode . prog-mode)))
  :config
  (setq jinx-exclude-regexps (append '((prog-mode "\\b[a-zA-Z]\\{2\\}\\b")
                                       (conf-mode . prog-mode)
                                       (css-mode "\\b[a-fA-F0-9]\\{6\\}\\b")
                                       (css-ts-mode . css-mode)
				       (t "\\b\\(\\d\\|\\w\\|_\\)*://.*\\b")) ; ignore urls
				     jinx-exclude-regexps))
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
  
  (defun oxcl/jinx-consider-hyphen-as-space-in-lisp ()
    (modify-syntax-entry ?- " " jinx--syntax-table))
  
  (defun oxcl/jinx-add-to-personal ()
    (interactive)
    (execute-kbd-macro (kbd "C-$ @")))
 
  (add-hook 'jinx-mode-hook #'oxcl/jinx-consider-hyphen-as-space-in-lisp)
  :bind
  ("C-$" . jinx-correct)
  ("C-@" . oxcl/jinx-add-to-personal)
  :hook (text-mode prog-mode conf-mode org-mode toml-mode toml-ts-mode))
