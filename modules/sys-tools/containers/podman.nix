{ config, pkgs, ... }: let
	_config = config;
in {

	config = {

		home.packages = with pkgs; [

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

				registries = {
					search = [
						"docker.io"
					];
				};

			};

		};

		systemd.user.sockets.podman = {
			Unit = {
				Description = "Podman API Socket";
			};
			Socket = {
				ListenStream = "%t/podman/podman.sock";
				SocketMode = "0660";
			};
			Install = {
				WantedBy = [ "sockets.target" ];
			};
		};

		systemd.user.services.podman = {
			Unit = {
				Description = "Podman API Service";
				Requires = [ "podman.socket" ];
				After = [ "podman.socket" ];
			};
			Service = {
				Type = "exec";
				ExecStart = "${pkgs.podman}/bin/podman system service";
			};
		};

	};

}
