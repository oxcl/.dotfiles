{ config,inputs,lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  
  # rofi-blocks is an extension to rofi which allows finer control over rofi
  nixpkgs.overlays = [
    inputs.rofi-blocks.overlay
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };


  home.packages = with pkgs; [
    cmake
    python3
    git
    git-extras
    git-crypt # transparently encrypt certain files and folders in a git repository
    qmk
    rxvt-unicode-emoji # urxvt
    xclip
    lsd
    fzf
    jq
    direnv
    nix-direnv
    unzip
    ncdu
    ansible
    noto-fonts-color-emoji
    (rofi.override { plugins = [ rofi-blocks ]; })
    bat
    pspg # tui table viewer for databases like postgress and .csv files
    w3m
    more
    most
    firefox
    browsh
    zoxide
    tldr
    nuspell
    hunspellDicts.en-us-large
    hunspellDicts.en_US-large
    hunspellDicts.fa-ir
    hunspellDicts.fa_IR
    ccls
    ((emacsPackagesFor emacs29).emacsWithPackages (
      epkgs: with epkgs; [ vterm treesit-grammars.with-all-grammars jinx ]
    ))
    jetbrains-mono
    noto-fonts-emoji
    vazir-fonts
    vazir-code-font
    emacs-all-the-icons-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    gnupg
    navi
    stow
    libfaketime
    poke
    nix-output-monitor
    websocat
    gh
    # archive and compression tools
    pigz
    pbzip2
    pixz
    lzip
    lz4
    rar
    zip
    cabextract
    p7zip
    asciinema
    asciinema-agg
    gifsicle
    fx
  ];

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  
  home.activation = {
    # automatically run my stow script to setup dotfiles in home directory after every home-manager/nixos rebuild
    myActivationAction = lib.hm.dag.entryAfter ["writeBoundary"] ''PATH="$PATH:${pkgs.stow}/bin" ${../../home/.local/bin/stowhome} '';
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
