{
  description = "NixOS User Configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    nix-flake-tests.url = "github:antifuchs/nix-flake-tests";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fromJsonSchema.url = "github:friedow/fromJsonSchema";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix tooling (feels like this should be a sub-flake)
    typenix = {
      url = "github:ryanrasti/typenix";
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
    system = builtins.head inputs.system;

  in {
    nixosModules.default = self.nixosModules.${system};
    homeConfigurations.default = self.homeConfigurations.${system};

    #######################################################################
    # Expose overlays
    overlays = {
      default                = import ./overlays/default.nix;
      allow-unfree           = import ./overlays/allow-unfree.nix;
      allow-unfree-jetbrains = import ./overlays/allow-unfree-jetbrains.nix;
      git-libsecret          = import ./overlays/git-libsecret.nix;
      snowflake-cli          = import ./overlays/snowflake-cli.nix;
      tflint                 = import ./overlays/tflint.nix;
    };

  } // flake-utils.lib.eachDefaultSystem (system: {

    #######################################################################
    # Exposing the config directly as modules.
    nixosModules = ./modules;

    #######################################################################
#    templates = ./templates; # TODO: fix this.

  });
}
