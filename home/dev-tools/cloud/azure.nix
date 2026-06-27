{ pkgs, ... }: {
	config = {

		home.packages = with pkgs; [

			azure-cli
#			azure-cli-ext.interactive (won't resolve for some reason)

		];

		xdg.configFile = {

			"bash_completion.d/az".source = "${pkgs.azure-cli}/share/bash-completion/completions/az.bash";

		};

	};
}
