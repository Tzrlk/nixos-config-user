{ config, pkgs, lib, ... }: with lib; {

	options.programs.powershell = mkOption {
		description = concatStringsSep "" [
			"Powershell installation config."
		];
		type = types.submodule ({ ... }: {
			options = {

				enable = mkEnableOption "powershell";

			};
		});
		default = {};
	};

	config = let

		cfg = config.programs.powershell;

	in mkIf cfg.enable {

		home.packages = with pkgs; [
			powershell
			powershell-editor-services
		];

		# TODO: profile config.

	};

}
