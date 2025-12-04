{ ... }: {

	home = {
		shell.enableBashIntegration = true;
		file = {
			".bashrc.d".source = ./.bashrc.d;
		};
	};

	programs.bash = {
		enable = true;
		enableVteIntegration = true;

		historyControl = [ "erasedups" ];
		historyIgnore = [
			"cd"
			"exit"
			"ls"
		];

		# All shells.
		bashrcExtra = builtins.readFile ./bashrc.sh;

		# Login shells.
		profileExtra = builtins.readFile ./profile.sh;

	};

}
