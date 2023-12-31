{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];
  home.packages = [
    wezterm # wezterm is sluggish in VMs
  ];
 
  home.file = {

  };
}
