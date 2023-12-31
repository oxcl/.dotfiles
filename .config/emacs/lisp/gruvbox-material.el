;; based on https://user-images.githubusercontent.com/58662350/213884039-4eac92cc-c23a-4add-8d45-6838daf9d48b.png
(setq modus-operandi-palette-overrides
      '((bg-main "#eddeb5") ; bg1
	(bg-dim "#d5c4a1") ; bg5
	(fg-main "#4f3829") ; fg1
	(fg-dim "#928374") ; grey1
	(bg-active "#ebdbb2") ; bg2
	(bg-inactive "#dac9a5") ; bg4
	(border "#928374") ; grey1
	(red "#c14a4a")
	(red-warmer "#d54b36")
	(red-cooler "#ad4b5f")
	(red-faint "#d79480")
	(red-intense "#ff5f5f")
	(green "#6c782e")
	(green-warmer "#80781a")
	(green-cooler "#587842")
	(green-faint "#adab72")
	(green-intense "#44df44")
	(yellow "#b47109")
	(yellow-warmer "#c35e0a") ;; orange
	(yellow-cooler "#a0701d")
	(yellow-faint "#d1a85f")
	(yellow-intense "#efef00")
	(blue "#45707a")
	(blue-warmer "#597066")
	(blue-cooler "#31718e")
	(blue-faint "#99a798")
	(blue-intense "#338fff")
	(magenta "#945e80")
	(magenta-warmer "#a85e6c")
	(magenta-cooler "#805e94")
	(magenta-faint "#c19e9b")
	(magenta-intense "#ff66ff")
	(cyan "#4c7a5d")
	(cyan-warmer "#607a49")
	(cyan-cooler "#387a71")
	(cyan-faint "#9dac89")
	(cyan-intense "#00eff0")
	(bg-red-intense "#ae5858")
	(bg-green-intense "#6f8352")
	(bg-yellow-intense "#a96b2c")
	(bg-red-subtle "#efd2b3")
	(bg-green-subtle "#d7d9ae")
	(bg-yellow-subtle "#f3deaa")
	(bg-blue-subtle "#d3d5b8")
	(bg-hover "#ebdbb2") ; bg_current_word same as bg2
	(bg-hl-line "#f2e5bc") ; bg0
	(bg-region "#f2e5bc") ; bg0
	(bg-mode-line-active bg-active)
	(bg-mode-line-inactive bg-inactive)
	(border-mode-line-active border)
	(border-mode-line-inactive "#a89984") ; grey0
	(bg-added-refine "#dfe1b4") ; bg_diff_green
	(bg-changed-refine "#dbddbf") ; bg_diff_blue
	(bg-removed-refine "#f7d9b9") ; bg_diff_red
	(bg-search-current yellow-faint)
	(bg-search-lazy bg-inactive)))

(setq modus-vivendi-palette-overrides
      '((bg-main "#3c3836") ;; bg1
	(bg-dim "#252423") ;; bg_dim
	(fg-main "#ddc7a1") ;; fg1
	(fg-dim "#928374") ;; grey1
	(border "#7c6f64") ;; grey0
	(bg-active "#504945") ; bg3
	(bg-inactive "#665c54") ; bg5
	(red "#ea6962") 
	(red-warmer "#fe6060")
	(red-cooler "#ea7074")
	(red-faint "#B04F4A")
	(red-intense "#ff5f5f")
	(green "#a9b665")
	(green-warmer "#bbb765")
	(green-cooler "#65b673")
	(green-faint "#8C9853")
	(green-intense "#44df44")
	(yellow "#d8a657")
	(yellow-warmer "#e78a4e") ;; orange
	(yellow-cooler "#d8a775")
	(yellow-faint "#BC904B")
	(yellow-intense "#efef00")
	(blue "#7daea3")
	(blue-warmer "#88aea3")
	(blue-cooler "#7da0ae")
	(blue-faint "#689088")
	(blue-intense "#338fff")
	(magenta "#d3869b")
	(magenta-warmer "#d386c1")
	(magenta-cooler "#d39886")
	(magenta-faint "#B77586")
	(magenta-intense "#ff66ff")
	(cyan "#89b482")
	(cyan-warmer "#aab482")
	(cyan-cooler "#7da8ad")
	(cyan-faint "#73986d")
	(cyan-intense "#00eff0")
	(bg-red-intense "#ea6962")
	(bg-green-intense "#a9b665")
	(bg-yellow-intense "#d8a657")
	(bg-red-subtle "#543937")
	(bg-green-subtle "#424a3e")
	(bg-yellow-subtle "#574833")
	(bg-blue-subtle "#404946")
	(bg-hover "#45403d") ; bg_current_word 
	(bg-hl-line "#32302f") ; bg0
	(bg-region "#665c54") ; b5
	(bg-mode-line-active "#5b534d") ; bg_statusline3
	(bg-mode-line-inactive "#46413e") ; bg_statusline2
	(border-mode-line-active border)
	(border-mode-line-inactive bg-inactive) ; grey0
	(bg-added-refine "#3d4220") ; bg_diff_green
	(bg-changed-refine "#0f3a42") ; bg_diff_blue
	(bg-removed-refine "#472322") ; bg_diff_red
	(bg-search-current yellow-faint)
	(bg-search-lazy bg-inactive)))

(setq modus-themes-common-palette-overrides
      '((fg-alt blue-warmer)
	(bg-magenta-subtle unspecified)
	(bg-cyan-subtle unspecified)
	(bg-blue-intense unspecified)
	(bg-magenta-intense unspecified)
	(bg-cyan-intense unspecified)
	(bg-completion "#ff0000")
	(fg-region  unspecified)
	(bg-char-0 bg-blue-intense)
	(bg-char-1 bg-red-intense)
	(bg-char-2 bg-yellow-intense)
	(fg-mode-line-inactive fg-dim)
	(fg-mode-line-active fg-main)
	(modeline-err red-warmer)
	(modeline-warning yellow-warmer)
	(modeline-info cyan-cooler)
	;;(bg-tab-bar "#313131")
	;;(bg-tab-current "#000000")
	;;(bg-tab-other "#545454")
	(bg-added bg-green-subtle)
	(bg-added-fringe bg-added)
	(bg-added-faint unspecified)
	(fg-added unspecified)
	(fg-added-intense unspecified)
	(bg-changed bg-blue-subtle)
	(bg-changed-fringe bg-changed)
	(bg-changed-faint unspecified)
	(fg-changed unspecified)
	(fg-changed-intense unspecifed)
	(bg-removed bg-red-subtle)
	(bg-removed-fringe bg-removed)
	(bg-removed-faint unspecified)
	(fg-removed unspecified)
	(fg-removed-intense unspecified)
	(bg-diff-context bg-hover)
	(bg-paren-match cyan-faint)
	(fringe bg-main)
	(string green)
	(keyword red)
	(type yellow)
	(comment fg-dim)
	(docstring fg-dim)
	(preprocessor magenta)
	(constant yellow)
	(variable blue)
	(fnname cyan)
	;;(bg-search-replace bg-red-intense)
	;;(bg-search-rx-group-0 bg-blue-intense)
	;;(bg-search-rx-group-1 bg-green-intense)
	;;(bg-search-rx-group-2 bg-red-subtle)
	;;(bg-search-rx-group-3 bg-magenta-subtle)
	(fg-completion-match-0 blue)
	(fg-completion-match-1 yellow)
	(fg-completion-match-2 cyan)
	(fg-completion-match-3 red)
	(bg-completion-match-0 unspecified)
	(bg-completion-match-1 unspecified)
	(bg-completion-match-2 unspecified)
	(bg-completion-match-3 unspecified)
	(fg-prompt cyan)
        (bg-prompt bg-region)
	(org-block-begin-line bg-dim)
	;; used by flyspell
	(underline-warning green-faint)
	(underline-err green-faint)))

(defun oxcl/disable-loose-color ()
  (custom-set-faces
   `(minibuffer-prompt ((t (:background ,(modus-themes-get-color-value 'bg-region t)
					:foreground ,(modus-themes-get-color-value 'cyan t)))))))
(defun oxcl/enable-loose-color ()
  (custom-set-faces
   `(minibuffer-prompt ((t (:background ,(modus-themes-get-color-value 'cyan t)
					:foreground ,(modus-themes-get-color-value 'bg-main t)))))))
;;  (add-hook 'isearch-mode-end-hook 'oxcl/disable-loose-color nil t))
;;(add-hook 'isearch-mode-hook (lambda ()
;;			       (if (bound-and-true-p oxcl/loose-search) (oxcl/enable-loose-color) (oxcl/disable-loose-color))))

(provide 'gruvbox-material)
