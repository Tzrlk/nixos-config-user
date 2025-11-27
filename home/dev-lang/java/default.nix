{ config, pkgs, lib, ... }: {

	programs.java = {
		enable = false; # TODO
		package = pkgs.jdk;
	};

}
