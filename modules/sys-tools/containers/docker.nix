{ config, pkgs, lib, ... }: let
	_config = config;
	_docker-cli = _config.programs.docker-cli;
in {

	config = {

		home.packages = with pkgs; [

			# The docker engine.
			docker

			# The actual engine that does the building.
			docker-buildx

		];

		programs.docker-cli = {
			enable    = true;
			configDir = "${config.xdg.configHome}/docker";
			contexts  = {
				podman = {
					Endpoints = {
						docker = "unix:///run/user/${toString _config.home.uid}/podman/podman.sock";
					};
				};
				docker = {
					Endpoints = {
						docker = "unix:///var/run/docker.sock";
					};
				};
			};
		};

		home.file."${_docker-cli.configDir}/config.json".force = true;

	};

}
