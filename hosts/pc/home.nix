{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];
  home.packages = with pkgs; [
    wezterm # wezterm is sluggish in VMs
  ];
 
  home.file = {

  };
}
