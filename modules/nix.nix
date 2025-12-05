{ inputs, ... }: {
	config.nix = {

		# A declarative alternative to Nix channels. Whereas with stock
		# channels, you would register URLs and fetch them into the Nix store
		# with nix-channel(1), this option allows you to register the store
		# path directly. One particularly useful example is registering flake
		# inputs as channels.
		channels = inputs;

		gc = {
			automatic  = true;
			persistent = true;
			dates      = "weekly";
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
}
