cmake_minimum_required(VERSION 3.8) `nil ;;this auto-insert generates a basic boilerplate for cmake by geussing different values such as project name and programming language from the directory`
project(${1:`(setq --CMakeLists.txt-project (file-name-nondirectory (directory-file-name (file-name-directory buffer-file-name))))`})

`;; guess if the project is C or C++ by looking at files in the directory and add the proper standard
(progn (setq --CMakeLists.txt-dir (file-name-directory buffer-file-name) ; this file's parent directory path
             --CMakeLists.txt-has-dir (file-directory-p --CMakeLists.txt-dir)
             --CMakeLists.txt-include-dir (expand-file-name "include" --CMakeLists.txt-dir) ; include/ subdirectory path
             --CMakeLists.txt-has-include (file-directory-p --CMakeLists.txt-include-dir)
             --CMakeLists.txt-src-dir (expand-file-name "src" --CMakeLists.txt-dir) ; src/ subdirectory path
             --CMakeLists.txt-has-src (file-directory-p --CMakeLists.txt-src-dir)
             --CMakeLists.txt-type (catch 'type ; figure out if project is C or C++
                      (dolist (file (append (if --CMakeLists.txt-has-dir (directory-files --CMakeLists.txt-dir))
                                            (if --CMakeLists.txt-has-src (directory-files --CMakeLists.txt-src-dir))
                                            (if --CMakeLists.txt-has-include (directory-files --CMakeLists.txt-include-dir))))
                        (if (string-match-p "\\.[cC]$" file)
                             (throw 'type 'c) 
                          (if (string-match-p "\\.\\([Cc]pp\\|[Hh]pp\\)$" file) 
                              (throw 'type 'cpp))))))
  (if (eq --CMakeLists.txt-type 'c) "set(CMAKE_C_STANDARD 99)" (if (eq --CMakeLists.txt-type 'cpp) "set(CMAKE_CXX_STANDARD 17)")))``
;; if a include/ subdirectory exists add it to cmake
(when --CMakeLists.txt-has-include (format "\ntarget_include_directories(%s PRIVATE ${PROJECT_SOURCE_DIR}/include)" --CMakeLists.txt-project) )`
add_executable($1)
target_sources($1 ${3:`
;; add .c and .cpp source files from current directory and src/ subdirectory 
(string-replace "\n" "\n    " (string-fill (string-join (append (if --CMakeLists.txt-has-dir (directory-files --CMakeLists.txt-dir nil "\\.[Cc]\\(pp\\)?$"))
                                  (if --CMakeLists.txt-has-src (mapcar (lambda (x) (concat "src/" x)) (directory-files --CMakeLists.txt-src-dir nil "\\.[Cc]\\(pp\\)?$")))) " ") 80))
`})
