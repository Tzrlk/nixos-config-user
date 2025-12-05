{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gradle.enable
	programs.gradle = {
		enable = false; # TODO
		home   = "${config.xdg.dataHome}/gradle";

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gradle.initScripts
		initScripts = {
		};

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gradle.settings
		settings = {
			"org.gradle.caching" = true;
			"org.gradle.parallel" = true;
			"org.gradle.jvmargs" = "";
#			"org.gradle.home" = pkgs.jdk17;
		};

	};

}
