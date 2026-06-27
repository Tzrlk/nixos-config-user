{ pkgs, ... }: {
	config = {

		xdg.configFile = {

			"bash_completion.d/aws".source = "${pkgs.awscli2}/share/bash-completion/completions/aws.bash";

		};

		programs.awscli = {
			enable  = true;
			package = pkgs.awscli2;
			# Manage settings manually / via symlink.
		};

	};
}
