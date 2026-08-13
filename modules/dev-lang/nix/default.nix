{ inputs, pkgs, ... }: {

	config = {

		home.packages = with pkgs; [

			# Nix LSP
			nixd

			# Nix doc generation
			nixdoc

			# Nix formatter
			nixfmt

			# Nix Typing
			inputs.typenix.packages.${pkgs.system}.typenix

		];

	};
}
