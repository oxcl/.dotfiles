(provide 'packages/package)

(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
			 ;; ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("melpa"  . "https://melpa.org/packages/")))

(defun oxcl/delete-unused-packages ()
  (let ((removable (package--removable-packages)))
    (when removable
      (mapc (lambda (p)
              (package-delete (cadr (assq p package-alist)) t))
                  removable))))

(add-hook 'after-init-hook #'oxcl/delete-unused-packages)
