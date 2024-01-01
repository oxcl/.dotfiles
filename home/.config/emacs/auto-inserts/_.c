`(let ((header-file (expand-file-name (concat (file-name-base (buffer-file-name)) ".h") (file-name-directory (buffer-file-name)))))
    (when (file-exists-p header-file) (concat "#include \"" (file-name-nondirectory header-file) "\"\n")))`
$0

