{ config, pkgs, lib, ... }: {
	config = {

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.enable
		programs.go = {
			enable = true;

			# Packages to add to GOPATH
			# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.go.packages
			packages = {
			};

		};

	};
}
