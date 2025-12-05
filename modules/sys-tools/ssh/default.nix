{ ... }: {
	config = {

		# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ssh.enable
		programs.ssh = {
			enable  = true;
			package = null; # system default used.

			# Now-deprecated default config.
			enableDefaultConfig = false;
			matchBlocks."*"     = {
				forwardAgent        = false;
				addKeysToAgent      = "no";
				compression         = false;
				serverAliveInterval = 0;
				serverAliveCountMax = 3;
				hashKnownHosts      = false;
				userKnownHostsFile  = "~/.ssh/known_hosts";
				controlMaster       = "no";
				controlPath         = "~/.ssh/master-%r@%n:%p";
				controlPersist      = "no";
			};

		};

	};
}
