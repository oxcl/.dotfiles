(provide 'packages/fonts)

(condition-case nil ;;
    (set-frame-font "Iosevka SS09-12") ;;
  (set-frame-font "Go Mono-11") ;;
  (set-frame-font "Fira Mono-11") ;;
  (set-frame-font "Inconsolata-13") ;;
  (set-frame-font "Monospace-11") ;;
  (set-frame-font "Ubuntu Mono-13") ;;
  (set-frame-font "IBM Plex Mono-13") ;;
  (set-frame-font "Cascadia Code-14") ;;
  (set-frame-font "Jetbrains Mono-11") ;;
  (set-frame-font "Monaco-11")
  (set-frame-font "Martian Mono-10") ;;
  (set-frame-font "Dina-10") ;;
  (set-frame-font "iAWriterDuospace-13") ;;
  (set-frame-font "Hermit-13") ;;
  (set-frame-font "Menlo-11") ;;
  (set-frame-font "Hack-14")
  (error (set-frame-font "Monospace-11")))
