{ config, pkgs, lib, ... }: {
	config = {

		# TODO: JBang

		programs.java = {
			enable = false; # TODO
			package = pkgs.jdk;
		};

		home.sessionVariables = {

		};

	};
}
