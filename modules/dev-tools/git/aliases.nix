{ ... }: {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.aliases
	programs.git.settings.alias = {

		# General quick shortcuts.
		st = "status -a";
		cl = "clone";
		ci = "commit";
		co = "checkout";
		br = "branch";
		dw = "diff --word-diff";
		dc = "diff --cached";
		rs = "reset";

		# Graph display.
		logr = "log --graph --decorate --oneline --abbrev-commit";
		logra = "logr --all";

		# Repo maintenance.
		fap = "fetch --all --prune";
		reset-from = ''!f() { git update-ref "refs/heads/''${1}" "''$(git rev-parse HEAD)" "''$(git rev-parse "''${1}")"; }; f'';

		# Laziness
		amend = "commit --amend --no-edit";
		jenk  = "!git add Jenkinsfile && !git amend && !git push -f";

	};

}
