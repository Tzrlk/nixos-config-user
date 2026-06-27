{ pkgs, ... }: {

	imports = [
		./plugins.nix
		./settings.nix
	];

	programs.vim = {
		enable = true;
		packageConfigurable = pkgs.vim-full;
	};

	home.sessionVariables = {
		EDITOR = "gvim -f";
		VISUAL = "gvim -f";
	};

}
