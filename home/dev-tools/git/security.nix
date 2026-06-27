{ config, pkgs, ... }: {

	home.packages = with pkgs; [
		gnome-keyring
		gnupg
		libsecret
	];

	programs.git = {

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.signing.format
		signing = {
			format        = "openpgp";
			key           = null; # TODO
			signByDefault = false; # TODO
#			signer        = ""; # TODO
		};

		settings = {

			# Identity and auth.
			credential = {
				helper = "libsecret";
				"https://github.com".username = "Tzrlk";
			};

		};
	};

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git-credential-keepassxc.enable
	# NOTE: "error: The option `programs.git-credential-keepassxc' does not exist."
#	programs.git-credential-keepassxc = {
#		enabled = false;
#		groups  = [ "git" ];
#		hosts   = [
#			"https://github.com"
#			"https://stash.westpac.co.nz"
#		];
#	};

}
