{ ... }: {

	imports = [
		./antlr.nix
		./openapi-generator.nix
	];

	config.programs = {
		antlr.enable = true;
		openapi-generator.enable = true;
	};

}
