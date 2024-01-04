(modus-themes-with-colors
  (custom-set-faces
   ;; tree-sitter 
   `(font-lock-operator-face ((,c :foreground ,yellow-warmer)))
   `(font-lock-char-face ((,c :foreground ,cyan)))
   `(font-lock-builtin_face ((,c :foreground ,magenta)))
   `(font-lock-delimiter-face ((,c :foreground ,yellow-warmer)))
   `(font-lock-misc-punctuation-face ((,c :foreground ,yellow-warmer)))
   `(font-lock-punctuation-face ((,c :foreground ,yellow-warmer)))
   `(font-lock-property-name-face ((,c :foreground ,blue)))
   ;; rainbow-delimiters 
   `(rainbow-delimiters-unmatched-face ((,c :background ,bg-red-intense :foreground ,bg-main :weight bold)))
   `(rainbow-delimiters-mismatched-face ((,c :background ,bg-yellow-intense :foreground ,bg-main)))
   `(rainbow-delimiters-depth-2-face ((,c :foreground ,yellow-warmer)))
   `(rainbow-delimiters-depth-3-face ((,c :foreground ,blue-warmer)))
   `(rainbow-delimiters-depth-4-face ((,c :foreground ,yellow-cooler)))
   `(rainbow-delimiters-depth-5-face ((,c :foreground ,cyan-cooler)))
   `(rainbow-delimiters-depth-6-face ((,c :foreground ,red-cooler)))
   `(rainbow-delimiters-depth-7-face ((,c :foreground ,magenta-warmer)))
   `(rainbow-delimiters-depth-8-face ((,c :foreground ,green-warmer)))
   `(rainbow-delimiters-depth-9-face ((,c :foreground ,blue)))
   ;; company-mode 
   `(company-tooltip ((,c :background ,bg-dim)))
   `(company-tooltip-selection ((,c :background ,bg-active)))
   `(company-scrollbar-bg ((,c :background ,bg-active)))
   `(company-scrollbar-fg ((,c :background ,fg-main)))
   ;; ace-window
   `(aw-background-face ((,c :foreground ,fg-dim)))
   `(aw-leading-char-face ((,c :foreground ,bg-main :background ,bg-red-intense :height 1.0)))
   ;; org-mode
   `(org-block ((,c :background ,bg-hl-line)))
   `(org-block-begin-line ((,c :background ,bg-hl-line :foreground ,fg-dim)))
   ;; idle-highlight-mode
   `(idle-highlight ((,c :background ,bg-hover)))
   ;; emacs scroll-bar
   `(scroll-bar ((,c :background ,bg-region)))
   ;; restclient-mode
   `(restclient-method-face ((,c :background ,bg-yellow-intense :foreground ,bg-main :weight bold)))
   `(restclient-url-face ((,c :foreground ,blue :weight bold :underline t)))
   `(restclient-header-name-face ((,c :foreground ,yellow)))
   ;; solaire-mode
  `( solaire-default-face ((,c :ihnerit default :background ,bg-dim)))
  `( solaire-line-number-face ((,c :ihnerit default)))
  `( solaire-hl-line-face ((,c :ihnerit default))))
  
  ;; my custom faces for colorizing hexl-mode
  (defface oxcl/hexl-printable-face `((t (:foreground ,yellow))) "Face for highlighting hex codes that are in the ascii printable range")
  (defface oxcl/hexl-null-face `((t (:foreground ,fg-dim))) "Face for highlighting 0 or null hex codes"))


(provide 'gruvbox-material-extras)
