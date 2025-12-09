{ pkgs, ... }: {
	config = {

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
