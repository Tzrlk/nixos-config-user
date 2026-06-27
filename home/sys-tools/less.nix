{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.less.enable
	programs.less = {
		enable = true;
		package = pkgs.less;
#		config = ""; << missing
#		options = {}; << missing
	};

}
