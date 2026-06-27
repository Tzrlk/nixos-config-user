{ pkgs, lib, config, ... }: with lib; {

	options.programs.antlr = mkOption {
		description = concatStringsSep "" [
			"Powerful parser generator"
		];
		default     = {};
		type        = types.submodule ({ ... }: {
			options = {
				enable  = mkEnableOption "antlr";
				package = mkPackageOption pkgs "antlr" {};
			};
		});
	};

	config = let

		cfg = config.programs.antlr;

	in mkIf cfg.enable {

		home.packages = [ cfg.package ];

	};

}
