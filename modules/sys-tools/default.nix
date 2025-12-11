{ pkgs, ... }: {

	imports = [
		./edge
		./gnome-keyring
		./gpg
		./nixos
		./podman
		./shell
		./ssh
		./taskwarrior
		./xdg
		./jq.nix
		./less.nix
		./man.nix
	];

	config = {

		home.packages = with pkgs; [
			curl
		];

		home.file = {
			# Misc scripts. Maybe this should be in xdg or outputs?
			# TODO: Look into programs.script-directory.
			"scripts".source = ./scripts;
		};

	};

}
