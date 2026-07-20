{ config, pkgs, lib, ... }: let
	_config = config;
	_podman = _config.services.podman;
in {

	config = lib.mkIf _podman.enable {

		# Docker compose but with podman.
		home.packages = with pkgs; [
			podman-compose
		];

		services.podman = {
			settings.containers.engine = {
				compose_warning_logs = false;
				compose_providers = [
					"${pkgs.podman-compose}/bin/podman-compose"
				];
			};
		};

	};

}
