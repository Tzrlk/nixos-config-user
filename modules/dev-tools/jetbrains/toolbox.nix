{ config, pkgs, lib, ... }: with lib; {

	options.programs.jetbrains-toolbox = mkOption {
		description = concatStringsSep "" [
			"Local configuration for installation of JetBrains Toolbox."
		];
		type = types.submodule ({ ... }: {
			options = {

				enable = mkEnableOption "jetbrains-toolbox";

			};
		});
		default = {};
	};

	config = let

		cfg = config.programs.jetbrains-toolbox;

	in mkIf cfg.enable {

		home = {
			packages    = [ pkgs.jetbrains-toolbox ];
			sessionPath = [
				"\${XDG_DATA_HOME}/JetBrains/Toolbox/scripts"
			];
		};

		xdg = {

			mimeApps.defaultApplications = {
				"x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
			};

		};

	};
}
