{ ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-services.gpg-agent.enable
	services.gpg-agent = {
		enable = false; # TODO
		enableBashIntegration = true;
		enableExtraSocket = true;
		enableSshSupport = true;
		extraConfig = "";
	};

}
