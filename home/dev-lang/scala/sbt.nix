{ config, pkgs, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.sbt.enable
	programs.sbt = {
		enable = true;
		package = pkgs.sbt;
		baseUserConfigPath = ".sbt"; # Move to XDG?

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.sbt.plugins
		plugins = [];

		repositories = [
			"maven-local"
			"maven-central"
		];

	};

}
