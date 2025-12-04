{ ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.aliases
	# https://git-scm.com/docs/git-config
	programs.git.settings = {

		branch = {
			autoSetupMerge  = false;
			autoSetupRebase = "always";
		};

		checkout = {
			defaultRemote = "origin";
			workers       = 2;
		};

		diff = {
			algorithm = "histogram";
			tool      = "vimdiff";
			guitool   = "gvimdiff";
			submodule = "log";
		};

		init = {
			defaultBranch = "main";
		};

		log = {
			follow = true;
		};

		merge = {
			tool    = "vimdiff";
			guitool = "gvimdiff";
		};

		pull = {
			ff     = "only";
			rebase = "interactive";
		};

		push = {
			default           = "upstream";
			recurseSubmodules = false;
		};

		rebase = {
			rebaseMerges = true;
		};

		status = {
			submoduleSummary = true;
		};

		submodule = {
			recurse           = true;
			propagateBranches = false;
		};

	};

}
