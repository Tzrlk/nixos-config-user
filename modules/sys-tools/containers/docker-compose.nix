{ config, pkgs, lib, ... }: let
	_config = config;
	_docker = _config.programs.docker-cli;
in {

	config = lib.mkIf _docker.enable {

		home.packages = with pkgs; [

			# The original docker compose.
			docker-compose

			# LSP for docker compose files.
			docker-compose-language-service

		];

		# Make sure podman has docker-compose on its provider list.
		services.podman = {
			settings.containers.engine = {
				compose_providers = [
					"${pkgs.docker-compose}/bin/docker-compose"
				];
			};
		};

	};

}
