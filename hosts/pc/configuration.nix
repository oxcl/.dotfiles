# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../base.nix
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts-emoji
    vazir-fonts
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users.user = import ../../home-manager/main.nix;
  };
}

