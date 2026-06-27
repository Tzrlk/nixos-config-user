{ ... }: {

	imports = [
		./rbenv.nix
	];

	# We don't want to install a system ruby, because it overrides whatever
	# rbenv does. Better to just handle everything with rbenv instead.

}
