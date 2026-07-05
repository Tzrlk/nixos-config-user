{
  description = "NixOS User Configuration";

  nixConfig = {
    #    substituters = [ "https://watersucks.cachix.org" ];
    #    trusted-public-keys = [
    #      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    #    ];
  };

  inputs = {

    # Flake Utils
    systems.url = "github:nix-systems/x86_64-linux";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-flake-tests.url = "github:antifuchs/nix-flake-tests";
    nixtest.url = "gitlab:TECHNOFAB/nixtest?dir=lib";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Complex utils
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ./home
        ./lib
        ./overlays
        ./templates
        ./tooling
      ];

      perSystem = { system, ... }: {

        # Consistent 'pkgs' flake module argument across systems.
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            #            self.overlays.lib
          ];
        };

      };

    };

}
