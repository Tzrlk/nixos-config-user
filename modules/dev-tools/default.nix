{ pkgs, ... }: {

	imports = [
		./editorconfig.nix
		./git
		./jetbrains
		./pandoc.nix
		./vim
		./vscode
	];

	config = {

		home.packages = with pkgs; [
			antlr4_12
			nixd
		];

	};

}
