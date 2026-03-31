{ pkgs, ... }: {
	config = {

		home.packages = with pkgs; [

			# Nix LSP
			nixd

			# Nix doc generation
			nixdoc

			# Nix formatter
			nixfmt

		];

	};
}
