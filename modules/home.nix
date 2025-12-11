{ ... }: {
	config = {

		home = {

			preferXdgDirectories = true;

		};

		# Let home-manager manage itself.
		programs.home-manager.enable = true;

		manual = {
			json.enable = true; # <profile>/share/doc/home-manager/options.json
			manpages.enable = true;
		};

		# Reload systemd when config changes.
		systemd.user = {
			startServices = "sd-switch";
		};

		# NOTE: Wayland config is just customisation of the systemd trigger, and
		#       configuring a window manager.

		# NOTE: XSession is the X11 display config, and is in competition to
		#       wayland. WSLg uses wayland/weston, so this should generally be
		#       avoided.

	};
}
