(provide 'packages/fonts)

(defun oxcl/use-font (face height fonts)
  (if (find-font (font-spec :name (car fonts)))
      (set-face-attribute face nil :height height :family (car fonts))
    (unless (eq (cdr fonts) nil)
      (oxcl/use-font face height (cdr fonts)))))

(oxcl/use-font 'default 100 '("ioZevka Code" "ioZevka Mono" "JetBrains Mono"))
(oxcl/use-font 'variable-pitch 100 '("ioZevka Quasi"))
