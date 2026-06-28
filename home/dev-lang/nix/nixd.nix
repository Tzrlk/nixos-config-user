{ pkgs, ... }: {
	config = {

    # Nix LSP
		home.packages = with pkgs; [
			nixd
		];

	};
}
