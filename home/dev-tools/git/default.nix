{ pkgs, ... }: {

	imports = [
		./aliases.nix
		./commands.nix
		./display.nix
		./security.nix
	];

	config = let

		package = pkgs.git.override { # Might need to do this with an overlay.
			withLibsecret = true;
		};

	in {
		programs.git = {
			enable = true;
			inherit package;

			lfs.enable = true;

			settings = {
				user.name = "Peter Cummuskey";
				i18n.filesEncoding = "utf-8";
				core = {
					eol = "lf"; # Replaces autocrlf="input"
					ignoreCase = false;
				};
			};

		};
	};

}
