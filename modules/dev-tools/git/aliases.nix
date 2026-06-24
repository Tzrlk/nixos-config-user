{ lib, ... }: with lib; let
	repeatArgs = flag: items: concatStringsSep " " (map (item: ''${flag} "${item}"'') items);
	exec       = body: "\$(${body})";
	fn         = body: "!f() { ${body}; }; f";
	hardReset  = ref:  ''git reset --hard "${ref}"'';
	updateRef  = ref: shaTo: shaFrom: ''git update-ref "${ref}" "${shaTo}" "${shaFrom}"'';
	commitTree = tree: parents: ''git commit-tree "${tree}" ${repeatArgs "-p" parents}'';
	revParse   = ref: ''git rev-parse "${ref}"'';
	treeParse  = ref: revParse "${ref}^{tree}";
in {

	# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.git.aliases
	programs.git.settings.alias = {

		## General quick shortcuts ############################################
		st = "status -a";
		cl = "clone";
		ci = "commit";
		co = "checkout";
		br = "branch";
		dw = "diff --word-diff";
		dc = "diff --cached";
		rs = "reset";

		## Log display ########################################################
		logr = "log --graph --decorate --oneline --abbrev-commit";
		logra = "logr --all";

		## Repo maintenance ###################################################

		## Reset From #################
		# Hard-resets a branch to the current commit.
		reset-from = fn (updateRef
			"refs/heads/\${1}"
			(exec (revParse "HEAD"))
			(exec (revParse "\${1}")));

		## Reset Into #################
		# Same as `reset-from`, but it also checks the branch out.
		reset-into = fn ''git reset-from "''${1}" && git co "''${1}"'';

		## Merge Theirs ###############
		# Merges the target branch into the current one, replacing the current
		# branches' content entirely with that of the target.
		merge-theirs = fn (hardReset
			(exec (commitTree (exec (treeParse "\${1}")) [
				(exec (revParse "HEAD"))
				(exec (revParse "\${1}"))
			])));

		## Laziness ###########################################################
		amend  = "commit --amend --no-edit";
		remain = "reset-into main";
		jenk   = "!git add Jenkinsfile && git fixup";
		fixup  = "!git amend && git push -f";
		yolo   = "!git add . && git fixup";
		fap    = "fetch --all --prune";

	};

}
