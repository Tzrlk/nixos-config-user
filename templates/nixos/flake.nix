{
	description = "Development environment config.";

	nixConfig = {
		pure-eval = false;
		experimental-features = [
			"flakes"
			"nix-command"
		];
	};

	inputs = {

		# Core dependencies
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		systems.url = "github:nix-systems/x86_64-linux";
		nix-flake-tests.url = "github:antifuchs/nix-flake-tests";

		# Managers
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Ugh
		nixpkgs-ruby = {
			url = "github:bobvanderlinden/nixpkgs-ruby";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-jetbrains-plugins = {
			url = "github:theCapypara/nix-jetbrains-plugins";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		# Extensions
		config-user = {
			url = "github:Tzrlk/nixos-config-user";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.systems.follows = "systems";
			inputs.home-manager.follows = "home-manager";
			inputs.system-manager.follows = "system-manager";
			inputs.nixpkgs-ruby.follows = "nixpkgs-ruby";
			inputs.nix-jetbrains-plugins.follows = "nix-jetbrains-plugins";
		};

	};

	outputs = inputs @ {
		self,
		nixpkgs,
		home-manager,
		config-user,
		...
	}: let
		system   = "x86_64-linux";
		username = "";
		hostname = "";

	in {

		#######################################################################
		# NixOS config.
		nixosModules = {};
		nixosConfigurations.${hostname} = null; # TODO

		#######################################################################
		# Home config.
		homeModules.home = ./home;
		homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
				overlays = [
					(final: prev: {

						# Ensure all versions of gnome-keyring aren't using the wrapper scripts that
						# don't exist in this environment.
						gnome-keyring = prev.gnome-keyring.override {
							useWrappedDaemon = false;
						};

					})
				];
			};
			modules = [
				config-user.nixosModules.${system}
				self.nixosModules.home
				({ ... }: {
					home = {
						stateVersion  = "25.05";
						username      = username;
						homeDirectory = "/home/${username}";
					};
				})
			];
			extraSpecialArgs = {
				inherit system;
				inherit inputs;
			};
		};

	};
}
