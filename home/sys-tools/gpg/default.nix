{ config, pkgs, lib, ... }: {

	programs.gpg = {
		enable  = true;
		homedir = "${config.xdg.dataHome}/gnupg";

		mutableKeys  = false;
		mutableTrust = false;

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.publicKeys
		publicKeys = [
		];

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gpg.settings
		# https://gnupg.org/documentation/manpage.html
		settings = {
		};

	};

}
