{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.man.enable
	programs.man = {
		enable = true;
		package = pkgs.man;
		generateCaches = false;
	};

}
