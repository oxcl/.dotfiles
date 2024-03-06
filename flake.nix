{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # since rofi-blocks was not available in nixpkgs i wrote my own flake for it.
    rofi-blocks = {
      url = "github:oxcl/rofi-blocks-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gruvbox-material-gtk = {
      url = "github:oxcl/gruvbox-material-gtk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs,unstable-nixpkgs,home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    unstable-overlay = final: prev: {
      unstable = import unstable-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
    overlays = [
      unstable-overlay
      inputs.rofi-blocks.overlay
      inputs.gruvbox-material-gtk.overlays.default
    ];
    pkgs = import inputs.nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      main = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {inherit inputs; };
        modules = [
          ./hosts/main/configuration.nix
        ];
      };
      work = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/work/configuration.nix
        ];
      };
    };
  };
}
