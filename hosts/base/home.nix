{ config,inputs,lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    cmake
    python3
    git
    git-extras
    rxvt-unicode-emoji # urxvt
    xclip
    lsd
    fzf
    jq
    direnv
    nix-direnv
    unzip
    ncdu
    # (rofi.override { plugins = [ rofi-blocks ]; })
    bat
    # pspg # tui table viewer for databases like postgress and .csv files
    # w3m # terminal browser
    tldr
    ((emacsPackagesFor emacs29).emacsWithPackages ( epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      jinx
    ]))
    gnupg
    # navi
    stow
    libfaketime
    nix-output-monitor
    # gh
    # archive and compression tools
    unrar
    pigz
    pbzip2
    pixz
    lzip
    lz4
    zip
    cabextract
    p7zip
    asciinema
    asciinema-agg
    gifsicle
    fx
    neofetch
    nodejs_21
    zsh-completions
    # thefuck
    # expect
    fq
    # pup
    ttyper
    dconf
    gruvbox-material-gtk
    sxiv
    hyperfine
    unstable.wezterm
    ffmpeg
    mpv
    xorg.xev
    entr
    # microsoft fonts
    vistafonts
    corefonts
    # metric compatible fonts
    liberation_ttf
    # default font
    vazir-fonts
    noto-fonts
    # monospace fonts
    # TODO: custom iozevka
    vazir-code-font
    jetbrains-mono
    # icon fonts
    emacs-all-the-icons-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    poetry
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];
    policies = (builtins.fromJSON (builtins.readFile ../../home/.mozilla/firefox/default/policies.json)).policies;
    profiles = {
      default = {
        isDefault =  true;
        name = "default";
        path = "default";
      };
    };
  };

  # services.gpg-agent = {
  #  enable = true;
  # };

  systemd.user.services.tridactyl-server = {
    Unit.Description = "local http server to host my firefox custom home page";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
    WorkingDirectory = "%h/.mozilla/firefox/default/home";
      ExecStart = "${pkgs.python3}/bin/python3 -m http.server 5743 --bind 127.0.0.1";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  
  home.activation = {
    # automatically run my stow script to setup dotfiles in home directory after every home-manager/nixos rebuild
    stowHome = lib.hm.dag.entryAfter ["writeBoundary"] ''PATH="$PATH:${pkgs.stow}/bin" ${../../home/.local/bin/stowhome} '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
