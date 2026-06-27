{ pkgs, lib, config, ... }: with lib; {

	options.programs.openapi-generator = mkOption {
		description = concatStringsSep "" [
			"Allows generation of API client libraries (SDK generation),"
			"server stubs and documentation automatically given an OpenAPI"
			"Spec"
		];
		default     = {};
		type        = types.submodule ({ ... }: {
			options = {
				enable  = mkEnableOption "openapi-generator";
				package = mkPackageOption pkgs "openapi-generator-cli" {};
			};
		});
	};

	config = let

		cfg = config.programs.openapi-generator;

	in mkIf cfg.enable {

		home.packages = [ cfg.package ];

	};

}
