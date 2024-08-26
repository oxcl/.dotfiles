(provide 'packages/unclutter)

;; emacs is a very noisy boy. every time you work on a project with the default
;; settings your project directory will become full of ~ files and # files and
;; backup files and auto save files and all sorts of 1990 garbage which there
;; is no use for on any modern computer
;; this is supposed to fix that

(setq server-auth-dir                 (expand-file-name "server" oxcl/cache-dir)
      backup-directory-alist         `((".*" . ,(expand-file-name "backups" oxcl/cache-dir)))
      auto-save-file-name-transforms `((".*" . ,(expand-file-name "save" oxcl/cache-dir) t))
      create-lockfiles                nil)
