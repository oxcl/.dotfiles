`(let ((description "this auto-insert checks if there is a header file with the same name in the same directory of this file and automatically adds the #include macro for it")
       (header-file (expand-file-name (concat (file-name-base (buffer-file-name)) ".h") (file-name-directory (buffer-file-name)))))
    (when (file-exists-p header-file) (concat "#include \"" (file-name-nondirectory header-file) "\"\n")))`
$0

