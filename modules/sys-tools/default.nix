{ pkgs, ... }: {

	imports = [
		./edge
		./gnome-keyring
		./gpg
		./keepass
		./nixos
		./podman
		./shell
		./ssh
		./taskwarrior
		./xdg
		./less.nix
		./man.nix
	];

	config = {

		home.packages = with pkgs; [
			curl

			# Provide better unicode support for symbols.
			noto-fonts
			noto-fonts-color-emoji
			noto-fonts-monochrome-emoji
			unifont
			vista-fonts

		];

		home.file = {
			# Misc scripts. Maybe this should be in xdg or outputs?
			# TODO: Look into programs.script-directory.
			"scripts".source = ./scripts;
		};

	};

}
