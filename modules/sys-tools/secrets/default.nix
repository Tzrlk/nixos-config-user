{ ... }: {

	imports = [
		./gnome-keyring.nix
		./keepass.nix
		./libsecret.nix
	];

	config = {
		programs = {
			keepassxc.enable = true;
			# libsecret is always enabled.
		};
		services = {
			gnome-keyring.enable = true;
		};
	};

}
