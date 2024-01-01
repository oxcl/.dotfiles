{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # since rofi-blocks was not available in nixpkgs i wrote my own flake for it.
    rofi-blocks = {
        url = "github:oxcl/rofi-blocks-nix";
    };
  };

  outputs = { self, nixpkgs,home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
	inherit system;
	config = {allowUnfree = true;};
      };
    in
    {
    
      nixosConfigurations = {
	main = nixpkgs.lib.nixosSystem {
	  inherit pkgs;
          specialArgs = {inherit inputs;};
          modules = [
            ./nixos/main/configuration.nix
          ];
        };
        work = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/work/configuration.nix
          ];
        };
      };
      # this is useful if you want to setup home-manager without nixos
      homeConfiguration = {
        main = home-manager.lib.homeManageConfiguration {
          inherit pkgs;
          modules = [ ./home-manager/main.nix ];
        };
      };
    };
}
