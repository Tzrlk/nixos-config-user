{ pkgs, lib, config, ... }: with lib; {
	config = let

		# In case we need to cook something in the install.
		package = pkgs.gnome-keyring;

		# Reference to the final config.
		cfg = config.services.gnome-keyring;

	in mkIf cfg.enable {

		# Export session vars to improve integrations.
		home.sessionVariables = {
			GNOME_KEYRING_CONTROL = "\${XDG_RUNTIME_DIR}/keyring";
			SSH_AUTH_SOCK         = "\${XDG_RUNTIME_DIR}/keyring/ssh";
		};

		# This creates a systemd user service.
		services.gnome-keyring = {
			inherit package;
			components = [
				"pkcs11"
				"secrets"
				"ssh"
			];
		};

		# Ensures dbus service availability is published, though apparently
		# it's supposed to be enabled by default as part of the package.
		dbus.packages = [ cfg.package ];

		# Override startup target to ensure it actually starts, since dbus
		# can't figure that part out for some reason.
		systemd.user.services = {
			gnome-keyring = {
				Install = {
					WantedBy = [ "default.target" ];
				};
			};
		};

		#	xdg.dataFile = {
		#		"dbus-1/services/org.freedesktop.secrets.service" = {
		#			enable = true;
		# TODO: write custom dbus service initiator.
		#		};
		#	};

	};
}
