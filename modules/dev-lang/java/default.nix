{ config, pkgs, lib, ... }: {
	config = {

		programs.java = {
			enable = false; # TODO
			package = pkgs.jdk;
		};

		home.sessionVariables = {

		};

	};
}
