{ pkgs, lib, config, ... }: {

	config = let
		package = pkgs.keepassxc;

		# TODO: Move this into shared utils.
		symlink = path:
			config.lib.file.mkOutOfStoreSymlink
				"${config.home.homeDirectory}/.config/home-manager/home/${path}";

	in {

		# Add all the necessary packages explicitly.
		home.packages = with pkgs; [
			package
			libsecret
		];

		programs.keepassxc = {
			inherit package;
			enable    = true;
#			autostart = true; # Conflicts with existing autostart file.
		};

		# Save settings as symlink back to project so gui can edit.
		# Make sure user settings are captured in git if they exist.
		xdg.configFile = {
			"keepassxc/keepassxc.ini".source = symlink "keepassxc.ini";
		};

		# KeepassXC package doesn't come with dbus service binding by default,
		# so we need to add it manually.
		# TODO: Swap from gnome-keyring
#		xdg.dataFile = {
#			"dbus-1/services/org.freedesktop.secrets.service" = {
#				text = lib.strings.join "\n" [
#					"[D-BUS Service]"
#					"Name=org.freedesktop.secrets"
#					"Exec=${package}/bin/keepassxc"
#				];
#			};
#		};

	};

}
