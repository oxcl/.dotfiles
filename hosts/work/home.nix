{ config, pkgs, ... }:

{
  imports = [ ../base/home.nix ];
  home.packages = with pkgs; [
    # wezterm # wezterm is sluggish in VMs
  ];
}
