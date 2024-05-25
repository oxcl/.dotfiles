{ config, pkgs, ... }:

{
  imports = [ ../base/home.nix ];
  home.packages = with pkgs; [
    unstable.wezterm # wezterm is sluggish in VMs
    unstable.alacritty
  ];
  home.sessionVariables = {
    MY_NIX_HOST="main";
  };
}
