{ pkgs, ... }: {

	config = {

		home.packages = with pkgs; [

			# Docker compose but with podman.
			podman-compose

			# Used to handle uid/gid mapping.
			# NOTE: Needs the following commands to be run after changing:
			#       * `sudo setcap cap_setgid+eip "$(readlink -f $(which newgidmap))"`
			#       * `sudo setcap cap_setuid+eip "$(readlink -f $(which newuidmap))"`
			shadow

		];

		# https://nix-community.github.io/home-manager/options.xhtml#opt-services.podman.enable
		services.podman = {
			enable = true;
			package = pkgs.podman;
			enableTypeChecks = true;

			# https://nix-community.github.io/home-manager/options.xhtml#opt-services.podman.autoUpdate.enable
			autoUpdate = {
				enable = false; # default
				onCalendar = "Sun *-*-* 00:00"; # default
			};

			# https://nix-community.github.io/home-manager/options.xhtml#opt-services.podman.settings.containers
			settings = {

				# containers.conf configuration
				containers = {
					compose_warning_logs = false;
					compose_providers = [
						"${pkgs.podman-compose}/bin/podman-compose"
					];
				};

				# mounts.conf configuration
	#			mounts = []; << missing

				# storage.conf configuration
				storage = {};

				registries = {
					search = [
						"docker.io"
					];
				};

			};

		};

	};

}
