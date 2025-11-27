{ pkgs, ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-services.ssh-agent.enable
	services.ssh-agent = {
		enable = false; # TODO
#		package = pkgs.openssh; << missing
	};

}
