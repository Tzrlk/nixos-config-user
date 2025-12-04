{ config, inputs, ... }: {

	imports = [
		./dev-lang
		./dev-tools
		./sys-tools
	];

	config = {

		home = {

			# Home-manager config compatibility
			stateVersion = "25.05";

			# User details
			homeDirectory = "/home/${config.home.username}";

			# User-specific packages
			packages = [
				inputs.system-manager
			];

		};

		# Let home-manager manage itself.
		programs.home-manager.enable = true;

		manual = {
			json.enable = true; # <profile>/share/doc/home-manager/options.json
			manpages.enable = true;
		};

		nix = {

			# A declarative alternative to Nix channels. Whereas with stock
			# channels, you would register URLs and fetch them into the Nix store
			# with nix-channel(1), this option allows you to register the store
			# path directly. One particularly useful example is registering flake
			# inputs as channels.
			channels = inputs;

			gc = {
				automatic  = true;
				dates      = "weekly";
				persistent = true;
			};

			# Adds new directories to the Nix expression search path.
			# Used by Nix when looking up paths in angular brackets
			# (e.g. <nixpkgs>).
			nixPath = [
				"nixpkgs=${inputs.nixpkgs}"
			];

			# User level flake registry.
			registry = {
				nixpkgs.flake = inputs.nixpkgs;
			};

			# https://nix-community.github.io/home-manager/options.xhtml#opt-nix.settings
			settings = {};

		};

		# Reload systemd when config changes.
		systemd.user = {
			startServices = "sd-switch";
		};

		# NOTE: Wayland config is just customisation of the systemd trigger, and
		#       configuring a window manager.

		# NOTE: XSession is the X11 display config, and is in competition to
		#       wayland. WSLg uses wayland/weston, so this should generally be
		#       avoided.

	};

}

