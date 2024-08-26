;; DON'T PUT ANYTHING HERE!!!
;;
;; if you want to add any elisp code add it to the relevant file in the lisp directory
;;
;; every elisp code in this emacs configuration should be part of a 'module'. there are 3 types of modules:
;;  - profile modules
;;  - feature modules
;;  - package modules
;;
;; profile modules are used to create different profiles for emacs.
;; each profile can be thought of as a separate configuration for emacs which you can switch to
;; in profile modules you can import other modules to prevent duplicating code.
;;
;; feature modules are a set of package modules (and maybe minimal glue code) that represent a common
;; feature. this is very useful to activate different sets of features in different profiles by just
;; importing the feature module (e.g. LSP, Evil mode, etc.)
;;
;; package modules contain of use-package declarations and configurations for builtin and third-party
;; packages. each package should have its own file. also I put custom elisp code, functions and commands
;; in their own file as a package module despite the fact that they are not 'real' packages
;;
;; following this system you can enable specific modules (profile,feature or package) using 
;; the emacs-with script I wrote (~/.local/bin/emacs-with) 
;; this is really handy for debugging the configuration when it breaks or testing out new packages and features

(add-to-list 'load-path (expand-file-name "lisp" (or real-user-emacs-directory user-emacs-directory)))
(require 'profiles/main)
