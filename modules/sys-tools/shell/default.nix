{ pkgs, ... }: {

	imports = [
		./bash.nix
		./blesh.nix
		./starship.nix
	];

	config = {

		home.packages = with pkgs; [
			shellcheck
		];

	};

	# TODO:
	# * https://github.com/Bash-it/bash-it
	# * https://github.com/ohmybash/oh-my-bash

}
