{ config, pkgs, ... }: {

	config = {
		home.packages = with pkgs; [

			# Make sure we have a groovy sdk available.
			groovy

			# Also grab an LSP for extra inspections.
			groovy-language-server

		];
	};

}
