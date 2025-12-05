{
	description = "NixOS User Configuration";

	inputs = {

		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		systems.url = "github:nix-systems/x86_64-linux";
		nix-flake-tests.url = "github:antifuchs/nix-flake-tests";
		flake-parts.url = "github:hercules-ci/flake-parts";

		flake-utils = {
			url = "github:numtide/flake-utils";
			inputs.systems.follows = "systems";
		};
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Resources
		nixpkgs-ruby = {
			url = "github:bobvanderlinden/nixpkgs-ruby";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-jetbrains-plugins = {
			url = "github:theCapypara/nix-jetbrains-plugins";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Only used to add the system manager tool to the user path, not to
		# actually build any config.
		system-manager = {
			url = "github:numtide/system-manager/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	outputs = inputs @ {
 		self,
 		nixpkgs,
 		flake-utils,
		home-manager,
		...
	}: let

		# Resolve any local overrides.
		locals =
			if builtins.pathExists ./locals.nix
			then import ./locals.nix
			else {};
		system = locals.system
			or (builtins.head inputs.system);
		username = locals.username
			or "nixos";

	in {
		overlays.default = self.overlays.${system};
		nixosModules.default = self.nixosModules.${system};
		homeConfigurations.default = self.homeConfigurations.${system};

	} // flake-utils.lib.eachDefaultSystem (system: {

		#######################################################################
		# Expose overlays
		overlays = import ./overlays {};

		#######################################################################
		# Exposing the config directly as modules.
		nixosModules = ./modules;

		#######################################################################
		# Home configs for applying config directly.
		homeConfigurations = home-manager.lib.homeManagerConfiguration {
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};
			modules = [
				./modules
				({ ... }: {
					home = {
						stateVersion  = "25.05";
						username      = username;
						homeDirectory = "/home/${username}";
					};
				})
			];
			extraSpecialArgs = {
				inherit inputs;
				inherit system;
			};
		};

	});
}
