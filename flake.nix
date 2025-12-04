{
	description = "NixOS User Configuration";

	inputs = {

		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		systems.url = "github:nix-systems/default-linux";
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
		home-manager,
		flake-utils,
		nix-flake-tests,
		...
	}: flake-utils.lib.eachDefaultSystem (system: let

		pkgs = import inputs.nixpkgs {
			inherit system;
			overlays = [
				self.overlays.nixpkgs
			];
		};

	in {

		#######################################################################
		# Development shell
		devShells.default = pkgs.mkShell {
			name = "nix devShell";
			buildInputs = with pkgs; [
				nixd
			];
		};

		#######################################################################
		# Expose overlays
		overlays = {
			nixpkgs = ./overlays/nixpkgs;
			default = ./overlays;
		};

		#######################################################################
		# Exposing the config directly as modules.
		nixosModules = {
			default = self.nixosModules.home;
			home    = ./home;
		};

		#######################################################################
		# Home config.
		homeConfigurations = {
			tzrlk   = self.homeConfigurations.default;
			default = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ self.nixosModules.home ];
				extraSpecialArgs = {
					inherit inputs;
				};
			};
		};

		#######################################################################
 		# Flake tests.
		checks = {
			unit = nix-flake-tests.lib.check {
				inherit pkgs;
				tests = {
					placeholder = { expected = 1; expr = 1; };
				};
			};
		};

	});
}
