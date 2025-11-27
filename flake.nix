{
	description = "NixOS User Configuration";

	inputs = {

		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

		system-manager = {
			url = "github:numtide/system-manager/7865b4a";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-flake-tests = {
			url = "github:antifuchs/nix-flake-tests";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		flake-utils = {
			url = "github:numtide/flake-utils";
			inputs.nixpkgs.follows = "nixpkgs";
		};

	};

	outputs = inputs @ {
 		self,
		nixpkgs,
		system-manager,
		home-manager,
		flake-utils,
		nix-flake-tests,
	}: flake-utils.lib.eachDefaultSystem (system: let

		lib = nixpkgs.lib;

		listCfg = dir: lib.mapAttrsToList
			(file: type: dir + "/${file}")
			(lib.filterAttrs
				(file: type: type != "directory" && (lib.hasSuffix ".nix" file))
				(builtins.readDir dir));

		pkgs = nixpkgs.legacyPackages.${system};

	in {

		# Development shell
		devShells.default = pkgs.mkShell {
			name = "nix devShell";
			buildInputs = with pkgs; [
				nixd
			];
		};

		# Home config.
		homeConfigurations = {
			tzrlk = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = listCfg ./home;
				extraSpecialArgs = {
					inherit inputs;
				};
			};
		};

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
