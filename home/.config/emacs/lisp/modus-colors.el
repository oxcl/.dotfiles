(provide 'modus-colors)
;; the colors are automatically injeceted in this file using the 'pelz' script i wrote which you can find
;; in my dotfilese (~/.local/bin/pelz).
(setq modus-vivendi-palette-overrides
'((bg-main "#202020")
(bg-dim "#131414")
(fg-main "#d4be98")
(fg-dim "#7c6f64")
(fg-alt "#c6daff")
(bg-active "#32302f")
(bg-inactive "#303030")
(border "#665c54")
(bg-hl-line "#2a2827")

(bg-region "#46403d")
(fg-region unspecified)

(bg-mode-line-active "#46403d")
(fg-mode-line-active "#ddc7a1")
(border-mode-line-active "#5a524c")

(bg-mode-line-inactive "#131414")
(fg-mode-line-inactive "#928374")
(border-mode-line-inactive "#32302f")

(red "#ea6962")
(red-warmer "#ff6b55")
(red-cooler "#ff7f9f")
(red-faint "#b85651")
(red-intense "#ef8f8a")

(green "#a9b665")
(green-warmer "#70b900")
(green-cooler "#00c06f")
(green-faint "#8f9a52")
(green-intense "#b6c17c")

(yellow "#d8a657")
(yellow-warmer "#fec43f")
(yellow-cooler "#dfaf7a")
(yellow-faint "#c18f41")
(yellow-intense "#deb472")

(blue "#7daea3")
(blue-warmer "#79a8ff")
(blue-cooler "#00bcff")
(blue-faint "#68948a")
(blue-intense "#94bcb3")

(magenta "#d3869b")
(magenta-warmer "#f78fe7")
(magenta-cooler "#b6a0ff")
(magenta-faint "#ab6c7d")
(magenta-intense "#dc9eaf")

(cyan "#89b482")
(cyan-warmer "#4ae2f0")
(cyan-cooler "#6ae4b9")
(cyan-faint "#72966c")
(cyan-intense "#a5c69f")

(olive "#9cbd6f")
(slate "#76afbf")
(indigo "#9099d9")
(maroon "#cf7fa7")
(pink "#d09dc0")

(bg-red-intense "#b85651")
(bg-red-subtle "#442e2d")
(bg-red-nuanced "#3c1f1e")

(bg-green-intense "#8f9a52")
(bg-green-subtle "#333e34")
(bg-green-nuanced "#32361a")

(bg-blue-intense "#68948a")
(bg-blue-subtle "#2e3b3b")
(bg-blue-nuanced "#0d3138")

(bg-yellow-intense "#c18f41")
(bg-yellow-subtle "#32302f")
(bg-yellow-nuanced "#473c29")

(bg-lavender "#38325c")
(bg-sage "#0f3d30")

;; modus-themes doesn't have an orange color so we have to use other colors for orange
(rust "#e78a4e") ;; this is orange
(gold "#e78a4e") ;; this is orangeBright
(bg-ochre "#bd6f3e") ;; this is orangeDim

(modeline-err "#ffa9bf")
(modeline-warning "#dfcf43")
(modeline-info "#9fefff")

(bg-completion "#3d3835")

(bg-graph-red-0 "#b52c2c")
(bg-graph-red-1 "#702020")
(bg-graph-green-0 "#0fed00")
(bg-graph-green-1 "#007800")
(bg-graph-yellow-0 "#f1e00a")
(bg-graph-yellow-1 "#b08940")
(bg-graph-blue-0 "#2fafef")
(bg-graph-blue-1 "#1f2f8f")
(bg-graph-magenta-0 "#bf94fe")
(bg-graph-magenta-1 "#5f509f")
(bg-graph-cyan-0 "#47dfea")
(bg-graph-cyan-1 "#00808f")

(bg-hover "#45605e")
(bg-hover-secondary "#654a39")

(bg-char-0 "#0050af")
(bg-char-1 "#7f1f7f")
(bg-char-2 "#625a00")

(bg-tab-bar "#313131")
(bg-tab-current "#000000")
(bg-tab-other "#545454")

(bg-added "#00381f")
(bg-added-faint "#002910")
(bg-added-refine "#034f2f")
(bg-added-fringe "#237f3f")
(fg-added "#a0e0a0")
(fg-added-intense "#80e080")

(bg-changed "#363300")
(bg-changed-faint "#2a1f00")
(bg-changed-refine "#4a4a00")
(bg-changed-fringe "#8a7a00")
(fg-changed "#efef80")
(fg-changed-intense "#c0b05f")

(bg-removed "#4f1119")
(bg-removed-faint "#380a0f")
(bg-removed-refine "#781a1f")
(bg-removed-fringe "#b81a1f")
(fg-removed "#ffbfbf")
(fg-removed-intense "#ff9095")

(bg-diff-context "#1a1a1a")))
