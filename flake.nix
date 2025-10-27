{
	description = "Personal user (not system) config for nixos.";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
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
		locals   = if (builtins.pathExists ./locals.nix)
		           then (import ./locals.nix)
		           else {};
		system   = locals.system   or "x86_64-linux";
		username = locals.username or "nixos";
		pkgs     = nixpkgs.legacyPackages.${system};

	in {

		homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [
				./home.nix
			];
			extraSpecialArgs = {
				inherit inputs self;
			};
		};
	
	};

}
