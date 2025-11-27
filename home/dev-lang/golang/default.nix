{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.enable
	programs.go = {
		enable = true;

		# Packages to add to GOPATH
		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.packages
		packages = {
		};

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.goPrivate
		env.GOPRIVATE = [
		];

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.telemetry
		telemetry.mode = "off";

	};

}
