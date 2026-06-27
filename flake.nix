{
	description = "NixOS User Configuration";

	inputs = {

		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		systems.url = "github:nix-systems/x86_64-linux";
		nix-flake-tests.url = "github:antifuchs/nix-flake-tests";
		flake-parts.url = "github:hercules-ci/flake-parts";

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

	};

	outputs = inputs @ { self, nixpkgs, flake-parts, ... }:
	  flake-parts.lib.mkFlake { inherit inputs; } (top @ { config, ... }: {
      systems = import inputs.systems;
      imports = [
        ./checks
        ./home
        ./overlays
        ./templates
      ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt-rfc-style; # Most "official" formatter.
      };

	  });

}
