{ ... }: {

	imports = [
		./gnome-keyring.nix
		./keepass.nix
		./libsecret.nix
		./vault.nix
	];

	config = {
		programs = {
			keepassxc.enable = true;
			# vault is usage-specific, so don't enable by default.
		};
		services = {
			gnome-keyring.enable = true;
			# libsecret is always enabled.
		};
	};

}
