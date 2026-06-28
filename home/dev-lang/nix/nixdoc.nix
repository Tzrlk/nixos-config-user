{ pkgs, ... }: {
	config = {

    # Nix doc generation
		home.packages = with pkgs; [
			nixdoc
		];

	};
}
