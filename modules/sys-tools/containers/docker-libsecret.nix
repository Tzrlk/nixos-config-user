{ config, pkgs, lib, ... }: let
	_config = config;
	_docker = _config.programs.docker-cli;
in {

	config = lib.mkIf _docker.enable {

		# Includes the dbus secretservice helper.
		home.packages = with pkgs; [
			docker-credential-helpers
		];

		programs.docker-cli = {
			settings.credStore = "secretservice";
		};

	};

}
