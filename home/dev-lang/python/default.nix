{ config, pkgs, lib, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.pyenv.enable
	programs.pyenv = {
		enable = true;
		package = pkgs.pyenv;
		enableBashIntegration = true;
		rootDirectory = "${config.xdg.dataHome}/pyenv";
	};

}
