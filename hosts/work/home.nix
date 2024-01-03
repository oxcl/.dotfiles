{ config, pkgs, ... }:

{
  imports = [ ../base/home.nix ];
  home.packages = with pkgs; [
    wezterm # wezterm is sluggish in VMs
  ];

  home.sessionVariables = {
    MY_NIX_HOST="work"
  }
}
