{
	description = "NixOS User Configuration";

	inputs = {

		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		systems.url = "github:nix-systems/x86_64-linux";
		nix-flake-tests.url = "github:antifuchs/nix-flake-tests";

		flake-utils = {
			url = "github:numtide/flake-utils";
			inputs.systems.follows = "systems";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
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
 		flake-utils,
		home-manager,
		nix-flake-tests,
		...
	}: (let

		# Used for iterating over the selected systems.
		defaultSystems = flake-utils.lib.defaultSystems;
		eachSystem = flake-utils.lib.eachSystemPassThrough defaultSystems;

		# Resolve any local overrides.
		locals =
			if builtins.pathExists ./locals.nix
			then import ./locals.nix
			else {};
		system' = locals.system
			or (builtins.head inputs.system);
		username = locals.username
			or "nixos";

		pkgs = eachSystem (system: {
			${system} = import inputs.nixpkgs {
				inherit system;
				overlays = [
					self.overlays.default
				];
			};
		});

	in {

		#######################################################################
		# Expose overlays
		overlays = {
			allow-unfree           = import ./overlays/allow-unfree.nix;
			allow-unfree-jetbrains = import ./overlays/allow-unfree-jetbrains.nix;
			git-libsecret          = import ./overlays/git-libsecret.nix;
			default                = import ./overlays;
		};

		#######################################################################
		# Exposing the config directly as modules.
		nixosModules = {
			default = self.nixosModules.home;
			home    = import ./home;
		};

		#######################################################################
		# Home configs for applying config directly.
		homeConfigurations = {
			default = self.homeConfigurations.${system'};
		} // eachSystem (system: {
			${system} = home-manager.lib.homeManagerConfiguration {
				pkgs = pkgs.${system};
				modules = [
					({ ... }: { home.username = username; })
					self.nixosModules.home
				];
				extraSpecialArgs = {
					inherit inputs;
				};
			};
		});

		#######################################################################
		# Development shell
		devShells = eachSystem (system: {
			${system}.default = pkgs.${system}.mkShell {
				name = "nix devShell";
				buildInputs = [
#					pkgs.${system}.nixd
				];
			};
		});

		#######################################################################
 		# Flake tests.
		checks = eachSystem (system: {
			${system}.unit = nix-flake-tests.lib.check {
				pkgs = pkgs.${system};
				tests = {
					placeholder = { expected = 0; expr = 1; };
				};
			};
		});

	});
}
