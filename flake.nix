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
	  # https://flake.parts/module-arguments.html
	  flake-parts.lib.mkFlake { inherit inputs; } (top @ { config, withSystem, moduleWithSystem, ... }: {
      systems = import inputs.systems;

      imports = [
      ];

      flake = {

        ## OVERLAYS ##############################################################
        overlays = {
          default                = import ./overlays;
          allow-unfree           = import ./overlays/allow-unfree.nix;
          allow-unfree-jetbrains = import ./overlays/allow-unfree-jetbrains.nix;
          git-libsecret          = import ./overlays/git-libsecret.nix;
        };

        ## MODULES ###############################################################
        homeModules = {
          default     = ./home;
          dev-lang    = ./home/dev-lang;
          bash        = ./home/dev-lang/bash;
          dotnet      = ./home/dev-lang/dotnet;
          golang      = ./home/dev-lang/golang;
          groovy      = ./home/dev-lang/groovy;
          java        = ./home/dev-lang/java;
          k8s         = ./home/dev-lang/k8s;
          kotlin      = ./home/dev-lang/kotlin;
          nix         = ./home/dev-lang/nix;
          nodejs      = ./home/dev-lang/nodejs;
          python      = ./home/dev-lang/python;
          ruby        = ./home/dev-lang/ruby;
          scala       = ./home/dev-lang/scala;
          terraform   = ./home/dev-lang/terraform;
          dev-tools   = ./home/dev-tools;
          cloud       = ./home/dev-tools/cloud;
          codegen     = ./home/dev-tools/codegen;
          data        = ./home/dev-tools/data;
          docs        = ./home/dev-tools/docs;
          git         = ./home/dev-tools/git;
          jetbrains   = ./home/dev-tools/jetbrains;
          vim         = ./home/dev-tools/vim;
          vscode      = ./home/dev-tools/vscode;
          sys-tools   = ./home/sys-tools;
          edge        = ./home/sys-tools/edge;
          gpg         = ./home/sys-tools/gpg;
          nixos       = ./home/sys-tools/nixos;
          podman      = ./home/sys-tools/podman;
          scripts     = ./home/sys-tools/scripts;
          secrets     = ./home/sys-tools/secrets;
          shell       = ./home/sys-tools/shell;
          ssh         = ./home/sys-tools/ssh;
          taskwarrior = ./home/sys-tools/taskwarrior;
          xdg         = ./home/sys-tools/xdg;
          less        = ./home/sys-tools/less.nix;
          man         = ./home/sys-tools/man.nix;
        };

        ## TEMPLATES #############################################################
        defaultTemplate = self.templates.nixos;
        templates       = {

          nixos = {
            path        = ./templates/nixos;
            description = "NixOS and Home manager config";
          };

          ubuntu-wsl = {
            path        = ./templates/ubuntu-wsl;
            description = "System and Home manager config for Ubuntu in WSL2";
          };

        };

      };

      perSystem = { pkgs, ... }: {

        ## CHECKS ################################################################
        checks = {
        };

        ## FORMATTER #############################################################
        formatter = pkgs.nixfmt-rfc-style; # Most "official" formatter.

      };

	  });

}
