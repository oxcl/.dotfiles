(setq theme-bg-dim          (getenv "MY_THEME_BG_DIM")
      theme-bg0             (getenv "MY_THEME_BG0")         
      theme-bg              (getenv "MY_THEME_BG")          
      theme-bg1             (getenv "MY_THEME_BG1")            
      theme-bg2             (getenv "MY_THEME_BG2")           
      theme-bg3             (getenv "MY_THEME_BG3")           
      theme-bg4             (getenv "MY_THEME_BG4")           
      theme-bg5             (getenv "MY_THEME_BG5")           
      theme-bg6             (getenv "MY_THEME_BG6")           
      theme-bg7             (getenv "MY_THEME_BG7")           
      theme-bg8             (getenv "MY_THEME_BG8")       
      theme-bg-green        (getenv "MY_THEME_BG_GREEN")
      theme-bg-green-subtle (getenv "MY_THEME_BG_GREEN_SUBTLE")
      theme-bg-red          (getenv "MY_THEME_BG_RED")
      theme-bg-red-subtle   (getenv "MY_THEME_BG_RED_SUBTLE")
      theme-bg-blue         (getenv "MY_THEME_BG_BLUE")
      theme-bg-blue-subtle  (getenv "MY_THEME_BG_BLUE_SUBTLE")
      theme-bg-yellow       (getenv "MY_THEME_BG_YELLOW")
      theme-fg-dim          (getenv "MY_THEME_FG_DIM")
      theme-fg	            (getenv "MY_THEME_FG")         
      theme-red	            (getenv "MY_THEME_RED")      
      theme-orange	    (getenv "MY_THEME_ORANGE")      
      theme-yellow	    (getenv "MY_THEME_YELLOW")       
      theme-green	    (getenv "MY_THEME_GREEN")        
      theme-aqua	    (getenv "MY_THEME_AQUA")          
      theme-blue	    (getenv "MY_THEME_BLUE")       
      theme-purple	    (getenv "MY_THEME_PURPLE")
      theme-red-subtle      (getenv "MY_THEME_RED_SUBTLE")
      theme-orange-subtle   (getenv "MY_THEME_ORANGE_SUBTLE")
      theme-yellow-subtle   (getenv "MY_THEME_YELLOW_SUBTLE")
      theme-green-subtle    (getenv "MY_THEME_GREEN_SUBTLE")
      theme-aqua-subtle     (getenv "MY_THEME_AQUA_SUBTLE")
      theme-blue-subtle     (getenv "MY_THEME_BLUE_SUBTLE") 
      theme-purple-subtle   (getenv "MY_THEME_PURPLE_SUBTLE")
      theme-dark-grey       (getenv "MY_THEME_DARK_GREY")
      theme-grey            (getenv "MY_THEME_GREY") 
      theme-light-grey      (getenv "MY_THEME_LIGHT_GREY"))

(defgroup doom-my-theme nil
  "Options for the `doom-my-theme' theme."
  :group 'doom-themes)

(defcustom doom-my-theme-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-my-theme
  :type 'boolean)

(defcustom doom-my-theme-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-my-theme
  :type 'boolean)

(defcustom doom-my-theme-comment-bg doom-my-theme-brighter-comments
  "If non-nil, comments will have a subtle highlight to enhance their
legibility."
  :group 'doom-my-theme
  :type 'boolean)

(defcustom doom-my-theme-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-my-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-my
  "A dark theme inspired by Atom One Dark."

  ;; name        default   256           16
  ((bg         `(,theme-bg "black"       "black"  ))
   (fg         `(,theme-fg "#bfbfbf"     "brightwhite"  ))

   ;; These are off-color variants of bg/fg, used primarily for `solaire-mode',
   ;; but can also be useful as a basis for subtle highlights (e.g. for hl-line
   ;; or region), especially when paired with the `doom-darken', `doom-lighten',
   ;; and `doom-blend' helper functions.
   (bg-alt     `(,theme-bg1 "black"       "black"        ))
   (fg-alt     `(,theme-fg "#2d2d2d"     "white"        ))

   ;; These should represent a spectrum from bg to fg, where base0 is a starker
   ;; bg and base8 is a starker fg. For example, if bg is light grey and fg is
   ;; dark grey, base0 should be white and base8 should be black.
   (base0      `(,theme-bg-dim "black"       "black"        ))
   (base1      `(,theme-bg0     "brightblack"  ))
   (base2      `(,(doom-darken theme-bg 0.2) "#2e2e2e"     "brightblack"  ))
   (base3      `(,theme-bg1 "#262626"     "brightblack"  ))
   (base4      `(,theme-bg3 "#3f3f3f"     "brightblack"  ))
   (base5      `(,theme-bg5 "#525252"     "brightblack"  ))
   (base6      `(,theme-bg8 "#6b6b6b"     "brightblack"  ))
   (base7      `(,theme-light-grey     "brightblack"  ))
   (base8      `(,theme-fg "#dfdfdf"     "white"        ))

   (grey       theme-grey)
   (red        `(,theme-red "#ff6655" "red"          ))
   (orange     `(,theme-orange "#dd8844" "brightred"    ))
   (green      `(,theme-green "#99bb66" "green"        ))
   (teal       `(,theme-aqua "#44b9b1" "brightgreen"  ))
   (yellow     `(,theme-yellow "#ECBE7B" "yellow"       ))
   (blue       `(,theme-blue "#51afef" "brightblue"   ))
   (dark-blue  `(,theme-blue-subtle "#2257A0" "blue"         ))
   (magenta    `(,theme-purple "#c678dd" "brightmagenta"))
   (violet     `(,theme-purple-subtle "#a9a1e1" "magenta"      ))
   (cyan       `(,theme-aqua "#46D9FF" "brightcyan"   ))
   (dark-cyan  `(,theme-aqua-subtle "#5699AF" "cyan"         ))

   ;; These are the "universal syntax classes" that doom-themes establishes.
   ;; These *must* be included in every doom themes, or your theme will throw an
   ;; error, as they are used in the base theme defined in doom-themes-base.
   (constants      fg)
   (functions      cyan)
   (keywords       red)
   (methods        cyan)
   (operators      orange)
   (type           yellow)
   (strings        green)
   (variables      fg)
   (numbers        magenta)
   (builtin        dark-cyan)
   (highlight      base7)
   (vertical-bar   base2)
   (comments       (if doom-my-theme-brighter-comments theme-light-grey grey))
   (doc-comments   (if doom-my-theme-brighter-comments green theme-green-subtle))

   (selection      red)
   (region         theme-bg6)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; These are extra color variables used only in this theme; i.e. they aren't
   ;; mandatory for derived themes.
   (modeline-fg              theme-fg-dim)
   (modeline-fg-alt          theme-fg-dim)
   (modeline-bg              (if doom-my-theme-brighter-modeline
                                 base5
                               base4))
   (modeline-bg-alt          (if doom-my-theme-brighter-modeline
                                 base5
                               base4))
   (modeline-bg-inactive     `(,(car bg-alt) ,@(cdr base1)))
   (modeline-bg-inactive-alt `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg)))

   (-modeline-pad
    (when doom-my-theme-padded-modeline
      (if (integerp doom-my-theme-padded-modeline) doom-my-theme-padded-modeline 4))))


  ;;;; Base theme face overrides
  (((line-number &override) :foreground base6)
   ((line-number-current-line &override) :foreground fg)
   ((font-lock-comment-face &override)
    :background (if doom-my-theme-comment-bg (doom-lighten bg 0.05) 'unspecified))
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if doom-my-theme-brighter-modeline base8 highlight))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if doom-my-theme-brighter-modeline modeline-bg highlight))
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'mode-line-emphasis :weight 'bold)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; ivy
   (ivy-current-match :background dark-blue :distant-foreground base0 :weight 'normal)
   ;;;; LaTeX-mode
   (font-latex-math-face :foreground green)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;;;; rjsx-mode
   (rjsx-tag :foreground red)
   (rjsx-attr :foreground orange)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt)))

   ;;;; hl-line
   (hl-line :background base3)
   ;;;; tree-sitter
   (font-lock-operator-face :foreground operators)
   (font-lock-escape-face   :foreground yellow)
   (font-lock-delimiter-face :foreground theme-yellow-subtle)
   (font-lock-doc-markup-face :foreground green)
   (font-lock-preprocessor-face :foreground theme-red-subtle)
   (font-lock-property-name-face :foreground blue)
   ;;;; idle highlight
   (idle-highlight :background base4)))
