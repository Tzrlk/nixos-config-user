{ ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.extraConfig
	programs.git.settings = {

		log = {
			date = "iso-local";
			abbrev-commit = true;
			decorate = "short";
			showRoot = true;
		};
		rebase = {
			abbreviateCommands = true;
		};

		format.pretty = "%C(auto)%h %s";

		color = {
			ui = true;
			branch = {
				current = "yellow bold";
				local   = "yellow";
				remote  = "green";
			};
			diff = {
				meta = "yellow bold";
				frag = "magenta bold";
				old = "red";
				new = "cyan";
			};
			status = {
				added = "green";
				changed = "yellow";
				untracked = "red";
			};
		};

	};

}
