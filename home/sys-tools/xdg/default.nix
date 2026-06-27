{ config, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.enable
	# More specific settings are configured in appropriate application config.
	xdg = {
		enable = true;

		autostart = {
			enable = true;
			readOnly = true;
		};

		# XDG home directories
		cacheHome = "${config.home.homeDirectory}/.cache";
		configHome = "${config.home.homeDirectory}/.config";
		dataHome = "${config.home.homeDirectory}/.local/share";

		mime.enable = true;
		mimeApps.enable = true;

		# https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable
		# https://github.com/flatpak/xdg-desktop-portal
		portal = {
			enable = false; # TODO: Requires impl
			xdgOpenUsePortal = true;
		};

	};

#	systemd.user.services.dbus = {
#		Service = {
#			Environment = {
#				XDG_RUNTIME_DIR = "/run/user/1000";
#				DISPLAY         = ":0";
#			};
#		};
#	};

}
