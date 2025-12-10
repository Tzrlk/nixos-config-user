{ config, pkgs, lib, ... }: {
	config = {

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

		home.file = {
			".bashrc.d/10-gradle.sh".source = ./gradle-invoker.sh;
		};

	};
}
