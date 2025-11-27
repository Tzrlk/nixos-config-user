{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.k9s.enable
	programs.k9s = {
		enable = true;
		package = pkgs.k9s;
		aliases = {};
#		hotKeys = {}; << missing
#		plugins = {}; << missing
		settings = {};
		skins = {};
		views = {};
	};

}
