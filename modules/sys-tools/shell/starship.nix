# Ultra-fancy shell prompts
{ pkgs, ... }: {

	home.packages = with pkgs; [ starship ];

	# https://wiki.nixos.org/wiki/Starship
	# https://starship.rs/config/
	# https://gist.github.com/s-a-c/0e44dc7766922308924812d4c019b109#file-starship-nix/
	programs.starship = {
		enable = true;
		settings = {
#			add_newline = true; # Already done via PS1
		};
	};

}
