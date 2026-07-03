{
	description = "NixOS User Configuration";

	nixConfig = {
    substituters = [ "https://watersucks.cachix.org" ];
    trusted-public-keys = [
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
	};

	inputs = {

    # Utils
		systems.url = "github:nix-systems/x86_64-linux";
		flake-parts.url = "github:hercules-ci/flake-parts";
		nix-flake-tests.url = "github:antifuchs/nix-flake-tests";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Tools
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-gui = {
		  url = "github:nix-gui/nix-gui";
		  inputs.nixpkgs.follows = "nixpkgs";
		};
		optnix = {
		  url = "sourcehut:~watersucks/optnix";
		  inputs.nixpkgs.follows = "nixpkgs";
		};
    nix-tree = {
      url = "github:utdemir/nix-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-output-monitor = {
      url = "github:maralorn/nix-output-monitor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    dix = {
      url = "github:manic-systems/dix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    manix = {
      url = "github:mlvzk/manix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:nix-community/nh";
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

	outputs = inputs @ { self, flake-parts, home-manager, ... }:
	  flake-parts.lib.mkFlake { inherit inputs; } (top @ { config, ... }: {
      systems = import inputs.systems;

      imports = [
        home-manager.flakeModules.home-manager
        ./checks
        ./home
        ./overlays
        ./templates
      ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixfmt; # Most "official" formatter.
      };

	  });

}
