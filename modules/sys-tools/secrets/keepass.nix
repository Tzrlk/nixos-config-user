{ pkgs, lib, config, ... }: with lib; {

# TODO: This will get complicated.
#	options.programs.keepassxc.configFile = mkOption {
#		description = "File-based alternative to nix config.";
#		default     = null;
#		type        = types.nullOr types.file;
#	};

	config = let

		package = pkgs.keepassxc;

		cfg = config.programs.keepassxc;

	in mkIf cfg.enable {

		# Add additional utilities
		home.packages = with pkgs; [
			keepass-diff # Util to compare two keepass files.
			kpcli        # Direct CLI access to keepass files.
		];

		programs.keepassxc = {
			inherit package;
#			autostart = true; # Conflicts with existing autostart file.
		};

		# Save settings as symlink back to project so gui can edit.
		# Make sure user settings are captured in git if they exist.
		xdg.configFile = {
#			"keepassxc/keepassxc.ini".source = symlink "keepassxc.ini";
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
