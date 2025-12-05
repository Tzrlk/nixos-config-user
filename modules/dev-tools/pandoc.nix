{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pandoc.enable
	programs.pandoc = {
		enable = true;
		package = pkgs.pandoc;
		defaults = {
			metadata = {
				author = "Peter Cummuskey";
			};
		};
		templates = {};
	};

}
