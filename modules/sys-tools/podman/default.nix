{ pkgs, ... }: {

	# NOTE: Required "shadow" package included in system config to ensure
	#       correct permissions.

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
			containers = {};

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

}
