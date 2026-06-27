{ config, pkgs, ... }: {

	config = {

		home.packages = with pkgs; [

			# Make sure we have a groovy sdk available.
			groovy

			# Also grab an LSP for extra inspections.
			groovy-language-server

		];

		# Put the groovy library code somewhere the IDE can use it.
		xdg.dataFile = {
			groovy.source = "${pkgs.groovy}";
		};

	};

}
