{ pkgs, ... }: {

	# Add all the necessary packages explicitly.
	home.packages = with pkgs; [
		gnome-keyring
		libsecret
	];

	# Export session vars to improve integrations.
	home.sessionVariables = {
		GNOME_KEYRING_CONTROL = "\${XDG_RUNTIME_DIR}/keyring";
		SSH_AUTH_SOCK         = "\${XDG_RUNTIME_DIR}/keyring/ssh";
	};

	# Ensures dbus service availability is published, though apparently it's
	# supposed to be enabled by default as part of the package.
	dbus.packages = with pkgs; [
		gnome-keyring
	];

	# This creates a systemd user service.
	services.gnome-keyring = {
		enable     = true;
		package    = pkgs.gnome-keyring;
		components = [
			"pkcs11"
			"secrets"
			"ssh"
		];
	};

#	xdg.dataFile = {
#		"dbus-1/services/org.freedesktop.secrets.service" = {
#			enable = true;
# TODO: write custom dbus service initiator.
#		};
#	};

	# Override startup target to ensure it actually starts, since dbus can't
	# figure that part out for some reason.
	systemd.user.services = {
		gnome-keyring = {
			Install = {
				WantedBy = [ "default.target" ];
			};
		};
	};

}
