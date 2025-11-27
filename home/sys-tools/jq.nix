{ config, pkgs, lib, ... }: {

	programs.jq = {
		enable = true;
		package = pkgs.jq;
#		colors = null;
	};

}
