{
	description = "Personal user (not system) config for nixos.";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-direnv = {
			url = "github:nix-community/nix-direnv";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		direnv-instant = {
			url = "github:Mic92/direnv-instant";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	outputs = inputs @ { self, nixpkgs, home-manager, ... }: let
#		locals = import ./flake.local.nix or {}
		username = "nixos";
		system = "x86_64-linux";

	in {

		homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};
			modules = [
				./home.nix
			];
			extraSpecialArgs = {
				inherit inputs self;
			};
		};
	
	};

}
