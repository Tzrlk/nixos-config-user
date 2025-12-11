{ pkgs, ... }: {

	config = {
		home.packages = with pkgs; [

			# Base kotlin compiler & tools
			kotlin

			# Official kotlin repl
			kotlin-interactive-shell

			# LSP for kotlin
			kotlin-language-server

			# Compile kotlin to native binaries.
			kotlin-native

		];
	};

}
