{ lib, ... }: {

	home.file = let
		fs = lib.filesystem;

		# Predicate to match paths that should be considered ssh config files.
		isSshConfig = path:
			(lib.hasSuffix ".ssh" path) &&
			((fs.pathType path) == "regular");

		# Finds all the additional ssh config files available.
		listSshConfig = path:
			(lib.filter
				isSshConfig
				(fs.listFilesRecursive
					path));

		# Given a potentially nested list of paths, this will flatten and
		# convert them into their associated file content.
		readFiles = paths:
			(map
				(p: builtins.readFile p)
				(lib.flatten paths));

	in {

		# Because of ssht not supporting includes, the whole config needs to be
		# concatenated together.
		".ssh/config".text =
			(lib.concatStrings
				(readFiles [
					(listSshConfig
						./config.ssh.d)
					./config.ssh
				]));

	};

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

}
