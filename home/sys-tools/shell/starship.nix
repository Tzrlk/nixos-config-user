# Ultra-fancy shell prompts
{ pkgs, ... }: {

	home.packages = with pkgs; [ starship ];

	# see ./.bashrc.d/blesh.sh for activation.

	# https://wiki.nixos.org/wiki/Starship
	# https://starship.rs/config/
	# https://gist.github.com/s-a-c/0e44dc7766922308924812d4c019b109#file-starship-nix/
	programs.starship = {
		enable = true;
		settings = {
		};
	};

}
